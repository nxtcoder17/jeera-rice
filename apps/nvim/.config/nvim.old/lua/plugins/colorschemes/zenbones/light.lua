local utils = require("plugins.colorschemes.zenbones.util")
local lush = require("lush")

local hl, colors, None = utils.hl, utils.colors, utils.None
local hsl = lush.hsl

local function editor_groups()
	hl("Normal", {
		fg = colors.gel_pen_variants["blue-black"],
		-- fg = colors.gel_pen_variants["cobalt-blue"],
		-- bg = colors.palette["star-dust"]["50"],
		-- bg = colors.palette["star-dust"]["50"],
		bg = None,
	})

	hl("LineNr", {
		bg = None,
		fg = lush.hsl(colors.gel_pen_variants["black"]).lighten(50),
	})

	-- hl("Delimeter", {
	-- 	bg = None,
	-- 	fg = lush.hsl(colors.gel_pen_variants["black"]).lighten(50),
	-- })

	hl("PmenuSel", {
		fg = colors.palette["blue-chill"]["600"],
		bg = colors.palette["blue-chill"]["50"],
	})

	hl("Pmenu", {
		fg = colors.palette["blue-chill"]["600"],
		bg = None,
	})

	hl("MatchParen", {
		fg = colors.palette["smalt-blue"]["800"],
		bg = colors.palette["smalt-blue"]["200"],
	})

	hl("CursorLine", { bg = lush.hsl(colors.gel_pen_variants["pale-blue"]).lighten(75) })

	hl("@punctuation.delimiter", { style = "bold", fg = colors.gel_pen_variants["blue-black"] })
	hl("@punctuation.bracket", { style = "bold", fg = colors.gel_pen_variants["blue-black"] })

	hl("Type", { fg = lush.hsl(colors.gel_pen_variants["pale-blue"]).darken(10) })

	hl("Error", { bg = lush.hsl(colors.gel_pen_variants["red-orange"]).darken(10) })
end

local function treesitter_groups_common()
	hl("@string", { fg = hsl(colors.gel_pen_variants["blue-black"]).lighten(10) })

	-- variables
	hl("@variable", { fg = colors.palette["bermuda-gray"]["700"] })

	hl("@variable.parameter", { fg = hsl(colors.palette["blue-chill"]["500"]).darken(20), style = "italic" })

	hl("@variable.member", { link = "@property" })

	-- types
	hl("@type", {
		fg = hsl(colors.gel_pen_variants["pale-blue"]).darken(50),
		bg = None,
		style = "bold",
	})

	hl("@type.builtin", {
		link = "@type",
		-- fg = hsl(colors.gel_pen_variants["vividian-green"]).darken(30),
	})

	hl("@type.definition", { link = "@type" })
end

local function treesitter_groups()
	-- variables
	-- hl("@variable", { fg = colors.palette["bermuda-gray"]["700"] })

	hl("Identifier", { link = "@variable" })

	-- properties
	hl("@property", {
		-- fg = colors.palette["picton-blue"]["800"],
		fg = hsl(colors.chocolate).darken(80),
		bg = None,
	})

	hl("@attribute", { link = "@property" })

	-- namespaces and modules

	hl("@module", {
		-- fg = hsl(colors.gel_pen_variants["cobalt-blue"]).darken(30),
		fg = hsl(colors.chocolate),
		-- bg = hsl(colors.chocolate).lighten(90),
		bg = None,
		style = "bold",
	})

	-- functions
	hl("@function.method", {
		-- fg = colors.palette["blue-chill"]["500"],
		fg = hsl(colors.palette["bermuda-gray"]["600"]),
		bg = hsl(colors.palette["bermuda-gray"]["50"]),
		style = "bold",
	})

	hl("@function", {
		-- fg = colors.palette["blue-chill"]["500"],
		-- fg = hsl(colors.gel_pen_variants["vividian-green"]).darken(60),
		-- bg = hsl(colors.gel_pen_variants["vividian-green"]).lighten(99),
		fg = hsl(colors.palette["bright-gray"]["600"]),
		bg = None,
		style = None,
	})

	hl("@function.builtin", {
		fg = colors.palette["blue-chill"]["500"],
		style = "bold",
		sp = colors.palette["blue-chill"]["50"],
	})

	hl("@function.call", {
		-- fg = hsl(colors.palette["bermuda-gray"]["700"]).darken(50),
		fg = hsl(colors.chocolate).darken(20),
		-- bg = hsl(colors.palette["bermuda-gray"]["50"]),
		bg = None,
		style = None,
		-- bg = hsl(colors.palette["bermuda-gray"]["50"]),
	})

	hl("@function.method.call", { link = "@function.call" })
end

local function diagnostics()
	hl("WarningMsg", {
		bg = hsl(colors.gel_pen_variants["yellow"]).lighten(70),
	})

	hl("DiagnosticUnderlineWarning", { link = "WarningMsg" })
	hl(
		"DiagnosticUnderlineError",
		{ bg = colors.palette["mandy"]["100"], fg = colors.palette["mandy"]["700"], style = "bold,undercurl" }
	)

	hl("DiagnosticError", { link = "DiagnosticUnderlineError" })
	hl("DiagnosticFloatingError", { link = "DiagnosticUnderlineError" })
end

vim.g.zenbones = {
	solid_line_nr = true,
	solid_float_border = true,
	darken_comments = 45,
	lightness = "bright",
	darkness = "warm",
	transparent_background = true,
	italic_comments = true,
}

vim.cmd("colorscheme zenbones")

editor_groups()
treesitter_groups_common()
treesitter_groups()
diagnostics()
