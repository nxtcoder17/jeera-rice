if vim.g.started_by_firenvim then
	pcall(require, "disable-builtins")
	-- pcall(require, "impatient")
	vim.opt.laststatus = 0
	-- vim.cmd [[packadd packer.nvim]]
	require("packer").startup({
		function() 
			use({
				"glacambre/firenvim",
				run = function() vim.fn['firenvim#install'](0) end 
			})
		end
	})
	return 
end

vim.g.root_dir = vim.fn.getcwd()
vim.cmd("set runtimepath+=" .. vim.g.root_dir .. "/.tools")

pcall(require, "disable-builtins")
pcall(require, "impatient")
pcall(require, "init")
pcall(require, "functions")
pcall(require, "plugins")
pcall(require, "keymaps")
-- pcall(require, "plugins_dir")
pcall(require, "autocmds")

local dirExtension = vim.fn.getcwd() .. "/.nxtcoder17.lua"
if vim.fn.filereadable(dirExtension) > 0 then
	vim.cmd("luafile" .. dirExtension)
end
