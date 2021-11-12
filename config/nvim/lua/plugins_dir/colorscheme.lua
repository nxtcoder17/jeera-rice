-- Example config in lua
-- vim.g.nord_contrast = false
-- vim.g.nord_borders = false
-- vim.g.nord_disable_background = false
-- vim.g.nord_italic = true

-- -- Load the colorscheme
-- require("nord").set()

-- require("nordbuddy").colorscheme({
--   underline_option = "none",
--   italic = true,
--   italic_comments = false,
--   minimal_mode = false,
-- })

-- require'nightfox'.load('nordfox')

-- vim.g.everforest_background = "medium"
-- vim.g.everforest_enable_italic = 1
-- vim.g.everforest_disable_italic_comment = 1

-- vim.cmd([[colorscheme everforest ]])

-- vim.g.sonokai_style = 'maia'
-- vim.g.sonokai_enable_italic = 1
-- vim.g.sonokai_cursor='auto' vim.g.sonokai_better_performance = 1
-- vim.cmd [[ colorscheme sonokai ]]
-- vim.cmd [[ colorscheme forestbones ]]

-- vim.g.forestbones = { 
--   solid_line_nr = true,
--   darken_comments = 40,
--   lighten_cursor_line = 17, 
--   darkness = 'warm'
-- }


-- Tokyo Night theme
vim.cmd[[ colorscheme tokyonight ]]
vim.g.tokyonight_style = "night"
vim.g.tokyonight_italic_functions = true
vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }
