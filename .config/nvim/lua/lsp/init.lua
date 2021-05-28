local lsp = vim.lsp

lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(
  lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = {
      prefix = "●",
      spacing = 4,
    }
  }
)

require('lspkind').init()

-- LSP Server Names are in the format provided by
-- lua, typescript, dockerfile, efm, html, css,

require'lspinstall'.setup{}
local servers = require'lspinstall'.installed_servers()
for _, server in ipairs(servers) do
    -- if file is not present, would throw error, and that's good
    require('lsp.languages.' .. server)
end
