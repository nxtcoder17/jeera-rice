if vim.o.background == "light" then
	-- return require("plugins.colorschemes.nxtcoder17.light")
	return require("nxtcoder17.theme.light")
end
return require("plugins.colorschemes.nxtcoder17.dark")
