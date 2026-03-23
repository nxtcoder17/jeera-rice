-- util/awk.lua — Shared AWK script builders for symbol extraction
--
-- Each function returns an AWK script string.
-- The engine decides how to invoke it (inline -f or piped).

local M = {}

-- Temp file cache: written once per session, cleaned on VimLeave
local awk_files = {}

local cleanup_registered = false
local function ensure_cleanup()
  if cleanup_registered then return end
  cleanup_registered = true
  vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
      for _, path in pairs(awk_files) do
        os.remove(path)
      end
    end,
  })
end

-- Write awk script to temp file, return path. Cached per name.
function M.to_file(name, content)
  if awk_files[name] then return awk_files[name] end
  ensure_cleanup()

  local path = vim.fn.tempname() .. "_docsearch_" .. name .. ".awk"
  local f = io.open(path, "w")
  if not f then return nil end
  f:write(content)
  f:close()
  awk_files[name] = path
  return path
end

-- Go: Base symbol parser (shared prefix for all Go awk scripts)
-- Handles method receivers: (r *Receiver) Method -> *Receiver{}.Method
function M.go_symbol_parser()
  return [[
{
  file = $1
  linenum = $2
  content = $0
  sub(/^[^:]+:[^:]+:/, "", content)
  gsub(/ *\{.*$/, "", content)

  symbol = content
  gsub(/^(func|type|const|var) +/, "", symbol)

  # Handle method receivers: (r *Receiver) MethodName -> *Receiver{}.MethodName
  if (match(symbol, /^\([^)]+\) +/)) {
    receiver_part = substr(symbol, RSTART, RLENGTH)
    method_part = substr(symbol, RSTART + RLENGTH)
    receiver_type = receiver_part
    gsub(/^\(/, "", receiver_type)
    gsub(/\) *$/, "", receiver_type)
    gsub(/^[^ ]+ +/, "", receiver_type)
    symbol = receiver_type "{}." method_part
  }
  # Strip params, return types, type keywords — keep just the identifier
  gsub(/[ \t([].*$/, "", symbol)
]]
end

-- Go: Workspace symbols — modname-prefixed import path
-- Variables: modname, basedir (passed via -v)
function M.go_workspace()
  return M.go_symbol_parser() .. [[
  dir = file
  gsub(/\/[^\/]+$/, "", dir)
  if (dir == file) dir = "."

  if (dir == ".") {
    importpath = modname
  } else {
    importpath = modname "/" dir
  }

  printf "%s.%s\t%s/%s:%s\n", importpath, symbol, basedir, file, linenum
}]]
end

-- Go: Stdlib symbols — directory-based import path
-- Variables: srcdir (passed via -v)
function M.go_stdlib()
  return M.go_symbol_parser() .. [[
  dir = file
  gsub(/\/[^\/]+$/, "", dir)
  if (dir == file) dir = ""
  importpath = dir

  if (importpath == "") {
    printf "%s\t%s/%s:%s\n", symbol, srcdir, file, linenum
  } else {
    printf "%s.%s\t%s/%s:%s\n", importpath, symbol, srcdir, file, linenum
  }
}]]
end

-- Go: Dependency symbols — extract import path from GOMODCACHE path
-- No variables needed.
function M.go_deps()
  return M.go_symbol_parser() .. [[
  # Extract import path from GOMODCACHE path
  importpath = file
  sub(/^.*\/pkg\/mod\//, "", importpath)
  sub(/@[^\/]+/, "", importpath)
  sub(/\/[^\/]+$/, "", importpath)

  printf "%s.%s\t%s:%s\n", importpath, symbol, file, linenum
}]]
end

-- Go: Single dep/package symbols — uses deppath variable
-- Variables: deppath (passed via -v)
function M.go_single_dep()
  return M.go_symbol_parser() .. [[
  dir = file
  gsub(/\/[^\/]+$/, "", dir)
  if (dir == file) dir = ""

  if (dir == "") {
    importpath = deppath
  } else {
    importpath = deppath "/" dir
  }

  printf "%s.%s\t%s:%s\n", importpath, symbol, file, linenum
}]]
end

-- Node/TS: Base symbol parser
-- Handles: export, async, function, class, interface, type, const, let, var
function M.node_symbol_parser()
  return [[
{
  file = $1
  linenum = $2
  content = $0
  sub(/^[^:]+:[^:]+:/, "", content)

  # Remove trailing braces, semicolons, and whitespace
  gsub(/[{;].*$/, "", content)
  gsub(/\s*$/, "", content)

  symbol = content
  original = content

  # Remove 'export default ' or 'export '
  gsub(/^export\s+default\s+/, "", symbol)
  gsub(/^export\s+/, "", symbol)

  # Remove 'declare '
  gsub(/^declare\s+/, "", symbol)

  # Remove 'async '
  gsub(/^async\s+/, "", symbol)

  # 1. function foo(...)
  if (match(symbol, /^function\s+/)) {
    gsub(/^function\s+/, "", symbol)
    gsub(/\s*\(.*$/, "", symbol)
    gsub(/\s*<.*$/, "", symbol)
    type_prefix = "fn"
  }
  # 2. class Foo
  else if (match(symbol, /^class\s+/)) {
    gsub(/^class\s+/, "", symbol)
    gsub(/\s+extends\s+.*$/, "", symbol)
    gsub(/\s+implements\s+.*$/, "", symbol)
    gsub(/\s*<.*$/, "", symbol)
    type_prefix = "class"
  }
  # 3. interface Foo
  else if (match(symbol, /^interface\s+/)) {
    gsub(/^interface\s+/, "", symbol)
    gsub(/\s+extends\s+.*$/, "", symbol)
    gsub(/\s*<.*$/, "", symbol)
    type_prefix = "interface"
  }
  # 4. type Foo = ...
  else if (match(symbol, /^type\s+/)) {
    gsub(/^type\s+/, "", symbol)
    gsub(/\s*=.*$/, "", symbol)
    gsub(/\s*<.*$/, "", symbol)
    type_prefix = "type"
  }
  # 5. const/let/var foo = ...
  else if (match(symbol, /^(const|let|var)\s+/)) {
    gsub(/^(const|let|var)\s+/, "", symbol)
    if (match(original, /=\s*(async\s*)?\(/) || match(original, /=\s*(async\s*)?function/)) {
      gsub(/\s*[:=].*$/, "", symbol)
      type_prefix = "fn"
    } else {
      gsub(/\s*[:=].*$/, "", symbol)
      type_prefix = "const"
    }
  }
  # 6. enum Foo
  else if (match(symbol, /^enum\s+/)) {
    gsub(/^enum\s+/, "", symbol)
    type_prefix = "enum"
  }
  # 7. namespace Foo
  else if (match(symbol, /^namespace\s+/)) {
    gsub(/^namespace\s+/, "", symbol)
    type_prefix = "ns"
  }
  else {
    next
  }

  # Clean up
  gsub(/\s+/, "", symbol)
  gsub(/\t/, "", symbol)
  if (symbol == "" || match(symbol, /^[^a-zA-Z_$]/)) next
]]
end

-- Node: Workspace symbols
-- Variables: pkgname, basedir (passed via -v)
function M.node_workspace()
  return M.node_symbol_parser() .. [[
  filename = file
  gsub(/^.*\//, "", filename)
  gsub(/\.[^.]+$/, "", filename)

  dir = file
  gsub(/\/[^\/]+$/, "", dir)
  if (dir == file) dir = ""

  sub(/^src\//, "", dir)

  if (filename == "index") {
    if (dir == "") importpath = pkgname
    else importpath = pkgname "/" dir
  } else {
    if (dir == "") importpath = pkgname "/" filename
    else importpath = pkgname "/" dir "/" filename
  }

  printf "%s.%s\t%s/%s:%s\n", importpath, symbol, basedir, file, linenum
}]]
end

-- Node: Dependency symbols (multiple deps)
-- No variables needed — extracts package name from path.
function M.node_deps()
  return M.node_symbol_parser() .. [[
  filename = file
  gsub(/^.*\//, "", filename)
  gsub(/\.[^.]+$/, "", filename)

  relpath = file
  sub(/^.*node_modules\//, "", relpath)

  if (match(relpath, /^@[^\/]+\/[^\/]+/)) {
    pkgname = substr(relpath, RSTART, RLENGTH)
    sub(/^@[^\/]+\/[^\/]+\/?/, "", relpath)
  } else {
    pkgname = relpath
    sub(/\/.*$/, "", pkgname)
    sub(/^[^\/]+\/?/, "", relpath)
  }

  dir = relpath
  gsub(/\/[^\/]+$/, "", dir)
  if (dir == relpath) dir = ""

  if (filename == "index") {
    if (dir == "") importpath = pkgname
    else importpath = pkgname "/" dir
  } else {
    if (dir == "") importpath = pkgname "/" filename
    else importpath = pkgname "/" dir "/" filename
  }

  printf "%s.%s\t%s:%s\n", importpath, symbol, file, linenum
}]]
end

-- Node: Single dependency symbols
-- Variables: deppath (passed via -v)
function M.node_single_dep()
  return M.node_symbol_parser() .. [[
  filename = file
  gsub(/^.*\//, "", filename)
  gsub(/\.[^.]+$/, "", filename)

  dir = file
  gsub(/\/[^\/]+$/, "", dir)
  if (dir == file) dir = ""

  if (filename == "index") {
    if (dir == "") importpath = deppath
    else importpath = deppath "/" dir
  } else {
    if (dir == "") importpath = deppath "/" filename
    else importpath = deppath "/" dir "/" filename
  }

  printf "%s.%s\t%s:%s\n", importpath, symbol, file, linenum
}]]
end

return M
