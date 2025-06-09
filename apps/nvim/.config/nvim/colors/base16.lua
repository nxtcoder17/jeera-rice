-- base16 theme

-- Reset highlighting.
-- vim.cmd.highlight("clear")
-- if vim.fn.exists("syntax_on") then
-- 	vim.cmd.syntax("reset")
-- end

vim.o.termguicolors = true
vim.g.colors_name = "base16"

local palette = {
	-- default palette, if base16 is not overriden at home
	-- base16 tomorrow night
	base00 = "#1d1f21",
	base01 = "#282a2e",
	base02 = "#373b41",
	base03 = "#969896",
	base04 = "#b4b7b4",
	base05 = "#c5c8c6",
	base06 = "#e0e0e0",
	base07 = "#ffffff",
	base08 = "#cc6666",
	base09 = "#de935f",
	base0A = "#f0c674",
	base0B = "#b5bd68",
	base0C = "#8abeb7",
	base0D = "#81a2be",
	base0E = "#b294bb",
	base0F = "#a3685a",
}

local lib = require("lib_color")

-- local base16_path = os.getenv("HOME") .. "/.base16/nvim-base16.lua"
local base16_path = os.getenv("HOME") .. "/.base16.d/nvim/base16.lua"
if vim.uv.fs_stat(base16_path) then
	palette = dofile(base16_path)
end

palette.base_warn = "#f0c674"
palette.base_error = "#a3685a"

local theme = lib.Theme(palette):set_hl_groups(function(p)
	-- local comment_fg = lib.darken(p.base03, 60)
	local comment_fg = p.base02
	lib.hl("Comment", { fg = comment_fg })
	-- util.hl("Normal", { bg = string.format("%s%s", p.base00, "00") })

	local nontext_fg = lib.lighten(comment_fg, 40)

	-- neovim native highlight groups
	lib.hl("Normal", { bg = "None" })
	lib.hl("NormalNC", { bg = "None" })
	lib.hl("Identifier", { fg = p.base0C })
	lib.hl("Variable", { fg = p.base05 })
	lib.hl("@variable", { link = "Variable" })
	lib.hl("Keyword", { fg = p.base08 })
	lib.hl("Structure", { fg = lib.darken(p.base09, 20) })
	lib.hl("String", { fg = lib.darken(p.base0B, 20) })

	lib.hl("Whitespace", { link = "Comment" })
	lib.hl("Delimiter", { fg = p.base0E })

	lib.hl("LineNr", { link = "Comment" })

	lib.hl("SignColumn", { bg = "None" })

	lib.hl("Visual", { bg = p.base00 })

	-- INFO: nontext and whitespace are for listchars highlighting
	lib.hl("NonText", { fg = nontext_fg })
	lib.hl("Whitespace", { fg = nontext_fg })

	lib.hl("MatchParen", { bg = lib.lighten(p.base02, 40), fg = p.base02 })

	lib.hl("FloatBorder", { link = "Comment" })

	lib.hl("Pmenu", { fg = p.base0D, bg = "None" })
	lib.hl("PmenuExtra", { bg = "None" })
	lib.hl("PmenuSel", { fg = p.base0C })

	lib.hl("CmpItemMenu", { link = "Pmenu" })

	lib.hl("WinSeparator", { bg = "None" })

	-- lib.hl("DiagnosticError", { bg = lib.darken(p.base_error, 80), fg = lib.lighten(p.base_error, 30) })
	lib.hl("DiagnosticError", { bg = p.base08, fg = lib.lighten(p.base08, 30) })
	-- lib.hl("DiagnosticSignError", { link = "DiagnosticError" })
	-- lib.hl("DiagnosticFloatingError", { link = "DiagnosticError" })
	lib.hl("DiagnosticUnnecessary", { fg = p.base03, style = "undercurl", sp = p.base_error })

	lib.hl("Underlined", { style = "undercurl" })

	lib.hl("DiagnosticUnderlineWarn", { sp = palette.base_warn, style = "undercurl" })
	lib.hl("DiagnosticUnderlineError", { sp = palette.base_error, style = "undercurl" })
	lib.hl("DiagnosticUnderlineHint", { style = "undercurl" })
	lib.hl("DiagnosticUnderlineInfo", { style = "undercurl" })
	lib.hl("DiagnosticUnderlineOk", { link = "DiagnosticUnderlineInfo" })

	lib.hl("Visual", { bg = lib.darken(p.base00, 30) })
	lib.hl("SpecialChar", { fg = p.base0E })

	lib.hl("StatusLine", { bg = "None", fg = "None" })
	lib.hl("StatusLineNC", { bg = "None", fg = "None" })

	-- lib.hl("MiniStatuslineDevinfo", { bg = p.base01 })
	-- lib.hl("MiniStatuslineDevinfo", { bg = p.base01 })
	lib.hl("MiniStatuslineDevinfo", { bg = nontext_fg, fg = lib.darken(nontext_fg, 80) })
	-- lib.hl("MiniStatuslineFileinfo", { bg = p.base01 })
	lib.hl("MiniStatuslineFilename", { bg = nontext_fg, fg = lib.darken(nontext_fg, 80) })
	lib.hl("MiniStatuslineModeNormal", { bg = p.base03 })
end)

Require("mini.base16").setup({
	-- Table with names from `base00` to `base0F` and values being strings of
	-- HEX colors with format "#RRGGBB". NOTE: this should be explicitly
	-- supplied in `setup()`.
	-- palette = palette_bright_daylight,
	palette = theme,

	-- Whether to support cterm colors. Can be boolean, `nil` (same as
	-- `false`), or table with cterm colors. See `setup()` documentation for
	-- more information.
	use_cterm = nil,

	-- Plugin integrations. Use `default = false` to disable all integrations.
	plugins = { default = true },
})

-- this should perform theme specific highlight overrides
theme:use_hl_groups()
