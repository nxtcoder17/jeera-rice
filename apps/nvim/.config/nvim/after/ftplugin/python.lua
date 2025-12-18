notify_if_not_installed({
  "pyright",
})

vim.lsp.config("pyright", {
  on_attach = Require("lsp.on_attach"),
})

vim.lsp.enable("pyright")
