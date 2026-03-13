local M = {}

-- Cache
local cache = {}

-- Find package.json by walking up from cwd
local function find_package_json()
  if cache.pkg then return cache.pkg, cache.root end

  local path = vim.fn.getcwd()
  while path ~= "/" do
    local pkg_path = path .. "/package.json"
    if vim.fn.filereadable(pkg_path) == 1 then
      local content = vim.fn.readfile(pkg_path)
      if #content > 0 then
        local ok, parsed = pcall(vim.json.decode, table.concat(content, "\n"))
        if ok then
          cache.pkg = parsed
          cache.root = path
          return parsed, path
        end
      end
    end
    path = vim.fn.fnamemodify(path, ":h")
  end
  return nil, nil
end

-- Find node_modules path (walks up to find it)
local function find_node_modules()
  if cache.node_modules then return cache.node_modules end

  local _, root = find_package_json()
  if not root then return nil end

  local path = root
  while path ~= "/" do
    local nm = path .. "/node_modules"
    if vim.fn.isdirectory(nm) == 1 then
      cache.node_modules = nm
      return nm
    end
    path = vim.fn.fnamemodify(path, ":h")
  end
  return nil
end

-- Public API

function M.get_project_root()
  local _, root = find_package_json()
  return root or vim.fn.getcwd()
end

function M.get_package_name()
  local pkg = find_package_json()
  return pkg and pkg.name or vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

function M.get_node_modules_path()
  return find_node_modules()
end

function M.get_dependencies()
  local pkg = find_package_json()
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
          table.insert(deps, { name = name, dir = vim.fn.resolve(dir) })
        end
      end
    end
  end

  add_deps(pkg.dependencies)
  add_deps(pkg.devDependencies)
  table.sort(deps, function(a, b) return a.name < b.name end)
  return deps
end

return M
