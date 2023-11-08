vim.opt.fillchars:append({
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┨",
  vertright = "┣",
  verthoriz = "╋",
})

function variant1()
  require("tokyonight").setup({
    --   -- your configuration comes here
    --   -- or leave it empty to use the default settings
    style = "night",      -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
    light_style = "day",  -- The theme is used when the background is set to light
    transparent = true,   -- Enable this to disable setting the background color
    terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
    styles = {
      -- Style to be applied to different syntax groups
      -- Value is any valid attr-list value for `:help nvim_set_hl`
      comments = { italic = true },
      keywords = { italic = true },
      functions = {},
      variables = {},
      -- Background styles. Can be "dark", "transparent" or "normal"
      sidebars = "dark",            -- style for sidebars, see below
      floats = "dark",              -- style for floating windows
    },
    sidebars = { "qf", "help" },    -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
    day_brightness = 0.3,           -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
    hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
    dim_inactive = false,           -- dims inactive windows
    lualine_bold = false,           -- When `true`, section headers in the lualine theme will be bold

    --- You can override specific color groups to use other groups or a hex color
    --- function will be called with a ColorScheme table
    ---@param colors ColorScheme
    on_colors = function(colors)
      colors.border = "#222b40"
    end,

    --- You can override specific highlights to use other groups or a hex color
    --- function will be called with a Highlights and ColorScheme table
    ---@param highlights Highlights
    ---@param colors ColorScheme
    on_highlights = function(highlights, colors)
      highlights.Normal = { bg = "#1A1B26", fg = "#C0CAF5" }
      --     highlights.Comment = { fg = "#5C6370" }
      --     highlights.Constant = { fg = "#A9B1D6" }
      --     highlights.String = { fg = "#B5CEA8" }
      --     highlights.Character = { fg = "#D7BA7D" }
      --     highlights.Number = { fg = "#D4D4D4" }
      --     highlights.Boolean = { fg = "#569CD6" }
      --     highlights.Float = { fg = "#9CDCFE" }
      --     highlights.Identifier = { fg = "#4EC9B0" }
      --     highlights.Function = { fg = "#DCDCAA" }
      --     highlights.Statement = { fg = "#CE9178" }
      --     highlights.Conditional = { fg = "#C586C0" }
      --     highlights.Repeat = { fg = "#D16969" }
      --     highlights.Label = { fg = "#E0AF68" }
      --     highlights.Operator = { fg = "#B5CEA8" }
      --     highlights.Keyword = { fg = "#C586C0" }
      --     highlights.Exception = { fg = "#F44747" }
      --     highlights.PreProc = { fg = "#D4D4D4" }
      --     highlights.Include = { fg = "#BEBEBE" }
      --     highlights.Define = { fg = "#4EC9B0" }
      --     highlights.Macro = { fg = "#569CD6" }
      --     highlights.PreCondit = { fg = "#9CDCFE" }
      --     highlights.Type = { fg = "#4FC1FF" }
      --     highlights.Structure = { fg = "#B8D7A3" }
      --     highlights.Typedef = { fg = "#A9B1D6" }
      --     highlights.Special = { fg = "#D7BA7D" }
      --     highlights.SpecialChar = { fg = "#569CD6" }
      --     highlights.Tag = { fg = "#4EC9B0" }
      --     highlights.Delimiter = { fg = "#DCDCAA" }
      --     highlights.SpecialComment = { fg = "#608B4E" }
      --     highlights.Debug = { fg = "#B5CEA8" }
      --     highlights.Underlined = { fg = "#569CD6", style = "underline" }
      --     highlights.Bold = { style = "bold" }
      --     highlights.Italic = { style = "italic" }
      --     highlights.Error = { fg = "#F44747" }
      --     highlights.Todo = { fg = "#C586C0" }
      --     highlights.CursorLineNr = { fg = "#C0CAF5" }
      --     highlights.Search = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.IncSearch = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.LineNr = { fg = "#4B5263" }
      --     highlights.SignColumn = { bg = "#1A1B26", fg = "#C0CAF5" }
      --     highlights.StatusLine = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.VertSplit = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.StatusLineNC = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.TabLine = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.TabLineSel = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.TabLineFill = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.Pmenu = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.PmenuSel = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.PmenuSbar = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.PmenuThumb = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.MatchParen = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.NormalFloat = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.FloatBorder = { bg = "#4B5263", fg = "#C0CAF5" }
      --     -- highlights.WarningMsg = { fg = "#FFD700" }
      --     highlights.DiffAdd = { bg = "#587C0C", fg = "#C0CAF5" }
      --     highlights.DiffChange = { bg = "#0C7D9D", fg = "#C0CAF5" }
      --     highlights.DiffDelete = { bg = "#94151B", fg = "#C0CAF5" }
      --     highlights.DiffText = { bg = "#265478", fg = "#C0CAF5" }
      --     highlights.QuickFixLine = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.CursorLine = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.CursorColumn = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.Folded = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.FoldColumn = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.Visual = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.VisualNOS = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.TermCursor = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.TermCursorNC = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.Conceal = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.Whitespace = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.WildMenu = { bg = "#4B5263", fg = "#C0CAF5" }
      --     -- highlights.EndOfBuffer = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.NonText = { bg = "#4B5263", fg = "#C0CAF5" }
      --     highlights.Directory = { fg = "#4EC9B0" }
      --     highlights.Title = { fg = "#4EC9B0" }
      --     -- highlights.Warning = { fg = "#FFD700" }
      --     -- highlights.ModeMsg = { fg = "#FFD700" }
      --     -- highlights.MoreMsg = { fg = "#FFD700" }
      --     -- highlights.Question = { fg = "#FFD700" }
      --     -- highlights.qfLineNr = { fg = "#FFD700" }
      --     -- highlights.qfFileName = { fg = "#FFD700" }
    end,
  })
end

function variant2()
  require("tokyonight").setup({
    style = "night",
    transparent = false,
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = false },
      functions = { bold = true },
      variables = { italic = false },
    },
    sidebars = { "qf", "vista_kind", "terminal", "packer" },
    day_brightness = 0.3,
    hide_inactive_statusline = true,
    dim_inactive = true,
    lualine_bold = true,

    on_colors = function(colors)
      -- General colors
      colors.bg = "#1a1b26"        -- Dark background
      colors.bg_highlight = "#292e42" -- Lighter background for selected lines
      colors.fg = "#a9b1d6"        -- Default foreground
      colors.fg_dark = "#545c7e"   -- Darker text foreground
      colors.fg_gutter = "#3b4261" -- Line number foreground
      colors.dark5 = "#737aa2"

      -- Syntax colors
      colors.red = "#db4b4b" -- Red for errors only
      colors.green = "#9ece6a" -- Soft green for strings
      colors.blue = "#7aa2f7" -- Soft blue for keywords
      colors.yellow = "#e0af68" -- Pale yellow for variables
      colors.purple = "#bb9af7" -- Muted purple
      colors.cyan = "#7dcfff" -- Soft cyan
      colors.orange = "#ff9e64" -- Gentle orange for types

      -- Override colors for a more subdued look
      colors.error = colors.red
      colors.warning = colors.yellow
      colors.info = colors.blue
      colors.hint = colors.cyan
    end,

    on_highlights = function(highlights, colors)
      -- Override highlight groups with custom colors
      highlights.Normal = { bg = colors.bg, fg = colors.fg }
      highlights.Comment = { fg = colors.dark5, style = "italic" }
      highlights.Conditional = { fg = colors.purple, style = "italic" }
      highlights.Constant = { fg = colors.orange }
      highlights.String = { fg = colors.green }
      highlights.Character = { fg = colors.green }
      highlights.Number = { fg = colors.orange }
      highlights.Boolean = { fg = colors.orange }
      highlights.Float = { fg = colors.orange }
      highlights.Identifier = { fg = colors.yellow }
      highlights.Function = { fg = colors.blue, style = "bold" }
      highlights.Statement = { fg = colors.purple }
      highlights.PreProc = { fg = colors.yellow }
      highlights.Type = { fg = colors.orange }
      highlights.Special = { fg = colors.blue }
      highlights.Underlined = { style = "underline" }
      highlights.Error = { fg = colors.error }
      highlights.Todo = { fg = colors.purple, bg = colors.bg_highlight, style = "bold" }
      highlights.LineNr = { fg = colors.fg_gutter }
      highlights.CursorLineNr = { fg = colors.fg }
      highlights.Search = { bg = colors.dark5 }
      highlights.IncSearch = { bg = colors.orange, fg = colors.bg }
      highlights.Visual = { bg = colors.dark5 }
      highlights.SignColumn = { bg = colors.bg }
      highlights.StatusLine = { bg = colors.dark5, fg = colors.fg }
      highlights.StatusLineNC = { bg = colors.bg_highlight, fg = colors.fg_dark }
      highlights.TabLine = { bg = colors.bg_highlight, fg = colors.fg_dark }
      highlights.TabLineSel = { bg = colors.dark5, fg = colors.fg }
      highlights.TabLineFill = { bg = colors.bg }
      highlights.DiagnosticError = { fg = colors.error }
      highlights.DiagnosticWarn = { fg = colors.warning }
      highlights.DiagnosticInfo = { fg = colors.info }
      highlights.DiagnosticHint = { fg = colors.hint }
    end,
  })
end

function variant3()
  require("tokyonight").setup({
    style = "night",
    transparent = false,
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = false },
      functions = { bold = false },
      variables = { italic = false },
    },
    sidebars = { "qf", "vista_kind", "terminal", "packer" },
    day_brightness = 0.3,
    hide_inactive_statusline = true,
    dim_inactive = true,
    lualine_bold = true,

    on_colors = function(colors)
      -- General colors with enhanced contrast for better readability
      colors.bg = "#1a1b26"        -- Dark background
      colors.bg_highlight = "#32374d" -- Darker highlight for contrast
      colors.fg = "#c0c0d0"        -- Brighter foreground for better readability
      colors.fg_dark = "#626880"   -- Slightly brighter text for dark foreground
      colors.fg_gutter = "#464b61" -- Line number foreground with more contrast
      colors.dark5 = "#7e8294"     -- Adjusted for contrast

      -- Syntax colors with more vibrant hues for distinction
      colors.red = "#ff6666" -- Brighter red for errors
      colors.green = "#bae67e" -- More vibrant green for strings
      colors.blue = "#5ccfe6" -- More vivid blue for keywords
      colors.yellow = "#ffd580" -- Brighter yellow for variables
      colors.purple = "#c3a6ff" -- More vivid purple
      colors.cyan = "#5ccfe6" -- More vivid cyan
      colors.orange = "#ffae57" -- Brighter orange for types

      -- Overriding colors for a clearer and more distinguishable palette
      colors.error = colors.red
      colors.warning = colors.yellow
      colors.info = colors.blue
      colors.hint = colors.cyan
    end,

    on_highlights = function(highlights, colors)
      -- Custom highlight groups for improved readability
      highlights.Normal = { bg = colors.bg, fg = colors.fg }
      highlights.Comment = { fg = colors.fg_dark, style = "italic" }
      highlights.Conditional = { fg = colors.purple, style = "none" }
      highlights.Constant = { fg = colors.orange }
      highlights.String = { fg = colors.green }
      highlights.Character = { fg = colors.green }
      highlights.Number = { fg = colors.orange }
      highlights.Boolean = { fg = colors.orange }
      highlights.Float = { fg = colors.orange }
      highlights.Identifier = { fg = colors.yellow }
      highlights.Function = { fg = colors.blue, style = "bold" }
      highlights.Statement = { fg = colors.purple }
      highlights.PreProc = { fg = colors.yellow }
      highlights.Type = { fg = colors.orange }
      highlights.Special = { fg = colors.blue }
      highlights.Underlined = { style = "underline" }
      highlights.Error = { fg = colors.error }
      highlights.Todo = { fg = colors.fg, bg = colors.bg_highlight, style = "bold,underline" }
      highlights.LineNr = { fg = colors.fg_gutter }
      highlights.CursorLineNr = { fg = colors.fg }
      highlights.Search = { bg = colors.dark5 }
      highlights.IncSearch = { bg = colors.orange, fg = colors.bg }
      highlights.Visual = { bg = colors.bg_highlight }
      highlights.SignColumn = { bg = colors.bg }
      highlights.StatusLine = { bg = colors.dark5, fg = colors.fg }
      highlights.StatusLineNC = { bg = colors.bg_highlight, fg = colors.fg_dark }
      highlights.TabLine = { bg = colors.bg_highlight, fg = colors.fg_dark }
      highlights.TabLineSel = { bg = colors.dark5, fg = colors.fg }
      highlights.TabLineFill = { bg = colors.bg }
      highlights.DiagnosticError = { fg = colors.error }
      highlights.DiagnosticWarn = { fg = colors.warning }
      highlights.DiagnosticInfo = { fg = colors.info }
      highlights.DiagnosticHint = { fg = colors.hint }
    end,
  })
end

function variant4()
  require("tokyonight").setup({
    style = "night",
    transparent = false,
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = false },
      functions = { bold = false },
      variables = { italic = false },
    },
    sidebars = { "qf", "vista_kind", "terminal", "packer" },
    -- day_brightness = 0.3,
    hide_inactive_statusline = false,
    dim_inactive = false,

    on_colors = function(colors)
      -- Completely new general colors
      colors.bg = "#282c34"        -- Deep space blue background
      colors.bg_highlight = "#3e4451" -- Smoky dark blue for selected lines
      colors.fg = "#abb2bf"        -- Soft off-white foreground for general text
      colors.fg_dark = "#5c6370"   -- Slate grey for less prominent text
      colors.fg_gutter = "#636d83" -- Bluish grey for gutter and line numbers
      colors.dark5 = "#4b5363"     -- Dark blue-grey for status lines

      -- New syntax colors for a distinctive look
      colors.red = "#e06c75" -- Warm pinkish-red for errors
      colors.green = "#98c379" -- Fresh green for strings
      colors.blue = "#61afef" -- Sky blue for keywords
      colors.yellow = "#e5c07b" -- Sand yellow for functions and titles
      colors.purple = "#c678dd" -- Soft lavender for constants
      colors.cyan = "#56b6c2" -- Ocean cyan for emphasis
      colors.orange = "#d19a66" -- Earthy orange for variables

      -- Assigning the new palette to diagnostic colors
      colors.error = colors.red
      colors.warning = colors.orange
      colors.info = colors.blue
      colors.hint = colors.cyan
    end,

    on_highlights = function(highlights, colors)
      -- Using the new color scheme for syntax highlighting
      highlights.Normal = { bg = colors.bg, fg = colors.fg }
      highlights.Comment = { fg = colors.fg_dark, style = "italic" }
      highlights.Conditional = { fg = colors.purple, style = "none" }
      highlights.Constant = { fg = colors.purple }
      highlights.String = { fg = colors.green }
      highlights.Character = { fg = colors.green }
      highlights.Number = { fg = colors.orange }
      highlights.Boolean = { fg = colors.red }
      highlights.Float = { fg = colors.orange }
      highlights.Identifier = { fg = colors.yellow }
      highlights.Function = { fg = colors.yellow, style = "bold" }
      highlights.Statement = { fg = colors.blue }
      highlights.PreProc = { fg = colors.purple }
      highlights.Type = { fg = colors.cyan }
      highlights.Special = { fg = colors.blue }
      highlights.Underlined = { style = "underline" }
      highlights.Error = { fg = colors.error }
      highlights.Todo = { fg = colors.yellow, bg = colors.bg_highlight, style = "bold,underline" }
      highlights.LineNr = { fg = colors.fg_gutter }
      highlights.CursorLineNr = { fg = colors.fg }
      highlights.Search = { bg = colors.dark5 }
      highlights.IncSearch = { bg = colors.orange, fg = colors.bg }
      highlights.Visual = { bg = colors.bg_highlight }
      highlights.SignColumn = { bg = colors.bg }
      highlights.StatusLine = { bg = colors.dark5, fg = colors.fg }
      highlights.StatusLineNC = { bg = colors.bg_highlight, fg = colors.fg_dark }
      highlights.TabLine = { bg = colors.bg_highlight, fg = colors.fg_dark }
      highlights.TabLineSel = { bg = colors.dark5, fg = colors.fg }
      highlights.TabLineFill = { bg = colors.bg }
      highlights.DiagnosticError = { fg = colors.error }
      highlights.DiagnosticWarn = { fg = colors.warning }
      highlights.DiagnosticInfo = { fg = colors.info }
      highlights.DiagnosticHint = { fg = colors.hint }
    end,
  })
end

function variant5()
  require("tokyonight").setup({
    style = "night",
    transparent = false,
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = false },
      functions = { bold = true },
      variables = { italic = false },
    },
    sidebars = { "qf", "vista_kind", "terminal", "packer" },
    day_brightness = 0.3,
    hide_inactive_statusline = true,
    dim_inactive = true,
    lualine_bold = true,

    on_colors = function(colors)
      -- New general colors for a fresh look
      colors.bg = "#1d1f21"        -- Charcoal black for the background
      colors.bg_highlight = "#282a2e" -- Dark slate gray for highlighted lines
      colors.fg = "#c5c8c6"        -- Light gray for foreground text
      colors.fg_dark = "#969896"   -- Medium gray for secondary text
      colors.fg_gutter = "#373b41" -- Dark gray for gutter and line numbers
      colors.dark5 = "#1d1f21"     -- Matching the background for consistency in UI elements

      -- New syntax color palette
      colors.red = "#cc6666" -- Brick red for errors and warnings
      colors.green = "#b5bd68" -- Olive green for strings and comments
      colors.blue = "#81a2be" -- Steel blue for keywords and statements
      colors.yellow = "#f0c674" -- Mustard yellow for functions and titles
      colors.purple = "#b294bb" -- Thistle purple for constants
      colors.cyan = "#8abeb7" -- Light sea green for support and decorators
      colors.orange = "#de935f" -- Sienna orange for variables and tags

      -- Diagnostic colors adjusted to the new palette
      colors.error = colors.red
      colors.warning = colors.orange
      colors.info = colors.blue
      colors.hint = colors.cyan
    end,

    on_highlights = function(highlights, colors)
      -- Apply the new color scheme for syntax highlighting
      highlights.Normal = { bg = colors.bg, fg = colors.fg }
      highlights.Comment = { fg = colors.green, style = "italic" }
      highlights.Conditional = { fg = colors.blue, style = "none" }
      highlights.Constant = { fg = colors.purple }
      highlights.String = { fg = colors.green }
      highlights.Character = { fg = colors.green }
      highlights.Number = { fg = colors.yellow }
      highlights.Boolean = { fg = colors.red }
      highlights.Float = { fg = colors.yellow }
      highlights.Identifier = { fg = colors.orange }
      highlights.Function = { fg = colors.yellow, style = "bold" }
      highlights.Statement = { fg = colors.blue }
      highlights.PreProc = { fg = colors.purple }
      highlights.Type = { fg = colors.cyan }
      highlights.Special = { fg = colors.blue }
      highlights.Underlined = { style = "underline" }
      highlights.Error = { fg = colors.error }
      highlights.Todo = { fg = colors.yellow, bg = colors.bg_highlight, style = "bold,underline" }
      highlights.LineNr = { fg = colors.fg_gutter }
      highlights.CursorLineNr = { fg = colors.fg }
      highlights.Search = { bg = colors.dark5 }
      highlights.IncSearch = { bg = colors.orange, fg = colors.bg }
      highlights.Visual = { bg = colors.bg_highlight }
      highlights.SignColumn = { bg = colors.bg }
      highlights.StatusLine = { bg = colors.dark5, fg = colors.fg }
      highlights.StatusLineNC = { bg = colors.bg_highlight, fg = colors.fg_dark }
      highlights.TabLine = { bg = colors.bg_highlight, fg = colors.fg_dark }
      highlights.TabLineSel = { bg = colors.dark5, fg = colors.fg }
      highlights.TabLineFill = { bg = colors.bg }
      highlights.DiagnosticError = { fg = colors.error }
      highlights.DiagnosticWarn = { fg = colors.warning }
      highlights.DiagnosticInfo = { fg = colors.info }
      highlights.DiagnosticHint = { fg = colors.hint }
    end,
  })
end

function variant6()
  require("tokyonight").setup({
    style = "night",
    transparent = false,
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = false },
      functions = { bold = true },
      variables = { italic = false },
    },
    sidebars = { "qf", "vista_kind", "terminal", "packer" },
    day_brightness = 0.3,
    hide_inactive_statusline = true,
    dim_inactive = true,
    lualine_bold = true,

    on_colors = function(colors)
      -- New general colors for a fresh look
      colors.bg = "#242730"        -- Deep space sparkle for the background
      colors.bg_highlight = "#2e3440" -- Outer space accent for highlighted lines
      colors.fg = "#d8dee9"        -- Light blue-gray for foreground text
      colors.fg_dark = "#4c566a"   -- Dark blue-gray for secondary text
      colors.fg_gutter = "#434c5e" -- Slate gray for gutter and line numbers
      colors.dark5 = "#3b4252"     -- Darker shade for UI elements

      -- New syntax color palette
      colors.red = "#bf616a" -- Salmon red for errors and warnings
      colors.green = "#a3be8c" -- Pastel green for strings and comments
      colors.blue = "#5e81ac" -- Glacier blue for keywords and statements
      colors.yellow = "#ebcb8b" -- Harvest gold for functions and titles
      colors.purple = "#b48ead" -- Faded purple for constants
      colors.cyan = "#88c0d0" -- Powder blue for support and decorators
      colors.orange = "#d08770" -- Dusty orange for variables and tags

      -- Diagnostic colors adjusted to the new palette
      colors.error = colors.red
      colors.warning = colors.orange
      colors.info = colors.blue
      colors.hint = colors.cyan
    end,

    on_highlights = function(highlights, colors)
      -- Apply the new color scheme for syntax highlighting
      highlights.Normal = { bg = colors.bg, fg = colors.fg }
      highlights.Comment = { fg = colors.green, style = "italic" }
      highlights.Conditional = { fg = colors.blue, style = "none" }
      highlights.Constant = { fg = colors.purple }
      highlights.String = { fg = colors.green }
      highlights.Character = { fg = colors.green }
      highlights.Number = { fg = colors.yellow }
      highlights.Boolean = { fg = colors.red }
      highlights.Float = { fg = colors.yellow }
      highlights.Identifier = { fg = colors.orange }
      highlights.Function = { fg = colors.yellow, style = "bold" }
      highlights.Statement = { fg = colors.blue }
      highlights.PreProc = { fg = colors.purple }
      highlights.Type = { fg = colors.cyan }
      highlights.Special = { fg = colors.blue }
      highlights.Underlined = { style = "underline" }
      highlights.Error = { fg = colors.error }
      highlights.Todo = { fg = colors.yellow, bg = colors.bg_highlight, style = "bold,underline" }
      highlights.LineNr = { fg = colors.fg_gutter }
      highlights.CursorLineNr = { fg = colors.fg }
      highlights.Search = { bg = colors.dark5 }
      highlights.IncSearch = { bg = colors.orange, fg = colors.bg }
      highlights.Visual = { bg = colors.bg_highlight }
      highlights.SignColumn = { bg = colors.bg }
      highlights.StatusLine = { bg = colors.dark5, fg = colors.fg }
      highlights.StatusLineNC = { bg = colors.bg_highlight, fg = colors.fg_dark }
      highlights.TabLine = { bg = colors.bg_highlight, fg = colors.fg_dark }
      highlights.TabLineSel = { bg = colors.dark5, fg = colors.fg }
      highlights.TabLineFill = { bg = colors.bg }
      highlights.DiagnosticError = { fg = colors.error }
      highlights.DiagnosticWarn = { fg = colors.warning }
      highlights.DiagnosticInfo = { fg = colors.info }
      highlights.DiagnosticHint = { fg = colors.hint }
    end,
  })
end

variant1()
