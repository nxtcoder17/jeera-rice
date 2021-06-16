local on_attach = require'lsp.on_attach'
local capabilities = require'lsp.capabilities'

require'lspconfig'.typescript.setup{
    cmd = {
      vim.fn.stdpath('data') .. '/lspinstall/typescript/node_modules/.bin/typescript-language-server',
      '--stdio'
    },
    capabilities = capabilities,
    on_attach = function (client)
      client.resolved_capabilities.document_formatting = false
      on_attach(client)
    end
}
