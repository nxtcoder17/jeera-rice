local on_attach = require'lsp.on_attach'

require'lspconfig'.typescript.setup{
  on_attach = function (client)
    client.resolved_capabilities.document_formatting = false
    on_attach(client)
  end
}
