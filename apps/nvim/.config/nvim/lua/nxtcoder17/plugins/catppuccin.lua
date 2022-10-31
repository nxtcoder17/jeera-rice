require("catppuccin").setup({
  flavour = "macchiato", -- mocha, macchiato, frappe, latte
  background = {
    dark = "mocha",
  },
  transparent_background = false,
  integrations = {
    fidget = true,
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { "italic" },
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
      },
      underlines = {
        errors = { "undercurl" },
        hints = { "undercurl" },
        warnings = { "undercurl" },
        information = { "undercurl" },
      },
    },
  },
})

vim.api.nvim_command("colorscheme catppuccin")
