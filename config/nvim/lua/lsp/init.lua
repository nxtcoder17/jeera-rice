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

--- Languages

-- EFM
local efm_config = vim.fn.stdpath('config') .. '/lua/lsp/languages/efm/config.yaml'
local efm_log_dir = '/tmp'
local efm_root_markers = { 'package.json', '.git/', '.zshrc' }


local eslint = {
  lintCommand = 'eslint_d --stdin --stdin-filename ${INPUT} -f unix',
  lintStdin = true,
  lintIgnoreExitCode = true
}

local prettier = {
  formatCommand = 'prettier --find-config-path --stdin-filepath ${INPUT}',
  formatStdin = true
}

local efm_languages = {
  yaml = { prettier },
  json = { prettier },
  markdown = { prettier },
  javascript = { eslint, prettier },
  javascriptreact = { eslint, prettier },
  typescript = { eslint, prettier },
  typescriptreact = { eslint, prettier },
  css = { prettier },
  scss = { prettier },
  sass = { prettier },
  less = { prettier },
  graphql = { prettier },
  vue = { prettier },
  html = { prettier }
}

local efmServerPath = vim.fn.stdpath('data') .. '/lspinstall/efm/efm-langserver'

require'lspconfig'.efm.setup{
  cmd = {
    efmServerPath,
    '-c',
    efm_config,
    '-logfile',
    efm_log_dir .. '/logfile.log'
  },
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
  on_attach = require'lsp.on_attach',
  init_options = {
    document_formatting = false,
  },
  settings = {
    rootMarkers = efm_root_markers,
    languages = efm_languages,
  },
}

-- LspInstall lua
require'lspconfig'.lua.setup{
  on_attach = require'lsp.on_attach',
  settings = {
    Lua = {
      diagnosticss = {
        enable = true,
        globals = {
          "vim",
        }
      }
    }
  }
}

-- LspInstall tailwindcss
require'lspconfig'.tailwindcss.setup{}

-- for _, server in ipairs(servers) do
    -- if file is not present, would throw error, and that's good
    -- require('lsp.languages.' .. server)
-- end

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

