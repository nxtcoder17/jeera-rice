-- vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldenable = true
vim.o.foldlevelstart = 99
-- vim.opt.foldminlines = 10
-- vim.opt.fillchars = "fold: "

local ufo = require("ufo")

require("ufo").setup({
  provider_selector = function(bufnr, filetype, buftype)
    -- return ""
    return { "treesitter" }
  end,
  enable_get_fold_virt_text = true,
})

vim.keymap.set("n", "zr", function()
  ufo.openFoldsExceptKinds({ "comment" })
end, { desc = " 󱃄 Open All Folds except comments" })

vim.keymap.set("n", "<C-M-j>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("zA", true, false, true), "m", true)
end, { desc = " 󱃄 Open All Folds except comments" })

vim.keymap.set("n", "zm", ufo.closeAllFolds, { desc = " 󱃄 Close All Folds" })
vim.keymap.set("n", "<C-M-k>", function()
  vim.cmd("foldc")
end, { desc = " 󱃄 Close All Folds" })

vim.keymap.set("n", "zR", function()
  ufo.openFoldsExceptKinds({ "comment" })
end, { desc = " Open All Folds except comments" })

vim.cmd([[
hi! link UfoFoldedEllipsis @comment
]])
