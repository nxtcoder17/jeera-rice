local function Theme(colors)
	local theme = colors

	function theme:modify(fn)
		if fn ~= nil then
			fn(self)
		end

		return self
	end

	function theme:set_hl_groups(fn)
		self.theme_hl_groups_fn = fn
		return self
	end

	function theme:use_hl_groups()
		self.theme_hl_groups_fn(self)
	end

	-- function theme:palette()
	-- 	return theme
	-- end

	return setmetatable(theme, {
		__index = function(self, key)
			if key == "palette" then
				return self
			end
		end,
	})
end

local lib = Require("plugins.colorschemes.lib")

local M = {}

local light = {}
local dark = {}

-- INFO: [base16 theme gallery](https://tinted-theming.github.io/tinted-gallery/)

light.catpuccin_latte = Theme({
	-- name: "Catppuccin Latte"
	-- author: "https://github.com/catppuccin/catppuccin"
	-- variant: "light"
	base00 = "#eff1f5", -- base
	base01 = "#e6e9ef", -- mantle
	base02 = "#ccd0da", -- surface0
	base03 = "#bcc0cc", -- surface1
	base04 = "#acb0be", -- surface2
	base05 = "#4c4f69", -- text
	base06 = "#dc8a78", -- rosewater
	base07 = "#7287fd", -- lavender
	base08 = "#d20f39", -- red
	base09 = "#fe640b", -- peach
	base0A = "#df8e1d", -- yellow
	base0B = "#40a02b", -- green
	base0C = "#179299", -- teal
	base0D = "#1e66f5", -- blue
	base0E = "#8839ef", -- mauve
	base0F = "#dd7878", -- flamingo
}):modify(function(p)
	p.base08 = "#027fa6"
	p.base0B = lib.darken(p.base0B, 40)
	-- p.base0A = "#51bda7"
	-- p.base0A = "#c97a0a"
	p.base0A = "#a86608"
	p.base09 = "#bd4b09"
end):set_hl_groups(function(p)
	-- for normal text on active windows
	lib.hl("Normal", { bg = "None" })

	-- for normal text on inactive windows
	lib.hl("NormalNC", { bg = "None" })

	lib.hl("LineNr", { bg = "None" })
	-- gutter space on the left of line numbers
	lib.hl("SignColumn", { bg = "None" })

	lib.hl("Comment", { fg = p.base04 })
	lib.hl("@comment", { link = "Comment" })

	-- border for floating windows
	lib.hl("FloatBorder", { bg = "None" })

	-- autocompletion menu
	lib.hl("Pmenu", { bg = "None" })
	lib.hl("PmenuThumb", { bg = p.base00 })

	-- cmp specifics
	lib.hl("CmpItemMenu", { link = "Pmenu" })
	lib.hl("CmpItemKind", { link = "Pmenu" })
	lib.hl("CmpItemMenu", { link = "Pmenu" })

	lib.hl("WinSeparator", { bg = "None" })

	lib.hl("MiniStatuslineFilename", { fg = p.base0D, bg = "None" })
	lib.hl("MiniStatuslineDevinfo", { fg = p.base0E, bg = "None" })
end)

light.grayscale = Theme({
	base00 = "#eff1f5", -- base (lightest gray)
	base01 = "#e6e9ef", -- mantle (very light gray)
	base02 = "#ccd0da", -- surface0 (light gray)
	base03 = "#bcc0cc", -- surface1 (soft gray)
	base04 = "#acb0be", -- surface2 (neutral gray)
	base05 = "#4c4f69", -- text (dark gray)
	base06 = "#60636e", -- rosewater (subtle highlight gray)
	base07 = "#5c5f6e", -- lavender (slightly darker highlight)
	base08 = "#595b6e", -- red (muted dark gray for contrast)
	base09 = "#535563", -- peach (dark gray with slight warmth)
	base0A = "#50535f", -- yellow (muted highlight gray)
	base0B = "#4d4f5c", -- green (cool dark gray)
	base0C = "#494b56", -- teal (deep cool gray)
	base0D = "#444755", -- blue (darker muted gray)
	base0E = "#404351", -- mauve (deep neutral gray)
	base0F = "#3c3f4e", -- flamingo (darkest muted gray)
}):set_hl_groups(function(p)
	lib.hl("Normal", { bg = "None", fg = p.base05 })
	lib.hl("NormalNC", { bg = "None" })

	lib.hl("LineNr", { bg = "None" })
	lib.hl("SignColumn", { bg = "None" })

	lib.hl("Comment", { fg = p.base03 })

	lib.hl("Keyword", { fg = lib.lighten(p.base05, 15), style = "bold" })
	lib.hl("@keyword", { link = "Keyword" })
	lib.hl("@module.builtin", { link = "Keyword" })

	lib.hl("Function", { style = "bold" })
	lib.hl("@function", { link = "Function" })
	lib.hl("@method", { link = "Function" })

	lib.hl("FloatBorder", { bg = "None" })
	lib.hl("Pmenu", { bg = "None" })
	lib.hl("PmenuThumb", { bg = p.base00 })

	lib.hl("CmpItemMenu", { link = "Pmenu" })
	lib.hl("CmpItemKind", { bg = "None" })
	lib.hl("CmpItemMenu", { link = "Pmenu" })

	lib.hl("WinSeparator", { bg = "None" })
end)

dark.tomorrow_night = Theme({
	-- name: "Tomorrow Night"
	-- author: "Chris Kempson (http://chriskempson.com)"
	-- variant: "dark"

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
}):modify(function(p)
	p.base08 = "#66accc"
end):set_hl_groups(function(p)
	local comment_fg = lib.darken(p.base03, 40)
	lib.hl("Comment", { fg = comment_fg })
	-- util.hl("Normal", { bg = string.format("%s%s", p.base00, "00") })

	-- active
	lib.hl("Normal", { bg = "None" })

	-- inactive
	lib.hl("NormalNC", { bg = "None" })

	lib.hl("Whitespace", { link = "Comment" })

	lib.hl("LineNr", { bg = "None", fg = comment_fg })

	lib.hl("SignColumn", { bg = "None" })

	lib.hl("Visual", { bg = p.base00 })

	-- INFO: nontext and whitespace are for listchars highlighting
	lib.hl("NonText", { fg = lib.darken(p.base03, 60) })
	lib.hl("Whitespace", { fg = lib.darken(p.base03, 60) })

	lib.hl("MatchParen", { bg = lib.darken(p.base0A, 80), fg = p.base0A })

	lib.hl("FloatBorder", { link = "Comment" })

	lib.hl("Pmenu", { bg = "None" })
	lib.hl("PmenuExtra", { bg = "None" })
	lib.hl("PmenuSel", { bg = p.base0C, fg = p.base0A })

	lib.hl("CmpItemMenu", { link = "Pmenu" })

	lib.hl("WinSeparator", { bg = "None" })
end)

dark.kanagawa = Theme({
	-- [source](https://github.com/RRethy/base16-nvim/blob/master/lua/colors/kanagawa.lua)
	base00 = "#1f1f28",
	base01 = "#16161d",
	base02 = "#223249",
	base03 = "#54546d",
	base04 = "#727169",
	base05 = "#dcd7ba",
	base06 = "#c8c093",
	base07 = "#717c7c",
	base08 = "#c34043",
	base09 = "#ffa066",
	base0A = "#c0a36e",
	base0B = "#76946a",
	base0C = "#6a9589",
	base0D = "#7e9cd8",
	base0E = "#957fb8",
	base0F = "#d27e99",
})

M.light = light
M.dark = dark

return M
