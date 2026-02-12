local palette = {
	bg_edge2 = '#c6c3bd',
	bg_edge = '#e9e6df',
	bg = '#f5f3ee',
	bg_mid = '#ddd9d0',
	bg_mid2 = '#e2ded7',

	fg_edge2 = '#3f3f4b',
	fg_edge = '#2a2a37',
	fg = '#2a2a37',
	fg_mid = '#a19f98',
	fg_mid2 = '#c2c0bb',

	accent = '#4a8a7a',
	accent_bg = '#1d3730',

	red = '#c84053',
	red_bg = '#501921',
	orange = '#b35c00',
	orange_bg = '#472400',
	yellow = '#b38a3c',
	yellow_bg = '#473718',
	green = '#5f7f3a',
	green_bg = '#263217',
	cyan = '#4a8a7a',
	cyan_bg = '#1d3730',
	azure = '#4583a2',
	azure_bg = '#1b3440',
	blue = '#4c6fae',
	blue_bg = '#1e2c45',
	purple = '#846aa5',
	purple_bg = '#2c203c',
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

vim.g.colors_name = 'dark'

-- Overrides using our palette colors
vim.api.nvim_set_hl(0, "Delimiter", { fg = palette.azure })
vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = palette.azure })
vim.api.nvim_set_hl(0, "@punctuation.delimiter", { fg = palette.azure })
vim.api.nvim_set_hl(0, "Constant", { fg = palette.purple })
vim.api.nvim_set_hl(0, "@number", { fg = palette.purple })
vim.api.nvim_set_hl(0, "@boolean", { fg = palette.purple })

-- Keywords: make them stand out (desaturated orange)
local keyword_color = '#8f6e30'
vim.api.nvim_set_hl(0, "Keyword", { fg = keyword_color, bold = true })
vim.api.nvim_set_hl(0, "@keyword", { fg = keyword_color, bold = true })
vim.api.nvim_set_hl(0, "Statement", { fg = keyword_color, bold = true })
vim.api.nvim_set_hl(0, "@keyword.function", { fg = keyword_color, bold = true })
vim.api.nvim_set_hl(0, "@keyword.return", { fg = keyword_color })

local text_color = '#2a2a37'
vim.api.nvim_set_hl(0, "Type", { fg = type_color, bold = true })
vim.api.nvim_set_hl(0, "@type.go", { link = "Type" })

vim.api.nvim_set_hl(0, "Identifier", { fg = text_color })

vim.api.nvim_set_hl(0, "Normal", { bg = "None" })

-- MiniStatusline mode highlights
vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { fg = palette.bg, bg = palette.blue, bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { fg = palette.bg, bg = palette.green, bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeVisual", { fg = palette.bg, bg = palette.purple, bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeReplace", { fg = palette.bg, bg = palette.red, bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeCommand", { fg = palette.bg, bg = palette.yellow, bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeOther", { fg = palette.bg, bg = palette.fg_mid, bold = true })

-- MiniStatusline section highlights
vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { fg = palette.fg, bg = palette.bg_mid })
vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { fg = palette.fg, bg = palette.bg_edge })
vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { fg = palette.fg_mid, bg = palette.bg_mid })
vim.api.nvim_set_hl(0, "MiniStatuslineInactive", { fg = palette.fg_mid2, bg = palette.bg_edge })
