if not notify_if_not_installed({ "shellcheck" }) then
  return
end

local ok, lint = pcall(require, "lint")
if not ok then
  vim.notify_error("mfussenegger/nvim-lint is not installed")
  return
end

lint.linters_by_ft.sh = { "shellcheck" }
lint.linters_by_ft.bash = { "shellcheck" }
