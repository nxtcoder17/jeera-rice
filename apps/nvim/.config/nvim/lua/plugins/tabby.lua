local colors = require("colors")

local function dark_theme()
  vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#000000", bg = "#698e91", bold = true })
  vim.api.nvim_set_hl(0, "TabLine", { fg = "#000000", bg = "#4c6669", bold = true })
end

local function light_theme()
  -- vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#000000", bg = "#f3ead3", bold = true })
  -- vim.api.nvim_set_hl(0, "TabLine", { fg = "#686959", bg = "#e5e6c5" })
  vim.api.nvim_set_hl(0, "TabLineSel", {
    bg = colors.palette["bermuda-gray"]["200"],
    fg = colors.gel_pen_variants["blue-black"],
    bold = true,
  })
  -- vim.api.nvim_set_hl(0, "TabLine", { fg = "#686959", bg = "#e5e6c5" })
  vim.api.nvim_set_hl(0, "TabLine", {
    fg = colors.gel_pen_variants["blue-black"],
    bg = colors.palette["bermuda-gray"]["50"],
    blend = 100,
  })
end

if vim.o.background == "light" then
  light_theme()
else
  dark_theme()
end

require("tabby").setup()
