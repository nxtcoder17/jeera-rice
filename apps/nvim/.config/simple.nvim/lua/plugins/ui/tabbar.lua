-- Custom tabbar plugin with tab renaming support
local M = {}

-- Highlight groups
local hl = {
  fill = "TabLineFill",
  current = "TabLineSel",
  inactive = "TabLine",
}

-- Get custom tab name or derive from buffer/directory
---@param tabnr number Tab page handle
---@return string
local function get_tab_name(tabnr)
  -- Check for custom name first
  local ok, name = pcall(vim.api.nvim_tabpage_get_var, tabnr, "custom_tab_name")
  if ok and name and name ~= "" then
    return name
  end

  -- Get the focused window's buffer name
  local win = vim.api.nvim_tabpage_get_win(tabnr)
  local buf = vim.api.nvim_win_get_buf(win)
  local bufname = vim.api.nvim_buf_get_name(buf)

  if bufname and bufname ~= "" then
    return vim.fn.fnamemodify(bufname, ":t")
  end

  -- Fallback to tab's cwd
  local tab_cwd = vim.fn.getcwd(-1, vim.api.nvim_tabpage_get_number(tabnr))
  if tab_cwd and tab_cwd ~= "" then
    return vim.fn.fnamemodify(tab_cwd, ":t")
  end

  return "[No Name]"
end

-- Build the tabline string
local function render_tabline()
  local tabs = vim.api.nvim_list_tabpages()
  local current_tab = vim.api.nvim_get_current_tabpage()
  local parts = {}

  for idx, tabnr in ipairs(tabs) do
    local is_current = tabnr == current_tab
    local tab_hl = is_current and hl.current or hl.inactive
    local name = get_tab_name(tabnr)

    -- Format: %{minwid}@FuncRef@text%X
    -- minwid (tabnr) is passed to the click handler as first argument
    local tab_str =
      string.format("%%#%s#%%%d@v:lua.require'plugins.ui.tabbar'.tab_click@ ▌ %d:%s ▌%%X", tab_hl, tabnr, idx, name)
    table.insert(parts, tab_str)
  end

  -- Add fill at the end
  table.insert(parts, "%#" .. hl.fill .. "#%=")

  return table.concat(parts, "")
end

-- Tab click handler (for mouse support)
function M.tab_click(tabnr, clicks, button, modifiers)
  if button == "l" then
    vim.api.nvim_set_current_tabpage(tabnr)
  elseif button == "r" then
    -- Right click to rename
    M.rename_tab(tabnr)
  elseif button == "m" then
    -- Middle click to close
    if #vim.api.nvim_list_tabpages() > 1 then
      vim.cmd("tabclose " .. vim.api.nvim_tabpage_get_number(tabnr))
    end
  end
end

-- Set custom tab name
---@param tabnr number|nil Tab page handle (nil for current tab)
---@param name string Custom name for the tab
function M.set_tab_name(tabnr, name)
  tabnr = tabnr or vim.api.nvim_get_current_tabpage()
  vim.api.nvim_tabpage_set_var(tabnr, "custom_tab_name", name)
  vim.cmd("redrawtabline")
end

-- Clear custom tab name
---@param tabnr number|nil Tab page handle (nil for current tab)
function M.clear_tab_name(tabnr)
  tabnr = tabnr or vim.api.nvim_get_current_tabpage()
  pcall(vim.api.nvim_tabpage_del_var, tabnr, "custom_tab_name")
  vim.cmd("redrawtabline")
end

-- Get tab name (exported for other modules like find-tabs)
---@param tabnr number Tab page handle
---@return string
M.get_tab_name = get_tab_name

-- Interactive rename
---@param tabnr number|nil Tab page handle (nil for current tab)
function M.rename_tab(tabnr)
  tabnr = tabnr or vim.api.nvim_get_current_tabpage()
  local current_name = get_tab_name(tabnr)

  vim.ui.input({
    prompt = "Tab name: ",
    default = current_name,
  }, function(input)
    if input == nil then
      return -- cancelled
    end

    if input == "" then
      M.clear_tab_name(tabnr)
    else
      M.set_tab_name(tabnr, input)
    end
  end)
end

-- Rename tab by index (1-based)
---@param tab_idx number
function M.rename_tab_by_index(tab_idx)
  local tabs = vim.api.nvim_list_tabpages()
  if tab_idx < 1 or tab_idx > #tabs then
    vim.notify("Invalid tab index: " .. tab_idx, vim.log.levels.ERROR)
    return
  end
  M.rename_tab(tabs[tab_idx])
end

-- Setup the tabline and commands
function M.setup(opts)
  opts = opts or {}

  -- Merge custom highlights if provided
  if opts.highlights then
    hl = vim.tbl_extend("force", hl, opts.highlights)
  end

  -- Set tabline
  vim.o.tabline = "%!v:lua.require'plugins.ui.tabbar'.tabline()"
  vim.o.showtabline = 2 -- Always show tabline

  -- Commands
  vim.api.nvim_create_user_command("TabRename", function(cmd_opts)
    if cmd_opts.args and cmd_opts.args ~= "" then
      M.set_tab_name(nil, cmd_opts.args)
    else
      M.rename_tab()
    end
  end, { nargs = "?", desc = "Rename current tab" })

  vim.api.nvim_create_user_command("TabClearName", function()
    M.clear_tab_name()
  end, { desc = "Clear custom tab name" })

  -- Keymaps
  vim.keymap.set("n", "tr", M.rename_tab, {
    silent = true,
    noremap = true,
    desc = "Rename current tab",
  })
end

-- Tabline function (called by vim)
function M.tabline()
  return render_tabline()
end

return M
