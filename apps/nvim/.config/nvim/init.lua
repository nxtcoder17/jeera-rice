require("globals")
require("disable-builtin-plugins")
require("options")
Require("plugins")
require("folds")
Require("keymaps")
Require("autocmds")
Require("commands")

-- vim.api.nvim_create_autocmd("OptionSet", {
-- 	pattern = "background",
-- 	callback = function()
-- 		vim.cmd("colorscheme base16")
-- 	end,
-- })
