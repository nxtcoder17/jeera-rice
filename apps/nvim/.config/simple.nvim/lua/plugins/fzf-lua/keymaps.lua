package.path = package.path .. ";" .. debug.getinfo(1, "S").source:match("@?(.*/)") .. "?.lua"

-- file picker
vim.keymap.set("n", "sf", Require("pickers.find-files"))

-- tab dir picker
vim.cmd([[ cnoreabbrev cd lua require('pickers.choose-tab-dir')()<CR>]])

-- tab picker
vim.keymap.set("n", "tl", Require("pickers.find-tabs"))

-- grep picker
vim.keymap.set({ "n", "v" }, "ff", Require("pickers.grep"))

vim.keymap.set({ "n" }, "FF", function()
  Require("pickers.grep")(vim.fn.getcwd(), vim.fn.expand("<cword>"))
end)

-- quicklist picker
vim.keymap.set({ "n", "v", "x" }, "f;", Require("pickers.quicklist"))

-- buffer grep picker
vim.keymap.set("n", "s/", "<cmd>FzfLua grep_curbuf multiprocess=false<CR>")

-- buffer picker
vim.keymap.set("n", "sb", "<Cmd>FzfLua buffers<CR>")
