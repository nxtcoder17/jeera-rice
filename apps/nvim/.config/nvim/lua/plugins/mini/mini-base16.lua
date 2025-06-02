local themes = R("plugins.colorschemes.base16")

local system_theme = os.getenv("SYSTEM_THEME")
vim.o.background = system_theme or vim.o.background

local theme = (function()
	if vim.o.background == "light" then
		return themes.light.catpuccin_latte
		-- return themes.light.grayscale
	end
	return themes.dark.tomorrow_night
	-- return themes.dark.black_metal_gorgoroth
end)()

Require("mini.base16").setup({
	-- Table with names from `base00` to `base0F` and values being strings of
	-- HEX colors with format "#RRGGBB". NOTE: this should be explicitly
	-- supplied in `setup()`.
	-- palette = palette_bright_daylight,
	palette = theme.palette,

	-- Whether to support cterm colors. Can be boolean, `nil` (same as
	-- `false`), or table with cterm colors. See `setup()` documentation for
	-- more information.
	use_cterm = nil,

	-- Plugin integrations. Use `default = false` to disable all integrations.
	plugins = { default = true },
})

-- this should perform theme specific highlight overrides
theme:use_hl_groups()
