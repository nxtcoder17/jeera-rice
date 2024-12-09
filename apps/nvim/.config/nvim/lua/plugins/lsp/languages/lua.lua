local M = {}

M.setup_mason = function()
	local mr = require("mason-registry")

	local requirements = {
		"lua-language-server",
		"stylua",
	}

	for _, item in ipairs(requirements) do
		if not mr.is_installed(item) then
			vim.cmd("MasonInstall " .. item)
		end
	end
end

M.setup_lsp = function(on_attach, capabilities_wrapper)
	local lsp_config = Require("lspconfig")

	local runtime_path = vim.split(package.path, ";")
	table.insert(runtime_path, "lua/?.lua")
	table.insert(runtime_path, "lua/?/init.lua")

	lsp_config.lua_ls.setup(capabilities_wrapper({
		-- cmd = lsp_servers.lua,
		on_attach = function(client)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false

			on_attach(client)
		end,
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
						-- vim.env.VIMRUNTIME,
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
end

M.setup_linter = function()
	return {
		"luacheck",
	}
end
M.setup_formatter = function()
	return {
		"",
	}
end

return M
