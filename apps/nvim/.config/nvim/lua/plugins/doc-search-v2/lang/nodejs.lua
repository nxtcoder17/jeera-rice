-- lang/nodejs.lua — Node/TS language adapter for doc-search engine
--
-- All syscalls are lazy and cached. Nothing runs at require-time.

local import = require("plugins.doc-search-v2.pkg")
local cache = import("cache")
local awk = import("util.awk")
local engine = import("engine")

local M = {}

-- Patterns for different symbol types
M.patterns = {
  all = "^(export )?(declare )?(async )?(function |class |interface |type |const |let |var |enum |namespace )",
  functions = "^(export )?(declare )?(async )?function ",
  classes = "^(export )?(declare )?class ",
  types = "^(export )?(declare )?(interface |type )",
  constants = "^(export )?(declare )?(const |let |var |enum )",
}

-- Symbol types with fzf shortcut keys
M.symbol_types = {
  { name = "all",       label = "all",     key = "ctrl-a", prompt = "Symbols" },
  { name = "functions", label = "funcs",   key = "ctrl-f", prompt = "Functions" },
  { name = "classes",   label = "classes",  key = "ctrl-l", prompt = "Classes" },
  { name = "types",     label = "types",   key = "ctrl-t", prompt = "Types" },
  { name = "constants", label = "consts",  key = "ctrl-k", prompt = "Constants" },
}

-- Available scopes with shortcut keys
M.scopes = {
  { name = "workspace", label = "workspace", key = "ctrl-w" },
  { name = "dep",       label = "deps",      key = "ctrl-d", handler = function(lang, query) lang.show_dep_packages(query) end },
}

-- Lazy cached syscalls
local function find_package_json()
  local path = vim.fn.getcwd()
  while path ~= "/" do
    local pkg_path = path .. "/package.json"
    if vim.fn.filereadable(pkg_path) == 1 then
      return pkg_path, path
    end
    path = vim.fn.fnamemodify(path, ":h")
  end
  return nil, nil
end

local function get_package_json()
  local pkg_file = find_package_json()
  return cache.get("node:package_json", function()
    if not pkg_file then return nil end
    local content = vim.fn.readfile(pkg_file)
    if #content == 0 then return nil end
    local ok, parsed = pcall(vim.json.decode, table.concat(content, "\n"))
    return ok and parsed or nil
  end, pkg_file)
end

local function get_project_root()
  return cache.get("node:project_root", function()
    local _, root = find_package_json()
    return root or vim.fn.getcwd()
  end)
end

local function get_package_name()
  return cache.get("node:package_name", function()
    local pkg = get_package_json()
    return pkg and pkg.name or vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  end)
end

local function find_node_modules()
  return cache.get("node:node_modules", function()
    local _, root = find_package_json()
    if not root then return nil end

    local path = root
    while path ~= "/" do
      local nm = path .. "/node_modules"
      if vim.fn.isdirectory(nm) == 1 then
        return nm
      end
      path = vim.fn.fnamemodify(path, ":h")
    end
    return nil
  end)
end

local function get_dependencies()
  local pkg_file = find_package_json()
  return cache.get("node:dependencies", function()
    local pkg = get_package_json()
    if not pkg then return {} end

    local nm = find_node_modules()
    if not nm then return {} end

    local deps, seen = {}, {}

    local function add_deps(dep_table)
      if not dep_table then return end
      for name in pairs(dep_table) do
        if not seen[name] then
          local dir = nm .. "/" .. name
          if vim.fn.isdirectory(dir) == 1 then
            seen[name] = true
            -- Read version from dep's package.json
            local version = "?"
            local dep_pkg_path = vim.fn.resolve(dir) .. "/package.json"
            if vim.fn.filereadable(dep_pkg_path) == 1 then
              local content = vim.fn.readfile(dep_pkg_path)
              if #content > 0 then
                local ok, dep_pkg = pcall(vim.json.decode, table.concat(content, "\n"))
                if ok and dep_pkg.version then
                  version = dep_pkg.version
                end
              end
            end
            table.insert(deps, { name = name, dir = vim.fn.resolve(dir), version = version })
          end
        end
      end
    end

    add_deps(pkg.dependencies)
    add_deps(pkg.devDependencies)
    table.sort(deps, function(a, b) return a.name < b.name end)
    return deps
  end, pkg_file)
end

-- Helper: write awk to temp file (cached + cleaned on exit)
local function awk_file(name, content)
  return awk.to_file("node_" .. name, content)
end

-- Build rg | awk command for a given scope
function M.build_cmd(scope, pattern, opts)
  pattern = pattern or M.patterns.all
  opts = opts or {}

  if scope == "workspace" then
    local base_dir = opts.dir or get_project_root()
    local pkgname = get_package_name()

    local awk_path = awk_file("workspace", awk.node_workspace())
    if not awk_path then return "echo 'Failed to create awk script'" end

    return "cd '" .. base_dir .. "' && rg -n --no-heading '" .. pattern .. "'"
      .. " --glob '*.js' --glob '*.jsx' --glob '*.ts' --glob '*.tsx' --glob '*.mjs' --glob '*.cjs'"
      .. " --glob '!*.test.*' --glob '!*.spec.*' --glob '!__tests__/**'"
      .. " --glob '!node_modules/**' --glob '!dist/**' --glob '!build/**' --glob '!.next/**' --glob '!coverage/**'"
      .. " . 2>/dev/null | sed 's|^\\./||'"
      .. " | awk -F: -v pkgname='" .. pkgname .. "' -v basedir='" .. base_dir .. "' -f '" .. awk_path .. "'"

  elseif scope == "dep" then
    local deps = get_dependencies()
    if #deps == 0 then return "echo ''" end

    local awk_path = awk_file("deps", awk.node_deps())
    if not awk_path then return "echo 'Failed to create awk script'" end

    local cmds = {}
    for _, dep in ipairs(deps) do
      local cmd = '(cd "' .. dep.dir .. '" && rg -n --no-heading -e \'' .. pattern .. "' --glob '*.d.ts' . 2>/dev/null"
        .. " | sed 's|^\\./|" .. dep.dir .. "/|')"
      table.insert(cmds, cmd)
    end

    return "{ " .. table.concat(cmds, "; ") .. "; } | awk -F: -f '" .. awk_path .. "'"

  elseif scope == "dep_package" then
    local dep_info = opts.dep_info
    if not dep_info then return "echo ''" end

    local awk_path = awk_file("single_dep", awk.node_single_dep())
    if not awk_path then return "echo 'Failed to create awk script'" end

    return 'cd "' .. dep_info.dir .. '" && rg -n --no-heading -e \'' .. pattern .. "'"
      .. " --glob '*.d.ts' . 2>/dev/null | sed 's|^\\./||'"
      .. " | awk -F: -v deppath='" .. dep_info.path .. "' -f '" .. awk_path .. "'"
  end

  return "echo ''"
end

-- Get query text from cursor position (treesitter-aware)
function M.get_query_at_cursor()
  local ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
  if ok then
    local node = ts_utils.get_node_at_cursor()
    if node then
      local current = node
      while current do
        local ntype = current:type()
        if ntype == "call_expression" then
          local func_node = current:field("function")[1]
          if func_node then
            return "'" .. vim.treesitter.get_node_text(func_node, 0)
          end
          break
        end
        if ntype == "member_expression" then
          local prop = current:field("property")[1]
          if prop then
            return "'" .. vim.treesitter.get_node_text(prop, 0)
          end
        end
        current = current:parent()
      end
    end
  end

  local cword = vim.fn.expand("<cword>")
  return cword ~= "" and "'" .. cword or nil
end

-- Show dependency packages picker
function M.show_dep_packages(query)
  local deps = get_dependencies()
  if #deps == 0 then
    vim.notify("No dependencies found in package.json", vim.log.levels.WARN)
    return
  end

  local items = {}
  for _, dep in ipairs(deps) do
    table.insert(items, dep.name .. "@" .. dep.version .. "\t" .. dep.dir .. "\t" .. dep.name)
  end

  engine.packages({
    lang = M,
    scope = "dep",
    items = items,
    query = query,
    prompt = "Dep Packages",
    extra_info = get_package_name() .. " (" .. #deps .. " deps)",
  })
end

return M
