

local palette = {
	bg_edge2 = '#ece9e3',
	bg_edge = '#e9e6df',
	bg = '#f5f3ee',
	bg_mid = '#ddd9d0',
	bg_mid2 = '#bbb8b0',

	fg_edge2 = '#252531',
	fg_edge = '#2a2a37',
	fg = '#2a2a37',
	fg_mid = '#8a887f',
	fg_mid2 = '#a8a69f',

	accent = '#b38a3c',
	accent_bg = '#e0d0b1',

	red = '#c84053',
	red_bg = '#e9b2ba',
	orange = '#b35c00',
	orange_bg = '#e0bd99',
	yellow = '#b38a3c',
	yellow_bg = '#e0d0b1',
	green = '#5f7f3a',
	green_bg = '#bfcbb0',
	cyan = '#4a8a7a',
	cyan_bg = '#b6d0c9',
	azure = '#4583a2',
	azure_bg = '#b4cdd9',
	blue = '#4c6fae',
	blue_bg = '#b7c5de',
	purple = '#6f5096',
	purple_bg = '#c5b9d5',
}

require("mini.hues").apply_palette(palette, {
	default = false,
	["ibhagwan/fzf-lua"] = false,
	["nvim-mini/mini.nvim"] = true,
	["folke/lazy.nvim"] = true,
	["folke/trouble.nvim"] = true,
	["hrsh7th/nvim-cmp"] = true,
	["rcarriga/nvim-dap-ui"] = true,
	["williamboman/mason.nvim"] = true,
})

vim.g.colors_name = "light"

-- Resets
vim.api.nvim_set_hl(0, "FloatBorder", { bg = vim.NONE })

-- Overrides using our palette colors
vim.api.nvim_set_hl(0, "Delimiter", { fg = palette.azure })
vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = palette.azure })
vim.api.nvim_set_hl(0, "@punctuation.delimiter", { fg = palette.azure })
vim.api.nvim_set_hl(0, "Constant", { fg = palette.purple })
vim.api.nvim_set_hl(0, "@number", { fg = palette.purple })
vim.api.nvim_set_hl(0, "@boolean", { fg = palette.purple })

-- Diagnostic Errors
vim.api.nvim_set_hl(0, "DiagnosticError", { bg = palette.red_bg, fg = palette.red })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { gui = undercurl })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { bg = palette.yellow_bg, fg = palette.yellow })
vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { gui = undercurl })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { gui = undercurl })
vim.api.nvim_set_hl(0, "DiagnosticInfo", { gui = undercurl })

-- Keywords: make them stand out (desaturated orange)
local keyword_color = '#a17c36'
vim.api.nvim_set_hl(0, "Keyword", { fg = keyword_color, bold = true })
vim.api.nvim_set_hl(0, "@keyword", { fg = keyword_color, bold = true })
vim.api.nvim_set_hl(0, "Statement", { fg = keyword_color, bold = true })
vim.api.nvim_set_hl(0, "@keyword.function", { fg = keyword_color, bold = true })
vim.api.nvim_set_hl(0, "@keyword.return", { fg = palette.purple, bold = true })
vim.api.nvim_set_hl(0, "@keyword.return.go", { link = "@keyword.return" })

local text_color = '#2a2a37'
vim.api.nvim_set_hl(0, "Type", { fg = type_color, bold = true })
vim.api.nvim_set_hl(0, "@type.go", { link = "Type" })
vim.api.nvim_set_hl(0, "@type.builtin.go", { link = "Keyword" })

vim.api.nvim_set_hl(0, "Identifier", { fg = text_color })

vim.api.nvim_set_hl(0, "Normal", { bg = "None" })

-- Make comments more readable in light mode
vim.api.nvim_set_hl(0, "Comment", { fg = palette.fg_mid, italic = true })
vim.api.nvim_set_hl(0, "@comment", { link = "Comment" })

-- Functions
vim.api.nvim_set_hl(0, "Function", { fg = palette.azure, bold = true })
vim.api.nvim_set_hl(0, "@function.go", { link = "Function" })

-- MiniStatusline mode highlights
vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { fg = palette.bg, bg = palette.blue, bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { fg = palette.bg, bg = palette.green, bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeVisual", { fg = palette.bg, bg = palette.purple, bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeReplace", { fg = palette.bg, bg = palette.red, bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeCommand", { fg = palette.bg, bg = palette.yellow, bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeOther", { fg = palette.bg, bg = palette.fg_mid, bold = true })

-- MiniStatusline section highlights
vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { fg = palette.fg, bg = palette.bg_mid2 })
vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { fg = palette.fg, bg = palette.bg_mid })
vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { fg = palette.fg, bg = palette.bg_mid2 })
vim.api.nvim_set_hl(0, "MiniStatuslineInactive", { fg = palette.fg_mid2, bg = palette.bg_mid })
