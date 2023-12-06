require("catppuccin").setup({
  flavour = "macchiato", -- latte, frappe, macchiato, mocha
  background = {    -- :h background
    light = "latte",
    dark = "macchiato",
  },
  transparent_background = false, -- disables setting the background color.
  show_end_of_buffer = false,    -- shows the '~' characters after the end of buffers
  term_colors = false,           -- sets terminal colors (e.g. `g:terminal_color_0`)
  dim_inactive = {
    enabled = false,             -- dims the background color of inactive window
    shade = "dark",
    percentage = 0.15,           -- percentage of the shade to apply to the inactive window
  },
  no_italic = false,             -- Force no italic
  no_bold = false,               -- Force no bold
  no_underline = false,          -- Force no underline
  styles = {                     -- Handles the styles of general hi groups (see `:h highlight-args`):
    comments = { "italic" },     -- Change the style of comments
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
    all = function(colors)
      return {
        NvimTreeNormal = { fg = colors.none },
        CmpBorder = { fg = "#3e4145" },
      }
    end,
    latte = function(latte)
      return {
        -- Normal = { fg = latte.base },
        -- Normal = { fg = "#b5bbc4" },
        Normal = { bg = "#f0f5f1" },
      }
    end,
    frappe = function(frappe)
      return {
        ["@comment"] = { fg = frappe.surface2, style = { "italic" } },
      }
    end,
    macchiato = function(macchiato)
      return {
        LineNr = { fg = macchiato.overlay1 },
      }
    end,
    mocha = function(mocha)
      return {
        Comment = { fg = mocha.flamingo },
      }
    end,
  },
  integrations = {
    cmp = true,
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
