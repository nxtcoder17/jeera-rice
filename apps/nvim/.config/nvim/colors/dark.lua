

local palette = {
	bg_edge2 = '#23232e',
	bg_edge = '#2a2a37',
	bg = '#1f1f28',
	bg_mid = '#363646',
	bg_mid2 = '#545461',

	fg_edge2 = '#dfdbc0',
	fg_edge = '#dcd7ba',
	fg = '#dcd7ba',
	fg_mid = '#8e8d87',
	fg_mid2 = '#878798',

	accent = '#7aa89f',
	accent_bg = '#30433f',

	red = '#e46876',
	red_bg = '#5b292f',
	orange = '#ffa066',
	orange_bg = '#664028',
	yellow = '#e6c384',
	yellow_bg = '#5c4e34',
	green = '#98bb6c',
	green_bg = '#3c4a2b',
	cyan = '#7aa89f',
	cyan_bg = '#30433f',
	azure = '#7fb4ca',
	azure_bg = '#324850',
	blue = '#7e9cd8',
	blue_bg = '#323e56',
	purple = '#a492c2',
	purple_bg = '#3b3249',
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

vim.g.colors_name = "dark"

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
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { gui = undercurl })
vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { gui = undercurl })
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
