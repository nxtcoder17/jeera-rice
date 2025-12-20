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
-- Build rg command with custom formatting: symbol<TAB>file:line
-- =============================================================================
local function build_cmd(base_dir, pattern)
  pattern = pattern or patterns.all
  return string.format(
    [[cd '%s' && rg -n --no-heading '%s' --glob '*.go' --glob '!*_test.go' . 2>/dev/null | sed 's|^\./||' | awk -F: '{
      content = $0; sub(/^[^:]+:[^:]+:/, "", content);
      gsub(/ *\{.*$/, "", content);
      printf "%%s\t%%s:%%s\n", content, $1, $2
    }']],
    base_dir, pattern
  )
end

-- =============================================================================
-- Build fzf options with preview showing file path as header
-- =============================================================================
local function build_fzf_opts(base_dir, header)
  return {
    ["--delimiter"] = "\t",
    ["--with-nth"] = "1",
    ["--preview"] = string.format(
      "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); echo '── '$f':'$l' ──' && echo && bat --style=numbers --color=always --highlight-line $l --line-range $l: '%s/'$f 2>/dev/null || cat -n '%s/'$f | tail -n +$l | head -30",
      base_dir, base_dir
    ),
    ["--preview-window"] = "right:40%",
    ["--header"] = header,
  }
end

-- =============================================================================
-- Parse selection: extract file, line, content from "symbol<TAB>file:line"
-- =============================================================================
local function parse_selection(selected)
  if not selected or #selected == 0 then return nil end
  local symbol, file_line = selected[1]:match("^([^\t]+)\t([^\t]+)$")
  if file_line then
    local file, line = file_line:match("^([^:]+):(%d+)")
    return { file = file, line = line, content = symbol }
  end
  return nil
end

-- =============================================================================
-- All symbols view
-- =============================================================================
function M.symbols(dir)
  local cwd = dir or vim.fn.getcwd()
  local header = dir and "ctrl-f: funcs | ctrl-t: types | ctrl-c: consts" or "ctrl-f: funcs | ctrl-t: types | ctrl-c: consts | ctrl-p: packages | ctrl-d: deps"

  fzf.fzf_exec(build_cmd(cwd, patterns.all), {
    prompt = "Symbols ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(cwd, header),
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. cwd .. "/" .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.content)
          vim.notify("Copied: " .. parsed.content)
        end
      end,
      ["ctrl-f"] = function() M.functions(dir) end,
      ["ctrl-t"] = function() M.types(dir) end,
      ["ctrl-c"] = function() M.constants(dir) end,
      ["ctrl-p"] = not dir and function() M.packages() end or nil,
      ["ctrl-d"] = not dir and function() M.dep_symbols() end or nil,
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
-- =============================================================================
local function build_deps_cmd(deps, pattern)
  pattern = pattern or patterns.all
  local dirs = {}
  for _, dep in ipairs(deps) do
    table.insert(dirs, "'" .. dep.dir .. "'")
  end
  if #dirs == 0 then return "echo ''" end

  return string.format(
    [[rg -n --no-heading '%s' --glob '*.go' --glob '!*_test.go' %s 2>/dev/null | awk -F: '{
      content = $0; sub(/^[^:]+:[^:]+:/, "", content);
      gsub(/ *\{.*$/, "", content);
      printf "%%s\t%%s:%%s\n", content, $1, $2
    }']],
    pattern, table.concat(dirs, " ")
  )
end

-- =============================================================================
-- Get all packages (workspace + GOMODCACHE)
-- =============================================================================
function M.packages()
  local items = {}

  -- Workspace packages (go list with directory)
  local workspace = vim.fn.systemlist("go list -f '{{.ImportPath}}:::{{.Dir}}' ./... 2>/dev/null")
  for _, line in ipairs(workspace) do
    if line ~= "" then
      local pkg, dir = line:match("^(.+):::(.+)$")
      if pkg and dir then
        table.insert(items, "[ws] " .. pkg .. "\t" .. dir)
      end
    end
  end

  -- GOMODCACHE packages
  local cache = vim.fn.systemlist("go env GOMODCACHE")[1] or ""
  if cache ~= "" then
    local cmd = string.format("fd -t d -d 4 '@v' '%s' 2>/dev/null | head -200", cache)
    local cached = vim.fn.systemlist(cmd)
    for _, path in ipairs(cached) do
      local pkg = path:gsub(cache .. "/", "")
      if pkg ~= "" then
        table.insert(items, "[mod] " .. pkg .. "\t" .. path)
      end
    end
  end

  fzf.fzf_exec(items, {
    prompt = "Packages ❯ ",
    previewer = false,
    fzf_opts = {
      ["--delimiter"] = "\t",
      ["--with-nth"] = "1",
      ["--preview"] = "tree -C -L 2 {2} 2>/dev/null || ls -la {2} 2>/dev/null",
      ["--header"] = "ctrl-a: all | ctrl-f: funcs | ctrl-t: types | ctrl-c: consts",
    },
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then return end
        local parts = vim.split(selected[1], "\t")
        local pkg_display = parts[1]:gsub("^%[[^%]]+%] ", "")
        local pkg_dir = parts[2]
        M.package_symbols(pkg_display, pkg_dir)
      end,
      ["ctrl-y"] = function(selected)
        if not selected or #selected == 0 then return end
        local pkg = selected[1]:gsub("^%[[^%]]+%] ", ""):match("^[^\t]+")
        vim.fn.setreg("+", pkg)
        vim.notify("Yanked: " .. pkg)
      end,
      ["ctrl-a"] = function() M.symbols() end,
      ["ctrl-f"] = function() M.functions() end,
      ["ctrl-t"] = function() M.types() end,
      ["ctrl-c"] = function() M.constants() end,
    },
  })
end

-- =============================================================================
-- Show all symbols within a package
-- =============================================================================
function M.package_symbols(pkg, pkg_dir)
  fzf.fzf_exec(build_cmd(pkg_dir, patterns.all), {
    prompt = pkg .. " ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(pkg_dir, "ctrl-f: funcs | ctrl-t: types | ctrl-c: consts"),
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
          vim.fn.setreg("+", parsed.content)
          vim.notify("Copied: " .. parsed.content)
        end
      end,
      ["ctrl-f"] = function() M.functions(pkg_dir) end,
      ["ctrl-t"] = function() M.types(pkg_dir) end,
      ["ctrl-c"] = function() M.constants(pkg_dir) end,
    },
  })
end

-- =============================================================================
-- Search functions
-- =============================================================================
function M.functions(dir)
  local cwd = dir or vim.fn.getcwd()
  local header = dir and "ctrl-a: all | ctrl-t: types | ctrl-c: consts" or "ctrl-a: all | ctrl-t: types | ctrl-c: consts | ctrl-p: packages | ctrl-d: deps"

  fzf.fzf_exec(build_cmd(cwd, patterns.functions), {
    prompt = "Functions ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(cwd, header),
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. cwd .. "/" .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.content)
          vim.notify("Copied: " .. parsed.content)
        end
      end,
      ["ctrl-a"] = function() M.symbols(dir) end,
      ["ctrl-t"] = function() M.types(dir) end,
      ["ctrl-c"] = function() M.constants(dir) end,
      ["ctrl-p"] = not dir and function() M.packages() end or nil,
      ["ctrl-d"] = not dir and function() M.dep_functions() end or nil,
    },
  })
end

-- =============================================================================
-- Search functions in dependencies
-- =============================================================================
function M.dep_functions()
  local deps = get_go_mod_deps()
  if #deps == 0 then
    vim.notify("No dependencies found in go.mod", vim.log.levels.WARN)
    return
  end

  fzf.fzf_exec(build_deps_cmd(deps, patterns.functions), {
    prompt = "Dep Functions ❯ ",
    previewer = false,
    fzf_opts = {
      ["--delimiter"] = "\t",
      ["--with-nth"] = "1",
      ["--preview"] = "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); echo '── '$f':'$l' ──' && echo && bat --style=numbers --color=always --highlight-line $l --line-range $l: $f 2>/dev/null || cat -n $f | tail -n +$l | head -30",
      ["--preview-window"] = "right:40%",
      ["--header"] = "ctrl-a: all | ctrl-t: types | ctrl-c: consts | ctrl-w: workspace",
    },
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
          vim.fn.setreg("+", parsed.content)
          vim.notify("Copied: " .. parsed.content)
        end
      end,
      ["ctrl-a"] = function() M.dep_symbols() end,
      ["ctrl-t"] = function() M.dep_types() end,
      ["ctrl-c"] = function() M.dep_constants() end,
      ["ctrl-w"] = function() M.functions() end,
    },
  })
end

-- =============================================================================
-- Search types
-- =============================================================================
function M.types(dir)
  local cwd = dir or vim.fn.getcwd()
  local header = dir and "ctrl-a: all | ctrl-f: funcs | ctrl-c: consts" or "ctrl-a: all | ctrl-f: funcs | ctrl-c: consts | ctrl-p: packages | ctrl-d: deps"

  fzf.fzf_exec(build_cmd(cwd, patterns.types), {
    prompt = "Types ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(cwd, header),
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. cwd .. "/" .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.content)
          vim.notify("Copied: " .. parsed.content)
        end
      end,
      ["ctrl-a"] = function() M.symbols(dir) end,
      ["ctrl-f"] = function() M.functions(dir) end,
      ["ctrl-c"] = function() M.constants(dir) end,
      ["ctrl-p"] = not dir and function() M.packages() end or nil,
      ["ctrl-d"] = not dir and function() M.dep_types() end or nil,
    },
  })
end

-- =============================================================================
-- Search types in dependencies
-- =============================================================================
function M.dep_types()
  local deps = get_go_mod_deps()
  if #deps == 0 then
    vim.notify("No dependencies found in go.mod", vim.log.levels.WARN)
    return
  end

  fzf.fzf_exec(build_deps_cmd(deps, patterns.types), {
    prompt = "Dep Types ❯ ",
    previewer = false,
    fzf_opts = {
      ["--delimiter"] = "\t",
      ["--with-nth"] = "1",
      ["--preview"] = "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); echo '── '$f':'$l' ──' && echo && bat --style=numbers --color=always --highlight-line $l --line-range $l: $f 2>/dev/null || cat -n $f | tail -n +$l | head -30",
      ["--preview-window"] = "right:40%",
      ["--header"] = "ctrl-a: all | ctrl-f: funcs | ctrl-c: consts | ctrl-w: workspace",
    },
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
          vim.fn.setreg("+", parsed.content)
          vim.notify("Copied: " .. parsed.content)
        end
      end,
      ["ctrl-a"] = function() M.dep_symbols() end,
      ["ctrl-f"] = function() M.dep_functions() end,
      ["ctrl-c"] = function() M.dep_constants() end,
      ["ctrl-w"] = function() M.types() end,
    },
  })
end

-- =============================================================================
-- Search constants/vars
-- =============================================================================
function M.constants(dir)
  local cwd = dir or vim.fn.getcwd()
  local header = dir and "ctrl-a: all | ctrl-f: funcs | ctrl-t: types" or "ctrl-a: all | ctrl-f: funcs | ctrl-t: types | ctrl-p: packages | ctrl-d: deps"

  fzf.fzf_exec(build_cmd(cwd, patterns.constants), {
    prompt = "Constants ❯ ",
    previewer = false,
    fzf_opts = build_fzf_opts(cwd, header),
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.cmd("edit " .. cwd .. "/" .. parsed.file)
          vim.cmd(":" .. parsed.line)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-y"] = function(selected)
        local parsed = parse_selection(selected)
        if parsed then
          vim.fn.setreg("+", parsed.content)
          vim.notify("Copied: " .. parsed.content)
        end
      end,
      ["ctrl-a"] = function() M.symbols(dir) end,
      ["ctrl-f"] = function() M.functions(dir) end,
      ["ctrl-t"] = function() M.types(dir) end,
      ["ctrl-p"] = not dir and function() M.packages() end or nil,
      ["ctrl-d"] = not dir and function() M.dep_constants() end or nil,
    },
  })
end

-- =============================================================================
-- Search constants in dependencies
-- =============================================================================
function M.dep_constants()
  local deps = get_go_mod_deps()
  if #deps == 0 then
    vim.notify("No dependencies found in go.mod", vim.log.levels.WARN)
    return
  end

  fzf.fzf_exec(build_deps_cmd(deps, patterns.constants), {
    prompt = "Dep Constants ❯ ",
    previewer = false,
    fzf_opts = {
      ["--delimiter"] = "\t",
      ["--with-nth"] = "1",
      ["--preview"] = "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); echo '── '$f':'$l' ──' && echo && bat --style=numbers --color=always --highlight-line $l --line-range $l: $f 2>/dev/null || cat -n $f | tail -n +$l | head -30",
      ["--preview-window"] = "right:40%",
      ["--header"] = "ctrl-a: all | ctrl-f: funcs | ctrl-t: types | ctrl-w: workspace",
    },
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
          vim.fn.setreg("+", parsed.content)
          vim.notify("Copied: " .. parsed.content)
        end
      end,
      ["ctrl-a"] = function() M.dep_symbols() end,
      ["ctrl-f"] = function() M.dep_functions() end,
      ["ctrl-t"] = function() M.dep_types() end,
      ["ctrl-w"] = function() M.constants() end,
    },
  })
end

-- =============================================================================
-- Search all symbols in dependencies
-- =============================================================================
function M.dep_symbols()
  local deps = get_go_mod_deps()
  if #deps == 0 then
    vim.notify("No dependencies found in go.mod", vim.log.levels.WARN)
    return
  end

  fzf.fzf_exec(build_deps_cmd(deps, patterns.all), {
    prompt = "Dep Symbols ❯ ",
    previewer = false,
    fzf_opts = {
      ["--delimiter"] = "\t",
      ["--with-nth"] = "1",
      ["--preview"] = "f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); echo '── '$f':'$l' ──' && echo && bat --style=numbers --color=always --highlight-line $l --line-range $l: $f 2>/dev/null || cat -n $f | tail -n +$l | head -30",
      ["--preview-window"] = "right:40%",
      ["--header"] = "ctrl-f: funcs | ctrl-t: types | ctrl-c: consts | ctrl-w: workspace",
    },
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
          vim.fn.setreg("+", parsed.content)
          vim.notify("Copied: " .. parsed.content)
        end
      end,
      ["ctrl-f"] = function() M.dep_functions() end,
      ["ctrl-t"] = function() M.dep_types() end,
      ["ctrl-c"] = function() M.dep_constants() end,
      ["ctrl-w"] = function() M.symbols() end,
    },
  })
end

return M
