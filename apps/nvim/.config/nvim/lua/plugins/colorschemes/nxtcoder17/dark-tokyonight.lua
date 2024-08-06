local mycolors = require("colors")

require("tokyonight").setup({
  style = "moon",        -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
  light_style = "day",   -- The theme is used when the background is set to light
  transparent = true,    -- Enable this to disable setting the background color
  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = "dark", -- style for sidebars, see below
    floats = "dark",   -- style for floating windows
  },
  day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  dim_inactive = false, -- dims inactive windows
  lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

  --- You can override specific color groups to use other groups or a hex color
  --- function will be called with a ColorScheme table
  ---@param colors ColorScheme
  on_colors = function(colors) end,

  --- You can override specific highlights to use other groups or a hex color
  --- function will be called with a Highlights and ColorScheme table
  ---@param highlights tokyonight.Highlights
  ---@param colors ColorScheme
  on_highlights = function(highlights, colors)
    local overrides = {
      Normal = { fg = colors.fg },

      -- background for line numbers
      Line = { fg = mycolors.palette["bermuda-gray"]["500"], bg = vim.NONE },

      -- line numbers
      LineNr = { link = "Line" },

      -- space on left of line numbers
      SignColumn = { bg = vim.NONE },

      ["@comment"] = { fg = mycolors.palette["bermuda-gray"]["600"], italic = true },

      -- ["@variable"] = { fg = mycolors.gel_pen_variants["light-blue"] },
      ["@variable"] = { fg = mycolors.palette["smalt-blue"]["300"] },
      ["@variable.member"] = { fg = mycolors.palette["star-dust"]["400"] },
      ["@property"] = { link = "@variable.member" },

      -- Function = { fg = mycolors.palette["blue-chill"]["300"] },
      Function = { fg = mycolors.palette["mantis"]["400"] },
      -- String = { fg = mycolors.palette["picton-blue"]["400"] },
      -- String = { fg = "#74b9cc" },
      -- String = { fg = mycolors.palette["mantis"]["300"] },
      String = { fg = mycolors.palette["mantis"]["300"] },

      -- ["PreProc"] = { fg = mycolors.palette["bermuda-gray"]["200"] },
      -- ["PreProc"] = { fg = mycolors.palette["curious-blue"]["400"] },
      -- ["PreProc"] = { fg = "#9ADBB8" },
      -- ["PreProc"] = { fg = "#56A5DA" },
      ["PreProc"] = { fg = mycolors.palette["blue-chill"]["400"], bold = true, italic = true },

      -- for unused variables
      DiagnosticUnnecessary = { link = "@comment" },
      -- DapStoppedLinehl = { bg = mycolors.palette["rose-of-sharon"]["500"] },
      DapStoppedLinehl = { bg = mycolors.palette["kidnapper"]["800"] },

      TabLineFill = { bg = vim.NONE },
    }

    for k, v in pairs(overrides) do
      highlights[k] = v
    end
  end,

  cache = true, -- When set to true, the theme will be cached for better performance

  ---@type table<string, boolean|{enabled:boolean}>
  plugins = {
    -- enable all plugins when not using lazy.nvim
    -- set to false to manually enable/disable plugins
    all = package.loaded.lazy == nil,
    -- uses your plugin manager to automatically enable needed plugins
    -- currently only lazy.nvim is supported
    auto = true,
  },
})

vim.cmd("colorscheme tokyonight")
