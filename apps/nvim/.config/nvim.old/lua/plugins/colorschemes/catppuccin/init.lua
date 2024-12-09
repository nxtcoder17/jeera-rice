if vim.o.background == "light" then
  return require("plugins.colorschemes.catppuccin.light")
end
return require("plugins.colorschemes.catppuccin.dark")
