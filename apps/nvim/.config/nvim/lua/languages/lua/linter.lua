notify_if_not_installed({ "selene" })

local ok, lint = pcall(require, "lint")
if not ok then
  vim.notify_error("mfussenegger/nvim-lint is not installed")
  return
end

lint.linters_by_ft.lua = { "selene" }
