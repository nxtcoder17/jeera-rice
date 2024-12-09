local M = {}

M.setup_mason = function()
	local mr = require("mason-registry")

	local requirements = {
		"deno",
	}

	for _, item in ipairs(requirements) do
		if not mr.is_installed(item) then
			vim.cmd("MasonInstall " .. item)
		end
	end
end

M.setup_lsp = function(on_attach, capabilities_wrapper)
	local lsp_config = Require("lspconfig")

	lsp_config.denols.setup(capabilities_wrapper({
		root_dir = lsp_config.util.root_pattern("deno.lock"),
		on_attach = on_attach,
	}))
end

return M
