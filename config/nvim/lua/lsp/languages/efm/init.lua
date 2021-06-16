local on_attach = require'lsp.on_attach'
local eslint = require'lsp.languages.efm.eslint'
local prettier = require'lsp.languages.efm.prettier'

local efm_config = vim.fn.stdpath('config') .. '/lua/lsp/languages/efm/config.yaml'
local efm_log_dir = '/tmp'
local efm_root_markers = { 'package.json', '.git/', '.zshrc' }

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
