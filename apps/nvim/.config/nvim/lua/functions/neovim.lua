local M = {}

M.get_selection = function()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_row, start_col = start_pos[2], start_pos[3]
  local end_row, end_col = end_pos[2], end_pos[3]

  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_text(bufnr, start_row - 1, start_col - 1, end_row - 1, end_col, {})

  return table.concat(lines, "\n")
end

M.new_logger = function(name, level)
  level = level or "debug"
  return require("plenary.log").new({
    plugin = name,
    level = level,
  })
end

return M
