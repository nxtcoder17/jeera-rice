-- vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
-- vim.o.foldenable = true
-- vim.opt.foldminlines = 10
-- vim.opt.fillchars = "fold: "

local ufo = require("ufo")

ufo.setup({
	provider_selector = function(_, ft, _)
		-- INFO some filetypes only allow indent, some only LSP, some only
		-- treesitter. However, ufo only accepts two kinds as priority,
		-- therefore making this function necessary :/
		local lspWithOutFolding = { "markdown", "bash", "sh", "bash", "zsh", "css", "html", "python" }
		if vim.tbl_contains(lspWithOutFolding, ft) then
			return { "treesitter", "indent" }
		end
		return { "lsp", "indent" }
	end,
	-- open opening the buffer, close these fold kinds
	-- use `:UfoInspect` to get available fold kinds from the LSP
	close_fold_kinds = { "imports" },
	open_fold_hl_timeout = 500,
	-- fold_virt_text_handler = foldTextFormatter,
})

vim.keymap.set("n", "zr", function()
	ufo.openFoldsExceptKinds({ "comment" })
end, { desc = " 󱃄 Open All Folds except comments" })

vim.keymap.set("n", "<C-M-j>", function()
	-- ufo.openFoldsExceptKinds({ "comment" })
	-- ufo.openFoldsExceptKinds({ "comment" })
	-- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('ifoo<cr>',true,false,true),'m',true)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("zA", true, false, true), "m", true)
end, { desc = " 󱃄 Open All Folds except comments" })

vim.keymap.set("n", "zm", ufo.closeAllFolds, { desc = " 󱃄 Close All Folds" })
vim.keymap.set("n", "<C-M-k>", function()
  vim.cmd("foldc")
end, { desc = " 󱃄 Close All Folds" })

-- vim.keymap.set("n", "zR", require("ufo").openAllFolds)
-- vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
