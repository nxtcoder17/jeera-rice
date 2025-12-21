local fzf = require("fzf-lua")

local M = {}

-- =============================================================================
-- Patterns for different symbol types
-- =============================================================================
local patterns = {
  all = "^(func |type |const |var )",
  functions = "^func ",
  types = "^type ",
  constants = "^(const |var )",
}

-- =============================================================================
-- Get module name from go.mod
-- =============================================================================
local function get_module_name()
  local mod = vim.fn.systemlist("go list -m 2>/dev/null")[1]
  return mod or "go.mod"
end

-- =============================================================================
-- Get GOROOT path
-- =============================================================================
local function get_goroot()
  local goroot = vim.fn.systemlist("go env GOROOT 2>/dev/null")[1]
  return goroot or ""
end

-- =============================================================================
-- Get stdlib packages
-- =============================================================================
local function get_stdlib_packages()
  local goroot = get_goroot()
  if goroot == "" then return {} end

  local src_dir = goroot .. "/src"
  if vim.fn.isdirectory(src_dir) ~= 1 then return {} end

  -- Get all stdlib packages using go list
  local pkgs = vim.fn.systemlist("go list std 2>/dev/null")
  local result = {}
  for _, pkg in ipairs(pkgs) do
    if pkg ~= "" and not pkg:match("^vendor/") and not pkg:match("^internal/") and not pkg:match("/internal/") and not pkg:match("/internal$") then
      local pkg_dir = src_dir .. "/" .. pkg
      if vim.fn.isdirectory(pkg_dir) == 1 then
        table.insert(result, { path = pkg, dir = pkg_dir })
      end
    end
  end
  return result
end

-- =============================================================================
-- Build rg command with custom formatting: import-path.Symbol<TAB>file:line
-- Includes both workspace and stdlib when include_stdlib is true
-- =============================================================================
local function build_cmd(base_dir, pattern, include_stdlib)
  pattern = pattern or patterns.all
  -- Get module name for import path calculation
  local mod_name = vim.fn.systemlist("cd '" .. base_dir .. "' && go list -m 2>/dev/null")[1] or ""
  if mod_name == "" or mod_name:match("^command%-line%-arguments") then
    mod_name = vim.fn.fnamemodify(base_dir, ":t") -- fallback to directory name
  end

  local goroot = get_goroot()
  local stdlib_src = goroot ~= "" and (goroot .. "/src") or ""

  -- Build workspace command
  local ws_cmd = string.format(
    [[cd '%s' && rg -n --no-heading '%s' --glob '*.go' --glob '!*_test.go' . 2>/dev/null | sed 's|^\./||' | awk -F: -v modname='%s' -v basedir='%s' '
    {
      file = $1
      linenum = $2
      content = $0
      sub(/^[^:]+:[^:]+:/, "", content)
      gsub(/ *\{.*$/, "", content)

      symbol = content
      gsub(/^(func|type|const|var) +/, "", symbol)

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

      dir = file
      gsub(/\/[^\/]+$/, "", dir)
      if (dir == file) dir = "."

      if (dir == ".") {
        importpath = modname
      } else {
        importpath = modname "/" dir
      }

      printf "%%s.%%s\t%%s/%%s:%%s\n", importpath, symbol, basedir, file, linenum
    }']],
    base_dir, pattern, mod_name, base_dir
  )

  -- If not including stdlib or stdlib not found, just return workspace command
  if not include_stdlib or stdlib_src == "" then
    return ws_cmd
  end

  -- Build stdlib command
  local stdlib_cmd = string.format(
    [[cd '%s' && rg -n --no-heading '%s' --glob '*.go' --glob '!*_test.go' --glob '!vendor/**' --glob '!internal/**' --glob '!**/internal/**' . 2>/dev/null | sed 's|^\./||' | awk -F: -v srcdir='%s' '
    {
      file = $1
      linenum = $2
      content = $0
      sub(/^[^:]+:[^:]+:/, "", content)
      gsub(/ *\{.*$/, "", content)

      symbol = content
      gsub(/^(func|type|const|var) +/, "", symbol)

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

      dir = file
      gsub(/\/[^\/]+$/, "", dir)
      if (dir == file) dir = ""
      importpath = dir

      if (importpath == "") {
        printf "%%s\t%%s/%%s:%%s\n", symbol, srcdir, file, linenum
      } else {
        printf "%%s.%%s\t%%s/%%s:%%s\n", importpath, symbol, srcdir, file, linenum
      }
    }']],
    stdlib_src, pattern, stdlib_src
  )

  -- Combine both commands
  return "{ " .. ws_cmd .. "; " .. stdlib_cmd .. "; }"
end

-- =============================================================================
-- Build fzf options with preview (handles absolute paths)
-- =============================================================================
local function build_fzf_opts(header, query)
  local opts = {
    ["--delimiter"] = "\t",
    ["--with-nth"] = "1",
    ["--nth"] = "1",
    ["--preview"] = "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); bat --style=header,numbers --color=always --highlight-line $l --line-range $l: $f 2>/dev/null || { echo \"── $f\"; cat -n $f | tail -n +$l | head -30; }",
    ["--preview-window"] = "right:40%",
    ["--header"] = header,
  }
  if query and query ~= "" then
    opts["--query"] = query
  end
  return opts
end

-- =============================================================================
-- Helper to extract query from fzf-lua opts
-- =============================================================================
local function get_query(opts)
  return opts and opts.__call_opts and opts.__call_opts.query or ""
end

-- =============================================================================
-- Get query text from cursor position using treesitter
-- Returns selector expression if on call_expression, otherwise falls back to <cword>
-- =============================================================================
local function get_query_at_cursor()
  local ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
  if ok then
    local node = ts_utils.get_node_at_cursor()
    if node then
      -- Walk up the tree to find a call_expression
      local current = node
      while current do
        if current:type() == "call_expression" then
          -- Found a call_expression, get the function field
          local func_node = current:field("function")[1]
          if func_node then
            if func_node:type() == "selector_expression" then
              return "'" .. vim.treesitter.get_node_text(func_node, 0)
            elseif func_node:type() == "identifier" then
              -- Simple function call like myFunc()
              return "'" .. vim.treesitter.get_node_text(func_node, 0)
            end
          end
          break
        end
        current = current:parent()
      end
    end
  end

  -- Fallback to word under cursor
  local cword = vim.fn.expand("<cword>")
  return cword ~= "" and "'" .. cword or nil
end

-- =============================================================================
-- Parse selection: extract file, line, symbol from "import-path.Symbol(...)<TAB>file:line"
-- =============================================================================
local function parse_selection(selected)
  if not selected or #selected == 0 then return nil end
  local parts = vim.split(selected[1], "\t")
  if #parts >= 2 then
    local file, line = parts[2]:match("^([^:]+):(%d+)")
    return { file = file, line = line, symbol = parts[1] }
  end
  return nil
end

-- =============================================================================
-- All symbols view (includes stdlib when searching from workspace root)
-- =============================================================================
function M.symbols(dir, query)
  local cwd = dir or vim.fn.getcwd()
  local include_stdlib = not dir -- include stdlib only when searching from workspace root
  -- Use selector at cursor as default query if none provided
  local effective_query = query or get_query_at_cursor()
  local shortcuts = dir and "ctrl-f: funcs | ctrl-t: types | ctrl-c: consts" or "ctrl-f: funcs | ctrl-t: types | ctrl-c: consts | ctrl-p: packages | ctrl-d: deps"
  local header = shortcuts
  fzf.fzf_exec(build_cmd(cwd, patterns.all, include_stdlib), {
    prompt = "Symbols ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, effective_query),
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.symbol)
          vim.notify("Copied: " .. parsed.symbol)
        end
      end,
      ["ctrl-f"] = function(_, opts) M.functions(dir, get_query(opts)) end,
      ["ctrl-t"] = function(_, opts) M.types(dir, get_query(opts)) end,
      ["ctrl-c"] = function(_, opts) M.constants(dir, get_query(opts)) end,
      ["ctrl-p"] = not dir and function(_, opts) M.packages(get_query(opts)) end or nil,
      ["ctrl-d"] = not dir and function(_, opts) M.dep_packages(get_query(opts)) end or nil,
    },
  })
end

-- =============================================================================
-- Get direct dependencies from go.mod
-- =============================================================================
local function get_go_mod_deps()
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

-- =============================================================================
-- Build rg command for multiple directories (dependencies)
-- Shows import-path.Symbol format (e.g., github.com/pkg/errors.New)
-- =============================================================================
local function build_deps_cmd(deps, pattern, gomodcache)
  pattern = pattern or patterns.all
  local dirs = {}
  for _, dep in ipairs(deps) do
    table.insert(dirs, "'" .. dep.dir .. "'")
  end
  if #dirs == 0 then return "echo ''" end

  return string.format(
    [[rg -n --no-heading '%s' --glob '*.go' --glob '!*_test.go' %s 2>/dev/null | awk -F: '
    {
      file = $1
      linenum = $2
      content = $0
      sub(/^[^:]+:[^:]+:/, "", content)
      gsub(/ *\{.*$/, "", content)

      # Extract symbol from declaration
      symbol = content
      gsub(/^(func|type|const|var) +/, "", symbol)

      # Handle method receivers: (r *Receiver) MethodName(...) -> *Receiver{}.MethodName(...)
      if (match(symbol, /^\([^)]+\) +/)) {
        receiver_part = substr(symbol, RSTART, RLENGTH)
        method_part = substr(symbol, RSTART + RLENGTH)

        # Extract type from receiver: "(s *UDPServer) " -> "*UDPServer"
        receiver_type = receiver_part
        gsub(/^\(/, "", receiver_type)
        gsub(/\) *$/, "", receiver_type)
        gsub(/^[^ ]+ +/, "", receiver_type)

        symbol = receiver_type "{}." method_part
      }
      gsub(/\t/, "", symbol)

      # Extract import path from GOMODCACHE path
      # e.g., /home/user/go/pkg/mod/github.com/pkg/errors@v0.9.1/errors.go
      #    -> github.com/pkg/errors
      importpath = file
      sub(/^.*\/pkg\/mod\//, "", importpath)  # remove gomodcache prefix
      sub(/@[^\/]+/, "", importpath)          # remove @version
      sub(/\/[^\/]+$/, "", importpath)        # remove filename

      printf "%%s.%%s\t%%s:%%s\n", importpath, symbol, file, linenum
    }']],
    pattern, table.concat(dirs, " ")
  )
end

-- =============================================================================
-- Build rg command for a single dependency directory
-- =============================================================================
local function build_single_dep_cmd(dep_dir, dep_path, pattern)
  pattern = pattern or patterns.all
  return string.format(
    [[cd '%s' && rg -n --no-heading '%s' --glob '*.go' --glob '!*_test.go' . 2>/dev/null | sed 's|^\./||' | awk -F: -v deppath='%s' '
    {
      file = $1
      linenum = $2
      content = $0
      sub(/^[^:]+:[^:]+:/, "", content)
      gsub(/ *\{.*$/, "", content)

      # Extract symbol from declaration
      symbol = content
      gsub(/^(func|type|const|var) +/, "", symbol)

      # Handle method receivers: (r *Receiver) MethodName(...) -> *Receiver{}.MethodName(...)
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

      # Calculate import path from file directory within dep
      dir = file
      gsub(/\/[^\/]+$/, "", dir)
      if (dir == file) dir = ""

      if (dir == "") {
        importpath = deppath
      } else {
        importpath = deppath "/" dir
      }

      printf "%%s.%%s\t%%s:%%s\n", importpath, symbol, file, linenum
    }']],
    dep_dir, pattern, dep_path
  )
end

-- =============================================================================
-- List dependency packages
-- =============================================================================
function M.dep_packages(query)
  local deps = get_go_mod_deps()
  if #deps == 0 then
    vim.notify("No dependencies found in go.mod", vim.log.levels.WARN)
    return
  end

  local items = {}
  for _, dep in ipairs(deps) do
    table.insert(items, dep.path .. "@" .. dep.version .. "\t" .. dep.dir .. "\t" .. dep.path)
  end

  local shortcuts = "ctrl-a: all symbols | ctrl-f: all funcs | ctrl-t: all types | ctrl-w: workspace"
  local header = shortcuts .. "\n" .. get_module_name() .. " (" .. #deps .. " deps)"

  local fzf_opts = {
    ["--delimiter"] = "\t",
    ["--with-nth"] = "1",
    ["--nth"] = "1",
    ["--preview"] = "tree -C -L 2 {2} 2>/dev/null || ls -la {2} 2>/dev/null",
    ["--header"] = header,
  }
  if query and query ~= "" then
    fzf_opts["--query"] = query
  end

  fzf.fzf_exec(items, {
    prompt = "Dep Packages ❯ ",
    previewer = false,
    fzf_opts = fzf_opts,
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then return end
        local parts = vim.split(selected[1], "\t")
        local dep_dir = parts[2]
        local dep_path = parts[3]
        M.dep_package_symbols(dep_path, dep_dir)
      end,
      ["ctrl-y"] = function(selected)
        if not selected or #selected == 0 then return end
        local parts = vim.split(selected[1], "\t")
        vim.fn.setreg("+", parts[3])
        vim.notify("Copied: " .. parts[3])
      end,
      ["ctrl-a"] = function(_, opts) M.dep_symbols(get_query(opts)) end,
      ["ctrl-f"] = function(_, opts) M.dep_functions(get_query(opts)) end,
      ["ctrl-t"] = function(_, opts) M.dep_types(get_query(opts)) end,
      ["ctrl-c"] = function(_, opts) M.dep_constants(get_query(opts)) end,
      ["ctrl-w"] = function(_, opts) M.functions(nil, get_query(opts)) end,
    },
  })
end

-- =============================================================================
-- Show symbols from a specific dependency package
-- =============================================================================
function M.dep_package_symbols(dep_path, dep_dir)
  local shortcuts = "ctrl-f: funcs | ctrl-t: types | ctrl-c: consts | ctrl-p: packages"
  local header = shortcuts .. "\n" .. dep_path

  fzf.fzf_exec(build_single_dep_cmd(dep_dir, dep_path, patterns.all), {
    prompt = "Symbols ❯ ",
    previewer = false,
    fzf_opts = {
      ["--delimiter"] = "\t",
      ["--with-nth"] = "1",
      ["--nth"] = "1",
      ["--preview"] = string.format(
        "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); bat --style=header,numbers --color=always --highlight-line $l --line-range $l: '%s/'$f 2>/dev/null || { echo '── %s/'$f; cat -n '%s/'$f | tail -n +$l | head -30; }",
        dep_dir, dep_dir, dep_dir
      ),
      ["--preview-window"] = "right:40%",
      ["--header"] = header,
    },
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. dep_dir .. "/" .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.symbol)
          vim.notify("Copied: " .. parsed.symbol)
        end
      end,
      ["ctrl-f"] = function() M.dep_package_functions(dep_path, dep_dir) end,
      ["ctrl-t"] = function() M.dep_package_types(dep_path, dep_dir) end,
      ["ctrl-c"] = function() M.dep_package_constants(dep_path, dep_dir) end,
      ["ctrl-p"] = function() M.dep_packages() end,
    },
  })
end

-- =============================================================================
-- Show functions from a specific dependency package
-- =============================================================================
function M.dep_package_functions(dep_path, dep_dir)
  local shortcuts = "ctrl-a: all | ctrl-t: types | ctrl-c: consts | ctrl-p: packages"
  local header = shortcuts .. "\n" .. dep_path

  fzf.fzf_exec(build_single_dep_cmd(dep_dir, dep_path, patterns.functions), {
    prompt = "Functions ❯ ",
    previewer = false,
    fzf_opts = {
      ["--delimiter"] = "\t",
      ["--with-nth"] = "1",
      ["--nth"] = "1",
      ["--preview"] = string.format(
        "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); bat --style=header,numbers --color=always --highlight-line $l --line-range $l: '%s/'$f 2>/dev/null || { echo '── %s/'$f; cat -n '%s/'$f | tail -n +$l | head -30; }",
        dep_dir, dep_dir, dep_dir
      ),
      ["--preview-window"] = "right:40%",
      ["--header"] = header,
    },
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. dep_dir .. "/" .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.symbol)
          vim.notify("Copied: " .. parsed.symbol)
        end
      end,
      ["ctrl-a"] = function() M.dep_package_symbols(dep_path, dep_dir) end,
      ["ctrl-t"] = function() M.dep_package_types(dep_path, dep_dir) end,
      ["ctrl-c"] = function() M.dep_package_constants(dep_path, dep_dir) end,
      ["ctrl-p"] = function() M.dep_packages() end,
    },
  })
end

-- =============================================================================
-- Show types from a specific dependency package
-- =============================================================================
function M.dep_package_types(dep_path, dep_dir)
  local shortcuts = "ctrl-a: all | ctrl-f: funcs | ctrl-c: consts | ctrl-p: packages"
  local header = shortcuts .. "\n" .. dep_path

  fzf.fzf_exec(build_single_dep_cmd(dep_dir, dep_path, patterns.types), {
    prompt = "Types ❯ ",
    previewer = false,
    fzf_opts = {
      ["--delimiter"] = "\t",
      ["--with-nth"] = "1",
      ["--nth"] = "1",
      ["--preview"] = string.format(
        "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); bat --style=header,numbers --color=always --highlight-line $l --line-range $l: '%s/'$f 2>/dev/null || { echo '── %s/'$f; cat -n '%s/'$f | tail -n +$l | head -30; }",
        dep_dir, dep_dir, dep_dir
      ),
      ["--preview-window"] = "right:40%",
      ["--header"] = header,
    },
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. dep_dir .. "/" .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.symbol)
          vim.notify("Copied: " .. parsed.symbol)
        end
      end,
      ["ctrl-a"] = function() M.dep_package_symbols(dep_path, dep_dir) end,
      ["ctrl-f"] = function() M.dep_package_functions(dep_path, dep_dir) end,
      ["ctrl-c"] = function() M.dep_package_constants(dep_path, dep_dir) end,
      ["ctrl-p"] = function() M.dep_packages() end,
    },
  })
end

-- =============================================================================
-- Show constants from a specific dependency package
-- =============================================================================
function M.dep_package_constants(dep_path, dep_dir)
  local shortcuts = "ctrl-a: all | ctrl-f: funcs | ctrl-t: types | ctrl-p: packages"
  local header = shortcuts .. "\n" .. dep_path

  fzf.fzf_exec(build_single_dep_cmd(dep_dir, dep_path, patterns.constants), {
    prompt = "Constants ❯ ",
    previewer = false,
    fzf_opts = {
      ["--delimiter"] = "\t",
      ["--with-nth"] = "1",
      ["--nth"] = "1",
      ["--preview"] = string.format(
        "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); bat --style=header,numbers --color=always --highlight-line $l --line-range $l: '%s/'$f 2>/dev/null || { echo '── %s/'$f; cat -n '%s/'$f | tail -n +$l | head -30; }",
        dep_dir, dep_dir, dep_dir
      ),
      ["--preview-window"] = "right:40%",
      ["--header"] = header,
    },
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. dep_dir .. "/" .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.symbol)
          vim.notify("Copied: " .. parsed.symbol)
        end
      end,
      ["ctrl-a"] = function() M.dep_package_symbols(dep_path, dep_dir) end,
      ["ctrl-f"] = function() M.dep_package_functions(dep_path, dep_dir) end,
      ["ctrl-t"] = function() M.dep_package_types(dep_path, dep_dir) end,
      ["ctrl-p"] = function() M.dep_packages() end,
    },
  })
end

-- =============================================================================
-- Get all packages (workspace + stdlib + GOMODCACHE)
-- =============================================================================
function M.packages(query)
  local items = {}

  -- Workspace packages (go list with directory)
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
  local cache = vim.fn.systemlist("go env GOMODCACHE")[1] or ""
  if cache ~= "" then
    local cmd = string.format("fd -t d -d 4 '@v' '%s' 2>/dev/null | head -200", cache)
    local cached = vim.fn.systemlist(cmd)
    for _, path in ipairs(cached) do
      local pkg = path:gsub(cache .. "/", "")
      if pkg ~= "" then
        -- Extract import path without version
        local import_path = pkg:gsub("@[^/]+", "")
        table.insert(items, "[mod] " .. pkg .. "\t" .. path .. "\t" .. import_path)
      end
    end
  end

  local shortcuts = "ctrl-a: all | ctrl-f: funcs | ctrl-t: types | ctrl-s: stdlib"
  local header = shortcuts .. "\n" .. get_module_name()

  local fzf_opts = {
    ["--delimiter"] = "\t",
    ["--with-nth"] = "1",
    ["--nth"] = "1",
    ["--preview"] = "tree -C -L 2 {2} 2>/dev/null || ls -la {2} 2>/dev/null",
    ["--header"] = header,
  }
  if query and query ~= "" then
    fzf_opts["--query"] = query
  end

  fzf.fzf_exec(items, {
    prompt = "Packages ❯ ",
    previewer = false,
    fzf_opts = fzf_opts,
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then return end
        local parts = vim.split(selected[1], "\t")
        local pkg_dir = parts[2]
        local pkg_path = parts[3]
        M.package_symbols(pkg_path, pkg_dir)
      end,
      ["ctrl-y"] = function(selected)
        if not selected or #selected == 0 then return end
        local parts = vim.split(selected[1], "\t")
        vim.fn.setreg("+", parts[3])
        vim.notify("Yanked: " .. parts[3])
      end,
      ["ctrl-a"] = function(_, opts) M.symbols(nil, get_query(opts)) end,
      ["ctrl-f"] = function(_, opts) M.functions(nil, get_query(opts)) end,
      ["ctrl-t"] = function(_, opts) M.types(nil, get_query(opts)) end,
      ["ctrl-c"] = function(_, opts) M.constants(nil, get_query(opts)) end,
      ["ctrl-s"] = function(_, opts) M.stdlib_packages(get_query(opts)) end,
    },
  })
end

-- =============================================================================
-- Show all symbols within a package (works for workspace, stdlib, and deps)
-- =============================================================================
function M.package_symbols(pkg_path, pkg_dir)
  local shortcuts = "ctrl-f: funcs | ctrl-t: types | ctrl-c: consts | ctrl-p: packages"
  local header = shortcuts .. "\n" .. pkg_path

  fzf.fzf_exec(build_single_dep_cmd(pkg_dir, pkg_path, patterns.all), {
    prompt = "Symbols ❯ ",
    previewer = false,
    fzf_opts = {
      ["--delimiter"] = "\t",
      ["--with-nth"] = "1",
      ["--nth"] = "1",
      ["--preview"] = string.format(
        "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); bat --style=header,numbers --color=always --highlight-line $l --line-range $l: '%s/'$f 2>/dev/null || { echo '── %s/'$f; cat -n '%s/'$f | tail -n +$l | head -30; }",
        pkg_dir, pkg_dir, pkg_dir
      ),
      ["--preview-window"] = "right:40%",
      ["--header"] = header,
    },
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. pkg_dir .. "/" .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.symbol)
          vim.notify("Copied: " .. parsed.symbol)
        end
      end,
      ["ctrl-f"] = function() M.package_functions(pkg_path, pkg_dir) end,
      ["ctrl-t"] = function() M.package_types(pkg_path, pkg_dir) end,
      ["ctrl-c"] = function() M.package_constants(pkg_path, pkg_dir) end,
      ["ctrl-p"] = function() M.packages() end,
    },
  })
end

-- =============================================================================
-- Show functions within a package
-- =============================================================================
function M.package_functions(pkg_path, pkg_dir)
  local shortcuts = "ctrl-a: all | ctrl-t: types | ctrl-c: consts | ctrl-p: packages"
  local header = shortcuts .. "\n" .. pkg_path

  fzf.fzf_exec(build_single_dep_cmd(pkg_dir, pkg_path, patterns.functions), {
    prompt = "Functions ❯ ",
    previewer = false,
    fzf_opts = {
      ["--delimiter"] = "\t",
      ["--with-nth"] = "1",
      ["--nth"] = "1",
      ["--preview"] = string.format(
        "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); bat --style=header,numbers --color=always --highlight-line $l --line-range $l: '%s/'$f 2>/dev/null || { echo '── %s/'$f; cat -n '%s/'$f | tail -n +$l | head -30; }",
        pkg_dir, pkg_dir, pkg_dir
      ),
      ["--preview-window"] = "right:40%",
      ["--header"] = header,
    },
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. pkg_dir .. "/" .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.symbol)
          vim.notify("Copied: " .. parsed.symbol)
        end
      end,
      ["ctrl-a"] = function() M.package_symbols(pkg_path, pkg_dir) end,
      ["ctrl-t"] = function() M.package_types(pkg_path, pkg_dir) end,
      ["ctrl-c"] = function() M.package_constants(pkg_path, pkg_dir) end,
      ["ctrl-p"] = function() M.packages() end,
    },
  })
end

-- =============================================================================
-- Show types within a package
-- =============================================================================
function M.package_types(pkg_path, pkg_dir)
  local shortcuts = "ctrl-a: all | ctrl-f: funcs | ctrl-c: consts | ctrl-p: packages"
  local header = shortcuts .. "\n" .. pkg_path

  fzf.fzf_exec(build_single_dep_cmd(pkg_dir, pkg_path, patterns.types), {
    prompt = "Types ❯ ",
    previewer = false,
    fzf_opts = {
      ["--delimiter"] = "\t",
      ["--with-nth"] = "1",
      ["--nth"] = "1",
      ["--preview"] = string.format(
        "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); bat --style=header,numbers --color=always --highlight-line $l --line-range $l: '%s/'$f 2>/dev/null || { echo '── %s/'$f; cat -n '%s/'$f | tail -n +$l | head -30; }",
        pkg_dir, pkg_dir, pkg_dir
      ),
      ["--preview-window"] = "right:40%",
      ["--header"] = header,
    },
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. pkg_dir .. "/" .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.symbol)
          vim.notify("Copied: " .. parsed.symbol)
        end
      end,
      ["ctrl-a"] = function() M.package_symbols(pkg_path, pkg_dir) end,
      ["ctrl-f"] = function() M.package_functions(pkg_path, pkg_dir) end,
      ["ctrl-c"] = function() M.package_constants(pkg_path, pkg_dir) end,
      ["ctrl-p"] = function() M.packages() end,
    },
  })
end

-- =============================================================================
-- Show constants within a package
-- =============================================================================
function M.package_constants(pkg_path, pkg_dir)
  local shortcuts = "ctrl-a: all | ctrl-f: funcs | ctrl-t: types | ctrl-p: packages"
  local header = shortcuts .. "\n" .. pkg_path

  fzf.fzf_exec(build_single_dep_cmd(pkg_dir, pkg_path, patterns.constants), {
    prompt = "Constants ❯ ",
    previewer = false,
    fzf_opts = {
      ["--delimiter"] = "\t",
      ["--with-nth"] = "1",
      ["--nth"] = "1",
      ["--preview"] = string.format(
        "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); bat --style=header,numbers --color=always --highlight-line $l --line-range $l: '%s/'$f 2>/dev/null || { echo '── %s/'$f; cat -n '%s/'$f | tail -n +$l | head -30; }",
        pkg_dir, pkg_dir, pkg_dir
      ),
      ["--preview-window"] = "right:40%",
      ["--header"] = header,
    },
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. pkg_dir .. "/" .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.symbol)
          vim.notify("Copied: " .. parsed.symbol)
        end
      end,
      ["ctrl-a"] = function() M.package_symbols(pkg_path, pkg_dir) end,
      ["ctrl-f"] = function() M.package_functions(pkg_path, pkg_dir) end,
      ["ctrl-t"] = function() M.package_types(pkg_path, pkg_dir) end,
      ["ctrl-p"] = function() M.packages() end,
    },
  })
end

-- =============================================================================
-- List stdlib packages only
-- =============================================================================
function M.stdlib_packages(query)
  local stdlib = get_stdlib_packages()
  if #stdlib == 0 then
    vim.notify("Could not find Go stdlib", vim.log.levels.WARN)
    return
  end

  local items = {}
  for _, pkg in ipairs(stdlib) do
    table.insert(items, pkg.path .. "\t" .. pkg.dir .. "\t" .. pkg.path)
  end

  local shortcuts = "ctrl-a: all symbols | ctrl-f: all funcs | ctrl-t: all types | ctrl-p: all packages"
  local header = shortcuts .. "\nGo stdlib (" .. #stdlib .. " packages)"

  local fzf_opts = {
    ["--delimiter"] = "\t",
    ["--with-nth"] = "1",
    ["--nth"] = "1",
    ["--preview"] = "tree -C -L 2 {2} 2>/dev/null || ls -la {2} 2>/dev/null",
    ["--header"] = header,
  }
  if query and query ~= "" then
    fzf_opts["--query"] = query
  end

  fzf.fzf_exec(items, {
    prompt = "Stdlib ❯ ",
    previewer = false,
    fzf_opts = fzf_opts,
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then return end
        local parts = vim.split(selected[1], "\t")
        local pkg_dir = parts[2]
        local pkg_path = parts[3]
        M.package_symbols(pkg_path, pkg_dir)
      end,
      ["ctrl-y"] = function(selected)
        if not selected or #selected == 0 then return end
        local parts = vim.split(selected[1], "\t")
        vim.fn.setreg("+", parts[3])
        vim.notify("Copied: " .. parts[3])
      end,
      ["ctrl-a"] = function(_, opts) M.stdlib_symbols(get_query(opts)) end,
      ["ctrl-f"] = function(_, opts) M.stdlib_functions(get_query(opts)) end,
      ["ctrl-t"] = function(_, opts) M.stdlib_types(get_query(opts)) end,
      ["ctrl-p"] = function(_, opts) M.packages(get_query(opts)) end,
    },
  })
end

-- =============================================================================
-- Build rg command for stdlib (all packages)
-- =============================================================================
local function build_stdlib_cmd(pattern)
  local goroot = get_goroot()
  if goroot == "" then return "echo ''" end

  local src_dir = goroot .. "/src"
  pattern = pattern or patterns.all

  return string.format(
    [[cd '%s' && rg -n --no-heading '%s' --glob '*.go' --glob '!*_test.go' --glob '!vendor/**' --glob '!internal/**' . 2>/dev/null | sed 's|^\./||' | awk -F: '
    {
      file = $1
      linenum = $2
      content = $0
      sub(/^[^:]+:[^:]+:/, "", content)
      gsub(/ *\{.*$/, "", content)

      # Extract symbol from declaration
      symbol = content
      gsub(/^(func|type|const|var) +/, "", symbol)

      # Handle method receivers
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

      # Get import path from file directory
      dir = file
      gsub(/\/[^\/]+$/, "", dir)
      if (dir == file) dir = ""
      importpath = dir

      if (importpath == "") {
        printf "%%s\t%%s:%%s\n", symbol, file, linenum
      } else {
        printf "%%s.%%s\t%%s:%%s\n", importpath, symbol, file, linenum
      }
    }']],
    src_dir, pattern
  )
end

-- =============================================================================
-- Search all stdlib symbols
-- =============================================================================
function M.stdlib_symbols(query)
  local shortcuts = "ctrl-f: funcs | ctrl-t: types | ctrl-c: consts | ctrl-p: packages"
  local header = shortcuts .. "\nGo stdlib"
  local goroot = get_goroot()
  local src_dir = goroot .. "/src"

  local fzf_opts = {
    ["--delimiter"] = "\t",
    ["--with-nth"] = "1",
    ["--nth"] = "1",
    ["--preview"] = string.format(
      "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); echo '── '$f':'; bat --style=numbers --color=always --highlight-line $l --line-range $l: '%s/'$f 2>/dev/null || cat -n '%s/'$f | tail -n +$l | head -30",
      src_dir, src_dir
    ),
    ["--preview-window"] = "right:40%",
    ["--header"] = header,
  }
  if query and query ~= "" then
    fzf_opts["--query"] = query
  end

  fzf.fzf_exec(build_stdlib_cmd(patterns.all), {
    prompt = "Stdlib Symbols ❯ ",
    previewer = false,
    fzf_opts = fzf_opts,
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. src_dir .. "/" .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.symbol)
          vim.notify("Copied: " .. parsed.symbol)
        end
      end,
      ["ctrl-f"] = function(_, opts) M.stdlib_functions(get_query(opts)) end,
      ["ctrl-t"] = function(_, opts) M.stdlib_types(get_query(opts)) end,
      ["ctrl-c"] = function(_, opts) M.stdlib_constants(get_query(opts)) end,
      ["ctrl-p"] = function(_, opts) M.stdlib_packages(get_query(opts)) end,
    },
  })
end

-- =============================================================================
-- Search all stdlib functions
-- =============================================================================
function M.stdlib_functions(query)
  local shortcuts = "ctrl-a: all | ctrl-t: types | ctrl-c: consts | ctrl-p: packages"
  local header = shortcuts .. "\nGo stdlib"
  local goroot = get_goroot()
  local src_dir = goroot .. "/src"

  local fzf_opts = {
    ["--delimiter"] = "\t",
    ["--with-nth"] = "1",
    ["--nth"] = "1",
    ["--preview"] = string.format(
      "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); echo '── '$f':'; bat --style=numbers --color=always --highlight-line $l --line-range $l: '%s/'$f 2>/dev/null || cat -n '%s/'$f | tail -n +$l | head -30",
      src_dir, src_dir
    ),
    ["--preview-window"] = "right:40%",
    ["--header"] = header,
  }
  if query and query ~= "" then
    fzf_opts["--query"] = query
  end

  fzf.fzf_exec(build_stdlib_cmd(patterns.functions), {
    prompt = "Stdlib Functions ❯ ",
    previewer = false,
    fzf_opts = fzf_opts,
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. src_dir .. "/" .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.symbol)
          vim.notify("Copied: " .. parsed.symbol)
        end
      end,
      ["ctrl-a"] = function(_, opts) M.stdlib_symbols(get_query(opts)) end,
      ["ctrl-t"] = function(_, opts) M.stdlib_types(get_query(opts)) end,
      ["ctrl-c"] = function(_, opts) M.stdlib_constants(get_query(opts)) end,
      ["ctrl-p"] = function(_, opts) M.stdlib_packages(get_query(opts)) end,
    },
  })
end

-- =============================================================================
-- Search all stdlib types
-- =============================================================================
function M.stdlib_types(query)
  local shortcuts = "ctrl-a: all | ctrl-f: funcs | ctrl-c: consts | ctrl-p: packages"
  local header = shortcuts .. "\nGo stdlib"
  local goroot = get_goroot()
  local src_dir = goroot .. "/src"

  local fzf_opts = {
    ["--delimiter"] = "\t",
    ["--with-nth"] = "1",
    ["--nth"] = "1",
    ["--preview"] = string.format(
      "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); echo '── '$f':'; bat --style=numbers --color=always --highlight-line $l --line-range $l: '%s/'$f 2>/dev/null || cat -n '%s/'$f | tail -n +$l | head -30",
      src_dir, src_dir
    ),
    ["--preview-window"] = "right:40%",
    ["--header"] = header,
  }
  if query and query ~= "" then
    fzf_opts["--query"] = query
  end

  fzf.fzf_exec(build_stdlib_cmd(patterns.types), {
    prompt = "Stdlib Types ❯ ",
    previewer = false,
    fzf_opts = fzf_opts,
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. src_dir .. "/" .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.symbol)
          vim.notify("Copied: " .. parsed.symbol)
        end
      end,
      ["ctrl-a"] = function(_, opts) M.stdlib_symbols(get_query(opts)) end,
      ["ctrl-f"] = function(_, opts) M.stdlib_functions(get_query(opts)) end,
      ["ctrl-c"] = function(_, opts) M.stdlib_constants(get_query(opts)) end,
      ["ctrl-p"] = function(_, opts) M.stdlib_packages(get_query(opts)) end,
    },
  })
end

-- =============================================================================
-- Search all stdlib constants
-- =============================================================================
function M.stdlib_constants(query)
  local shortcuts = "ctrl-a: all | ctrl-f: funcs | ctrl-t: types | ctrl-p: packages"
  local header = shortcuts .. "\nGo stdlib"
  local goroot = get_goroot()
  local src_dir = goroot .. "/src"

  local fzf_opts = {
    ["--delimiter"] = "\t",
    ["--with-nth"] = "1",
    ["--nth"] = "1",
    ["--preview"] = string.format(
      "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); echo '── '$f':'; bat --style=numbers --color=always --highlight-line $l --line-range $l: '%s/'$f 2>/dev/null || cat -n '%s/'$f | tail -n +$l | head -30",
      src_dir, src_dir
    ),
    ["--preview-window"] = "right:40%",
    ["--header"] = header,
  }
  if query and query ~= "" then
    fzf_opts["--query"] = query
  end

  fzf.fzf_exec(build_stdlib_cmd(patterns.constants), {
    prompt = "Stdlib Constants ❯ ",
    previewer = false,
    fzf_opts = fzf_opts,
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. src_dir .. "/" .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.symbol)
          vim.notify("Copied: " .. parsed.symbol)
        end
      end,
      ["ctrl-a"] = function(_, opts) M.stdlib_symbols(get_query(opts)) end,
      ["ctrl-f"] = function(_, opts) M.stdlib_functions(get_query(opts)) end,
      ["ctrl-t"] = function(_, opts) M.stdlib_types(get_query(opts)) end,
      ["ctrl-p"] = function(_, opts) M.stdlib_packages(get_query(opts)) end,
    },
  })
end

-- =============================================================================
-- Search functions (includes stdlib when searching from workspace root)
-- =============================================================================
function M.functions(dir, query)
  local cwd = dir or vim.fn.getcwd()
  local include_stdlib = not dir
  -- Use selector at cursor as default query if none provided
  local effective_query = query or get_query_at_cursor()
  local shortcuts = dir and "ctrl-a: all | ctrl-t: types | ctrl-c: consts" or "ctrl-a: all | ctrl-t: types | ctrl-c: consts | ctrl-p: packages | ctrl-d: deps"
  local header = shortcuts
  fzf.fzf_exec(build_cmd(cwd, patterns.functions, include_stdlib), {
    prompt = "Functions ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, effective_query),
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.symbol)
          vim.notify("Copied: " .. parsed.symbol)
        end
      end,
      ["ctrl-a"] = function(_, opts) M.symbols(dir, get_query(opts)) end,
      ["ctrl-t"] = function(_, opts) M.types(dir, get_query(opts)) end,
      ["ctrl-c"] = function(_, opts) M.constants(dir, get_query(opts)) end,
      ["ctrl-p"] = not dir and function(_, opts) M.packages(get_query(opts)) end or nil,
      ["ctrl-d"] = not dir and function(_, opts) M.dep_packages(get_query(opts)) end or nil,
    },
  })
end

-- =============================================================================
-- Search functions in dependencies
-- =============================================================================
function M.dep_functions(query)
  local deps = get_go_mod_deps()
  if #deps == 0 then
    vim.notify("No dependencies found in go.mod", vim.log.levels.WARN)
    return
  end
  local shortcuts = "ctrl-a: all | ctrl-t: types | ctrl-c: consts | ctrl-p: packages | ctrl-w: workspace"
  local header = shortcuts .. "\n" .. get_module_name() .. " deps (" .. #deps .. ")"

  local fzf_opts = {
    ["--delimiter"] = "\t",
    ["--with-nth"] = "1",
    ["--nth"] = "1",
    ["--preview"] = "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); bat --style=header,numbers --color=always --highlight-line $l --line-range $l: $f 2>/dev/null || { echo \"── $f\"; cat -n $f | tail -n +$l | head -30; }",
    ["--preview-window"] = "right:40%",
    ["--header"] = header,
  }
  if query and query ~= "" then
    fzf_opts["--query"] = query
  end

  fzf.fzf_exec(build_deps_cmd(deps, patterns.functions), {
    prompt = "Dep Functions ❯ ",
    previewer = false,
    fzf_opts = fzf_opts,
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.symbol)
          vim.notify("Copied: " .. parsed.symbol)
        end
      end,
      ["ctrl-a"] = function(_, opts) M.dep_symbols(get_query(opts)) end,
      ["ctrl-t"] = function(_, opts) M.dep_types(get_query(opts)) end,
      ["ctrl-c"] = function(_, opts) M.dep_constants(get_query(opts)) end,
      ["ctrl-p"] = function(_, opts) M.dep_packages(get_query(opts)) end,
      ["ctrl-w"] = function(_, opts) M.functions(nil, get_query(opts)) end,
    },
  })
end

-- =============================================================================
-- Search types (includes stdlib when searching from workspace root)
-- =============================================================================
function M.types(dir, query)
  local cwd = dir or vim.fn.getcwd()
  local include_stdlib = not dir
  -- Use selector at cursor as default query if none provided
  local effective_query = query or get_query_at_cursor()
  local shortcuts = dir and "ctrl-a: all | ctrl-f: funcs | ctrl-c: consts" or "ctrl-a: all | ctrl-f: funcs | ctrl-c: consts | ctrl-p: packages | ctrl-d: deps"
  local header = shortcuts
  fzf.fzf_exec(build_cmd(cwd, patterns.types, include_stdlib), {
    prompt = "Types ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, effective_query),
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.symbol)
          vim.notify("Copied: " .. parsed.symbol)
        end
      end,
      ["ctrl-a"] = function(_, opts) M.symbols(dir, get_query(opts)) end,
      ["ctrl-f"] = function(_, opts) M.functions(dir, get_query(opts)) end,
      ["ctrl-c"] = function(_, opts) M.constants(dir, get_query(opts)) end,
      ["ctrl-p"] = not dir and function(_, opts) M.packages(get_query(opts)) end or nil,
      ["ctrl-d"] = not dir and function(_, opts) M.dep_packages(get_query(opts)) end or nil,
    },
  })
end

-- =============================================================================
-- Search types in dependencies
-- =============================================================================
function M.dep_types(query)
  local deps = get_go_mod_deps()
  if #deps == 0 then
    vim.notify("No dependencies found in go.mod", vim.log.levels.WARN)
    return
  end
  local shortcuts = "ctrl-a: all | ctrl-f: funcs | ctrl-c: consts | ctrl-p: packages | ctrl-w: workspace"
  local header = shortcuts .. "\n" .. get_module_name() .. " deps (" .. #deps .. ")"

  local fzf_opts = {
    ["--delimiter"] = "\t",
    ["--with-nth"] = "1",
    ["--nth"] = "1",
    ["--preview"] = "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); bat --style=header,numbers --color=always --highlight-line $l --line-range $l: $f 2>/dev/null || { echo \"── $f\"; cat -n $f | tail -n +$l | head -30; }",
    ["--preview-window"] = "right:40%",
    ["--header"] = header,
  }
  if query and query ~= "" then
    fzf_opts["--query"] = query
  end

  fzf.fzf_exec(build_deps_cmd(deps, patterns.types), {
    prompt = "Dep Types ❯ ",
    previewer = false,
    fzf_opts = fzf_opts,
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.symbol)
          vim.notify("Copied: " .. parsed.symbol)
        end
      end,
      ["ctrl-a"] = function(_, opts) M.dep_symbols(get_query(opts)) end,
      ["ctrl-f"] = function(_, opts) M.dep_functions(get_query(opts)) end,
      ["ctrl-c"] = function(_, opts) M.dep_constants(get_query(opts)) end,
      ["ctrl-p"] = function(_, opts) M.dep_packages(get_query(opts)) end,
      ["ctrl-w"] = function(_, opts) M.types(nil, get_query(opts)) end,
    },
  })
end

-- =============================================================================
-- Search constants/vars (includes stdlib when searching from workspace root)
-- =============================================================================
function M.constants(dir, query)
  local cwd = dir or vim.fn.getcwd()
  local include_stdlib = not dir
  -- Use selector at cursor as default query if none provided
  local effective_query = query or get_query_at_cursor()
  local shortcuts = dir and "ctrl-a: all | ctrl-f: funcs | ctrl-t: types" or "ctrl-a: all | ctrl-f: funcs | ctrl-t: types | ctrl-p: packages | ctrl-d: deps"
  local header = shortcuts
  fzf.fzf_exec(build_cmd(cwd, patterns.constants, include_stdlib), {
    prompt = "Constants ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, effective_query),
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.symbol)
          vim.notify("Copied: " .. parsed.symbol)
        end
      end,
      ["ctrl-a"] = function(_, opts) M.symbols(dir, get_query(opts)) end,
      ["ctrl-f"] = function(_, opts) M.functions(dir, get_query(opts)) end,
      ["ctrl-t"] = function(_, opts) M.types(dir, get_query(opts)) end,
      ["ctrl-p"] = not dir and function(_, opts) M.packages(get_query(opts)) end or nil,
      ["ctrl-d"] = not dir and function(_, opts) M.dep_packages(get_query(opts)) end or nil,
    },
  })
end

-- =============================================================================
-- Search constants in dependencies
-- =============================================================================
function M.dep_constants(query)
  local deps = get_go_mod_deps()
  if #deps == 0 then
    vim.notify("No dependencies found in go.mod", vim.log.levels.WARN)
    return
  end
  local shortcuts = "ctrl-a: all | ctrl-f: funcs | ctrl-t: types | ctrl-p: packages | ctrl-w: workspace"
  local header = shortcuts .. "\n" .. get_module_name() .. " deps (" .. #deps .. ")"

  local fzf_opts = {
    ["--delimiter"] = "\t",
    ["--with-nth"] = "1",
    ["--nth"] = "1",
    ["--preview"] = "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); bat --style=header,numbers --color=always --highlight-line $l --line-range $l: $f 2>/dev/null || { echo \"── $f\"; cat -n $f | tail -n +$l | head -30; }",
    ["--preview-window"] = "right:40%",
    ["--header"] = header,
  }
  if query and query ~= "" then
    fzf_opts["--query"] = query
  end

  fzf.fzf_exec(build_deps_cmd(deps, patterns.constants), {
    prompt = "Dep Constants ❯ ",
    previewer = false,
    fzf_opts = fzf_opts,
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.symbol)
          vim.notify("Copied: " .. parsed.symbol)
        end
      end,
      ["ctrl-a"] = function(_, opts) M.dep_symbols(get_query(opts)) end,
      ["ctrl-f"] = function(_, opts) M.dep_functions(get_query(opts)) end,
      ["ctrl-t"] = function(_, opts) M.dep_types(get_query(opts)) end,
      ["ctrl-p"] = function(_, opts) M.dep_packages(get_query(opts)) end,
      ["ctrl-w"] = function(_, opts) M.constants(nil, get_query(opts)) end,
    },
  })
end

-- =============================================================================
-- Search all symbols in dependencies
-- =============================================================================
function M.dep_symbols(query)
  local deps = get_go_mod_deps()
  if #deps == 0 then
    vim.notify("No dependencies found in go.mod", vim.log.levels.WARN)
    return
  end
  local shortcuts = "ctrl-f: funcs | ctrl-t: types | ctrl-c: consts | ctrl-p: packages | ctrl-w: workspace"
  local header = shortcuts .. "\n" .. get_module_name() .. " deps (" .. #deps .. ")"

  local fzf_opts = {
    ["--delimiter"] = "\t",
    ["--with-nth"] = "1",
    ["--nth"] = "1",
    ["--preview"] = "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); bat --style=header,numbers --color=always --highlight-line $l --line-range $l: $f 2>/dev/null || { echo \"── $f\"; cat -n $f | tail -n +$l | head -30; }",
    ["--preview-window"] = "right:40%",
    ["--header"] = header,
  }
  if query and query ~= "" then
    fzf_opts["--query"] = query
  end

  fzf.fzf_exec(build_deps_cmd(deps, patterns.all), {
    prompt = "Dep Symbols ❯ ",
    previewer = false,
    fzf_opts = fzf_opts,
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.symbol)
          vim.notify("Copied: " .. parsed.symbol)
        end
      end,
      ["ctrl-f"] = function(_, opts) M.dep_functions(get_query(opts)) end,
      ["ctrl-t"] = function(_, opts) M.dep_types(get_query(opts)) end,
      ["ctrl-c"] = function(_, opts) M.dep_constants(get_query(opts)) end,
      ["ctrl-p"] = function(_, opts) M.dep_packages(get_query(opts)) end,
      ["ctrl-w"] = function(_, opts) M.symbols(nil, get_query(opts)) end,
    },
  })
end

return M
