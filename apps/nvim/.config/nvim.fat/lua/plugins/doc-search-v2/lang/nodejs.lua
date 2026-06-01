-- lang/nodejs.lua — Node/TS language adapter (Simplified)

local import = require("plugins.doc-search-v2.pkg")
local cache = import("cache")
local awk = import("util.awk")

local M = {}

M.patterns = {
  all = "^(export )?(declare )?(async )?(function |class |interface |type |const |let |var |enum |namespace )",
}

local function find_package_json()
  local path = vim.fn.getcwd()
  while path ~= "/" do
    local pkg_path = path .. "/package.json"
    if vim.fn.filereadable(pkg_path) == 1 then return pkg_path, path end
    path = vim.fn.fnamemodify(path, ":h")
  end
  return nil, nil
end

local function get_package_json()
  local pkg_file = find_package_json()
  return cache.get("node:package_json", function()
    if not pkg_file then return nil end
    local content = vim.fn.readfile(pkg_file)
    local ok, parsed = pcall(vim.json.decode, table.concat(content, "\n"))
    return ok and parsed or nil
  end, pkg_file)
end

local function get_package_name()
  return cache.get("node:package_name", function()
    local pkg = get_package_json()
    return pkg and pkg.name or vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  end)
end

local function get_dependencies()
  local pkg_file = find_package_json()
  return cache.get("node:dependencies", function()
    local pkg = get_package_json()
    if not pkg then return {} end
    local _, root = find_package_json()
    local nm = root .. "/node_modules"
    local deps = {}
    local function add(t)
      if not t then return end
      for name in pairs(t) do
        local dir = nm .. "/" .. name
        if vim.fn.isdirectory(dir) == 1 then table.insert(deps, { name = name, dir = dir }) end
      end
    end
    add(pkg.dependencies); add(pkg.devDependencies)
    return deps
  end, pkg_file)
end

function M.get_search_dirs()
  local dirs = {}
  local _, root = find_package_json()
  table.insert(dirs, { path = root or vim.fn.getcwd(), label = "workspace", prefix = "[ws] " })
  for _, dep in ipairs(get_dependencies()) do
    table.insert(dirs, { path = dep.dir, label = "dep", prefix = "[dep] ", sublabel = dep.name })
  end
  return dirs
end

function M.get_awk_script(dirs)
  return awk.node_simplified(get_package_name(), dirs)
end

function M.get_query_at_cursor()
  local cword = vim.fn.expand("<cword>")
  return cword ~= "" and "'" .. cword or nil
end

return M
