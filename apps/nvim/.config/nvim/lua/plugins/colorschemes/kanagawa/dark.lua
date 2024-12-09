local lib = Require("plugins.colorschemes.kanagawa.lib")

vim.o.background = "dark"

-- [color palette](https://github.com/rebelot/kanagawa.nvim?tab=readme-ov-file #color-palette)
local my_colors = {
	theme = {
		all = {
			ui = {
				bg_gutter = "none",
			},
		},
	},

	palette = {
		carpYellow = "#D8B374",
		lightBlue = lib.darken("#6aafeb", 10),
	},
}

local overrides = function(colors)
	local palette = colors.palette
	return {
		Identifier = { fg = palette.lightBlue },
		DiagnosticError = { fg = palette.peachRed, bg = palette.winterRed, undercurl = true },
		DiagnosticFloatingError = { link = "DiagnosticError" },
		DiagnosticUnderlineError = { link = "DiagnosticError" },

		PreProc = { fg = palette.sakuraPink },

		Visual = { bg = lib.darken(palette.winterBlue, 80) },

		Keyword = { fg = palette.springBlue },
		["@keyword.import"] = { fg = palette.autumnYellow, italic = true },
		["@keyword.return"] = { fg = palette.springBlue, italic = true },

		Pmenu = { fg = palette.sumInk4, bg = palette.winterBlue }, -- add `blend = vim.o.pumblend` to enable transparency
		PmenuSel = { fg = "NONE", bg = palette.crystalBlue },
		-- PmenuSbar = { bg = theme.ui.bg_m1 },
		-- PmenuThumb = { bg = theme.ui.bg_p2 },
		FloatBorder = { bg = "none" },

		-- tabby overrides
		TablineFill = { bg = "none" },
		-- Tabline = { fg = palette.sumiInk1, bg = palette.sumiInk2 },
		Tabline = { link = "Comment" },
		TablineSel = { link = "Keyword" },

		-- mini statusline
		MiniStatuslineFilename = { fg = palette.lightBlue, bg = "none", italic = true },
		MiniStatuslineFileinfo = { fg = palette.lightBlue, bg = "none" },

		-- mini hi patterns
		MiniHipatternsInfo = { fg = palette.waveBlue1, bg = palette.crystalBlue, bold = true, italic = true },

		-- luasnip
		LuasnipChoiceNode = { link = "Keyword" },
		LuasnipInsertNode = { link = "PreProc" },
	}
end

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
	compile = true,
	uncercurl = true,
	globalStatus = true,
	transparent = true,
	colors = my_colors,
	overrides = overrides,
	-- keywordStyle = { italic = true },
	-- specialReturn = true, -- special highlight for the return keyword
	-- theme = "lotus",
	background = {
		dark = "wave",
		light = "lotus",
	},
})

vim.cmd("colorscheme kanagawa")
