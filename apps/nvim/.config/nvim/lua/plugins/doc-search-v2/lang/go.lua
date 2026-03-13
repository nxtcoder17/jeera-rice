-- lang/go.lua — Go language adapter for doc-search engine
--
-- All syscalls are lazy and cached. Nothing runs at require-time.

local import = require("plugins.doc-search-v2.pkg")
local cache = import("cache")
local awk = import("util.awk")
local engine = import("engine")

local M = {}

-- Patterns for different symbol types
M.patterns = {
  all = "^(func |type |const |var )",
  functions = "^func ",
  types = "^type ",
  constants = "^(const |var )",
}

-- Symbol types with fzf shortcut keys
M.symbol_types = {
  { name = "all",       label = "all",    key = "ctrl-a", prompt = "Symbols" },
  { name = "functions", label = "funcs",  key = "ctrl-f", prompt = "Functions" },
  { name = "types",     label = "types",  key = "ctrl-t", prompt = "Types" },
  { name = "constants", label = "consts", key = "ctrl-c", prompt = "Constants" },
}

-- Available scopes with shortcut keys
M.scopes = {
  { name = "workspace", label = "workspace", key = "ctrl-w" },
  { name = "packages",  label = "packages",  key = "ctrl-p", handler = function(lang, query) lang.show_packages(query) end },
  { name = "dep",       label = "deps",      key = "ctrl-d", handler = function(lang, query) lang.show_dep_packages(query) end },
  { name = "stdlib",    label = "stdlib",     key = "ctrl-s" },
}

-- Lazy cached syscalls
local function find_gomod_file()
  -- Walk up from cwd to find go.mod
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

local function get_gomod()
  local gomod_file = find_gomod_file()
  return cache.get("go:modname", function()
    local mod = vim.fn.systemlist("go list -m 2>/dev/null")[1] or ""
    if mod == "" or mod:match("^command%-line%-arguments") then
      mod = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    end
    return mod
  end, gomod_file)
end

local function get_goroot()
  return cache.get("go:goroot", function()
    return vim.fn.systemlist("go env GOROOT 2>/dev/null")[1] or ""
  end)
end

local function get_gomodcache()
  return cache.get("go:gomodcache", function()
    return vim.fn.systemlist("go env GOMODCACHE 2>/dev/null")[1] or ""
  end)
end

function M.stdlib_src()
  local goroot = get_goroot()
  return goroot ~= "" and (goroot .. "/src") or ""
end

local function get_stdlib_packages()
  local goroot = get_goroot()
  return cache.get("go:stdlib_packages", function()
    if goroot == "" then return {} end
    local src_dir = goroot .. "/src"
    if vim.fn.isdirectory(src_dir) ~= 1 then return {} end

    local result = {}
    local pkgs = vim.fn.systemlist("go list std 2>/dev/null | grep -vE 'vendor|internal'")
    for _, pkg in ipairs(pkgs) do
      if pkg ~= "" then
        local pkg_dir = src_dir .. "/" .. pkg
        if vim.fn.isdirectory(pkg_dir) == 1 then
          table.insert(result, { path = pkg, dir = pkg_dir })
        end
      end
    end
    return result
  end)
end

local function get_deps()
  local gomod_file = find_gomod_file()
  return cache.get("go:deps", function()
    local deps = {}
    local modcache = get_gomodcache()
    if modcache == "" then return deps end

    local mod_deps = vim.fn.systemlist("go list -m -f '{{.Path}}@{{.Version}}' all 2>/dev/null")
    for _, dep in ipairs(mod_deps) do
      if dep ~= "" and not dep:match("^command%-line%-arguments") then
        local path, version = dep:match("^(.+)@(.+)$")
        if path and version then
          local dep_dir = modcache .. "/" .. path .. "@" .. version
          if vim.fn.isdirectory(dep_dir) == 1 then
            table.insert(deps, { path = path, version = version, dir = dep_dir })
          end
        end
      end
    end
    return deps
  end, gomod_file)
end

-- Build rg | awk command for a given scope
function M.build_cmd(scope, pattern, opts)
  pattern = pattern or M.patterns.all
  opts = opts or {}

  if scope == "workspace" then
    local cwd = opts.dir or vim.fn.getcwd()
    local modname = get_gomod()
    local stdlib_src = M.stdlib_src()

    -- Workspace command
    local ws_cmd = string.format(
      "cd '%s' && rg -n --no-heading '%s' --glob '*.go' --glob '!*_test.go' . 2>/dev/null | sed 's|^\\./||' | awk -F: -v modname='%s' -v basedir='%s' '%s'",
      cwd, pattern, modname, cwd, awk.go_workspace()
    )

    -- Include stdlib in workspace searches
    if stdlib_src ~= "" and not opts.dir then
      local stdlib_cmd = string.format(
        "cd '%s' && rg -n --no-heading '%s' --glob '*.go' --glob '!*_test.go' --glob '!vendor/**' --glob '!internal/**' --glob '!**/internal/**' . 2>/dev/null | sed 's|^\\./||' | awk -F: -v srcdir='%s' '%s'",
        stdlib_src, pattern, stdlib_src, awk.go_stdlib()
      )
      return "{ " .. ws_cmd .. "; " .. stdlib_cmd .. "; }"
    end

    return ws_cmd

  elseif scope == "stdlib" then
    local stdlib_src = M.stdlib_src()
    if stdlib_src == "" then return "echo ''" end

    return string.format(
      "cd '%s' && rg -n --no-heading '%s' --glob '*.go' --glob '!*_test.go' --glob '!vendor/**' --glob '!internal/**' . 2>/dev/null | sed 's|^\\./||' | awk -F: -v srcdir='%s' '%s'",
      stdlib_src, pattern, stdlib_src, awk.go_stdlib()
    )

  elseif scope == "dep" then
    local deps = get_deps()
    if #deps == 0 then return "echo ''" end

    local dirs = {}
    for _, dep in ipairs(deps) do
      table.insert(dirs, "'" .. dep.dir .. "'")
    end

    return string.format(
      "rg -n --no-heading '%s' --glob '*.go' --glob '!*_test.go' %s 2>/dev/null | awk -F: '%s'",
      pattern, table.concat(dirs, " "), awk.go_deps()
    )

  elseif scope == "dep_package" then
    local dep_info = opts.dep_info
    if not dep_info then return "echo ''" end

    return string.format(
      "cd '%s' && rg -n --no-heading '%s' --glob '*.go' --glob '!*_test.go' . 2>/dev/null | sed 's|^\\./||' | awk -F: -v deppath='%s' '%s'",
      dep_info.dir, pattern, dep_info.path, awk.go_single_dep()
    )
  end

  return "echo ''"
end

-- Get query text from cursor position
function M.get_query_at_cursor()
  local fns_ok, fns = pcall(require, "functions.encoding")
  if fns_ok then
    local mode = vim.api.nvim_get_mode()["mode"]
    if mode == "v" then
      local sel = fns.get_selection()
      if sel and sel ~= "" then return "'" .. sel end
    end
  end
  local cword = vim.fn.expand("<cword>")
  return cword ~= "" and "'" .. cword or nil
end

-- Show packages picker (workspace + stdlib + modcache)
function M.show_packages(query)
  local items = {}
  local modname = get_gomod()

  -- Workspace packages
  local workspace = vim.fn.systemlist("go list -f '{{.ImportPath}}:::{{.Dir}}' ./... 2>/dev/null")
  for _, line in ipairs(workspace) do
    if line ~= "" then
      local pkg, dir = line:match("^(.+):::(.+)$")
      if pkg and dir then
        table.insert(items, "[ws] " .. pkg .. "\t" .. dir .. "\t" .. pkg)
      end
    end
  end

  -- Stdlib packages
  local stdlib = get_stdlib_packages()
  for _, pkg in ipairs(stdlib) do
    table.insert(items, "[std] " .. pkg.path .. "\t" .. pkg.dir .. "\t" .. pkg.path)
  end

  -- GOMODCACHE packages
  local modcache = get_gomodcache()
  if modcache ~= "" then
    local cached = vim.fn.systemlist(string.format("fd -t d -d 4 '@v' '%s' 2>/dev/null | head -200", modcache))
    for _, path in ipairs(cached) do
      local pkg = path:gsub(modcache .. "/", "")
      if pkg ~= "" then
        local import_path = pkg:gsub("@[^/]+", "")
        table.insert(items, "[mod] " .. pkg .. "\t" .. path .. "\t" .. import_path)
      end
    end
  end

  engine.packages({
    lang = M,
    scope = "packages",
    items = items,
    query = query,
    prompt = "Packages",
    extra_info = modname,
  })
end

-- Show dependency packages picker
function M.show_dep_packages(query)
  local deps = get_deps()
  if #deps == 0 then
    vim.notify("No dependencies found in go.mod", vim.log.levels.WARN)
    return
  end

  local items = {}
  for _, dep in ipairs(deps) do
    table.insert(items, dep.path .. "@" .. dep.version .. "\t" .. dep.dir .. "\t" .. dep.path)
  end

  engine.packages({
    lang = M,
    scope = "dep",
    items = items,
    query = query,
    prompt = "Dep Packages",
    extra_info = get_gomod() .. " (" .. #deps .. " deps)",
  })
end

-- Show stdlib packages picker
function M.show_stdlib_packages(query)
  local stdlib = get_stdlib_packages()
  if #stdlib == 0 then
    vim.notify("Could not find Go stdlib", vim.log.levels.WARN)
    return
  end

  local items = {}
  for _, pkg in ipairs(stdlib) do
    table.insert(items, pkg.path .. "\t" .. pkg.dir .. "\t" .. pkg.path)
  end

  engine.packages({
    lang = M,
    scope = "stdlib",
    items = items,
    query = query,
    prompt = "Stdlib",
    extra_info = "Go stdlib (" .. #stdlib .. " packages)",
  })
end

return M
