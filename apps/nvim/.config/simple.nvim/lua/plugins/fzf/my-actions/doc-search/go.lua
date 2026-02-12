local fzf = require("fzf-lua")
local go_syscalls = require("plugins.fzf.my-actions.doc-search.go.syscalls")
local go_awk = require("plugins.fzf.my-actions.doc-search.go.awk")


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

local GO_MOD = go_syscalls.get_gomod()
local GO_ROOT = go_syscalls.get_goroot()

-- =============================================================================
-- Build rg command with custom formatting: import-path.Symbol<TAB>file:line
-- Includes both workspace and stdlib when include_stdlib is true
-- =============================================================================
local function build_cmd(base_dir, pattern, include_stdlib)
  pattern = pattern or patterns.all

  local stdlib_src = GO_ROOT ~= "" and (GO_ROOT .. "/src") or ""

  -- Build workspace command
  local ws_cmd = string.format(
    "cd '%s' && rg -n --no-heading '%s' --glob '*.go' --glob '!*_test.go' . 2>/dev/null | sed 's|^\\./||' | awk -F: -v modname='%s' -v basedir='%s' '%s'",
    base_dir, pattern, GO_MOD, base_dir, go_awk.workspace_symbols()
  )

  -- If not including stdlib or stdlib not found, just return workspace command
  if not include_stdlib or stdlib_src == "" then
    return ws_cmd
  end

  -- Build stdlib command
  local stdlib_cmd = string.format(
    "cd '%s' && rg -n --no-heading '%s' --glob '*.go' --glob '!*_test.go' --glob '!vendor/**' --glob '!internal/**' --glob '!**/internal/**' . 2>/dev/null | sed 's|^\\./||' | awk -F: -v srcdir='%s' '%s'",
    stdlib_src, pattern, stdlib_src, go_awk.stdlib_symbols()
  )

  -- Combine both commands
  return "{ " .. ws_cmd .. "; " .. stdlib_cmd .. "; }"
end

-- =============================================================================
-- Preview command builder
-- =============================================================================
local function preview_cmd(prefix)
  if prefix then
    return string.format(
      "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); bat --style=header,numbers --color=always --highlight-line $l --line-range $l: '%s/'$f 2>/dev/null || { echo '── %s/'$f; cat -n '%s/'$f | tail -n +$l | head -30; }",
      prefix, prefix, prefix
    )
  end
  return "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); bat --style=header,numbers --color=always --highlight-line $l --line-range $l: $f 2>/dev/null || { echo \"── $f\"; cat -n $f | tail -n +$l | head -30; }"
end

-- Stdlib preview (shows relative path in header)
local function preview_cmd_stdlib(prefix)
  return string.format(
    "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); echo '── '$f':'; bat --style=numbers --color=always --highlight-line $l --line-range $l: '%s/'$f 2>/dev/null || cat -n '%s/'$f | tail -n +$l | head -30",
    prefix, prefix
  )
end

-- =============================================================================
-- Build fzf options with preview
-- prefix: optional path prefix for preview (e.g., dep_dir)
-- stdlib: if true, use stdlib preview style (relative path header)
-- =============================================================================
local function build_fzf_opts(header, query, prefix, stdlib)
  local opts = {
    ["--delimiter"] = "\t",
    ["--with-nth"] = "1",
    ["--nth"] = "1",
    ["--preview"] = stdlib and preview_cmd_stdlib(prefix) or preview_cmd(prefix),
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
  local fns = require("functions.encoding")
  local query = vim.api.nvim_get_mode()["mode"] == 'v' and fns.get_selection() or vim.fn.expand("<cword>")
  return query ~= "" and "'" .. query or nil
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
-- Common action builders
-- =============================================================================
local function make_open_action(prefix)
  return function(selected)
    local parsed = parse_selection(selected)
    if parsed then
      local file = prefix and (prefix .. "/" .. parsed.file) or parsed.file
      vim.cmd("edit " .. file)
      vim.cmd(":" .. parsed.line)
      vim.cmd("normal! zz")
    end
  end
end

local function make_yank_action()
  return function(selected)
    local parsed = parse_selection(selected)
    if parsed then
      vim.fn.setreg("+", parsed.symbol)
      vim.notify("Copied: " .. parsed.symbol)
    end
  end
end

-- =============================================================================
-- All symbols view (includes stdlib when searching from workspace root)
-- =============================================================================
function M.symbols(dir, query)
  local cwd = dir or vim.fn.getcwd()
  local include_stdlib = not dir
  local effective_query = query or get_query_at_cursor()
  local shortcuts = dir and "ctrl-f: funcs | ctrl-t: types | ctrl-c: consts" or "ctrl-f: funcs | ctrl-t: types | ctrl-c: consts | ctrl-p: packages | ctrl-d: deps"

  fzf.fzf_exec(build_cmd(cwd, patterns.all, include_stdlib), {
    prompt = "Symbols ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(shortcuts, effective_query),
    actions = {
      ["default"] = make_open_action(),
      ["ctrl-y"] = make_yank_action(),
      ["ctrl-f"] = function(_, opts) M.functions(dir, get_query(opts)) end,
      ["ctrl-t"] = function(_, opts) M.types(dir, get_query(opts)) end,
      ["ctrl-c"] = function(_, opts) M.constants(dir, get_query(opts)) end,
      ["ctrl-p"] = not dir and function(_, opts) M.packages(get_query(opts)) end or nil,
      ["ctrl-d"] = not dir and function(_, opts) M.dep_packages(get_query(opts)) end or nil,
    },
  })
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
    "rg -n --no-heading '%s' --glob '*.go' --glob '!*_test.go' %s 2>/dev/null | awk -F: '%s'",
    pattern, table.concat(dirs, " "), go_awk.deps_symbols()
  )
end

-- =============================================================================
-- Build rg command for a single dependency directory
-- =============================================================================
local function build_single_dep_cmd(dep_dir, dep_path, pattern)
  pattern = pattern or patterns.all
  return string.format(
    "cd '%s' && rg -n --no-heading '%s' --glob '*.go' --glob '!*_test.go' . 2>/dev/null | sed 's|^\\./||' | awk -F: -v deppath='%s' '%s'",
    dep_dir, pattern, dep_path, go_awk.single_dep_symbols()
  )
end

-- =============================================================================
-- List dependency packages
-- =============================================================================
function M.dep_packages(query)
  local deps = go_syscalls.get_go_mod_deps()
  if #deps == 0 then
    vim.notify("No dependencies found in go.mod", vim.log.levels.WARN)
    return
  end

  local items = {}
  for _, dep in ipairs(deps) do
    table.insert(items, dep.path .. "@" .. dep.version .. "\t" .. dep.dir .. "\t" .. dep.path)
  end

  local shortcuts = "ctrl-a: all symbols | ctrl-f: all funcs | ctrl-t: all types | ctrl-w: workspace"
  local header = shortcuts .. "\n" .. GO_MOD .. " (" .. #deps .. " deps)"

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
  local header = "ctrl-f: funcs | ctrl-t: types | ctrl-c: consts | ctrl-p: packages\n" .. dep_path

  fzf.fzf_exec(build_single_dep_cmd(dep_dir, dep_path, patterns.all), {
    prompt = "Symbols ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, nil, dep_dir),
    actions = {
      ["default"] = make_open_action(dep_dir),
      ["ctrl-y"] = make_yank_action(),
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
  local header = "ctrl-a: all | ctrl-t: types | ctrl-c: consts | ctrl-p: packages\n" .. dep_path

  fzf.fzf_exec(build_single_dep_cmd(dep_dir, dep_path, patterns.functions), {
    prompt = "Functions ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, nil, dep_dir),
    actions = {
      ["default"] = make_open_action(dep_dir),
      ["ctrl-y"] = make_yank_action(),
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
  local header = "ctrl-a: all | ctrl-f: funcs | ctrl-c: consts | ctrl-p: packages\n" .. dep_path

  fzf.fzf_exec(build_single_dep_cmd(dep_dir, dep_path, patterns.types), {
    prompt = "Types ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, nil, dep_dir),
    actions = {
      ["default"] = make_open_action(dep_dir),
      ["ctrl-y"] = make_yank_action(),
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
  local header = "ctrl-a: all | ctrl-f: funcs | ctrl-t: types | ctrl-p: packages\n" .. dep_path

  fzf.fzf_exec(build_single_dep_cmd(dep_dir, dep_path, patterns.constants), {
    prompt = "Constants ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, nil, dep_dir),
    actions = {
      ["default"] = make_open_action(dep_dir),
      ["ctrl-y"] = make_yank_action(),
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
  local stdlib = go_syscalls.get_stdlib_packages(GO_ROOT)
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
  local header = shortcuts .. "\n" .. GO_MOD

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
  local header = "ctrl-f: funcs | ctrl-t: types | ctrl-c: consts | ctrl-p: packages\n" .. pkg_path

  fzf.fzf_exec(build_single_dep_cmd(pkg_dir, pkg_path, patterns.all), {
    prompt = "Symbols ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, nil, pkg_dir),
    actions = {
      ["default"] = make_open_action(pkg_dir),
      ["ctrl-y"] = make_yank_action(),
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
  local header = "ctrl-a: all | ctrl-t: types | ctrl-c: consts | ctrl-p: packages\n" .. pkg_path

  fzf.fzf_exec(build_single_dep_cmd(pkg_dir, pkg_path, patterns.functions), {
    prompt = "Functions ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, nil, pkg_dir),
    actions = {
      ["default"] = make_open_action(pkg_dir),
      ["ctrl-y"] = make_yank_action(),
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
  local header = "ctrl-a: all | ctrl-f: funcs | ctrl-c: consts | ctrl-p: packages\n" .. pkg_path

  fzf.fzf_exec(build_single_dep_cmd(pkg_dir, pkg_path, patterns.types), {
    prompt = "Types ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, nil, pkg_dir),
    actions = {
      ["default"] = make_open_action(pkg_dir),
      ["ctrl-y"] = make_yank_action(),
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
  local header = "ctrl-a: all | ctrl-f: funcs | ctrl-t: types | ctrl-p: packages\n" .. pkg_path

  fzf.fzf_exec(build_single_dep_cmd(pkg_dir, pkg_path, patterns.constants), {
    prompt = "Constants ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, nil, pkg_dir),
    actions = {
      ["default"] = make_open_action(pkg_dir),
      ["ctrl-y"] = make_yank_action(),
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
  local stdlib = go_syscalls.get_stdlib_packages(GO_ROOT)
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
  if GO_ROOT == "" then return "echo ''" end

  local src_dir = GO_ROOT .. "/src"
  pattern = pattern or patterns.all

  return string.format(
    "cd '%s' && rg -n --no-heading '%s' --glob '*.go' --glob '!*_test.go' --glob '!vendor/**' --glob '!internal/**' . 2>/dev/null | sed 's|^\\./||' | awk -F: -v srcdir='%s' '%s'",
    src_dir, pattern, src_dir, go_awk.stdlib_symbols()
  )
end

-- =============================================================================
-- Search all stdlib symbols
-- =============================================================================
function M.stdlib_symbols(query)
  local header = "ctrl-f: funcs | ctrl-t: types | ctrl-c: consts | ctrl-p: packages\nGo stdlib"
  local src_dir = GO_ROOT .. "/src"

  fzf.fzf_exec(build_stdlib_cmd(patterns.all), {
    prompt = "Stdlib Symbols ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, query, src_dir, true),
    actions = {
      ["default"] = make_open_action(src_dir),
      ["ctrl-y"] = make_yank_action(),
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
  local header = "ctrl-a: all | ctrl-t: types | ctrl-c: consts | ctrl-p: packages\nGo stdlib"
  local src_dir = GO_ROOT .. "/src"

  fzf.fzf_exec(build_stdlib_cmd(patterns.functions), {
    prompt = "Stdlib Functions ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, query, src_dir, true),
    actions = {
      ["default"] = make_open_action(src_dir),
      ["ctrl-y"] = make_yank_action(),
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
  local header = "ctrl-a: all | ctrl-f: funcs | ctrl-c: consts | ctrl-p: packages\nGo stdlib"
  local src_dir = GO_ROOT .. "/src"

  fzf.fzf_exec(build_stdlib_cmd(patterns.types), {
    prompt = "Stdlib Types ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, query, src_dir, true),
    actions = {
      ["default"] = make_open_action(src_dir),
      ["ctrl-y"] = make_yank_action(),
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
  local header = "ctrl-a: all | ctrl-f: funcs | ctrl-t: types | ctrl-p: packages\nGo stdlib"
  local src_dir = GO_ROOT .. "/src"

  fzf.fzf_exec(build_stdlib_cmd(patterns.constants), {
    prompt = "Stdlib Constants ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, query, src_dir, true),
    actions = {
      ["default"] = make_open_action(src_dir),
      ["ctrl-y"] = make_yank_action(),
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
  local effective_query = query or get_query_at_cursor()
  local shortcuts = dir and "ctrl-a: all | ctrl-t: types | ctrl-c: consts" or "ctrl-a: all | ctrl-t: types | ctrl-c: consts | ctrl-p: packages | ctrl-d: deps"

  fzf.fzf_exec(build_cmd(cwd, patterns.functions, include_stdlib), {
    prompt = "Functions ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(shortcuts, effective_query),
    actions = {
      ["default"] = make_open_action(),
      ["ctrl-y"] = make_yank_action(),
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
  local deps = go_syscalls.get_go_mod_deps()
  if #deps == 0 then
    vim.notify("No dependencies found in go.mod", vim.log.levels.WARN)
    return
  end
  local header = "ctrl-a: all | ctrl-t: types | ctrl-c: consts | ctrl-p: packages | ctrl-w: workspace\n" .. GO_MOD .. " deps (" .. #deps .. ")"

  fzf.fzf_exec(build_deps_cmd(deps, patterns.functions), {
    prompt = "Dep Functions ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, query),
    actions = {
      ["default"] = make_open_action(),
      ["ctrl-y"] = make_yank_action(),
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
  local effective_query = query or get_query_at_cursor()
  local shortcuts = dir and "ctrl-a: all | ctrl-f: funcs | ctrl-c: consts" or "ctrl-a: all | ctrl-f: funcs | ctrl-c: consts | ctrl-p: packages | ctrl-d: deps"

  fzf.fzf_exec(build_cmd(cwd, patterns.types, include_stdlib), {
    prompt = "Types ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(shortcuts, effective_query),
    actions = {
      ["default"] = make_open_action(),
      ["ctrl-y"] = make_yank_action(),
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
  local deps = go_syscalls.get_go_mod_deps()
  if #deps == 0 then
    vim.notify("No dependencies found in go.mod", vim.log.levels.WARN)
    return
  end
  local header = "ctrl-a: all | ctrl-f: funcs | ctrl-c: consts | ctrl-p: packages | ctrl-w: workspace\n" .. GO_MOD .. " deps (" .. #deps .. ")"

  fzf.fzf_exec(build_deps_cmd(deps, patterns.types), {
    prompt = "Dep Types ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, query),
    actions = {
      ["default"] = make_open_action(),
      ["ctrl-y"] = make_yank_action(),
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
  local effective_query = query or get_query_at_cursor()
  local shortcuts = dir and "ctrl-a: all | ctrl-f: funcs | ctrl-t: types" or "ctrl-a: all | ctrl-f: funcs | ctrl-t: types | ctrl-p: packages | ctrl-d: deps"

  fzf.fzf_exec(build_cmd(cwd, patterns.constants, include_stdlib), {
    prompt = "Constants ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(shortcuts, effective_query),
    actions = {
      ["default"] = make_open_action(),
      ["ctrl-y"] = make_yank_action(),
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
  local deps = go_syscalls.get_go_mod_deps()
  if #deps == 0 then
    vim.notify("No dependencies found in go.mod", vim.log.levels.WARN)
    return
  end
  local header = "ctrl-a: all | ctrl-f: funcs | ctrl-t: types | ctrl-p: packages | ctrl-w: workspace\n" .. GO_MOD .. " deps (" .. #deps .. ")"

  fzf.fzf_exec(build_deps_cmd(deps, patterns.constants), {
    prompt = "Dep Constants ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, query),
    actions = {
      ["default"] = make_open_action(),
      ["ctrl-y"] = make_yank_action(),
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
  local deps = go_syscalls.get_go_mod_deps()
  if #deps == 0 then
    vim.notify("No dependencies found in go.mod", vim.log.levels.WARN)
    return
  end
  local header = "ctrl-f: funcs | ctrl-t: types | ctrl-c: consts | ctrl-p: packages | ctrl-w: workspace\n" .. GO_MOD .. " deps (" .. #deps .. ")"

  fzf.fzf_exec(build_deps_cmd(deps, patterns.all), {
    prompt = "Dep Symbols ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, query),
    actions = {
      ["default"] = make_open_action(),
      ["ctrl-y"] = make_yank_action(),
      ["ctrl-f"] = function(_, opts) M.dep_functions(get_query(opts)) end,
      ["ctrl-t"] = function(_, opts) M.dep_types(get_query(opts)) end,
      ["ctrl-c"] = function(_, opts) M.dep_constants(get_query(opts)) end,
      ["ctrl-p"] = function(_, opts) M.dep_packages(get_query(opts)) end,
      ["ctrl-w"] = function(_, opts) M.symbols(nil, get_query(opts)) end,
    },
  })
end

return M
