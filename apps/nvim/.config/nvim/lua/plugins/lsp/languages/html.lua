local M = {}

M.setup_mason = function()
	local mr = require("mason-registry")

	local requirements = {
		"html-lsp",
		"emmet-language-server",
	}

	for _, item in ipairs(requirements) do
		if not mr.is_installed(item) then
			vim.cmd("MasonInstall " .. item)
		end
	end
end

M.setup_lsp = function(on_attach, capabilities_wrapper)
	local lsp_config = Require("lspconfig")

	lsp_config.html.setup(capabilities_wrapper({
		on_attach = on_attach,
		filetypes = { "gohtmltmpl", "html", "htmljinja", "svelte", "vue" },
	}))

	lsp_config.emmet_language_server.setup({
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
end

return M
