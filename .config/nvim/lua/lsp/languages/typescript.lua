local on_attach = require'lsp.on_attach'

require'lspconfig'.tsserver.setup{
    cmd = {
      '/home/nxtcoder17/.cache/nvim/lspconfig/tsserver/node_modules/.bin/typescript-language-server',
      '--stdio'
    },
  on_attach = function (client, bufnr) 
    client.resolved_capabilities.document_formatting = false
    on_attach(client)
    -- local ts_utils = require'nvim-lsp-ts-utils';

--      -- defaults
--         ts_utils.setup {
--             debug = false,
--             disable_commands = false,
--             enable_import_on_completion = false,
--             import_on_completion_timeout = 5000,

--             -- eslint
--             eslint_enable_code_actions = true,
--             eslint_bin = "eslint",
--             eslint_args = {"-f", "json", "--stdin", "--stdin-filename", "$FILENAME"},
--             eslint_enable_disable_comments = true,

-- 	    -- experimental settings!
--             -- eslint diagnostics
--             eslint_enable_diagnostics = false,
--             eslint_diagnostics_debounce = 250,

--             -- formatting
--             enable_formatting = false,
--             formatter = "prettier",
--             formatter_args = {"--stdin-filepath", "$FILENAME"},
--             format_on_save = false,
--             no_save_after_format = false,

--             -- parentheses completion
--             complete_parens = false,
--             signature_help_in_parens = false,

--             -- update imports on file move
--             update_imports_on_move = false,
--             require_confirmation_on_move = false,
--             watch_dir = "/src",
--         }

--         -- required to enable ESLint code actions and formatting
--         ts_utils.setup_client(client)

--         -- no default maps, so you may want to define some here
--         vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", {silent = true})
--         vim.api.nvim_buf_set_keymap(bufnr, "n", "qq", ":TSLspFixCurrent<CR>", {silent = true})
--         vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", {silent = true})
--         vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", {silent = true})

  end
}
