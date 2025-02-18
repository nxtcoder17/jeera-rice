local system_theme = os.getenv("SYSTEM_THEME")
vim.o.background = system_theme or vim.o.background

if vim.o.background == "light" then
	return Require("plugins.colorschemes.kanagawa.light")
else
	return Require("plugins.colorschemes.kanagawa.dark")
end
