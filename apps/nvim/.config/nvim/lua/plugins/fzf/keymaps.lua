vim.keymap.set("n", "sf", Require("plugins.fzf.my-actions.find-files"))

-- vim.cmd(
-- [[ cnoreabbrev cd lua require('fuzzy-actions.choose-tab-dir')()<CR>\|lua vim.api.nvim_feedkeys("x", "n", true)<CR> ]]
-- )

-- vim.keymap.set("c", "cd", require("fuzzy-actions.choose-tab-dir"))
vim.keymap.set("n", "tl", Require("plugins.fzf.my-actions.find-tabs"))
vim.keymap.set("n", "ff", Require("plugins.fzf.my-actions.grep"))
vim.keymap.set({ "n", "v", "x" }, "f;", Require("plugins.fzf.my-actions.quicklist"))
vim.keymap.set("n", "s/", "<cmd>FzfLua grep_curbuf multiprocess=false<CR>")
vim.keymap.set("n", "sb", "<Cmd>FzfLua buffers<CR>")
