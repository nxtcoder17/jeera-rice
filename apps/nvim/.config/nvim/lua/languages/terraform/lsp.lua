vim.lsp.config("terraformls", {
	filetypes = { "terraform", "hcl" },
	on_attach = Require("lsp.on_attach"),
	root_markers = { ".terraform" },
})

vim.lsp.enable("terraformls")
