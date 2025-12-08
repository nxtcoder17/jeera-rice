if not notify_if_not_installed({ "bash-language-server" }) then
  return
end

vim.lsp.configure("bashls", {
  on_attach = Require("lsp.on_attach"),
  filetypes = { "sh", "bash" },
})
