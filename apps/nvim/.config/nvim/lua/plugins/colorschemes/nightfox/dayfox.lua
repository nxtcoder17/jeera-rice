local M = {}

local light_shades = {}

local colors = {
  ["mantis"] = {
    ["50"] = "#f6faf3",
    ["100"] = "#e9f5e3",
    ["200"] = "#d3eac8",
    ["300"] = "#afd89d",
    ["400"] = "#82bd69",
    ["500"] = "#61a146",
    ["600"] = "#4c8435",
    ["700"] = "#3d692c",
    ["800"] = "#345427",
    ["900"] = "#2b4522",
    ["950"] = "#13250e",
  },

  -- #ba7264
  ["contessa"] = {
    ["50"] = "#fbf6f5",
    ["100"] = "#f6ecea",
    ["200"] = "#f0dcd8",
    ["300"] = "#e4c3bd",
    ["400"] = "#d3a096",
    ["500"] = "#ba7264",
    ["600"] = "#aa6558",
    ["700"] = "#8e5347",
    ["800"] = "#77463d",
    ["900"] = "#643f38",
    ["950"] = "#351e1a",
  },

  -- #000000
  ["black"] = {
    ["50"] = "#f6f6f6",
    ["100"] = "#e7e7e7",
    ["200"] = "#d1d1d1",
    ["300"] = "#b0b0b0",
    ["400"] = "#888888",
    ["500"] = "#6d6d6d",
    ["600"] = "#5d5d5d",
    ["700"] = "#4f4f4f",
    ["800"] = "#454545",
    ["900"] = "#3d3d3d",
    ["950"] = "#000000",
  },

  ["rose-of-sharon"] = {
    ["50"] = "#fffbeb",
    ["100"] = "#fef3c7",
    ["200"] = "#fde58a",
    ["300"] = "#fbd24e",
    ["400"] = "#fabe25",
    ["500"] = "#f49d0c",
    ["600"] = "#d87607",
    ["700"] = "#bc560a",
    ["800"] = "#923f0e",
    ["900"] = "#78340f",
    ["950"] = "#451a03",
  },

  -- #438e96
  ["blue-chill"] = {
    ["50"] = "#f2f9f9",
    ["100"] = "#ddeff0",
    ["200"] = "#bfe0e2",
    ["300"] = "#92cace",
    ["400"] = "#5faab1",
    ["500"] = "#438e96",
    ["600"] = "#3b757f",
    ["700"] = "#356169",
    ["800"] = "#325158",
    ["900"] = "#2d464c",
    ["950"] = "#1a2c32",
  },

  -- #e6edd5
  ["kidnapper"] = {
    ["50"] = "#f5f8ed",
    ["100"] = "#e6edd5",
    ["200"] = "#d2e0b6",
    ["300"] = "#b6cb8b",
    ["400"] = "#9ab566",
    ["500"] = "#7d9a48",
    ["600"] = "#607a36",
    ["700"] = "#4b5e2d",
    ["800"] = "#3d4c28",
    ["900"] = "#364225",
    ["950"] = "#1b2310",
  },

  ["bermuda-gray"] = {
    ["50"] = "#f4f6f7",
    ["100"] = "#e2e8eb",
    ["200"] = "#c9d3d8",
    ["300"] = "#a3b4bd",
    ["400"] = "#728997",
    ["500"] = "#5b717f",
    ["600"] = "#4e5f6c",
    ["700"] = "#44515a",
    ["800"] = "#3d454d",
    ["900"] = "#363d43",
    ["950"] = "#21262b",
  },
}

require("nightfox").setup({
  options = {
    -- Compiled file's destination location
    compile_path = vim.fn.stdpath("cache") .. "/nightfox",
    compile_file_suffix = "_compiled", -- Compiled file suffix
    transparent = false,             -- Disable setting background
    terminal_colors = true,          -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
    dim_inactive = false,            -- Non focused panes set to alternative background
    module_default = true,           -- Default enable value for modules
    colorblind = {
      enable = true,                 -- Enable colorblind support
      simulate_only = true,          -- Only show simulated colorblind colors and not diff shifted
      severity = {
        protan = 0,                  -- Severity [0,1] for protan (red)
        deutan = 0,                  -- Severity [0,1] for deutan (green)
        tritan = 0,                  -- Severity [0,1] for tritan (blue)
      },
    },
    styles = {          -- Style to be applied to different syntax groups
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
    modules = { -- List of various plugins and additional options
      -- ...
    },
  },
  palettes = {
    -- Palettes are the base color defines of a colorscheme.
    -- You can override these palettes for each colorscheme defined by nightfox.

    -- source: https://github.com/EdenEast/nightfox.nvim#customize-palettes-and-groups

    -- Each palette defines these colors:
    -- black, red, green, yellow, blue, magenta, cyan, white, orange, pink
    -- NOTE: These colors have 3 shades: base, bright, and dim.
    -- blue = { base = "#4d688e", bright = "#4e75aa", dim = "#485e7d" },
    -- or
    -- blue = "#4d688e" -- Defining just a color defines it's base color.

    -- A palette also defines the following:
    --   bg0, bg1, bg2, bg3, bg4, fg0, fg1, fg2, fg3, sel0, sel1, comment

    -- Everything defined under `all` will be applied to each style.
    nightfox = M.color_palette,
  },
  specs = {
    nightfox = {
      syntax = {
        -- keyword = "magenta",
        keyword = "magenta",
      },
    },
  },
  groups = {
    -- Groups are the highlight group definitions. The keys of this table are the name of the highlight
    -- groups that will be overridden. The value is a table with the following values:
    --   - fg, bg, style, sp, link,
    dayfox = {
      --
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
        -- bg = colors["black"]["50"],
      },

      Visual = {
        bg = "#dadee0",
        -- fg = "#aec3cf",
      },

      Pmenu = {
        -- bg = vim.NIL,
        bg = colors["kidnapper"]["50"],
      },
      CursorLine = {
        bg = "#a8cfe3",
      },
      LineNr = {
        fg = "#4d616b",
      },

      -- ["@function.call"] = {
      --   bg = colors["black"]["50"],
      -- },

      -- ["@string"] = {
      --   bg = colors["black"]["50"],
      -- },

      ["@property"] = {
        fg = colors["black"]["500"],
      },

      ["@module"] = {
        fg = colors["bermuda-gray"]["400"],
        bg = "",
        style = "italic",
      },

      ["@type"] = {
        fg = colors["kidnapper"]["500"],
        bg = colors["kidnapper"]["50"],
        style = "bold",
      },
      ["@type.builtin"] = {
        fg = colors["black"]["400"],
        bg = colors["mantis"]["50"],
      },

      ["@function.method"] = {
        fg = colors["blue-chill"]["500"],
        style = "bold",
      },

      ["@function"] = {
        fg = colors["blue-chill"]["500"],
        style = "bold",
      },

      ["@function.builtin"] = {
        fg = colors["blue-chill"]["500"],
        style = "bold",
      },

      ["DiagnosticUnderlineError"] = {
        bg = colors["contessa"]["700"],
        fg = colors["contessa"]["50"],
      },

      ["@function.method.call"] = {
        fg = colors["blue-chill"]["400"],
        style = "bold,italic",
        bg = colors["blue-chill"]["50"],
      },

      ["@function.call"] = {
        fg = colors["blue-chill"]["400"],
        style = "bold,italic",
        bg = colors["blue-chill"]["50"],
      },
    },
  },
})

vim.cmd("colorscheme dayfox")
