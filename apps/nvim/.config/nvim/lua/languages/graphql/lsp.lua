vim.lsp.config("graphql", {
	on_attach = Require("lsp.on_attach"),
	root_markers = { "gqlgen.yml", "graphql.config.*" },
})

vim.lsp.enable("graphql")
