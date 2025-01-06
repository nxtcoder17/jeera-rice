local lotusPalette = {
	lotusInk1 = "#545464",
	lotusInk2 = "#43436c",
	lotusGray = "#dcd7ba",
	lotusGray2 = "#716e61",
	lotusGray3 = "#8a8980",
	lotusWhite0 = "#d5cea3",
	lotusWhite1 = "#dcd5ac",
	lotusWhite2 = "#e5ddb0",
	lotusWhite3 = "#f2ecbc",
	lotusWhite4 = "#e7dba0",
	lotusWhite5 = "#e4d794",
	lotusViolet1 = "#a09cac",
	lotusViolet2 = "#766b90",
	lotusViolet3 = "#c9cbd1",
	lotusViolet4 = "#624c83",
	lotusBlue1 = "#c7d7e0",
	lotusBlue2 = "#b5cbd2",
	lotusBlue3 = "#9fb5c9",
	lotusBlue4 = "#4d699b",
	lotusBlue5 = "#5d57a3",
	lotusGreen = "#6f894e",
	lotusGreen2 = "#6e915f",
	lotusGreen3 = "#b7d0ae",
	lotusPink = "#b35b79",
	lotusOrange = "#cc6d00",
	lotusOrange2 = "#e98a00",
	lotusYellow = "#77713f",
	lotusYellow2 = "#836f4a",
	lotusYellow3 = "#de9800",
	lotusYellow4 = "#f9d791",
	lotusRed = "#c84053",
	lotusRed2 = "#d7474b",
	lotusRed3 = "#e82424",
	lotusRed4 = "#d9a594",
	lotusAqua = "#597b75",
	lotusAqua2 = "#5e857a",
	lotusTeal1 = "#4e8ca2",
	lotusTeal2 = "#6693bf",
	lotusTeal3 = "#5a7785",
	lotusCyan = "#d7e3d8",
}

-- [color palette](https://github.com/rebelot/kanagawa.nvim?tab=readme-ov-file#color-palette)
local my_colors = {
	theme = {
		all = {
			ui = {
				bg_gutter = "none",
			},
		},
	},

	palette = {
		-- lotusGray = "#ccdcba",
		lotusWhite0 = "#f4f7ed",
		lotusWhite1 = "#f4f7ed",
		lotusWhite2 = "#f4f7ed",
		-- lotusWhite4 = "#f4f7ed",
		lotusWhite4 = "#d0d9d8",
		-- lotusWhite5 = "#edf7f6",
		lotusWhite5 = "#c9d6d5",

		-- lotusBlue1 = lotusPalette.lotusInk1,
		-- lotusBlue2 = lotusPalette.lotusInk2,
		-- lotusBlue4 = lotusPalette.lotusViolet4,

		lotusYellow = "#6e6c2b",
		lotusGreen = "#4c571f",

		lotusTeal1 = "#407385",
		lotusTeal2 = "#407385",
		lotusTeal3 = "#407385",

		-- lotusOrange = "#a15703",
		lotusOrange = "#9e5721",

		paper_bg = "#f4f7ed",
	},
}

local lib = Require("plugins.colorschemes.kanagawa.lib")

local overrides = function(colors)
	local palette = colors.palette
	local theme = colors.theme
	return {
		-- Identifier = { fg = palette.lotusGreen2 },
		Identifier = { fg = palette.lotusViolet4 },
		-- Identifier = { fg = palette.lotusGreen },
		-- DiagnosticError = { fg = palette.peachRed, bg=palette.winterRed, undercurl = true },
		-- DiagnosticFloatingError = { link = "DiagnosticError" },
		-- DiagnosticUnderlineError = { link = "DiagnosticError" },
		--
		-- PreProc = { fg = palette.sakuraPink },
		--
		Function = { fg = palette.lotusAqua2, bg = "none", bold = true },
		["@function.builtin"] = { link = "Function" },

		["@variable.builtin"] = { fg = palette.lotusOrange },

		-- Type = { fg = lib.darken(palette.lotusTeal3, 40), bold = true, italic = true },
		Type = { fg = lib.darken(palette.lotusViolet4, 20), bold = true, italic = true },
		--
		Special = { fg = palette.lotusViolet4 },
		-- -- Keyword = { fg = palette.springBlue },
		-- ["@keyword.import"] = { fg = palette.autumnYellow, italic = true, },
		-- ["@keyword.return"] = { fg = palette.springBlue, italic = true },
		--
		Pmenu = { fg = palette.lotusGray3, bg = palette.paper_bg }, -- add `blend = vim.o.pumblend` to enable transparency
		DiagnosticUnderlineError = { bg = lib.lighten(palette.lotusRed4, 20), undercurl = true },
		-- PmenuSel = { fg = "NONE", bg = palette.crystalBlue },
		-- PmenuSbar = { bg = theme.ui.bg_m1 },
		-- PmenuThumb = { bg = theme.ui.bg_p2 },

		PreProc = { fg = palette.lotusViolet4, bold = true }, -- add `blend = vim.o.pumblend` to enable transparency
		Structure = { fg = palette.lotusViolet4, italic = true }, -- add `blend = vim.o.pumblend` to enable transparency

		FloatBorder = { bg = "none" },
		--
		-- -- tabby overrides
		TabLineFill = { bg = "none" },
		-- -- Tabline = { fg = palette.sumiInk1, bg = palette.sumiInk2 },
		TabLine = { link = "Comment" },
		TabLineSel = { bg = palette.paper_bg, fg = lib.darken(palette.lotusViolet4, 40) },
		-- TablineSel = { fg = palette.crystalBlue, bg = palette., italic = true },
		--
		-- -- mini hi patterns
		-- MiniHipatternsInfo = { fg = palette.waveBlue1, bg = palette.crystalBlue, bold = true, italic = true},
		WinSeparator = { fg = Require("plugins.colorschemes.kanagawa.lib").lighten(palette.lotusGray, 20) },

		-- for luasnip
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

vim.opt.background = "light"

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
