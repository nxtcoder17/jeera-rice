local M = {}

function M.get_gomod()
  local mod_name = vim.fn.systemlist("go list -m 2>/dev/null")[1] or ""
  if mod_name == "" or mod_name:match("^command%-line%-arguments") then
    mod_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  end
  return mod_name
end

function M.get_goroot()
  local goroot = vim.fn.systemlist("go env GOROOT 2>/dev/null")[1]
  return goroot or ""
end

function M.get_stdlib_packages(goroot)
  if goroot == "" then return {} end

  local src_dir = goroot .. "/src"
  if vim.fn.isdirectory(src_dir) ~= 1 then return {} end

  local result = {}

  -- Get all stdlib packages using go list, filter out vendor/internal
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
end

function M.get_go_mod_deps()
  local deps = {}
  local cache = vim.fn.systemlist("go env GOMODCACHE")[1] or ""
  if cache == "" then return deps end

  -- Get direct dependencies from go.mod using go list
  local mod_deps = vim.fn.systemlist("go list -m -f '{{.Path}}@{{.Version}}' all 2>/dev/null")
  for _, dep in ipairs(mod_deps) do
    if dep ~= "" and not dep:match("^command%-line%-arguments") then
      local path, version = dep:match("^(.+)@(.+)$")
      if path and version then
        local dep_dir = cache .. "/" .. path .. "@" .. version
        if vim.fn.isdirectory(dep_dir) == 1 then
          table.insert(deps, { path = path, version = version, dir = dep_dir })
        end
      end
    end
  end
  return deps
end

return M
