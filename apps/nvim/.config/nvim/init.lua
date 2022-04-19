vim.g.root_dir = vim.fn.getcwd()
vim.cmd("set runtimepath+=" .. vim.g.root_dir .. "/.tools")

pcall(require, "disable-builtins")
pcall(require, "impatient")
require("options")
require("functions")
require("plugins")
require("keymaps")
require("plugins_dir")
require("autocmds")
require("functions")

local dirExtension = vim.fn.getcwd() .. "/.nxtcoder17.lua"
if vim.fn.filereadable(dirExtension) > 0 then
	vim.cmd("luafile" .. dirExtension)
end
