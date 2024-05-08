-- local min_severity = vim.diagnostic.severity.WARN
local min_severity = vim.diagnostic.severity.HINT
vim.diagnostic.config({
  underline = {
    severity = {
      min = min_severity,
      max = vim.diagnostic.severity.ERROR,
    },
  },
  -- virtual_text = {
  --   -- prefix = "☠ ",
  --   prefix = " ● ",
  --   severity = vim.diagnostic.severity.ERROR,
  --   only_current_line = true,
  -- },
  virtual_text = false,
  signs = {
    severity = {
      min = min_severity,
      max = vim.diagnostic.severity.ERROR,
    },
  },
  float = {
    source = "always",
    focusable = false,
    border = "single",
  },
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  -- delay update diagnostics
  update_in_insert = false,
})

local function on_attach(client, bufnr)
  local opts = { silent = true, buffer = bufnr, remap = false }

  -- if client.supports_method("textDocument/inlayHint") then
  --   vim.lsp.inlay_hint.enable(bufnr, true)
  -- end

  if client ~= nil and client.server_capabilities ~= nil then
    client.server_capabilities.semanticTokensProvider = nil
  end
  -- client.server_capabilities.semanticTokensProvider = nil

  -- vim.api.nvim_create_autocmd("CursorHold", {
  --   buffer = bufnr,
  --   callback = function()
  --     local float_opts = {
  --       focusable = false,
  --       close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
  --       border = "rounded",
  --       source = "always",
  --       prefix = " ",
  --       scope = "cursor",
  --     }
  --     vim.diagnostic.open_float(nil, float_opts)
  --   end,
  -- })

  vim.keymap.set("n", "sn", function()
    local severity = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severity.ERROR }
    local ft = vim.bo.filetype
    if ft == "typescript" or ft == "typescript.tsx" or ft == "typescriptreact" then
      severity.min = vim.diagnostic.severity.HINT
    end
    vim.diagnostic.goto_next({ severity = severity })
  end, opts)

  vim.keymap.set("n", "sp", function()
    local severity = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severity.ERROR }
    local ft = vim.bo.filetype
    if ft == "typescript" or ft == "typescript.tsx" or ft == "typescriptreact" then
      severity.min = vim.diagnostic.severity.HINT
    end
    vim.diagnostic.goto_prev({ severity = severity })
  end, opts)

  vim.keymap.set("n", "se", vim.diagnostic.open_float, opts)

  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set({ "n", "v" }, "<M-CR>", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "f;", function()
    vim.lsp.buf.format({ async = false })
  end, opts)

  -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gr", function()
    require("telescope.builtin").lsp_references({ include_current_line = false, show_line = false })
  end, opts)
  -- vim.keymap.set("n", "gd", "<Cmd>Telescope lsp_definitions<CR>", opts)
  vim.keymap.set("n", "gd", "<Cmd>Fzf lsp_definitions jump_to_single_result=true<CR>", opts)
  vim.keymap.set("n", "gD", "<Cmd>Fzf lsp_typedefs<CR>", opts)
  vim.keymap.set("n", "gi", "<Cmd>Fzf lsp_implementations<CR>", opts)
  vim.keymap.set("n", "sr", vim.lsp.buf.rename, opts)
end

-- LSP signs default
local signs = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- setting up lsp servers

local lsp_config = require("lspconfig")

-- table.insert(vim.opt.runtimepath, vim.fn.stdpath("data") .. "/mason/bin")
vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.stdpath("data") .. "/mason/bin"

-- local base_dir = vim.fn.stdpath("data") .. "/mason/bin"
-- local lsp_servers = {
--   tsserver = {
--     base_dir .. "/typescript-language-server",
--     "--stdio",
--   },
--   graphql = {
--     base_dir .. "/graphql-lsp",
--     "server",
--     "-m",
--     "stream",
--   },
--   rome = {
--     base_dir .. "/rome",
--     -- "--stdio",
--   },
--   yaml = {
--     base_dir .. "/yaml-language-server",
--     "--stdio",
--   },
--   lua = {
--     base_dir .. "/lua-language-server",
--   },
--   go = {
--     base_dir .. "/gopls",
--   },
--   eslint_d = {
--     base_dir .. "/eslint_d",
--     "--stdio",
--   },
--   css = {
--     base_dir .. "/vscode-langservers-extracted/node_modules/.bin/vscode-css-language-server",
--   },
--   tailwindcss = {
--     base_dir .. "/tailwindcss-language-server",
--     "--stdio",
--   },
--   json = {
--     base_dir .. "/jsonls/node_modules/.bin/vscode-json-language-server",
--     "--stdio",
--   },
--   docker = {
--     base_dir .. "/docker-langserver",
--     "--stdio",
--   },
--   bashls = {
--     base_dir .. "/bash-language-server",
--     "start",
--   },
--   python = {
--     base_dir .. "/python/node_modules/.bin/pyright-langserver",
--     "--stdio",
--   },
--   quicklint = {
--     base_dir .. "/quick_lint_js/bin/quick-lint-js",
--     "--lsp",
--   },
--   terraform = {
--     base_dir .. "/terraform-ls",
--     "serve",
--   },
-- }

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

-- Code actions
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.codeAction = {
  dynamicRegistration = true,
  codeActionLiteralSupport = {
    valueSet = {
      "",
      "quickfix",
      "refactor",
      "refactor.extract",
      "refactor.inline",
      "refactor.rewrite",
      "source",
      "source.organizeImports",
    },
  },
}

capabilities.document_formatting = true
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

-- has_cmp, cmp = pcall(require, "cmp")
-- if has_cmp then
--   require("cmp_nvim_lsp").default_capabilities(capabilities)
-- end

-- Add bun for Node.js-based servers
local lspconfig_util = require("lspconfig.util")
-- local add_bun_prefix = require("plugins.lsp.bun").add_bun_prefix
-- lspconfig_util.on_setup = lspconfig_util.add_hook_before(lspconfig_util.on_setup, add_bun_prefix)

local function wrapper(...)
  local has_coq, coq = pcall(require, "coq")
  if has_coq then
    return coq.lsp_ensure_capabilities(...)
  end
  local has_cmp, cmp = pcall(require, "cmp")
  if has_cmp then
    return vim.tbl_deep_extend(
      "force",
      ...,
      -- { capabilities = cmp.update_capabilities(vim.lsp.protocol.make_client_capabilities()) }
      { capabilities = require("cmp_nvim_lsp").default_capabilities() }
    )
  end

  return ...
end

-- tsserver
lsp_config.tsserver.setup({
  -- cmd = lsp_servers.tsserver,
  capabilities = capabilities,
  root_dir = lsp_config.util.root_pattern("jsconfig.json", "tsconfig.json", "package.json", ".git"),
  on_attach = function(client)
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
    -- client.server_capabilities.document_formatting = false
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    on_attach(client)
  end,
})

-- lsp_config.eslint.setup(config({
--   cmd = lsp_servers.eslint_d,
--   on_attach = on_attach,
--   -- root_dir = lsp_config.util.root_pattern(".eslintrc.yml", "package.json"),
-- }))

-- lsp_config.rome.setup({
--   on_attach = on_attach,
-- })
--
lsp_config.graphql.setup({
  -- cmd = lsp_servers.graphql,
  on_attach = on_attach,
  root_dir = lsp_config.util.root_pattern("gqlgen.yml", ".graphql.config.*", "graphql.config.*"),
})

require("neodev").setup({
  capabilities = capabilities,
  library = {
    plugins = {
      "nvim-dap-ui",
      "neotest",
    },
    types = true,
  },
})

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lsp_config.lua_ls.setup(wrapper({
  -- cmd = lsp_servers.lua,
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      runtime = {
        version = "LuaJIT",
      },
      -- runtime = {
      --   path = runtime_path,
      -- },
      -- completion = {
      --   callSnippet = "Replace",
      -- },
      workspace = {
        -- library = vim.api.nvim_get_runtime_file("", true),
        library = {
          vim.env.VIMRUNTIME,
          -- [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          -- [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}))

-- -- yamlls
-- lsp_config.yamlls.setup({
--     cmd = lsp_servers.yaml,
--     on_attach = on_attach,
--     capabilities = capabilities,
--     filetypes = { "yaml", "yml" },
--     settings = {
--         yaml = {
--             schemaStore = {
--                 url = "https://www.schemastore.org/api/json/catalog.json",
--                 enable = true,
--             },
--         },
--     },
-- })

-- Css
lsp_config.cssls.setup({
  capabilities = capabilities,
  -- cmd = lsp_servers.css,
  on_attach = on_attach,
})

-- Tailwind CSS
lsp_config.tailwindcss.setup({
  -- cmd = lsp_servers.tailwindcss,
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "javascriptreact", "typescriptreact", "html", "css", "typescript.tsx", "javascript.jsx" },
  root_dir = lsp_config.util.root_pattern("tailwind.config.js"),
  log_level = vim.lsp.protocol.MessageType.Warning,
  settings = {},
})

-- -- json
-- lsp_config.jsonls.setup({
-- 	cmd = lsp_servers.json,
-- 	capabilities = capabilities,
-- 	on_attach = on_attach,
-- 	settings = {
-- 		json = {
-- 			--[[
-- 			schemas = require("schemastore").json.schemas({
-- 				select = {
-- 					"package.json",
-- 					"jsconfig.json",
-- 					"tsconfig.json",
-- 					"eslintrc.json",
-- 				},
-- 			}),
-- 			--]]
-- 			-- validate = { enable = true },
-- 			schemas = {
-- 				{
-- 					fileMatch = { "package.json" },
-- 					url = "https://json.schemastore.org/npmpackagejsonlintrc.json",
-- 				},
-- 				{
-- 					fileMatch = { "jsconfig.json" },
-- 					url = "https://json.schemastore.org/jsconfig.json",
-- 				},
-- 				{
-- 					fileMatch = { "tsconfig.json" },
-- 					url = "https://json.schemastore.org/tsconfig.json",
-- 				},
-- 				{
-- 					fileMatch = { ".eslintrc.json", ".eslintrc" },
-- 					url = "https://json.schemastore.org/eslintrc.json",
-- 				},
-- 			},
-- 		},
-- 	},
-- })

-- Bash
lsp_config.bashls.setup({
  -- cmd = lsp_servers.bashls,
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "sh", "bash" },
})

-- Dockerfile
lsp_config.dockerls.setup({
  -- cmd = lsp_servers.docker,
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "Dockerfile", "dockerfile" },
  root_dir = lsp_config.util.root_pattern("Dockerfile"),
  log_level = vim.lsp.protocol.MessageType.Warning,
  settings = {},
})

-- python lsp
lsp_config.pyright.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  -- cmd = lsp_servers.python,
})

lsp_config.gopls.setup(wrapper({
  -- cmd = lsp_servers.go,
  -- capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "go", "gomod", "gowork" },
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    gopls = {
      usePlaceholders = true,
      gofumpt = true,
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = false,
        tidy = false,
        upgrade_dependency = false,
        vendor = false,
      },
      experimentalPostfixCompletions = true,
      completeUnimported = true,
      staticcheck = true,
      directoryFilters = { "-.git", "-node_modules", "-vendor" },
      semanticTokens = true,
      hints = {
        assignVariableTypes = false,
        compositeLiteralFields = false,
        compositeLiteralTypes = false,
        constantValues = false,
        functionTypeParameters = false,
        parameterNames = false,
        rangeVariableTypes = false,
      },
    },
  },
}))

lsp_config.terraformls.setup(wrapper({
  -- cmd = lsp_servers.terraform,
  filetypes = { "terraform", "hcl" },
  on_attach = on_attach,
  root_dir = lsp_config.util.root_pattern(".git", ".terraform", "*.tf", "*.pkr.hcl"),
}))

lsp_config.helm_ls.setup({
  -- cmd = { "helm_ls", "serve" },
  filetypes = { "helm", "gotmpl" },
  root_dir = lsp_config.util.root_pattern("Chart.yaml"),
})

lsp_config.bufls.setup({
  root_dir = lsp_config.util.root_pattern("*.proto"),
})

require("lspconfig").rnix.setup({})

require("lspconfig").emmet_language_server.setup({
  filetypes = {
    "css",
    "eruby",
    "html",
    "javascriptreact",
    "less",
    "sass",
    "scss",
    "pug",
    "jsx",
    "tsx",
    "typescriptreact",
  },
  -- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
  -- **Note:** only the options listed in the table are supported.
  init_options = {
    ---@type table<string, string>
    includeLanguages = {},
    --- @type string[]
    excludeLanguages = {},
    --- @type string[]
    extensionsPath = {},
    --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
    preferences = {},
    --- @type boolean Defaults to `true`
    showAbbreviationSuggestions = true,
    --- @type "always" | "never" Defaults to `"always"`
    showExpandedAbbreviation = "always",
    --- @type boolean Defaults to `false`
    showSuggestionsAsSnippets = false,
    --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
    syntaxProfiles = {},
    --- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
    variables = {},
  },
})

lsp_config.biome.setup({})

lsp_config.efm.setup({
  init_options = { documentFormatting = true },
  settings = {
    -- rootMarkers = { ".git/" },
    languages = {
      lua = {
        require("efmls-configs.linters.luacheck"),
        require("efmls-configs.formatters.stylua"),
      },
      typescript = {
        require("efmls-configs.linters.eslint_d"),
        require("efmls-configs.formatters.eslint_d"),
      },
      javascript = {
        require("efmls-configs.linters.eslint_d"),
        require("efmls-configs.formatters.eslint_d"),
      },
      typescriptreact = {
        require("efmls-configs.linters.eslint_d"),
        require("efmls-configs.formatters.eslint_d"),
      },
      javascriptreact = {
        require("efmls-configs.linters.eslint_d"),
        require("efmls-configs.formatters.eslint_d"),
      },
      go = {
        require("efmls-configs.linters.go_revive"),
        require("efmls-configs.formatters.gofmt"),
        require("efmls-configs.formatters.goimports"),
      },
      bash = {
        require("efmls-configs.linters.bashate"),
        require("efmls-configs.formatters.shfmt"),
      },
      sh = {
        require("efmls-configs.linters.bashate"),
        require("efmls-configs.formatters.shfmt"),
      },
      -- proto = {
      -- require("efmls-configs.linters.buf"),
      -- require("efmls-configs.formatters.buf"),
      -- },
    },
  },
})
