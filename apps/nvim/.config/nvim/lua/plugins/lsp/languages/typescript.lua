local M = {}

M.setup_mason = function()
	local mr = require("mason-registry")

	local ts_tools = {
		"typescript-language-server",
		"biome",
	}

	for _, item in ipairs(ts_tools) do
		if not mr.is_installed(item) then
			vim.cmd("MasonInstall " .. item)
		end
	end
end

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.codeAction = {
-- 	dynamicRegistration = true,
-- 	codeActionLiteralSupport = {
-- 		valueSet = {
-- 			"",
-- 			"quickfix",
-- 			"refactor",
-- 			"refactor.extract",
-- 			"refactor.inline",
-- 			"refactor.rewrite",
-- 			"source",
-- 			"source.organizeImports",
-- 		},
-- 	},
-- }

-- capabilities.document_formatting = true
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
-- capabilities.textDocument.foldingRange = {
-- 	dynamicRegistration = false,
-- 	lineFoldingOnly = true,
-- }
-- capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

-- typescript LSP
M.setup_lsp = function(on_attach, capabilities_wrapper)
	local lsp_config = Require("lspconfig")
	lsp_config.ts_ls.setup(capabilities_wrapper({
		root_dir = lsp_config.util.root_pattern("package-lock.json", "yarn.lock", "pnpm-lock.yaml"),
		single_file_support = false,
		on_attach = function(client)
			if client.config.flags then
				client.config.flags.allow_incremental_sync = true
			end
			-- client.server_capabilities.document_formatting = false
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
			on_attach(client)
		end,
	}))

	lsp_config.biome.setup({})

	-- lsp_config.eslint.setup(config({
	-- on_attach = on_attach,
	-- root_dir = lsp_config.util.root_pattern(".eslintrc.yml", "package.json"),
	-- }))
end

return M
