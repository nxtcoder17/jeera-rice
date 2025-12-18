-- LSP
notify_if_not_installed({ "bash-language-server" })

vim.lsp.config("bashls", {
  on_attach = Require("lsp.on_attach"),
  filetypes = { "sh", "bash" },
})

-- LINTER
set_linter(vim.bo.filetype, { "shellcheck" })

-- FORMATTER
set_formatter(vim.bo.filetype, { "shfmt" })
