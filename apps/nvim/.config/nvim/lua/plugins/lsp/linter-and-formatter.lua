local M = {}

M.setup_mason = function()
	local mr = require("mason-registry")

	local requirements = {
		"efm",

		-- lua
		"luacheck",
		"stylua",

		-- typescript

		"eslint_d",

		-- golang
		"revive",
		"goimports",

		-- bash
		"shellcheck",
		"shfmt",

		-- -- protobuf
		-- "buf",
		--
		-- -- nix
		-- "statix",
		-- "nixfmt",

		-- sql
		"sqlfluff",

		-- HTML
		"prettier_d",
	}

	for _, item in ipairs(requirements) do
		if not mr.is_installed(item) then
			vim.cmd("MasonInstall " .. item)
		end
	end
end

M.setup_lsp = function(on_attach, capabilities_wrapper)
	local lsp_config = Require("lspconfig")

	lsp_config.efm.setup({
		init_options = {
			documentFormatting = true,
			documentRangeFormatting = true,
		},
		settings = {
			-- rootMarkers = { "package.json" },
			languages = {
				-- lua = {
				-- 	require("efmls-configs.linters.luacheck"),
				-- 	require("efmls-configs.formatters.stylua"),
				-- },
				-- typescript = {
				-- 	require("efmls-configs.linters.eslint_d"),
				-- 	require("efmls-configs.formatters.eslint_d"),
				-- },
				-- javascript = {
				-- 	require("efmls-configs.linters.eslint_d"),
				-- 	require("efmls-configs.formatters.eslint_d"),
				-- },
				-- typescriptreact = {
				-- 	require("efmls-configs.linters.eslint_d"),
				-- 	require("efmls-configs.formatters.eslint_d"),
				-- },
				-- javascriptreact = {
				-- 	require("efmls-configs.linters.eslint_d"),
				-- 	require("efmls-configs.formatters.eslint_d"),
				-- },
				go = {
					{
						lintCommand = "revive -formatter unix",
						lintFormats = { "%.%#:%l:%c: %m" },
						lintSource = "efm/revive",
						lintStdin = true,
						lintIgnoreExitCode = true,
						prefix = "revive",
						rootMarkers = {},
					},
					-- require("efmls-configs.linters.go_revive"),
					require("efmls-configs.formatters.gofumpt"),
				},
				-- bash = {
				-- 	require("efmls-configs.linters.shellcheck"),
				-- 	require("efmls-configs.formatters.shfmt"),
				-- },
				-- sh = {
				-- 	require("efmls-configs.linters.shellcheck"),
				-- 	require("efmls-configs.formatters.shfmt"),
				-- },
				-- html = {
				-- 	require("efmls-configs.formatters.prettier_d"),
				-- },

				-- sql = {
				-- 	Require("efmls-configs.linters.sqlfluff"),
				-- 	Require("efmls-configs.formatters.sqlfluff"),
				-- },
				-- proto = {
				-- 	require("efmls-configs.linters.buf"),
				-- 	require("efmls-configs.formatters.buf"),
				-- },
				-- nix = {
				-- 	require("efmls-configs.linters.statix"),
				-- 	require("efmls-configs.formatters.nixfmt"),
				-- },
			},
		},
	})
end

return M
