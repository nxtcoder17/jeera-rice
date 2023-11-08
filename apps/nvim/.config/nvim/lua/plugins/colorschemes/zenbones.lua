local zenbones_variant = "neobones"

vim.g[zenbones_variant] = {
  darkness = "stark",
  solid_line_nr = true,
}
vim.cmd("colorscheme " .. zenbones_variant)
