local M = {}

--- Get the word under cursor or partial word being typed
local function get_current_word()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]

  -- Find the start of the word
  local start = col
  while start > 0 and line:sub(start, start):match("[%w_]") do
    start = start - 1
  end
  start = start + 1

  -- Extract the partial word
  local word = line:sub(start, col)
  return word, start, col
end

--- Delete the partial word under cursor
local function delete_partial_word(start_col, end_col)
  local line = vim.api.nvim_get_current_line()
  local row = vim.api.nvim_win_get_cursor(0)[1]

  -- Delete from start to cursor position
  local new_line = line:sub(1, start_col - 1) .. line:sub(end_col + 1)
  vim.api.nvim_buf_set_lines(0, row - 1, row, false, { new_line })

  -- Move cursor to the position where we deleted
  vim.api.nvim_win_set_cursor(0, { row, start_col - 1 })
end

--- Ensure cursor line is visible above the ivy popup
--- @param popup_height_ratio number The height ratio of the popup (e.g., 0.35 for 35%)
local function ensure_cursor_visible(popup_height_ratio)
  local win_height = vim.api.nvim_win_get_height(0)
  local popup_lines = math.floor(win_height * popup_height_ratio)

  -- Get cursor position in window (1-indexed from top of window)
  local cursor_winline = vim.fn.winline()

  -- Calculate the safe zone (area that won't be covered by popup)
  local safe_zone = win_height - popup_lines

  -- If cursor is in the danger zone (would be covered by popup)
  if cursor_winline > safe_zone then
    -- Scroll so cursor is at 60% from top (comfortably above popup)
    local target_line = math.floor(win_height * 0.6)
    local scroll_amount = cursor_winline - target_line

    if scroll_amount > 0 then
      -- Scroll down to move cursor up in the window
      vim.cmd("normal! " .. scroll_amount .. "\x05") -- Ctrl-E to scroll down
    end
  end
end

--- Tag completion using fzf-lua
function M.complete_tags()
  local fzf = require("fzf-lua")
  local actions = require("fzf-lua.actions")

  -- Ensure cursor line is visible before opening popup
  ensure_cursor_visible(0.35)

  -- Get the current word being typed
  local current_word, start_col, end_col = get_current_word()

  -- Custom action to insert the selected tag
  local function insert_tag(selected, opts)
    if not selected or #selected == 0 then
      return
    end

    -- Parse the selected tag line
    -- Format: "tagname	filename	/pattern/;"	kind
    local tag_line = selected[1]
    local tag_name = tag_line:match("^([^%s\t]+)")

    if not tag_name then
      return
    end

    -- Delete the partial word
    delete_partial_word(start_col, end_col)

    -- Insert the completed tag name
    vim.api.nvim_put({ tag_name }, "c", true, true)

    -- Return to insert mode
    vim.cmd("startinsert!")
  end

  -- Call fzf-lua tags with ivy-style configuration
  fzf.tags({
    query = current_word,
    prompt = "Complete❯ ",
    fzf_opts = {
      ["--nth"] = "1",
      ["--with-nth"] = "1,2,3",
    },
    winopts = {
      height = 0.35, -- ivy mode: small height
      width = 1, -- ivy mode: full width
      row = 1, -- ivy mode: bottom-aligned
      preview = {
        layout = "horizontal",
        horizontal = "right:50%",
      },
    },
    actions = {
      ["default"] = insert_tag,
      ["ctrl-v"] = false, -- Disable split actions in insert mode
      ["ctrl-x"] = false,
      ["ctrl-t"] = false,
    },
    -- Show preview with file context
    -- previewer = "builtin",
  })
end

function M.complete_snippets()
  local luasnip = require("luasnip")
  local fzf_lua = require("fzf-lua")

  -- Get available snippets
  local snippets = luasnip.available()

  -- Flatten the snippets table and prepare entries for fzf-lua
  local entries = {}
  for category, snippet_list in pairs(snippets) do
    if type(snippet_list) == "table" then
      for _, snippet in ipairs(snippet_list) do
        local description = snippet.description[1] or "" -- Extract the first description if available
        local entry = string.format("%s - %s (%s) : %s", snippet.trigger, snippet.name, category, description)
        table.insert(entries, entry)
      end
    end
  end

  -- Use fzf-lua to search through snippets
  fzf_lua.fzf_exec(entries, {
    prompt = "Snippet ϟ ",
    actions = {
      ["default"] = function(selected)
        if #selected > 0 then
          -- Extract the trigger from the selected entry
          local trigger = selected[1]:match("^(.-)%s+-")

          -- Insert the trigger into the current buffer and go into insert mode
          vim.api.nvim_put({ trigger }, "c", true, true)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>i", true, true, true), "n", true)
        end
      end,
    },
  })
end

return M
