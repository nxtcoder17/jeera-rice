local defaultColors = require("kanagawa.colors").setup()
local colors = {
	nxtSelection1 = "#273e5e",
	MiniIndentscopeSymbol = "red",
}

local overrides = {
	Visual = {
		bg = colors.nxtSelection1,
	},
	TSException = {
		fg = defaultColors.oniViolet,
	},
	TSKeywordReturn = {
		fg = defaultColors.lightBlue,
	},
	javascriptTSVariableBuiltin = {
		fg = defaultColors.lightBlue,
	},
	DiagnosticError = {
		bg = defaultColors.winterRed,
		fg = defaultColors.peachRed,
	},
	DiagnosticSignError = {
		bg = vim.NIL,
		fg = defaultColors.peachRed,
	},
}

vim.opt.fillchars:append({
	horiz = "━",
	horizup = "┻",
	horizdown = "┳",
	vert = "┃",
	vertleft = "┨",
	vertright = "┣",
	verthoriz = "╋",
})

require("kanagawa").setup({
	globalStatus = true,
	transparent = false,
	overrides = overrides,
	colors = colors,
	specialReturn = false, -- special highlight for the return keyword
})

vim.cmd("colorscheme kanagawa")
