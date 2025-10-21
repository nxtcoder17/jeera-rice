local M = {}

M.list_buffers = function()
  local buffers = {}
  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buffer)
    if name ~= "" then
      table.insert(buffers, name)
    end
  end
  return buffers
end

M.delete_nameless = function()
  local bufids = {}
  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buffer)
    if name == "" then
      vim.api.nvim_buf_delete(buffer, { force = false })
    end
  end
  return bufids
end

return M
