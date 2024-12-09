local utils = require("plugins.colorschemes.zenbones.util")
local lush = require("lush")

local hl, colors, None = utils.hl, utils.colors, utils.None

local hsl = lush.hsl

local function editor_groups()
	hl("Normal", {
		fg = hsl(colors.gel_pen_variants["pale-blue"]).lighten(10),
		bg = None,
	})

	hl("LineNr", {
		bg = None,
		fg = lush.hsl(colors.gel_pen_variants["black"]).lighten(30),
	})

	-- hl("Delimeter", {
	-- 	bg = None,
	-- 	fg = lush.hsl(colors.gel_pen_variants["black"]).lighten(50),
	-- })

	hl("PmenuSel", {
		-- fg = colors.palette["blue-chill"]["600"],
		fg = hsl(colors.gel_pen_variants["pale-blue"]),
		-- bg = colors.palette["blue-chill"]["50"],
		bg = hsl(colors.gel_pen_variants["pale-blue"]).darken(60),
	})

	hl("TablineSel", {
		-- fg = colors.palette["blue-chill"]["600"],
		fg = hsl(colors.gel_pen_variants["pale-blue"]),
		-- bg = colors.palette["blue-chill"]["50"],
		bg = hsl(colors.gel_pen_variants["pale-blue"]).darken(60),
	})

	hl("Pmenu", {
		fg = hsl(colors.gel_pen_variants["pale-blue"]),
		bg = hsl(colors.gel_pen_variants["pale-blue"]).darken(90),
	})

	hl("PmenuSbar", {
		fg = hsl(colors.gel_pen_variants["pale-blue"]),
		bg = hsl(colors.gel_pen_variants["pale-blue"]).darken(90),
	})

	hl("PmenuThumb", {
		fg = hsl(colors.gel_pen_variants["pale-blue"]),
		bg = hsl(colors.gel_pen_variants["pale-blue"]).darken(90),
	})

	hl("FloatBorder", {
		fg = hsl(colors.gel_pen_variants["pale-blue"]),
		-- bg = hsl(colors.gel_pen_variants["pale-blue"]).darken(90),
		bg = None,
	})

	hl("MatchParen", {
		fg = colors.palette["smalt-blue"]["300"],
		bg = colors.palette["smalt-blue"]["800"],
	})

	hl("CursorLine", {
		fg = lush.hsl(colors.gel_pen_variants["blue-black"]).lighten(50),
		bg = lush.hsl(colors.gel_pen_variants["blue-black"]).darken(10),
	})
	--
	-- hl("@punctuation.delimiter", { style = "bold", fg = colors.gel_pen_variants["blue-black"] })
	-- hl("@punctuation.bracket", { style = "bold", fg = colors.gel_pen_variants["blue-black"] })
	--
	-- hl("Type", { fg = lush.hsl(colors.gel_pen_variants["pale-blue"]).darken(10) })

	hl("Error", { bg = lush.hsl(colors.gel_pen_variants["red-orange"]).darken(80), style = "undercurl" })
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
		style = None,
		-- bg = hsl(colors.palette["bermuda-gray"]["50"]),
	})

	hl("@function.method.call", { link = "@function.call" })
end

local function diagnostics()
	hl("WarningMsg", {
		fg = None,
		bg = None,
		sp = hsl(colors.gel_pen_variants["yellow"]),
		style = "bold,undercurl",
	})

	-- hl("DiagnosticUnderlineWarning", { link = "WarningMsg" })
	-- hl(
	-- 	"DiagnosticUnderlineError",
	-- 	{ bg = colors.palette["mandy"]["100"], fg = colors.palette["mandy"]["700"], style = "bold,undercurl" }
	-- )
	--
	-- hl("DiagnosticError", { link = "DiagnosticUnderlineError" })
	-- hl("DiagnosticFloatingError", { link = "DiagnosticUnderlineError" })
end

-- local theme = {
-- 	["foreground"] = "#c5c8c6",
-- 	["background"] = "#1d1f21",
-- 	["selection"] = "#373b41",
-- 	["line"] = "#282a2e",
-- 	["comment"] = "#969896",
-- 	["red"] = "#cc6666",
-- 	["orange"] = "#de935f",
-- 	["yellow"] = "#f0c674",
-- 	["green"] = "#b5bd68",
-- 	["aqua"] = "#8abeb7",
-- 	["blue"] = "#81a2be",
-- 	["purple"] = "#b294bb",
-- 	["window"] = "#4d5057",
-- }

local function syntax_groups()
	hl("Statement", {
		fg = hsl(colors.gel_pen_variants["blue-black"]).lighten(50),
	})

	hl("Constant", {
		fg = hsl(colors.gel_pen_variants["blue-black"]).lighten(50),
	})

	hl("@string", {
		fg = hsl(colors.gel_pen_variants["black"]).lighten(60),
	})

	hl("Identifier", {
		fg = hsl(colors.gel_pen_variants["blue-black"]).lighten(60),
		style = None,
	})
end

vim.g.kanagawabones = {
	solid_line_nr = true,
	solid_float_border = true,
	darken_comments = 45,
	lightness = "bright",
	darkness = "warm",
	transparent_background = true,
	italic_comments = true,
}

vim.cmd("colorscheme kanagawabones")

-- syntax_groups()

-- editor_groups()
-- treesitter_groups_common()
-- treesitter_groups()
-- diagnostics()
