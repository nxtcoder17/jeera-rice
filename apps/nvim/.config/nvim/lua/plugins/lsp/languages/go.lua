local M = {}

M.setup_mason = function()
	local mr = Require("mason-registry")

	local golang_tools = {
		"gopls",
		"gofumpt",
		"delve",
		"gotests",
		"gomodifytags",
		"impl",
		"iferr",
		"json-to-struct",
	}

	for _, item in ipairs(golang_tools) do
		if not mr.is_installed(item) then
			vim.cmd("MasonInstall " .. item)
		end
	end
end

M.setup_lsp = function(on_attach, capabilities_wrapper)
	Require("lspconfig").gopls.setup(capabilities_wrapper({
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
end

return M
