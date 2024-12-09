-- vim.o.background = "dark"
-- Require(string.format("plugins.colorschemes.kanagawa.%s", vim.o.background))

local system_theme = os.getenv("SYSTEM_THEME")
if system_theme ~= vim.o.background then
	vim.o.background = system_theme
	-- print("system_theme", system_theme, "vim.o.background", vim.o.background)
	return Require(string.format("plugins.colorschemes.kanagawa.%s", system_theme))
	-- local colors = Require(string.format("plugins.colorschemes.kanagawa.%s", system_theme))
	-- vim.schedule(function()
	-- 	Require("kanagawa").compile()
	-- end)
	-- return colors
end

return Require(string.format("plugins.colorschemes.kanagawa.%s", system_theme))
