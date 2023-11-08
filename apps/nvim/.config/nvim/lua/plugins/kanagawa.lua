-- see, color palette here: https://github.com/rebelot/kanagawa.nvim#color-palette

-- local palette_colors = {
--   -- Bg Shades
--   sumiInk0 = "#16161D",
--   sumiInk1b = "#181820",
--   sumiInk1c = "#1a1a22",
--   sumiInk1 = "#1F1F28",
--   sumiInk2 = "#2A2A37",
--   sumiInk3 = "#363646",
--   sumiInk4 = "#54546D",
--   -- Popup and Floats
--   waveBlue1 = "#223249",
--   waveBlue2 = "#2D4F67",
--   -- Diff and Git
--   winterGreen = "#2B3328",
--   winterYellow = "#49443C",
--   winterRed = "#43242B",
--   winterBlue = "#252535",
--   autumnGreen = "#76946A",
--   autumnRed = "#C34043",
--   autumnYellow = "#DCA561",
--   -- Diag
--   samuraiRed = "#E82424",
--   roninYellow = "#FF9E3B",
--   waveAqua1 = "#6A9589",
--   dragonBlue = "#658594",
--   -- Fg and Comments
--   oldWhite = "#C8C093",
--   fujiWhite = "#DCD7BA",
--   fujiGray = "#727169",
--   springViolet1 = "#938AA9",
--   oniViolet = "#957FB8",
--   crystalBlue = "#7E9CD8",
--   springViolet2 = "#9CABCA",
--   springBlue = "#7FB4CA",
--   lightBlue = "#A3D4D5", -- unused yet
--   waveAqua2 = "#7AA89F", -- improve lightness: desaturated greenish Aqua
--   -- waveAqua2  = "#68AD99",
--   -- waveAqua4  = "#7AA880",
--   -- waveAqua5  = "#6CAF95",
--   -- waveAqua3  = "#68AD99",
--
--   springGreen = "#98BB6C",
--   boatYellow1 = "#938056",
--   boatYellow2 = "#C0A36E",
--   carpYellow = "#E6C384",
--   sakuraPink = "#D27E99",
--   waveRed = "#E46876",
--   peachRed = "#FF5D62",
--   surimiOrange = "#FFA066",
--   katanaGray = "#717C7C",
-- }

local kanagawa_theme = "wave" -- "wave" or "dragon" or "lotus"
local kanagawa_colors = require("kanagawa.colors").setup({ theme = kanagawa_theme })

local colors = {
  theme = {
    all = {
      ui = {
        bg_gutter = "none",
      },
    },
  },

  palette = {
    nxtSelection1 = "#273e5e",
    MiniIndentscopeSymbol = "red",
    oniViolet = kanagawa_colors.lightBlue,
  },
}

local function nxt_colors()
  return {
    identifier = "#b5a68a", -- modified carp-yellow
    constants = "#b09b74", -- modified from constants
    builtin_variable = "#639fa8",

    function_name = "#86a1bf",
    boolean = "#dea27c",
    namespace = "#4ba9eb",
    property = "#a7b37d",
    include = "#4799a1",

    window_background = "#111414",
  }
end

local function recommended_for_floating_windows(theme)
  return {
    NormalFloat = { bg = "none" },
    FloatBorder = { bg = "none" },
    FloatTitle = { bg = "none" },

    -- Save an hlgroup with dark background and dimmed foreground
    -- so that you can use it where your still want darker windows.
    -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
    NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

    -- Popular plugins that open floats will link to NormalFloat by default;
    -- set their background accordingly if you wish to keep them dark and borderless
    LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
    MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

    TelescopeTitle = { fg = theme.ui.special, bold = true },
    TelescopePromptNormal = { bg = theme.ui.bg_p1 },
    TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
    TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
    TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
    TelescopePreviewNormal = { bg = theme.ui.bg_dim },
    TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
  }
end

local overrides = function(themeColors)
  local theme = themeColors.theme
  local changes = {
    Normal = {
      -- bg = "#252626",
      -- bg = "#171a1a",
      bg = nxt_colors().window_background,
    },
    Visual = {
      bg = colors.palette.nxtSelection1,
    },
    TSException = {
      fg = kanagawa_colors.palette.oniViolet,
    },
    TSKeywordReturn = {
      fg = kanagawa_colors.palette.lightBlue,
    },
    javascriptTSVariableBuiltin = {
      fg = kanagawa_colors.palette.lightBlue,
    },
    DiagnosticError = {
      bg = kanagawa_colors.palette.winterRed,
      fg = kanagawa_colors.palette.peachRed,
    },
    DiagnosticSignError = {
      -- bg = vim.NIL,
      fg = kanagawa_colors.palette.peachRed,
    },
    ["@keyword.return"] = {
      fg = kanagawa_colors.palette.dragonGreen2,
    },
    ["@method"] = {
      -- fg = themeColors.palette.roninYellow,
      -- fg = "#dce09b",
      -- fg = "#b3b58a",
      fg = nxt_colors().function_name,
      -- bold = true,
      -- italic = true,
    },
    ["@function"] = {
      -- fg = "#dce09b",
      -- fg = "#b3b58a",
      fg = nxt_colors().function_name,
    },
    ["@method.call"] = {
      -- fg = themeColors.palette.roninYellow,
      fg = themeColors.palette.crystalBlue,
    },

    ["@variable"] = {
      fg = nxt_colors().identifier,
    },

    ["@variable.builtin"] = {
      fg = nxt_colors().builtin_variable,
    },

    ["@constant"] = {
      fg = nxt_colors().constants,
    },

    ["Constant"] = {
      fg = nxt_colors().constants,
    },

    ["@field"] = {
      fg = nxt_colors().identifier,
    },
    ["@boolean"] = {
      fg = nxt_colors().boolean,
    },
    ["@namespace"] = {
      -- go packages
      fg = nxt_colors().namespace,
    },

    ["@property"] = {
      -- .<something>
      fg = nxt_colors().property,
    },
    ["@include"] = {
      -- <package> name
      fg = nxt_colors().include,
    },

    Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
    PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
    PmenuSbar = { bg = theme.ui.bg_m1 },
    PmenuThumb = { bg = theme.ui.bg_p2 },
  }

  return vim.tbl_deep_extend("force", changes, recommended_for_floating_windows(themeColors.theme))
end

vim.opt.fillchars:append({
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┨",
  vertright = "┣",
  verthoriz = "╋",
})

require("kanagawa").setup({
  compile = true,
  uncercurl = true,
  globalStatus = true,
  transparent = true,
  overrides = overrides,
  colors = colors,
  keywordStyle = { italic = true },
  specialReturn = true, -- special highlight for the return keyword
  theme = "wave",
  background = {
    dark = "wave",
    light = "lotus",
  },
})
