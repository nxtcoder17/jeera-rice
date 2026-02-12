local fzf = require("fzf-lua")
local syscalls = require("plugins.fzf.my-actions.doc-search.nodejs.syscalls")
local awk = require("plugins.fzf.my-actions.doc-search.nodejs.awk")

local M = {}

-- =============================================================================
-- Patterns for different symbol types
-- Note: Keep patterns simple to avoid shell escaping issues
-- =============================================================================
local patterns = {
  all = "^(export )?(declare )?(async )?(function |class |interface |type |const |let |var |enum |namespace )",
  functions = "^(export )?(declare )?(async )?function ",
  classes = "^(export )?(declare )?class ",
  types = "^(export )?(declare )?(interface |type )",
  constants = "^(export )?(declare )?(const |let |var |enum )",
}

-- Cache package info
local PKG_NAME = syscalls.get_package_name()
local PROJECT_ROOT = syscalls.get_project_root()

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

-- =============================================================================
-- Build fzf options with preview
-- =============================================================================
local function build_fzf_opts(header, query, prefix)
  local opts = {
    ["--delimiter"] = "\t",
    ["--with-nth"] = "1",
    ["--nth"] = "1",
    ["--preview"] = preview_cmd(prefix),
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
-- Parse selection: extract file, line, symbol from "import-path.Symbol<TAB>file:line"
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
-- Get query text from cursor position using treesitter
-- =============================================================================
local function get_query_at_cursor()
  local ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
  if ok then
    local node = ts_utils.get_node_at_cursor()
    if node then
      local current = node
      while current do
        local ntype = current:type()
        -- Call expression: foo() or pkg.foo()
        if ntype == "call_expression" then
          local func_node = current:field("function")[1]
          if func_node then
            local text = vim.treesitter.get_node_text(func_node, 0)
            return "'" .. text
          end
          break
        end
        -- Member expression: obj.method
        if ntype == "member_expression" then
          local prop = current:field("property")[1]
          if prop then
            return "'" .. vim.treesitter.get_node_text(prop, 0)
          end
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
-- Helper to write AWK script to temp file and return path
-- =============================================================================
local awk_cache = {}
local function get_awk_file(name, content)
  if awk_cache[name] then
    return awk_cache[name]
  end
  local tmpfile = vim.fn.tempname() .. "_" .. name .. ".awk"
  local f = io.open(tmpfile, "w")
  if f then
    f:write(content)
    f:close()
    awk_cache[name] = tmpfile
    return tmpfile
  end
  return nil
end

-- =============================================================================
-- Build rg command for workspace
-- =============================================================================
local function build_cmd(base_dir, pattern)
  pattern = pattern or patterns.all

  local awk_file = get_awk_file("workspace", awk.workspace_symbols())
  if not awk_file then return "echo 'Failed to create awk script'" end

  return "cd '" .. base_dir .. "' && rg -n --no-heading '" .. pattern .. "'"
    .. " --glob '*.js' --glob '*.jsx' --glob '*.ts' --glob '*.tsx' --glob '*.mjs' --glob '*.cjs'"
    .. " --glob '!*.test.*' --glob '!*.spec.*' --glob '!__tests__/**'"
    .. " --glob '!node_modules/**' --glob '!dist/**' --glob '!build/**' --glob '!.next/**' --glob '!coverage/**'"
    .. " . 2>/dev/null | sed 's|^\\./||'"
    .. " | awk -F: -v pkgname='" .. PKG_NAME .. "' -v basedir='" .. base_dir .. "' -f '" .. awk_file .. "'"
end

-- =============================================================================
-- Build rg command for dependencies
-- =============================================================================
local function build_deps_cmd(deps, pattern)
  pattern = pattern or patterns.all
  if #deps == 0 then return "echo ''" end

  local awk_file = get_awk_file("deps", awk.deps_symbols())
  if not awk_file then return "echo 'Failed to create awk script'" end

  -- cd into each dep and search from there (avoids gitignore issues with node_modules)
  local cmds = {}
  for _, dep in ipairs(deps) do
    local cmd = '(cd "' .. dep.dir .. '" && rg -n --no-heading -e \'' .. pattern .. "' --glob '*.d.ts' . 2>/dev/null"
      .. " | sed 's|^\\./|" .. dep.dir .. "/|')"
    table.insert(cmds, cmd)
  end

  return "{ " .. table.concat(cmds, "; ") .. "; } | awk -F: -f '" .. awk_file .. "'"
end

-- =============================================================================
-- Build rg command for single dependency
-- =============================================================================
local function build_single_dep_cmd(dep_dir, dep_path, pattern)
  pattern = pattern or patterns.all

  local awk_file = get_awk_file("single_dep", awk.single_dep_symbols())
  if not awk_file then return "echo 'Failed to create awk script'" end

  return 'cd "' .. dep_dir .. '" && rg -n --no-heading -e \'' .. pattern .. "'"
    .. " --glob '*.d.ts' . 2>/dev/null | sed 's|^\\./||'"
    .. " | awk -F: -v deppath='" .. dep_path .. "' -f '" .. awk_file .. "'"
end

-- =============================================================================
-- All symbols view
-- =============================================================================
function M.symbols(dir, query)
  local cwd = dir or PROJECT_ROOT
  local effective_query = query or get_query_at_cursor()
  local shortcuts = dir and "ctrl-f: funcs | ctrl-l: classes | ctrl-t: types | ctrl-k: consts"
    or "ctrl-f: funcs | ctrl-l: classes | ctrl-t: types | ctrl-k: consts | ctrl-d: deps"

  fzf.fzf_exec(build_cmd(cwd, patterns.all), {
    prompt = "Symbols ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(shortcuts, effective_query),
    actions = {
      ["default"] = make_open_action(),
      ["ctrl-y"] = make_yank_action(),
      ["ctrl-f"] = function(_, opts) M.functions(dir, get_query(opts)) end,
      ["ctrl-l"] = function(_, opts) M.classes(dir, get_query(opts)) end,
      ["ctrl-t"] = function(_, opts) M.types(dir, get_query(opts)) end,
      ["ctrl-k"] = function(_, opts) M.constants(dir, get_query(opts)) end,
      ["ctrl-d"] = not dir and function(_, opts) M.dep_packages(get_query(opts)) end or nil,
    },
  })
end

-- =============================================================================
-- Functions view
-- =============================================================================
function M.functions(dir, query)
  local cwd = dir or PROJECT_ROOT
  local effective_query = query or get_query_at_cursor()
  local shortcuts = dir and "ctrl-a: all | ctrl-l: classes | ctrl-t: types | ctrl-k: consts"
    or "ctrl-a: all | ctrl-l: classes | ctrl-t: types | ctrl-k: consts | ctrl-d: deps"

  fzf.fzf_exec(build_cmd(cwd, patterns.functions), {
    prompt = "Functions ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(shortcuts, effective_query),
    actions = {
      ["default"] = make_open_action(),
      ["ctrl-y"] = make_yank_action(),
      ["ctrl-a"] = function(_, opts) M.symbols(dir, get_query(opts)) end,
      ["ctrl-l"] = function(_, opts) M.classes(dir, get_query(opts)) end,
      ["ctrl-t"] = function(_, opts) M.types(dir, get_query(opts)) end,
      ["ctrl-k"] = function(_, opts) M.constants(dir, get_query(opts)) end,
      ["ctrl-d"] = not dir and function(_, opts) M.dep_packages(get_query(opts)) end or nil,
    },
  })
end

-- =============================================================================
-- Classes view
-- =============================================================================
function M.classes(dir, query)
  local cwd = dir or PROJECT_ROOT
  local effective_query = query or get_query_at_cursor()
  local shortcuts = dir and "ctrl-a: all | ctrl-f: funcs | ctrl-t: types | ctrl-k: consts"
    or "ctrl-a: all | ctrl-f: funcs | ctrl-t: types | ctrl-k: consts | ctrl-d: deps"

  fzf.fzf_exec(build_cmd(cwd, patterns.classes), {
    prompt = "Classes ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(shortcuts, effective_query),
    actions = {
      ["default"] = make_open_action(),
      ["ctrl-y"] = make_yank_action(),
      ["ctrl-a"] = function(_, opts) M.symbols(dir, get_query(opts)) end,
      ["ctrl-f"] = function(_, opts) M.functions(dir, get_query(opts)) end,
      ["ctrl-t"] = function(_, opts) M.types(dir, get_query(opts)) end,
      ["ctrl-k"] = function(_, opts) M.constants(dir, get_query(opts)) end,
      ["ctrl-d"] = not dir and function(_, opts) M.dep_packages(get_query(opts)) end or nil,
    },
  })
end

-- =============================================================================
-- Types view (interfaces + type aliases)
-- =============================================================================
function M.types(dir, query)
  local cwd = dir or PROJECT_ROOT
  local effective_query = query or get_query_at_cursor()
  local shortcuts = dir and "ctrl-a: all | ctrl-f: funcs | ctrl-l: classes | ctrl-k: consts"
    or "ctrl-a: all | ctrl-f: funcs | ctrl-l: classes | ctrl-k: consts | ctrl-d: deps"

  fzf.fzf_exec(build_cmd(cwd, patterns.types), {
    prompt = "Types ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(shortcuts, effective_query),
    actions = {
      ["default"] = make_open_action(),
      ["ctrl-y"] = make_yank_action(),
      ["ctrl-a"] = function(_, opts) M.symbols(dir, get_query(opts)) end,
      ["ctrl-f"] = function(_, opts) M.functions(dir, get_query(opts)) end,
      ["ctrl-l"] = function(_, opts) M.classes(dir, get_query(opts)) end,
      ["ctrl-k"] = function(_, opts) M.constants(dir, get_query(opts)) end,
      ["ctrl-d"] = not dir and function(_, opts) M.dep_packages(get_query(opts)) end or nil,
    },
  })
end

-- =============================================================================
-- Constants view
-- =============================================================================
function M.constants(dir, query)
  local cwd = dir or PROJECT_ROOT
  local effective_query = query or get_query_at_cursor()
  local shortcuts = dir and "ctrl-a: all | ctrl-f: funcs | ctrl-l: classes | ctrl-t: types"
    or "ctrl-a: all | ctrl-f: funcs | ctrl-l: classes | ctrl-t: types | ctrl-d: deps"

  fzf.fzf_exec(build_cmd(cwd, patterns.constants), {
    prompt = "Constants ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(shortcuts, effective_query),
    actions = {
      ["default"] = make_open_action(),
      ["ctrl-y"] = make_yank_action(),
      ["ctrl-a"] = function(_, opts) M.symbols(dir, get_query(opts)) end,
      ["ctrl-f"] = function(_, opts) M.functions(dir, get_query(opts)) end,
      ["ctrl-l"] = function(_, opts) M.classes(dir, get_query(opts)) end,
      ["ctrl-t"] = function(_, opts) M.types(dir, get_query(opts)) end,
      ["ctrl-d"] = not dir and function(_, opts) M.dep_packages(get_query(opts)) end or nil,
    },
  })
end

-- =============================================================================
-- List dependency packages
-- =============================================================================
function M.dep_packages(query)
  local deps = syscalls.get_dependencies()
  if #deps == 0 then
    vim.notify("No dependencies found in package.json", vim.log.levels.WARN)
    return
  end

  local items = {}
  for _, dep in ipairs(deps) do
    table.insert(items, dep.name .. "@" .. dep.version .. "\t" .. dep.dir .. "\t" .. dep.name)
  end

  local shortcuts = "ctrl-a: all symbols | ctrl-f: all funcs | ctrl-t: all types | ctrl-w: workspace"
  local header = shortcuts .. "\n" .. PKG_NAME .. " (" .. #deps .. " deps)"

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
        local dep_name = parts[3]
        M.dep_package_symbols(dep_name, dep_dir)
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
      ["ctrl-w"] = function(_, opts) M.functions(nil, get_query(opts)) end,
    },
  })
end

-- =============================================================================
-- Show symbols from a specific dependency package
-- =============================================================================
function M.dep_package_symbols(dep_name, dep_dir)
  local header = "ctrl-f: funcs | ctrl-l: classes | ctrl-t: types | ctrl-k: consts | ctrl-p: packages\n" .. dep_name

  fzf.fzf_exec(build_single_dep_cmd(dep_dir, dep_name, patterns.all), {
    prompt = "Symbols ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, nil, dep_dir),
    actions = {
      ["default"] = make_open_action(dep_dir),
      ["ctrl-y"] = make_yank_action(),
      ["ctrl-f"] = function() M.dep_package_functions(dep_name, dep_dir) end,
      ["ctrl-l"] = function() M.dep_package_classes(dep_name, dep_dir) end,
      ["ctrl-t"] = function() M.dep_package_types(dep_name, dep_dir) end,
      ["ctrl-k"] = function() M.dep_package_constants(dep_name, dep_dir) end,
      ["ctrl-p"] = function() M.dep_packages() end,
    },
  })
end

-- =============================================================================
-- Show functions from a specific dependency package
-- =============================================================================
function M.dep_package_functions(dep_name, dep_dir)
  local header = "ctrl-a: all | ctrl-l: classes | ctrl-t: types | ctrl-k: consts | ctrl-p: packages\n" .. dep_name

  fzf.fzf_exec(build_single_dep_cmd(dep_dir, dep_name, patterns.functions), {
    prompt = "Functions ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, nil, dep_dir),
    actions = {
      ["default"] = make_open_action(dep_dir),
      ["ctrl-y"] = make_yank_action(),
      ["ctrl-a"] = function() M.dep_package_symbols(dep_name, dep_dir) end,
      ["ctrl-l"] = function() M.dep_package_classes(dep_name, dep_dir) end,
      ["ctrl-t"] = function() M.dep_package_types(dep_name, dep_dir) end,
      ["ctrl-k"] = function() M.dep_package_constants(dep_name, dep_dir) end,
      ["ctrl-p"] = function() M.dep_packages() end,
    },
  })
end

-- =============================================================================
-- Show classes from a specific dependency package
-- =============================================================================
function M.dep_package_classes(dep_name, dep_dir)
  local header = "ctrl-a: all | ctrl-f: funcs | ctrl-t: types | ctrl-k: consts | ctrl-p: packages\n" .. dep_name

  fzf.fzf_exec(build_single_dep_cmd(dep_dir, dep_name, patterns.classes), {
    prompt = "Classes ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, nil, dep_dir),
    actions = {
      ["default"] = make_open_action(dep_dir),
      ["ctrl-y"] = make_yank_action(),
      ["ctrl-a"] = function() M.dep_package_symbols(dep_name, dep_dir) end,
      ["ctrl-f"] = function() M.dep_package_functions(dep_name, dep_dir) end,
      ["ctrl-t"] = function() M.dep_package_types(dep_name, dep_dir) end,
      ["ctrl-k"] = function() M.dep_package_constants(dep_name, dep_dir) end,
      ["ctrl-p"] = function() M.dep_packages() end,
    },
  })
end

-- =============================================================================
-- Show types from a specific dependency package
-- =============================================================================
function M.dep_package_types(dep_name, dep_dir)
  local header = "ctrl-a: all | ctrl-f: funcs | ctrl-l: classes | ctrl-k: consts | ctrl-p: packages\n" .. dep_name

  fzf.fzf_exec(build_single_dep_cmd(dep_dir, dep_name, patterns.types), {
    prompt = "Types ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, nil, dep_dir),
    actions = {
      ["default"] = make_open_action(dep_dir),
      ["ctrl-y"] = make_yank_action(),
      ["ctrl-a"] = function() M.dep_package_symbols(dep_name, dep_dir) end,
      ["ctrl-f"] = function() M.dep_package_functions(dep_name, dep_dir) end,
      ["ctrl-l"] = function() M.dep_package_classes(dep_name, dep_dir) end,
      ["ctrl-k"] = function() M.dep_package_constants(dep_name, dep_dir) end,
      ["ctrl-p"] = function() M.dep_packages() end,
    },
  })
end

-- =============================================================================
-- Show constants from a specific dependency package
-- =============================================================================
function M.dep_package_constants(dep_name, dep_dir)
  local header = "ctrl-a: all | ctrl-f: funcs | ctrl-l: classes | ctrl-t: types | ctrl-p: packages\n" .. dep_name

  fzf.fzf_exec(build_single_dep_cmd(dep_dir, dep_name, patterns.constants), {
    prompt = "Constants ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, nil, dep_dir),
    actions = {
      ["default"] = make_open_action(dep_dir),
      ["ctrl-y"] = make_yank_action(),
      ["ctrl-a"] = function() M.dep_package_symbols(dep_name, dep_dir) end,
      ["ctrl-f"] = function() M.dep_package_functions(dep_name, dep_dir) end,
      ["ctrl-l"] = function() M.dep_package_classes(dep_name, dep_dir) end,
      ["ctrl-t"] = function() M.dep_package_types(dep_name, dep_dir) end,
      ["ctrl-p"] = function() M.dep_packages() end,
    },
  })
end

-- =============================================================================
-- Search all symbols in dependencies
-- =============================================================================
function M.dep_symbols(query)
  local deps = syscalls.get_dependencies()
  if #deps == 0 then
    vim.notify("No dependencies found in package.json", vim.log.levels.WARN)
    return
  end
  local header = "ctrl-f: funcs | ctrl-l: classes | ctrl-t: types | ctrl-k: consts | ctrl-p: packages | ctrl-w: workspace\n" .. PKG_NAME .. " deps (" .. #deps .. ")"

  fzf.fzf_exec(build_deps_cmd(deps, patterns.all), {
    prompt = "Dep Symbols ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, query),
    actions = {
      ["default"] = make_open_action(),
      ["ctrl-y"] = make_yank_action(),
      ["ctrl-f"] = function(_, opts) M.dep_functions(get_query(opts)) end,
      ["ctrl-l"] = function(_, opts) M.dep_classes(get_query(opts)) end,
      ["ctrl-t"] = function(_, opts) M.dep_types(get_query(opts)) end,
      ["ctrl-k"] = function(_, opts) M.dep_constants(get_query(opts)) end,
      ["ctrl-p"] = function(_, opts) M.dep_packages(get_query(opts)) end,
      ["ctrl-w"] = function(_, opts) M.symbols(nil, get_query(opts)) end,
    },
  })
end

-- =============================================================================
-- Search functions in dependencies
-- =============================================================================
function M.dep_functions(query)
  local deps = syscalls.get_dependencies()
  if #deps == 0 then
    vim.notify("No dependencies found in package.json", vim.log.levels.WARN)
    return
  end
  local header = "ctrl-a: all | ctrl-l: classes | ctrl-t: types | ctrl-k: consts | ctrl-p: packages | ctrl-w: workspace\n" .. PKG_NAME .. " deps (" .. #deps .. ")"

  fzf.fzf_exec(build_deps_cmd(deps, patterns.functions), {
    prompt = "Dep Functions ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, query),
    actions = {
      ["default"] = make_open_action(),
      ["ctrl-y"] = make_yank_action(),
      ["ctrl-a"] = function(_, opts) M.dep_symbols(get_query(opts)) end,
      ["ctrl-l"] = function(_, opts) M.dep_classes(get_query(opts)) end,
      ["ctrl-t"] = function(_, opts) M.dep_types(get_query(opts)) end,
      ["ctrl-k"] = function(_, opts) M.dep_constants(get_query(opts)) end,
      ["ctrl-p"] = function(_, opts) M.dep_packages(get_query(opts)) end,
      ["ctrl-w"] = function(_, opts) M.functions(nil, get_query(opts)) end,
    },
  })
end

-- =============================================================================
-- Search classes in dependencies
-- =============================================================================
function M.dep_classes(query)
  local deps = syscalls.get_dependencies()
  if #deps == 0 then
    vim.notify("No dependencies found in package.json", vim.log.levels.WARN)
    return
  end
  local header = "ctrl-a: all | ctrl-f: funcs | ctrl-t: types | ctrl-k: consts | ctrl-p: packages | ctrl-w: workspace\n" .. PKG_NAME .. " deps (" .. #deps .. ")"

  fzf.fzf_exec(build_deps_cmd(deps, patterns.classes), {
    prompt = "Dep Classes ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, query),
    actions = {
      ["default"] = make_open_action(),
      ["ctrl-y"] = make_yank_action(),
      ["ctrl-a"] = function(_, opts) M.dep_symbols(get_query(opts)) end,
      ["ctrl-f"] = function(_, opts) M.dep_functions(get_query(opts)) end,
      ["ctrl-t"] = function(_, opts) M.dep_types(get_query(opts)) end,
      ["ctrl-k"] = function(_, opts) M.dep_constants(get_query(opts)) end,
      ["ctrl-p"] = function(_, opts) M.dep_packages(get_query(opts)) end,
      ["ctrl-w"] = function(_, opts) M.classes(nil, get_query(opts)) end,
    },
  })
end

-- =============================================================================
-- Search types in dependencies
-- =============================================================================
function M.dep_types(query)
  local deps = syscalls.get_dependencies()
  if #deps == 0 then
    vim.notify("No dependencies found in package.json", vim.log.levels.WARN)
    return
  end
  local header = "ctrl-a: all | ctrl-f: funcs | ctrl-l: classes | ctrl-k: consts | ctrl-p: packages | ctrl-w: workspace\n" .. PKG_NAME .. " deps (" .. #deps .. ")"

  fzf.fzf_exec(build_deps_cmd(deps, patterns.types), {
    prompt = "Dep Types ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, query),
    actions = {
      ["default"] = make_open_action(),
      ["ctrl-y"] = make_yank_action(),
      ["ctrl-a"] = function(_, opts) M.dep_symbols(get_query(opts)) end,
      ["ctrl-f"] = function(_, opts) M.dep_functions(get_query(opts)) end,
      ["ctrl-l"] = function(_, opts) M.dep_classes(get_query(opts)) end,
      ["ctrl-k"] = function(_, opts) M.dep_constants(get_query(opts)) end,
      ["ctrl-p"] = function(_, opts) M.dep_packages(get_query(opts)) end,
      ["ctrl-w"] = function(_, opts) M.types(nil, get_query(opts)) end,
    },
  })
end

-- =============================================================================
-- Search constants in dependencies
-- =============================================================================
function M.dep_constants(query)
  local deps = syscalls.get_dependencies()
  if #deps == 0 then
    vim.notify("No dependencies found in package.json", vim.log.levels.WARN)
    return
  end
  local header = "ctrl-a: all | ctrl-f: funcs | ctrl-l: classes | ctrl-t: types | ctrl-p: packages | ctrl-w: workspace\n" .. PKG_NAME .. " deps (" .. #deps .. ")"

  fzf.fzf_exec(build_deps_cmd(deps, patterns.constants), {
    prompt = "Dep Constants ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(header, query),
    actions = {
      ["default"] = make_open_action(),
      ["ctrl-y"] = make_yank_action(),
      ["ctrl-a"] = function(_, opts) M.dep_symbols(get_query(opts)) end,
      ["ctrl-f"] = function(_, opts) M.dep_functions(get_query(opts)) end,
      ["ctrl-l"] = function(_, opts) M.dep_classes(get_query(opts)) end,
      ["ctrl-t"] = function(_, opts) M.dep_types(get_query(opts)) end,
      ["ctrl-p"] = function(_, opts) M.dep_packages(get_query(opts)) end,
      ["ctrl-w"] = function(_, opts) M.constants(nil, get_query(opts)) end,
    },
  })
end

-- =============================================================================
-- List all packages (alias for dep_packages)
-- =============================================================================
function M.packages(query)
  M.dep_packages(query)
end

-- Aliases for package_* -> dep_package_*
M.package_symbols = M.dep_package_symbols
M.package_functions = M.dep_package_functions
M.package_classes = M.dep_package_classes
M.package_types = M.dep_package_types
M.package_constants = M.dep_package_constants

return M
