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

local on_attach = require'lsp.on_attach'

-- Lua
require'lspconfig'.lua.setup{
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
          globals = { 'vim' }
      }
    }
  }
}

-- Typescript/Javascript
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Code actions
capabilities.textDocument.codeAction = {
    dynamicRegistration = true,
    codeActionLiteralSupport = {
        codeActionKind = {
            valueSet = (function()
                local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
                table.sort(res)
                return res
            end)()
        }
    }
}

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

-- Css
require'lspconfig'.css.setup{}

-- Tailwind CSS
require'lspconfig'.tailwindcss.setup{}

-- json
require'lspconfig'.json.setup{}

-- Bash
require'lspconfig'.bash.setup{}

-- Dockerfile
require'lspconfig'.dockerfile.setup{}

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
  on_attach = on_attach,
  init_options = {
    document_formatting = false,
  },
  settings = {
    rootMarkers = efm_root_markers,
    languages = efm_languages,
  },
}

