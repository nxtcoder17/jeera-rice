-- engine.lua — Generic fzf view factory for doc-search
--
-- Replaces the N*M function explosion with a single entry point.
-- Language adapters provide: patterns, build_cmd, scopes, symbol_types.

local import = require("plugins.doc-search-v2.pkg")
local fzf = require("fzf-lua")
local preview = import("util.preview")

local M = {}

-- Parse fzf selection: "import-path.Symbol\tfile:line" -> { file, line, symbol }
local function parse_selection(selected)
  if not selected or #selected == 0 then return nil end
  local parts = vim.split(selected[1], "\t")
  if #parts >= 2 then
    local file, line = parts[2]:match("^([^:]+):(%d+)")
    return { file = file, line = tonumber(line), symbol = parts[1] }
  end
  return nil
end

-- Extract current query from fzf-lua opts (for passing between views)
local function get_query(opts)
  return opts and opts.__call_opts and opts.__call_opts.query or ""
end

-- Open file action builder
local function make_open_action(prefix)
  return function(selected)
    local parsed = parse_selection(selected)
    if not parsed then return end
    local file = prefix and (prefix .. "/" .. parsed.file) or parsed.file
    vim.cmd("edit " .. vim.fn.fnameescape(file))
    vim.cmd(":" .. parsed.line)
    vim.cmd("normal! zz")
  end
end

-- Yank symbol action
local function make_yank_action()
  return function(selected)
    local parsed = parse_selection(selected)
    if not parsed then return end
    vim.fn.setreg("+", parsed.symbol)
    vim.notify("Copied: " .. parsed.symbol)
  end
end

-- Build shortcut header string from available transitions
local function build_header(lang, scope, current_symbol_type, extra_info)
  local parts = {}

  -- Symbol type shortcuts (switch within same scope)
  for _, st in ipairs(lang.symbol_types) do
    if st.name ~= current_symbol_type and st.key then
      table.insert(parts, st.key .. ": " .. st.label)
    end
  end

  -- Scope shortcuts (switch scope)
  for _, sc in ipairs(lang.scopes) do
    if sc.name ~= scope and sc.key then
      table.insert(parts, sc.key .. ": " .. sc.label)
    end
  end

  local header = table.concat(parts, " | ")
  if extra_info then
    header = header .. "\n" .. extra_info
  end
  return header
end

-- Core search function — the single entry point
--
-- opts = {
--   scope         : string — "workspace" | "stdlib" | "dep" | "dep_package" | "packages"
--   symbol_type   : string — "all" | "functions" | "types" | "constants" | "classes"
--   lang          : table  — language adapter
--   query         : string — initial fzf query (optional)
--   dir           : string — scoped directory (optional)
--   dep_info      : table  — { path, dir } for dep_package scope (optional)
--   extra_info    : string — extra header info (optional)
-- }
function M.search(opts)
  local lang = opts.lang
  local scope = opts.scope or "workspace"
  local symbol_type = opts.symbol_type or "all"
  local query = opts.query or lang.get_query_at_cursor()

  -- Get pattern for this symbol type
  local pattern = lang.patterns[symbol_type] or lang.patterns.all

  -- Get the shell command from the language adapter
  local cmd = lang.build_cmd(scope, pattern, {
    dir = opts.dir,
    dep_info = opts.dep_info,
  })

  -- Determine preview prefix
  local preview_prefix = nil
  if scope == "dep_package" and opts.dep_info then
    preview_prefix = opts.dep_info.dir
  elseif scope == "stdlib" and lang.stdlib_src then
    preview_prefix = lang.stdlib_src()
  end

  -- Build fzf options
  local header = build_header(lang, scope, symbol_type, opts.extra_info)
  local fzf_opts = {
    ["--delimiter"] = "\t",
    ["--with-nth"] = "1",
    ["--nth"] = "1",
    ["--preview"] = preview.build(preview_prefix),
    ["--preview-window"] = "right:40%",
    ["--header"] = header,
  }
  if query and query ~= "" then
    fzf_opts["--query"] = query
  end

  -- Build actions
  local actions = {
    ["default"] = make_open_action(preview_prefix),
    ["ctrl-y"] = make_yank_action(),
  }

  -- Symbol type switch shortcuts (stay in same scope)
  for _, st in ipairs(lang.symbol_types) do
    if st.name ~= symbol_type and st.key then
      actions[st.key] = function(_, fzf_cb_opts)
        M.search(vim.tbl_extend("force", opts, {
          symbol_type = st.name,
          query = get_query(fzf_cb_opts),
        }))
      end
    end
  end

  -- Scope switch shortcuts
  for _, sc in ipairs(lang.scopes) do
    if sc.name ~= scope and sc.key then
      actions[sc.key] = function(_, fzf_cb_opts)
        local new_opts = vim.tbl_extend("force", opts, {
          scope = sc.name,
          query = get_query(fzf_cb_opts),
        })
        -- Scope switches may need special handling
        if sc.handler then
          sc.handler(lang, get_query(fzf_cb_opts))
        else
          M.search(new_opts)
        end
      end
    end
  end

  -- Get prompt from symbol type
  local st_info = nil
  for _, st in ipairs(lang.symbol_types) do
    if st.name == symbol_type then
      st_info = st
      break
    end
  end
  local prompt_name = st_info and st_info.prompt or "Search"

  fzf.fzf_exec(cmd, {
    prompt = prompt_name .. " > ",
    previewer = false,
    fzf_opts = fzf_opts,
    actions = actions,
  })
end

-- Package listing view — used for browsing packages/deps before drilling into symbols
--
-- opts = {
--   lang       : table  — language adapter
--   scope      : string — which package list ("packages" | "dep" | "stdlib_packages")
--   items      : table  — pre-built list of "display\tdir\tpath" strings
--   query      : string — initial query (optional)
--   extra_info : string — extra header info (optional)
-- }
function M.packages(opts)
  local lang = opts.lang
  local scope = opts.scope or "packages"
  local query = opts.query

  -- Build header from scope shortcuts
  local parts = {}
  for _, sc in ipairs(lang.scopes) do
    if sc.name ~= scope and sc.key then
      table.insert(parts, sc.key .. ": " .. sc.label)
    end
  end
  -- Add symbol type shortcuts that make sense at package level
  for _, st in ipairs(lang.symbol_types) do
    if st.key and st.name ~= "all" then
      table.insert(parts, st.key .. ": all " .. st.label)
    end
  end

  local header = table.concat(parts, " | ")
  if opts.extra_info then
    header = header .. "\n" .. opts.extra_info
  end

  local fzf_opts = {
    ["--delimiter"] = "\t",
    ["--with-nth"] = "1",
    ["--nth"] = "1",
    ["--preview"] = preview.directory(),
    ["--header"] = header,
  }
  if query and query ~= "" then
    fzf_opts["--query"] = query
  end

  local actions = {
    -- Default: drill into package symbols
    ["default"] = function(selected)
      if not selected or #selected == 0 then return end
      local selected_parts = vim.split(selected[1], "\t")
      local pkg_dir = selected_parts[2]
      local pkg_path = selected_parts[3]
      M.search({
        scope = "dep_package",
        symbol_type = "all",
        lang = lang,
        dep_info = { path = pkg_path, dir = pkg_dir },
        extra_info = pkg_path,
      })
    end,
    ["ctrl-y"] = function(selected)
      if not selected or #selected == 0 then return end
      local selected_parts = vim.split(selected[1], "\t")
      vim.fn.setreg("+", selected_parts[3])
      vim.notify("Copied: " .. selected_parts[3])
    end,
  }

  -- Scope switch shortcuts
  for _, sc in ipairs(lang.scopes) do
    if sc.name ~= scope and sc.key then
      actions[sc.key] = function(_, fzf_cb_opts)
        if sc.handler then
          sc.handler(lang, get_query(fzf_cb_opts))
        else
          M.search({
            scope = sc.name,
            symbol_type = "all",
            lang = lang,
            query = get_query(fzf_cb_opts),
          })
        end
      end
    end
  end

  -- Symbol type shortcuts -> search all with that type
  for _, st in ipairs(lang.symbol_types) do
    if st.key then
      actions[st.key] = function(_, fzf_cb_opts)
        M.search({
          scope = "workspace",
          symbol_type = st.name,
          lang = lang,
          query = get_query(fzf_cb_opts),
        })
      end
    end
  end

  fzf.fzf_exec(opts.items, {
    prompt = (opts.prompt or "Packages") .. " > ",
    previewer = false,
    fzf_opts = fzf_opts,
    actions = actions,
  })
end

-- Expose helpers for hover.lua
M.parse_selection = parse_selection
M.get_query = get_query

return M
