

local palette = {
	bg_edge2 = '#494955',
	bg_edge = '#2a2a37',
	bg = '#1f1f28',
	bg_mid = '#363646',
	bg_mid2 = '#2d2d3b',

	fg_edge2 = '#c6c1a7',
	fg_edge = '#dcd7ba',
	fg = '#dcd7ba',
	fg_mid = '#727169',
	fg_mid2 = '#54546d',

	accent = '#e6c384',
	accent_bg = '#f5e7cd',

	red = '#e46876',
	red_bg = '#f4c2c8',
	orange = '#ffa066',
	orange_bg = '#ffd9c1',
	yellow = '#e6c384',
	yellow_bg = '#f5e7cd',
	green = '#98bb6c',
	green_bg = '#d5e3c4',
	cyan = '#7aa89f',
	cyan_bg = '#c9dcd8',
	azure = '#7fb4ca',
	azure_bg = '#cbe1e9',
	blue = '#7e9cd8',
	blue_bg = '#cbd7ef',
	purple = '#957fb8',
	purple_bg = '#d4cbe2',
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
local keyword_color = '#b89c69'
vim.api.nvim_set_hl(0, "Keyword", { fg = keyword_color, bold = true })
vim.api.nvim_set_hl(0, "@keyword", { fg = keyword_color, bold = true })
vim.api.nvim_set_hl(0, "Statement", { fg = keyword_color, bold = true })
vim.api.nvim_set_hl(0, "@keyword.function", { fg = keyword_color, bold = true })
vim.api.nvim_set_hl(0, "@keyword.return", { fg = keyword_color })

local text_color = '#dcd7ba'
vim.api.nvim_set_hl(0, "Type", { fg = type_color, bold = true })
vim.api.nvim_set_hl(0, "@type.go", { link = "Type" })

vim.api.nvim_set_hl(0, "Identifier", { fg = text_color })

vim.api.nvim_set_hl(0, "Normal", { bg = "None" })

-- Make comments more readable in light mode
vim.api.nvim_set_hl(0, "Comment", { fg = palette.fg_mid, italic = true })
vim.api.nvim_set_hl(0, "@comment", { link = "Comment" })

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
