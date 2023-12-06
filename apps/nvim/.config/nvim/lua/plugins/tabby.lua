local function for_dark_theme()
  vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#000000", bg = "#698e91", bold = true })
  vim.api.nvim_set_hl(0, "TabLine", { fg = "#000000", bg = "#4c6669", bold = true })
end

local function for_light_theme()
  vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#000000", bg = "#f3ead3", bold = true })
  vim.api.nvim_set_hl(0, "TabLine", { fg = "#686959", bg = "#e5e6c5" })
end

if vim.o.background == "light" then
  for_light_theme()
else
  for_dark_theme()
end

require("tabby").setup()
