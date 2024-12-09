local M = {}

M.setup_mason = function()
	local mr = require("mason-registry")

	local requirements = {
		"bash-language-server",
		"shellcheck",
		"shfmt",
	}

	for _, item in ipairs(requirements) do
		if not mr.is_installed(item) then
			vim.cmd("MasonInstall " .. item)
		end
	end
end

M.setup_lsp = function(on_attach, capabilities_wrapper)
	local lsp_config = Require("lspconfig")

	lsp_config.bashls.setup(capabilities_wrapper({
		on_attach = on_attach,
		filetypes = { "sh", "bash" },
	}))
end

return M
