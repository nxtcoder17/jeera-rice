local colors = require("colors")

local hl_groups = {
  --[[
    Groups are the highlight group definitions.
      + keys are the name of the highlight groups that will be overridden.
      + values are the highlight group definitions, which are tables with the following keys:
        - fg: foreground color
        - bg: background color
        - style: style of the highlight, can be one of the following:
          - bold
          - italic
          - underline
          - undercurl
          - reverse
          - nocombine
        - sp: special color for the highlight, can be one of the following:
          - comment
          - constant
          - identifier
          - statement
          - error
          - type
          - include
          - keyword
          - struct
          - string
          - character
          - number
          - boolean
          - float
          - function
          - title
          - variable
          - constructor
          - field
          - property
          - method
          - operator
          - preproc
          - constant.builtin
          - constant.macro
          - repeat
          - label
          - conditional
          - keyword.operator
          - keyword.return
          - keyword.function
          - keyword.statement
        - link: another highlight group to link to, see |:help highlight-links|
    --]]

  MatchParen = {
    bg = "#dadee0",
    -- fg = "#4d616b",
  },

  Cursor = {
    -- bg = "#aec3cf",
    fg = "#dadee0",
  },
  --
  Normal = {
    bg = "#FFFFFF",
    -- bg = colors.palette["black"]["50"],
  },

  Visual = {
    bg = "#dadee0",
    -- fg = "#aec3cf",
  },

  Pmenu = {
    -- bg = vim.NIL,
    bg = colors.palette["kidnapper"]["50"],
  },
  CursorLine = {
    bg = "#a8cfe3",
  },
  LineNr = {
    fg = "#4d616b",
  },

  -- ["@function.call"] = {
  --   bg = colors.palette["black"]["50"],
  -- },

  -- ["@string"] = {
  --   bg = colors.palette["black"]["50"],
  -- },

  ["@property"] = {
    fg = colors.palette["black"]["500"],
  },

  ["@module"] = {
    fg = colors.palette["bermuda-gray"]["400"],
    bg = "",
    style = "italic",
  },

  ["@type"] = {
    fg = colors.palette["kidnapper"]["500"],
    bg = colors.palette["kidnapper"]["50"],
    style = "bold",
  },
  ["@type.builtin"] = {
    fg = colors.palette["black"]["400"],
    bg = colors.palette["mantis"]["50"],
  },

  ["@function.method"] = {
    fg = colors.palette["blue-chill"]["500"],
    style = "bold",
  },

  ["@function"] = {
    fg = colors.palette["blue-chill"]["500"],
    style = "bold",
  },

  ["@function.builtin"] = {
    fg = colors.palette["blue-chill"]["500"],
    style = "bold",
  },

  ["DiagnosticUnderlineError"] = {
    bg = colors.palette["contessa"]["700"],
    fg = colors.palette["contessa"]["50"],
  },

  ["@function.method.call"] = {
    fg = colors.palette["blue-chill"]["400"],
    style = "bold,italic",
    bg = colors.palette["blue-chill"]["50"],
  },

  ["@function.call"] = {
    fg = colors.palette["blue-chill"]["400"],
    style = "bold,italic",
    bg = colors.palette["blue-chill"]["50"],
  },
}

require("nightfox").setup({
  options = {
    transparent = true,
    terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`

    styles = {            -- Style to be applied to different syntax groups
      comments = "italic", -- Value is any valid attr-list value `:help attr-list`
      conditionals = "italic",
      constants = "italic",
      functions = "NONE",
      keywords = "italic",
      numbers = "NONE",
      operators = "NONE",
      strings = "NONE",
      types = "NONE",
      variables = "NONE",
    },
    inverse = { -- Inverse highlight for different types
      match_paren = false,
      visual = false,
      search = false,
    },
  },
  groups = {
    ["dayfox"] = hl_groups,
  },
})

vim.cmd("colorscheme dayfox")
