local ok, conform = pcall(require, "conform")
if not ok then
  vim.notify_error("stevearc/conform.nvim not installed")
  return
end

notify_if_not_installed({ "black" })

conform.formatters_by_ft.black = { "black" }
