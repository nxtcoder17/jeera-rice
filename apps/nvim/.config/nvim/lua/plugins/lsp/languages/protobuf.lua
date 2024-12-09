local M = {}

M.setup_mason = function()
	local mr = require("mason-registry")

	local requirements = {
		"buf",
		"buf-language-server",
	}

	for _, item in ipairs(requirements) do
		if not mr.is_installed(item) then
			vim.cmd("MasonInstall " .. item)
		end
	end
end

M.setup_lsp = function(on_attach, capabilities_wrapper)
	local lsp_config = Require("lspconfig")
	lsp_config.buf_ls.setup(capabilities_wrapper({
		on_attach = on_attach,
		root_dir = lsp_config.util.root_pattern("*.proto"),
	}))
end

return M
