-- -- vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99
vim.o.foldenable = true
vim.o.foldlevelstart = 99
-- vim.opt.foldminlines = 10
-- vim.opt.fillchars = "fold: "
vim.opt.foldnestmax = 4
vim.opt.foldtext = ""

-- TREESITTER based folding
-- [snippet source](https://www.jackfranklin.co.uk/blog/code-folding-in-vim-neovim/)
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt.foldcolumn = "0"
-- vim.opt.foldtext = ""
-- vim.opt.foldlevel = 99
-- vim.opt.foldlevelstart = 1
-- vim.opt.foldnestmax = 4

local ufo = Require("ufo")

ufo.setup({
	provider_selector = function(bufnr, filetype, buftype)
		return { "treesitter" }
	end,
	enable_get_fold_virt_text = true,
	enable_fold_end_virt_text = true,
})

vim.keymap.set("n", "zr", function()
	ufo.openFoldsExceptKinds({ "comment" })
end, { desc = " 󱃄 Open All Folds except comments" })

vim.keymap.set("n", "<C-M-j>", function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("zA", true, false, true), "m", true)
end, { desc = " 󱃄 Open All Folds except comments" })

-- vim.keymap.set("n", "zm", ufo.closeAllFolds, { desc = " 󱃄 Close All Folds" })
vim.keymap.set("n", "zm", function()
	ufo.closeAllFolds()
end, { desc = " 󱃄 Close All Folds" })

vim.keymap.set("n", "<C-M-k>", function()
	vim.cmd("foldc")
end, { desc = " 󱃄 Close All Folds" })

vim.keymap.set("n", "zR", function()
	ufo.openFoldsExceptKinds({ "comment" })
end, { desc = " Open All Folds except comments" })

vim.cmd([[
hi! link UfoFoldedEllipsis @comment
]])
