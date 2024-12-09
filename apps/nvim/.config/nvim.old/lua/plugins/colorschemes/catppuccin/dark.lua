local colors = require("colors")

require("catppuccin").setup({
  -- flavour = "macchiato", -- latte, frappe, macchiato, mocha
  -- flavour = vim.opt.background == "light" and "latte" or "macchiato", -- latte, frappe, macchiato, mocha
  flavour = "macchiato",
  background = {
    light = "latte",
    dark = "macchiato",
  },
  transparent_background = true, -- disables setting the background color.
  show_end_of_buffer = false,   -- shows the '~' characters after the end of buffers
  term_colors = false,          -- sets terminal colors(e.g. `g:terminal_color_0`)
  dim_inactive = {
    enabled = false,            -- dims the background color of inactive window
    shade = "dark",
    percentage = 0.15,          -- percentage of the shade to apply to the inactive window
  },
  no_italic = false,            -- Force no italic
  no_bold = false,              -- Force no bold
  no_underline = false,         -- Force no underline
  styles = {                    -- Handles the styles of general hi groups (see `:h highlight-args`):
    comments = { "italic" },    -- Change the style of comments
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  color_overrides = {},
  custom_highlights = {},
  highlight_overrides = {
    all = function(all)
      return {
        NvimTreeNormal = { fg = all.none },
        CmpBorder = { fg = "#3e4145" },
      }
    end,
    macchiato = function()
      return {
        PmenuSel = { bg = "#282C34", fg = "NONE" },
        DiagnosticUnderlineError = { fg = colors.palette["mandy"]["400"], style = { "undercurl" } },
        DiagnosticUnderlineWarn = {
          fg = colors.palette["rose-of-sharon"]["300"],
          style = { "undercurl" },
        },
      }
    end,
  },
  integrations = {
    cmp = false,
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    notify = false,
    rainbow_delimiters = true,
    mini = {
      enabled = true,
      indentscope_color = "",
    },
    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  },
})

-- setup must be called before loading
vim.cmd.colorscheme("catppuccin")
