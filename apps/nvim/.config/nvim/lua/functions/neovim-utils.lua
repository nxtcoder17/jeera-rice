local M = {}

-- M.get_selection = function()
--   local start_pos = vim.fn.getpos("'<")
--   local end_pos = vim.fn.getpos("'>")
--
--   vim.print(start_pos, end_pos)
--
--   local start_row, start_col = start_pos[2], start_pos[3]
--   local end_row, end_col = end_pos[2], end_pos[3]
--
--   vim.print(start_row, start_col, end_row, end_col)
--
--   local bufnr = vim.api.nvim_get_current_buf()
--   local lines = vim.api.nvim_buf_get_text(bufnr, start_row - 1, start_col - 1, end_row - 1, end_col, {})
--   local out = table.concat(lines, "\n")
--   print(out)
--   return out
-- end

-- author: justinmk source: https://github.com/neovim/neovim/pull/13896#issuecomment-1621702052
function region_to_text(region)
  local text = ""
  local maxcol = vim.v.maxcol
  for line, cols in vim.spairs(region) do
    local endcol = cols[2] == maxcol and -1 or cols[2]
    local chunk = vim.api.nvim_buf_get_text(0, line, cols[1], line, endcol, {})[1]
    text = ("%s%s"):format(text, chunk)
  end
  return text
end

M.get_selection = function(opts)
  opts = opts or { debug = false }
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true)
  local region = vim.region(0, "'<", "'>", vim.fn.visualmode(), true)
  local out = region_to_text(region)
  if opts.debug then
    print(out)
  end
  return out
end

M.new_logger = function(name, level)
  level = level or "debug"
  return require("plenary.log").new({
    plugin = name,
    level = level,
  })
end

return M
