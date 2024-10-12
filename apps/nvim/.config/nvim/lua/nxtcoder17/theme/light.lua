local colors = require("nxtcoder17.colors")
local color_utils = require("nxtcoder17.colors.utils")

local hl_groups = {}

--- @class HLGroupParams
--- @field fg string|nil The foreground color of the highlight group. (Optional)
--- @field bg string|nil The background color of the highlight group. (Optional)
--- @field style string|nil The text style of the highlight group. (Optional). See |:help attr-list| for more information.
--- @field sp string|nil The special color for the highlight group. (Optional)
--- @field link string|nil The name of another highlight group to link to. (Optional) See |:help highlight-links| for more information.

--- Adds a highlight group with the specified parameters.
--- @param group string The name of the highlight group.
--- @param params HLGroupParams A table containing the highlight parameters. The table may have the following keys:
-- Example:
-- hl("MyHighlightGroup", { fg = "#ff0000", bg = "#000000", style = "bold" })
local function hl(group, params)
	hl_groups[group] = params
end

local function vim_native_groups()
	hl("MatchParen", {
		fg = colors.palette["smalt-blue"]["800"],
		bg = colors.palette["smalt-blue"]["200"],
	})

	hl("Normal", {
		fg = colors.gel_pen_variants["blue-black"],
		-- bg = colors.palette["star-dust"]["50"],
		-- bg = colors.palette["star-dust"]["50"],
		bg = "NONE",
	})

	hl("Visual", {
		bg = colors.palette["star-dust"]["200"],
	})

	hl("Folded", {
		bg = colors.palette["purple-heart"]["100"],
	})

	hl("PmenuSel", {
		fg = colors.palette["blue-chill"]["600"],
		bg = colors.palette["blue-chill"]["50"],
	})

	hl("Pmenu", { fg = colors.palette["blue-chill"]["600"], bg = "NONE" })

	hl("CursorLine", { bg = "#a8cfe3" })

	hl("LineNr", { fg = "#4d616b" })

	hl("Comment", { fg = colors.palette["bright-gray"]["400"], style = "italic" })
end

local function treesitter_groups()
	-- variables
	hl("@variable", { fg = colors.palette["bermuda-gray"]["700"] })

	hl("Identifier", { link = "@variable" })

	hl("@variable.parameter", { fg = colors.palette["blue-chill"]["500"], style = "italic" })

	hl("@variable.member", { link = "@property" })

	-- properties
	hl("@property", {
		fg = colors.palette["picton-blue"]["800"],
		bg = "",
	})

	hl("@attribute", { link = "@property" })

	-- namespaces and modules

	hl("@module", {
		fg = colors.palette["purple-heart"]["700"],
		bg = colors.palette["purple-heart"]["50"],
		style = "italic",
	})

	-- types
	hl("@type", {
		fg = colors.palette["kidnapper"]["500"],
		bg = colors.palette["kidnapper"]["50"],
		style = "bold",
	})

	hl("@type.builtin", {
		fg = colors.palette["black"]["400"],
		bg = colors.palette["mantis"]["50"],
	})

	-- functions
	hl("@function.method", {
		fg = colors.palette["blue-chill"]["500"],
		style = "bold",
	})

	hl("@function", { fg = colors.palette["blue-chill"]["500"], style = "bold" })

	hl("@function.builtin", {
		fg = colors.palette["blue-chill"]["500"],
		style = "bold",
		sp = colors.palette["blue-chill"]["50"],
	})

	hl("@function.call", {
		fg = colors.palette["curious-blue"]["700"],
		bg = "",
	})

	hl("@function.method.call", { link = "@function.call" })

	-- diagnostics
	hl(
		"DiagnosticUnderlineError",
		{ bg = colors.palette["mandy"]["100"], fg = colors.palette["mandy"]["700"], style = "bold,undercurl" }
	)
end

vim_native_groups()
treesitter_groups()

local function plugin_dap_highlights()
	hl("DapStoppedLinehl", { bg = colors.palette["rose-of-sharon"]["200"] })
end

plugin_dap_highlights()

require("nightfox").setup({
	options = {
		transparent = true,
		terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) use in `:terminal`

		styles = { -- Style to be applied to different syntax groups
			comments = "italic", -- Value is any valid attr-list value `:help attr-list`
			conditionals = "italic",
			constants = "italic",
			functions = "NONE",
			keywords = "italic",
			numbers = "NONE",
			operators = "NONE",
			strings = "NONE",
			types = "NONE",
			variables = "NONE",
		},
		inverse = { -- Inverse highlight for different types
			match_paren = false,
			visual = false,
			search = false,
		},
	},
	groups = {
		["dayfox"] = hl_groups,
	},
})

vim.cmd("colorscheme dayfox")
