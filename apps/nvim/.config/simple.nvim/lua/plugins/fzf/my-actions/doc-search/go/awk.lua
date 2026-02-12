local M = {}

-- =============================================================================
-- AWK script to parse rg output and format symbols
-- Handles method receivers: (r *Receiver) Method -> *Receiver{}.Method
-- =============================================================================
local symbol_parser = [[
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
  gsub(/\t/, "", symbol)
]]

-- Workspace: uses modname for import path
function M.workspace_symbols()
  return symbol_parser .. [[
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

-- Stdlib: uses directory as import path
function M.stdlib_symbols()
  return symbol_parser .. [[
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

-- Deps: extracts import path from GOMODCACHE path
function M.deps_symbols()
  return symbol_parser .. [[
  # Extract import path from GOMODCACHE path
  importpath = file
  sub(/^.*\/pkg\/mod\//, "", importpath)
  sub(/@[^\/]+/, "", importpath)
  sub(/\/[^\/]+$/, "", importpath)

  printf "%s.%s\t%s:%s\n", importpath, symbol, file, linenum
}]]
end

-- Single dep/package: uses deppath for import path
function M.single_dep_symbols()
  return symbol_parser .. [[
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

return M
