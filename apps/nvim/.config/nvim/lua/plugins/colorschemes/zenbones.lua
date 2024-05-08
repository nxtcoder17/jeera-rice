vim.opt.background = "light"
local zenbones_variant = "zenwritten"
-- local zenbones_variant = "kanagawabones"

vim.g[zenbones_variant] = {
  -- darkness = "stark",
  lightness = "bright",
  italic_comments = true,
  solid_line_nr = true,
  transparent_background = true,
}

vim.cmd("colorscheme " .. zenbones_variant)
