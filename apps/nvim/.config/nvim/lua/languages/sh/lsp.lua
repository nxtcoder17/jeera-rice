if not notify_if_not_installed({ "bash-language-server" }) then
  vim.notify_error("[bash] failed to configure and start LSP server")
  return
end

vim.lsp.configure("bashls", {
  on_attach = Require("lsp.on_attach"),
  filetypes = { "sh", "bash" },
})
