local M = {}

M.setup_mason = function()
	local mr = require("mason-registry")

	local requirements = {
		"terraform-ls",
		"tflint",
	}

	for _, item in ipairs(requirements) do
		if not mr.is_installed(item) then
			vim.cmd("MasonInstall " .. item)
		end
	end
end

M.setup_lsp = function(on_attach, capabilities_wrapper)
	local lsp_config = Require("lspconfig")

	lsp_config.terraformls.setup(capabilities_wrapper({
		-- cmd = lsp_servers.terraform,
		filetypes = { "terraform", "hcl" },
		on_attach = on_attach,
		root_dir = lsp_config.util.root_pattern(".git", ".terraform", "*.tf", "*.pkr.hcl"),
	}))
end

return M
