local util = require("nxtcoder17.theme.util")

local hl, None = util.hl, util.None

local theme = {
	fg = "NvimLightGray2",
	bg = "#F2EEDE",

	-- paper_bg = "#bcbcbc",
	paper_bg = "#D8D5C7",

	-- special = "#315969",
	-- special = "#198c9e",
	special = "NvimDarkCyan",
	special2 = "#30630e",
	-- special3 = "#198c9e",
	-- special3 = "#2e0a57",
	-- special3 = "#6a02e3",
	-- special3 = "#442666",
	special3 = "#502e78",

	error_fg = "#7a1616",
	error_bg = "#fcb1b1",

	transparent = "transparent",
}

hl("Normal", {
	fg = theme.fg,
	bg = theme.transparent,
})

local function editor_groups()
	hl("Normal", {
		fg = theme.fg,
		bg = theme.transparent,
	})
end
--
-- 	hl("Error", {
-- 		fg = theme.error_fg,
-- 		bg = theme.error_bg,
-- 		style = "undercurl",
-- 	})
--
-- 	hl("Special", {
-- 		fg = theme.special,
-- 	})
--
-- 	hl("Type", {
-- 		fg = theme.special,
-- 		bg = None,
-- 		style = "bold",
-- 	})
--
-- 	hl("MatchParen", {
-- 		fg = theme.special,
-- 		bg = theme.paper_bg,
-- 	})
--
-- 	hl("Pmenu", {
-- 		fg = theme.fg,
-- 		bg = theme.bg,
-- 	})
--
-- 	hl("Visual", {
-- 		bg = theme.paper_bg,
-- 	})
--
-- 	hl("Function", {
-- 		fg = theme.special2,
-- 		bg = theme.paper_bg,
--
-- 		style = "bold",
-- 	})
--
-- 	hl("@function.call", {
-- 		fg = theme.special3,
-- 		-- fg = theme.fg,
-- 		bg = None,
-- 		style = None,
-- 	})
--
-- 	hl("@function.builtin", { link = "@function.call" })
-- 	hl("@function.method.call", { link = "@function.call" })
-- end
--
-- local function diagnostics()
-- 	hl("DiagnosticUnderlineWarn", {
-- 		style = "undercurl",
-- 	})
--
-- 	hl("DiagnosticUnderlineError", {
-- 		link = "Error",
-- 	})
-- end
--
-- editor_groups()
--
-- diagnostics()
