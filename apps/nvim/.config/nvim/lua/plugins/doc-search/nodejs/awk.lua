local M = {}

-- =============================================================================
-- Base AWK script to parse rg output and format symbols for JS/TS
-- Handles: export, async, function, class, interface, type, const, let, var
-- Also handles arrow functions: const foo = () => or const foo = async () =>
-- =============================================================================
local symbol_parser = [[
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

  # Handle different declaration types:

  # 1. function foo(...) or async function foo(...)
  if (match(symbol, /^function\s+/)) {
    gsub(/^function\s+/, "", symbol)
    gsub(/\s*\(.*$/, "", symbol)
    gsub(/\s*<.*$/, "", symbol)  # Remove generics
    type_prefix = "fn"
  }
  # 2. class Foo
  else if (match(symbol, /^class\s+/)) {
    gsub(/^class\s+/, "", symbol)
    gsub(/\s+extends\s+.*$/, "", symbol)
    gsub(/\s+implements\s+.*$/, "", symbol)
    gsub(/\s*<.*$/, "", symbol)  # Remove generics
    type_prefix = "class"
  }
  # 3. interface Foo
  else if (match(symbol, /^interface\s+/)) {
    gsub(/^interface\s+/, "", symbol)
    gsub(/\s+extends\s+.*$/, "", symbol)
    gsub(/\s*<.*$/, "", symbol)  # Remove generics
    type_prefix = "interface"
  }
  # 4. type Foo = ...
  else if (match(symbol, /^type\s+/)) {
    gsub(/^type\s+/, "", symbol)
    gsub(/\s*=.*$/, "", symbol)
    gsub(/\s*<.*$/, "", symbol)  # Remove generics
    type_prefix = "type"
  }
  # 5. const/let/var foo = ... (including arrow functions)
  else if (match(symbol, /^(const|let|var)\s+/)) {
    gsub(/^(const|let|var)\s+/, "", symbol)
    # Check if it's an arrow function or regular function
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
    # Unknown, skip
    next
  }

  # Clean up symbol name
  gsub(/\s+/, "", symbol)
  gsub(/\t/, "", symbol)

  # Skip if symbol is empty or just punctuation
  if (symbol == "" || match(symbol, /^[^a-zA-Z_$]/)) next
]]

-- =============================================================================
-- Workspace: uses package name for import path (file-based)
-- =============================================================================
function M.workspace_symbols()
  return symbol_parser .. [[
  # Extract filename without extension
  filename = file
  gsub(/^.*\//, "", filename)
  gsub(/\.[^.]+$/, "", filename)

  # Get directory path
  dir = file
  gsub(/\/[^\/]+$/, "", dir)
  if (dir == file) dir = ""

  # Remove src/ prefix if present
  sub(/^src\//, "", dir)

  # Build import path (file-based)
  # For index files, use directory name; otherwise include filename
  if (filename == "index") {
    if (dir == "") {
      importpath = pkgname
    } else {
      importpath = pkgname "/" dir
    }
  } else {
    if (dir == "") {
      importpath = pkgname "/" filename
    } else {
      importpath = pkgname "/" dir "/" filename
    }
  }

  printf "%s.%s\t%s/%s:%s\n", importpath, symbol, basedir, file, linenum
}]]
end

-- =============================================================================
-- Dependencies: extracts package name from node_modules path (file-based)
-- =============================================================================
function M.deps_symbols()
  return symbol_parser .. [[
  # Extract filename without extension
  filename = file
  gsub(/^.*\//, "", filename)
  gsub(/\.[^.]+$/, "", filename)

  # Get path after node_modules/
  relpath = file
  sub(/^.*node_modules\//, "", relpath)

  # Extract package name (handle scoped packages)
  if (match(relpath, /^@[^\/]+\/[^\/]+/)) {
    # Scoped package: @org/pkg
    pkgname = substr(relpath, RSTART, RLENGTH)
    sub(/^@[^\/]+\/[^\/]+\/?/, "", relpath)
  } else {
    # Regular package
    pkgname = relpath
    sub(/\/.*$/, "", pkgname)
    sub(/^[^\/]+\/?/, "", relpath)
  }

  # Get directory within package (without filename)
  dir = relpath
  gsub(/\/[^\/]+$/, "", dir)
  if (dir == relpath) dir = ""

  # Build import path (file-based)
  if (filename == "index") {
    if (dir == "") {
      importpath = pkgname
    } else {
      importpath = pkgname "/" dir
    }
  } else {
    if (dir == "") {
      importpath = pkgname "/" filename
    } else {
      importpath = pkgname "/" dir "/" filename
    }
  }

  printf "%s.%s\t%s:%s\n", importpath, symbol, file, linenum
}]]
end

-- =============================================================================
-- Single dependency: uses provided deppath for import path (file-based)
-- =============================================================================
function M.single_dep_symbols()
  return symbol_parser .. [[
  # Extract filename without extension
  filename = file
  gsub(/^.*\//, "", filename)
  gsub(/\.[^.]+$/, "", filename)

  # Get directory path
  dir = file
  gsub(/\/[^\/]+$/, "", dir)
  if (dir == file) dir = ""

  # Build import path (file-based)
  if (filename == "index") {
    if (dir == "") {
      importpath = deppath
    } else {
      importpath = deppath "/" dir
    }
  } else {
    if (dir == "") {
      importpath = deppath "/" filename
    } else {
      importpath = deppath "/" dir "/" filename
    }
  }

  printf "%s.%s\t%s:%s\n", importpath, symbol, file, linenum
}]]
end

return M
