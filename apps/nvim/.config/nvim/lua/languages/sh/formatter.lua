if not notify_if_not_installed({ "shfmt" }) then
  vim.notify_error("[lua] failed to configure and start formatter")
  return
end

local ok, conform = pcall(require, "conform")
if not ok then
  vim.notify_error("stevearc/conform.nvim not installed")
  return
end

conform.formatters_by_ft.sh = { "shfmt" }
conform.formatters_by_ft.bash = { "shfmt" }
