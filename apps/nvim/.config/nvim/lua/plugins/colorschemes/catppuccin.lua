local colors = require("colors")

require("catppuccin").setup({
  -- flavour = "macchiato", -- latte, frappe, macchiato, mocha
  flavour = "latte", -- latte, frappe, macchiato, mocha
  background = {    -- :h background
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
    latte = function(latte)
      return {
        -- Normal = { fg = latte.base },
        -- Normal = { fg = "#b5bbc4" },
        -- Normal = { bg = "#f0f5f1" },
        ["@boolean"] = { fg = colors.palette["blue-chill"]["900"] },
        ["@number"] = { fg = colors.palette["blue-chill"]["900"] },
        ["@variable"] = { fg = colors.palette["bermuda-gray"]["900"] },
        ["@variable.parameter"] = { fg = colors.palette["blue-chill"]["500"], style = { "italic" } },
        ["@variable.member"] = { fg = colors.palette["blue-chill"]["600"], style = { "italic" } },
        ["Identifier"] = { link = "@variable" },

        ["@function"] = { fg = colors.palette["blue-chill"]["600"], style = { "bold", "italic" } },
        ["@method"] = { link = "@function" },
        ["@function.builtin"] = { link = "@function" },
        ["@function.method"] = { link = "@function" },
        ["@function.call"] = { link = "@function" },
        ["@function.method.call"] = { link = "@function" },

        ["@module"] = { fg = colors.palette["contessa"]["800"], bg = colors.palette["contessa"]["50"] },

        ["@punctuation"] = { fg = colors.palette["blue-chill"]["800"] },
        ["@punctuation.bracket"] = { link = "@punctuation" },
        ["@punctuation.special"] = {
          fg = colors.palette["contessa"]["700"],
          style = { "italic" },
        },
        ["@constructor"] = { link = "@punctuation" },
        ["@operator"] = { link = "@punctuation" },

        ["MatchParen"] = { fg = colors.palette["blue-chill"]["900"], bg = colors.palette["blue-chill"]["200"] },

        ["@constant"] = { fg = colors.palette["blue-chill"]["900"], style = { "bold" } },
        ["@constant.builtin"] = { link = "@constant" },

        -- types, like go structs
        ["@type"] = { fg = colors.palette["blue-chill"]["900"] },
        ["@type.definition"] = { link = "@type" },
        ["@type.builtin"] = { fg = colors.palette["rose-of-sharon"]["800"], style = { "italic" } },

        -- @attribute are  graphql directives, like @hasLoggedIn
        ["@attribute"] = { fg = colors.palette["contessa"]["600"] },

        ["Structure"] = { link = "@type.builtin" },
        ["Type"] = { link = "@type.builtin" },
        ["Number"] = { link = "@constant" },

        ["Statement"] = { link = "@punctuation" }, -- fzf lua selection
        -- ["@string"] = { fg = colors.palette["curious-blue"]["600"] },
        ["@string"] = { fg = colors.gel_pen_variants["pale-blue"] },

        -- struct fields
        ["@property"] = { fg = colors.palette["curious-blue"]["700"] },
        -- ["@property"] = { fg = "#1f719b" },

        -- PmenuSel = { fg = "NONE", bg = colors.palette["mantis"]["50"] },
        PmenuSel = { fg = colors.palette["blue-chill"]["600"], bg = colors.palette["blue-chill"]["50"] },
        Pmenu = { fg = colors.palette["blue-chill"]["600"], bg = "NONE" },
        -- CursorLine = { fg = colors.palette["curious-blue"]["800"], bg = colors.palette["curious-blue"]["100"] },
        Normal = { fg = colors.gel_pen_variants["blue-black"] },

        DiagnosticUnderlineError = { fg = "#d20f3a", bg = colors.palette["mandy"]["100"], style = { "undercurl" } },
        DapStoppedLinehl = { bg = colors.palette["rose-of-sharon"]["200"] },
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
