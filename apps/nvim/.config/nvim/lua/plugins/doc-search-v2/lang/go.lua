-- lang/go.lua — Go language adapter (Simplified & Cached)

local import = require("plugins.doc-search-v2.pkg")
local cache = import("cache")
local awk = import("util.awk")

local M = {}

function M.build_query(type, search)
  if type == "function" then
    if search:match("^%^func ") then
      return search:gsub("^%^func ", "", 1)
    end
    return "^func " .. search
  end

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

local function find_gomod_file()
  local path = vim.fn.getcwd()
  while path ~= "/" do
    local gomod = path .. "/go.mod"
    if vim.fn.filereadable(gomod) == 1 then return gomod end
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

function M.get_search_command(search)
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
    local gomod_result = vim.system({ "go", "list", "-m", "-f", "{{.Path}}@{{.Version}}:::{{.Dir}}", "all" }, { text = true }):wait()
    if gomod_result.code == 0 then
      for _, line in ipairs(vim.split(gomod_result.stdout, "\n")) do
        local path_ver, dir = line:match("^(.+):::(.+)$")
        if path_ver and dir and dir ~= "" then
          table.insert(dirs, dir)
          -- table.insert(dirs, { label = "module", path = dir, prefix = "[mod]", sublabel = path_ver })
        end
      end
    end

    return dirs
  end, gomod_file)

  local dirs = { goroot }
  for _, d in ipairs(godeps) do
    table.insert(dirs, d)
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

  return string.format([[
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
  ]], table.concat(rg_args, " "), search, table.concat(dirs, " "), vim.fn.getcwd() .. "/", goroot, gomodcache)

end

function M.get_search_dirs()
  local gomod_file = find_gomod_file()

  return cache.get("go:search_dirs", function()
    local dirs = {}

    -- INFO: skipping workspace as it is already included in dependencies section
    -- -- 1. Workspace
    -- table.insert(dirs, { path = vim.fn.getcwd(), label = "workspace", prefix = "[ws]" })

    local goroot = ""
    local gomodcache = ""

    -- 2. Stdlib
    local goroot_result = vim.system({ "go", "env", "GOROOT" }, { text = true }):wait()
    if goroot_result.code == 0 then
      goroot = vim.split(goroot_result.stdout, "\n")[1] .. "/src"
      table.insert(dirs, goroot)
    end

    local gomodcache_result = vim.system({ "go", "env", "GOMODCACHE" }, { text = true }):wait()
    if gomodcache_result.code == 0 then
      gomodcache = vim.split(gomodcache_result.stdout, "\n")[1]
    end

    -- 3. Dependencies
    local gomod_result = vim.system({ "go", "list", "-m", "-f", "{{.Path}}@{{.Version}}:::{{.Dir}}", "all" }, { text = true }):wait()
    if gomod_result.code == 0 then
      for _, line in ipairs(vim.split(gomod_result.stdout, "\n")) do
        local path_ver, dir = line:match("^(.+):::(.+)$")
        if path_ver and dir and dir ~= "" then
          table.insert(dirs, dir)
          -- table.insert(dirs, { label = "module", path = dir, prefix = "[mod]", sublabel = path_ver })
        end
      end
    end

    local pretty_path = function(p)
      if p:find("^" .. vim.pesc(goroot)) then
        return  "[std] ".. p:gsub("^" .. vim.pesc(goroot) .. "/?", "")
      end

      if p:find("^" .. vim.pesc(gomodcache)) then
        return  "[mod] ".. p:gsub("^" .. vim.pesc(gomodcache) .. "/?", "")
      end

      return p
    end

    -- vim.print("DIRS:", vim.inspect(dirs))
    return { dirs, pretty_path }
  end, gomod_file)
end

function M.get_awk_script(dirs)
  local modname = get_gomod()
  return awk.go_simplified(modname, dirs)
end

function M.get_query_at_cursor()
  local cword = vim.fn.expand("<cword>")
  return cword ~= "" and "'" .. cword or nil
end

return M
