local on_attach = require'lsp.on_attach'

require'lspconfig'.lua.setup({
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        enable = true,
        globals = {
          "vim"
        }
      }
    }
  }
})
