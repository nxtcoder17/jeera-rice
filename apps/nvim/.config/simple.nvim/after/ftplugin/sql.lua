notify_if_not_installed({
  "sql-language-server",
})

vim.lsp.config("sqlls", {
  single_file_support = true,
})

vim.lsp.enable("sqlls")
