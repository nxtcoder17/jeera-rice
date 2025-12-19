notify_if_not_installed({ "buf" })

vim.lsp.config("buf_ls", {
  on_attach = Require("lsp.on_attach"),
})

vim.lsp.enable("buf_ls")
