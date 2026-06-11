-- lang/go.lua — Go language adapter (Simplified & Cached)

local import = require("plugins.doc-search-v2.pkg")
local cache = import("cache")
local awk = import("util.awk")

local M = {}
local find_gomod_file

local function get_go_env()
  local gomod_file = find_gomod_file()

  local goroot = cache.get("go:goroot", function()
    local goroot_result = vim.system({ "go", "env", "GOROOT" }, { text = true }):wait()
    if goroot_result.code == 0 then
      return vim.split(goroot_result.stdout, "\n")[1] .. "/src"
    end
  end)

  local gomodcache = cache.get("go:gomodcache", function()
    local gomodcache_result = vim.system({ "go", "env", "GOMODCACHE" }, { text = true }):wait()
    if gomodcache_result.code == 0 then
      return vim.split(gomodcache_result.stdout, "\n")[1]
    end
  end)

  local godeps = cache.get("go:godeps", function()
    local dirs = {}
    local gomod_result = vim
      .system({ "go", "list", "-m", "-f", "{{.Path}}@{{.Version}}:::{{.Dir}}", "all" }, { text = true })
      :wait()
    if gomod_result.code == 0 then
      for _, line in ipairs(vim.split(gomod_result.stdout, "\n")) do
        local path_ver, dir = line:match("^(.+):::(.+)$")
        if path_ver and dir and dir ~= "" then
          table.insert(dirs, { path = dir, sublabel = path_ver })
        end
      end
    end

    return dirs
  end, gomod_file)

  return {
    goroot = goroot,
    gomodcache = gomodcache,
    godeps = godeps,
  }
end

function M.build_query(type, search)
  if type == "function" then
    if search:match("^%^func%.%*") then
      return search:gsub("^%^func%.%*", "", 1)
    end
    return "^func.*" .. search
  end

  if type == "exported_function" then
    if search:match("^%^func%s+%(%?:%([^()]*%)%s*%)%?[A-Z]%w*") then
      return search:gsub("^%^func%s+%(%?:%([^()]*%)%s*%)%?[A-Z]%w*", "", 1)
    end
    return [[^func\s+(?:\([^()]*\)\s*)?[A-Z]\w*]] .. search
  end

  -- if type == "exported_function" then
  --   if search:match("^%^func% %[A-Z%]%+") then
  --     return search:gsub("^%^func% %[A-Z%]%+", "", 1)
  --   end
  --   return [[func\s+(?:\([^()]*\)\s*)?[A-Z]\w*]] .. search
  -- end

  if type == "function_call" then
    return "!^func|\\." .. search
  end

  if type == "type" then
    if search:match("type ") then
      return search:gsub("type ", "", 1)
    end
    return "type " .. search
  end

  return search
end

function find_gomod_file()
  local path = vim.fn.getcwd()
  while path ~= "/" do
    local gomod = path .. "/go.mod"
    if vim.fn.filereadable(gomod) == 1 then
      return gomod
    end
    path = vim.fn.fnamemodify(path, ":h")
  end
  return nil
end

function M.rg_options()
  return {
    "--column",
    "--line-number",
    "--no-heading",
    "--color=always",
    "--smart-case",
    "-t go",
    "-e",
  }
end

function M.get_search_dirs()
  local env = get_go_env()
  local dirs = {}

  if env.goroot and env.goroot ~= "" then
    local stdlib_dirs = vim.fn.glob(env.goroot .. "/*", false, true)
    table.sort(stdlib_dirs)
    for _, std_path in ipairs(stdlib_dirs) do
      if vim.fn.isdirectory(std_path) == 1 then
        table.insert(dirs, {
          path = std_path,
          label = "stdlib",
          prefix = "[std] ",
          sublabel = vim.fn.fnamemodify(std_path, ":t"),
        })
      end
    end
  end

  for _, dep in ipairs(env.godeps or {}) do
    table.insert(dirs, {
      path = dep.path,
      label = "module",
      prefix = "[mod] ",
      sublabel = dep.sublabel,
    })
  end

  return dirs
end

function M.get_search_command(search, opts)
  opts = opts or {}
  search = search or get_search_query()

  local env = get_go_env()

  local dirs = {}
  if opts.search_dirs and #opts.search_dirs > 0 then
    for _, d in ipairs(opts.search_dirs) do
      table.insert(dirs, d)
    end
  else
    for _, d in ipairs(M.get_search_dirs()) do
      table.insert(dirs, d.path)
    end
  end

  local escaped_dirs = {}
  for _, d in ipairs(dirs) do
    table.insert(escaped_dirs, vim.fn.shellescape(d))
  end

  local rg_args = {
    "--column",
    "--line-number",
    "--no-heading",
    "--color=always",
    "--smart-case",
    "-t go",
    "--glob '!**/testdata/**'",
    "--glob '!**/test/**'",
    "--glob '!*_test.go'",
    "-e",
  }

  return string.format(
    [[
    rg %s '%s' %s | awk -F':' '{
      file = $1;
      line = $2;
      col  = $3;

      entry = $0;

      # Replace the string in the "rest" part
      gsub("%s", "", entry)
      gsub("%s", "[std]", entry)
      gsub("%s", "[mod]", entry)

      # Rebuild clean format
      print file ":" line ":" col " ≈" entry
    }'
  ]],
    table.concat(rg_args, " "),
    search,
    table.concat(escaped_dirs, " "),
    vim.fn.getcwd() .. "/",
    env.goroot or "",
    env.gomodcache or ""
  )
end

-- Treesitter Capture At Cursor
local query = vim.treesitter.query.parse(
  "go",
  [[
  (call_expression
    function: (identifier) @function.call)

  (call_expression
    function: (selector_expression
      field: (field_identifier) @method.call))

  (selector_expression
    field: (field_identifier) @field.access)

  (identifier) @identifier

  ;; type usage
  (type_identifier) @type
]]
)

local priority = {
  ["method.call"] = 1,
  ["type"] = 1,
  ["function.call"] = 2,
  ["field.access"] = 3,
  ["identifier"] = 4,
}

local search_patterns = {
  ["method.call"] = 1,
  ["function.call"] = 2,
  ["field.access"] = 3,
  ["identifier"] = 4,
}

local function get_ts_capture()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1] - 1, cursor[2]

  local parser = vim.treesitter.get_parser(bufnr, "go")
  local tree = parser:parse()[1]
  local root = tree:root()

  local best = nil
  local best_prio = math.huge

  for id, node, _ in query:iter_captures(root, bufnr, row, row + 1) do
    local name = query.captures[id]
    local sr, sc, er, ec = node:range()

    local in_range = (row > sr or (row == sr and col >= sc)) and (row < er or (row == er and col <= ec))

    if in_range then
      local prio = priority[name] or 100

      if prio < best_prio then
        best = {
          kind = name,
          node = node,
          text = vim.treesitter.get_node_text(node, bufnr),
          range = { sr, sc, er, ec },
        }
        best_prio = prio
      end
    end
  end

  return best
end

local function get_search_query()
  local capture = get_ts_capture()

  if capture == nil then
    return vim.fn.expand("<cword>")
  end

  if capture.kind == "method.call" then
    return "^func.*" .. capture.text
  end

  if capture.kind == "function.call" then
    return "^func " .. capture.text
  end

  if capture.kind == "type" then
    return "type " .. capture.text
  end

  return capture.text
end

return M
