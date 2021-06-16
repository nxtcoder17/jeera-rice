local lsp = vim.lsp

lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(
  lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = {
      prefix = "●",
      spacing = 12,
    }
  }
)

-- lua, typescript, dockerfile, efm, html, css,

require'lspinstall'.setup{}
local servers = require'lspinstall'.installed_servers()
for _, server in ipairs(servers) do
    -- if file is not present, would throw error, and that's good
    require('lsp.languages.' .. server)
end

local method = "textDocument/publishDiagnostics"
local default_handler = vim.lsp.handlers[method]
vim.lsp.handlers[method] = function(err, method, result, client_id, bufnr,
                                    config)
    default_handler(err, method, result, client_id, bufnr, config)
    local diagnostics = vim.lsp.diagnostic.get_all()
    local qflist = {}
    for bufnr, diagnostic in pairs(diagnostics) do
        for _, d in ipairs(diagnostic) do
            d.bufnr = bufnr
            d.lnum = d.range.start.line + 1
            d.col = d.range.start.character + 1
            d.text = d.message
            table.insert(qflist, d)
        end
    end
    vim.lsp.util.set_qflist(qflist)
  end
