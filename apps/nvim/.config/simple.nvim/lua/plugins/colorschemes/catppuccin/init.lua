package.path = package.path .. ";" .. debug.getinfo(1, "S").source:match("@?(.*/)") .. "?.lua"

local color_overrides = require(os.getenv("SYSTEM_THEME") or "light")

local lib = require("plugins.colorschemes.lib.color")

require("catppuccin").setup({
  flavour = "auto",
  float = { solid = true, transparent = false },
  background = {
    light = "latte",
    dark = "mocha",
  },
  transparent_background = true,
  dim_inactive = {
    enabled = false,
  },
  color_overrides = {
    all = color_overrides,
  },
  no_italic = true,
  highlight_overrides = {
    all = function(colors)
      return {
        -- ["@variable.member"] = { fg = colors.peach },
        ["@variable.parameter"] = { fg = colors.sky },
        ["@variable.builtin"] = { fg = colors.lavender, bold = true },
        -- ["@property"] = { fg = colors.blue },
        -- ["Special"] = { fg = colors.mauve },
        -- Function = { fg = colors.teal, italic = true },
        Boolean = { fg = colors.mauve, bold = true },
        --
        DiagnosticError = { undercurl = true },
        DiagnosticUnderlineError = { link = "DiagnosticError" },

        DiagnosticWarn = { undercurl = true },
        DiagnosticUnderlineWarn = { link = "DiagnosticWarn" },

        DiagnosticInfo = { undercurl = true },
        DiagnosticUnderlineInfo = { link = "DiagnosticInfo" },

        DiagnosticHint = { undercurl = true },
        DiagnosticUnderlineHint = { link = "DiagnosticHint" },

        Comment = { fg = lib.blend(colors.overlay0, 10) },

        Repeat = { link = "Keyword" },
        Conditional = { link = "Keyword" },
        ["@keyword"] = { link = "Keyword" },
        ["@keyword.return"] = { link = "Keyword" },
        ["@constant.builtin"] = { link = "Keyword" },

        ["@function.builtin"] = { link = "Function" },
        ["@variable.member"] = { link = "Variable" },
      }
    end,
    latte = function(colors)
      return {
        -- ["Variable"] = { fg = lib.darken(colors.blue, 70) },
        -- ["String"] = { fg = lib.darken(colors.green, 50) },
        -- ["Number"] = { fg = lib.darken(colors.green, 50) },
        -- Type = { fg = lib.darken(colors.yellow, 30), bold = false },
        -- ["@type.builtin"] = { link = "Type" },
        -- ["Normal"] = { bg = "#dfe2e5" },
        Type = { fg = lib.gel_pen_variants["blue"], bold = true },
        Function = {
          -- fg = lib.darken(lib.gel_pen_variants["pale-blue"], 40),
          fg = lib.gel_pen_variants["cobalt-blue"],
          bold = true,
        },
        ["@module"] = { bold = true },
        Keyword = { fg = lib.darken(lib.gel_pen_variants["vividian-green"], 50), bold = true },
        Variable = { fg = lib.gel_pen_variants["black"] },
        Constant = { fg = lib.darken(lib.gel_pen_variants["light-blue"], 60), bold = true },
      }
    end,
    mocha = function(colors)
      return {
        -- ["String"] = { fg = lib.darken(colors.green, 50) },
        -- ["Number"] = { fg = lib.darken(colors.green, 50) },
      }
    end,
  },
})

vim.cmd("colorscheme catppuccin")
