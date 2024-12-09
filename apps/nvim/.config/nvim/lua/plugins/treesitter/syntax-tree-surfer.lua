local sts = Require("syntax-tree-surfer")

local fn = Require("functions")

local opts = { noremap = true, silent = true }

local statement_like_nodes = {
	"import_declaration",
	"type_declaration",
	"function_declration",
	"method_declaration",
	"const_declaration",

	"if_statement",
	"else_statement",
	"return_statement",
	"for_statement",
	"switch_statement",

	-- jsx
	"jsx_element",
}

vim.keymap.set("n", "<C-j>", function() -- jump to all that you specify
	sts.filtered_jump(statement_like_nodes, true)
	vim.cmd("normal zz")
end, fn.join_tables(opts, { desc = "jumping to next statement like nodes" }))

vim.keymap.set("n", "<C-k>", function() -- jump to all that you specify
	sts.filtered_jump(statement_like_nodes, false)
	vim.cmd("normal zz")
end, fn.join_tables(opts, { desc = "jumping to previous statement like nodes" }))

local function_like_nodes = {
	-- golang
	"import_declaration",
	"type_declaration",
	"function_declaration",
	"method_declaration",
	"const_declaration",

	-- lua
	"function_definition",
}

vim.keymap.set("n", "<C-S-j>", function()
	sts.filtered_jump(function_like_nodes, true)
	vim.cmd("normal zz")
end, fn.join_tables(opts, { desc = "jumping to next function like nodes" }))

vim.keymap.set("n", "<C-S-k>", function()
	sts.filtered_jump(function_like_nodes, false)
	vim.cmd("normal zz")
end, fn.join_tables(opts, { desc = "jumping to previous function like nodes" }))
