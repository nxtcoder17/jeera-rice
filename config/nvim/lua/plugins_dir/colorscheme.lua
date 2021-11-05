-- Example config in lua
-- vim.g.nord_contrast = false
-- vim.g.nord_borders = false
-- vim.g.nord_disable_background = false
-- vim.g.nord_italic = true

-- -- Load the colorscheme
-- require("nord").set()

require("nordbuddy").colorscheme({
  underline_option = "none",
  italic = true,
  italic_comments = false,
  minimal_mode = false,
})

-- vim.g.everforest_background = "medium"
-- vim.g.everforest_enable_italic = 1
-- vim.g.everforest_disable_italic_comment = 1

-- vim.cmd([[colorscheme everforest ]])
