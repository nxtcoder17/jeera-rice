local defaultColors = require("kanagawa.colors").setup()

local colors = {
  -- nxtSelection1 = "#355078"
  nxtSelection1 = "#273e5e"
}

local overrides = {
  Visual = {
    bg = colors.nxtSelection1,
  },
  TSException = {
    fg = defaultColors.oniViolet,
  },
  TSKeywordReturn = {
    fg = defaultColors.lightBlue,
  }
}

require'kanagawa'.setup({ overrides = overrides, colors = colors })
vim.cmd('colorscheme kanagawa')
