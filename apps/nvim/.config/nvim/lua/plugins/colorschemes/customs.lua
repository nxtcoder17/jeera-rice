local function tokyonight_everforest()
  local everforest = {
    -- sourced from https://github.com/neanias/everforest-nvim/blob/6e06de0a08afc09c7e63acc4ace8c748fe48d8b9/lua/everforest/colours.lua#L136C1-L171C2
    base_palette = {
      light = {
        fg = "#5c6a72",
        red = "#f85552",
        orange = "#f57d26",
        yellow = "#dfa000",
        green = "#8da101",
        aqua = "#35a77c",
        blue = "#3a94c5",
        purple = "#df69ba",
        grey0 = "#a6b0a0",
        grey1 = "#939f91",
        grey2 = "#829181",
        statusline1 = "#93b259",
        statusline2 = "#708089",
        statusline3 = "#e66868",
        none = "NONE",
      },
      dark = {
        fg = "#d3c6aa",
        red = "#e67e80",
        orange = "#e69875",
        yellow = "#dbbc7f",
        green = "#a7c080",
        aqua = "#83c092",
        blue = "#7fbbb3",
        purple = "#d699b6",
        grey0 = "#7a8478",
        grey1 = "#859289",
        grey2 = "#9da9a0",
        statusline1 = "#a7c080",
        statusline2 = "#d3c6aa",
        statusline3 = "#e67e80",
        none = "NONE",
      },
    },
    -- sourced from  https://github.com/neanias/everforest-nvim/blob/6e06de0a08afc09c7e63acc4ace8c748fe48d8b9/lua/everforest/colours.lua#L40
    hard_background = {
      dark = {
        bg_dim = "#1e2326",
        bg0 = "#272e33",
        bg1 = "#2e383c",
        bg2 = "#374145",
        bg3 = "#414b50",
        bg4 = "#495156",
        bg5 = "#4f5b58",
        bg_visual = "#4c3743",
        bg_red = "#493b40",
        bg_green = "#3c4841",
        bg_blue = "#384b55",
        bg_yellow = "#45443c",
      },
      light = {
        bg_dim = "#f2efdf",
        bg0 = "#fffbef",
        bg1 = "#f8f5e4",
        bg2 = "#f2efdf",
        bg3 = "#edeada",
        bg4 = "#e8e5d5",
        bg5 = "#bec5b2",
        bg_visual = "#f0f2d4",
        bg_red = "#ffe7de",
        bg_green = "#f3f5d9",
        bg_blue = "#ecf5ed",
        bg_yellow = "#fef2d5",
      },
    },
  }

  -- ---@type table<string, table<string, string>>
  -- local highlights = {
  --   Normal = {
  --     -- fg = everforest.base_palette.dark.fg,
  --     -- bg = everforest.hard_background.dark.bg0,
  --   },
  --   LineNr = {
  --     fg = everforest.base_palette.dark.grey0,
  --   },
  --   FzfLuaBorder = {
  --     fg = everforest.hard_background.dark.bg2,
  --   },
  -- }
  -- Define basic colors
  local colors = {
    bg = "#282c34",      -- soft dark background
    fg = "#abb2bf",      -- foreground for regular text
    fg_gutter = "#636d83", -- gutter and line numbers
    black = "#1b1f27",   -- for darker background elements
    red = "#e06c75",     -- reserved for errors and problems
    green = "#98c379",   -- strings and success messages
    yellow = "#e5c07b",  -- TODOs and accents
    blue = "#61afef",    -- functions, methods, and headers
    magenta = "#c678dd", -- parameters, classes, types
    cyan = "#56b6c2",    -- keywords, storage
    white = "#dcdfe4",   -- for lighter text
    orange = "#d19a66",  -- constants, enums
    purple = "#c882e7",  -- special characters
    comment = "#5c6370", -- comments and inactive text
    error = "#be5046",   -- errors and warnings
    warning = "#d19a66", -- warnings and hints
    info = "#56b6c2",    -- information messages
    hint = "#c678dd",    -- hints and suggestions
  }

  -- Define the colorscheme based on the above colors
  local highlights = {
    -- Provide values for the highlight groups
    Comment = { fg = colors.comment },
    ColorColumn = { bg = colors.black },
    Conceal = { fg = colors.comment },
    Cursor = { fg = colors.bg, bg = colors.fg },
    lCursor = { fg = colors.bg, bg = colors.fg },
    CursorIM = { fg = colors.bg, bg = colors.fg },
    CursorColumn = { bg = colors.black },
    CursorLine = { bg = colors.black },
    Directory = { fg = colors.blue },
    DiffAdd = { bg = colors.green },
    DiffChange = { bg = colors.yellow },
    DiffDelete = { bg = colors.red },
    DiffText = { bg = colors.blue },
    EndOfBuffer = { fg = colors.bg },
    ErrorMsg = { fg = colors.red },
    VertSplit = { fg = colors.comment },
    Folded = { fg = colors.blue, bg = colors.black },
    FoldColumn = { fg = colors.comment, bg = colors.bg },
    SignColumn = { fg = colors.fg_gutter, bg = colors.bg },
    Substitute = { bg = colors.red, fg = colors.black },
    LineNr = { fg = colors.fg_gutter },
    CursorLineNr = { fg = colors.fg },
    MatchParen = { fg = colors.magenta, bold = true },
    ModeMsg = { fg = colors.white, bold = true },
    MsgArea = { fg = colors.white },
    MoreMsg = { fg = colors.blue },
    NonText = { fg = colors.comment },
    Normal = { fg = colors.fg, bg = colors.bg },
    NormalNC = { fg = colors.fg, bg = colors.bg },
    Pmenu = { bg = colors.black, fg = colors.fg },
    PmenuSel = { bg = colors.blue, fg = colors.black },
    PmenuSbar = { bg = colors.black },
    PmenuThumb = { bg = colors.fg_gutter },
    Question = { fg = colors.blue },
    QuickFixLine = { bg = colors.purple, bold = true },
    Search = { bg = colors.blue, fg = colors.bg },
    IncSearch = { bg = colors.orange, fg = colors.bg },
    SpecialKey = { fg = colors.purple },
    SpellBad = { sp = colors.red, undercurl = true },
    SpellCap = { sp = colors.yellow, undercurl = true },
    SpellLocal = { sp = colors.cyan, undercurl = true },
    SpellRare = { sp = colors.purple, undercurl = true },
    StatusLine = { fg = colors.white, bg = colors.black },
    StatusLineNC = { fg = colors.comment, bg = colors.black },
    TabLine = { bg = colors.black, fg = colors.comment },
    TabLineFill = { bg = colors.black },
    TabLineSel = { fg = colors.bg, bg = colors.blue },
    Title = { fg = colors.blue, bold = true },
    Visual = { bg = colors.purple },
    WarningMsg = { fg = colors.warning },
    Whitespace = { fg = colors.comment },
    WildMenu = { bg = colors.purple },
    Constant = { fg = colors.orange },
    String = { fg = colors.green },
    Character = { fg = colors.green },
    Identifier = { fg = colors.magenta },
    Function = { fg = colors.blue },
    Statement = { fg = colors.cyan },
    Operator = { fg = colors.cyan },
    Keyword = { fg = colors.cyan },
    PreProc = { fg = colors.cyan },
    Type = { fg = colors.blue },
    Special = { fg = colors.blue },
    Debug = { fg = colors.orange },
    Underlined = { underline = true },
    Bold = { bold = true },
    Italic = { italic = true },
    Error = { fg = colors.error },
    Todo = { bg = colors.yellow, fg = colors.bg },
    DiagnosticError = { fg = colors.error },
    DiagnosticWarn = { fg = colors.warning },
    DiagnosticInfo = { fg = colors.info },
    DiagnosticHint = { fg = colors.hint },
    DiagnosticUnderlineError = { undercurl = true, sp = colors.error },
    DiagnosticUnderlineWarn = { undercurl = true, sp = colors.warning },
    DiagnosticUnderlineInfo = { undercurl = true, sp = colors.info },
    DiagnosticUnderlineHint = { undercurl = true, sp = colors.hint },

    --
    FzfLuaBorder = { fg = everforest.hard_background.dark.bg2 },
  }

  -- -- Return the theme to be used by the colorscheme
  -- return theme

  for group, spec in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, spec)
  end
end

vim.cmd("colorscheme tokyonight")
-- tokyonight_everforest()

local function mycolorscheme()
  local palette = {
    bg = "#282c34",
    fg = "#abb2bf",
    fg_gutter = "#4b5263",
    black = "#1c1e26",
    red = "#e06c75",
    green = "#98c379",
    yellow = "#e5c07b",
    blue = "#61afef",
    magenta = "#c678dd",
    cyan = "#56b6c2",
    white = "#abb2bf",
    orange = "#d19a66",
    pink = "#ff6ac1",
    comment = "#5c6370",
    bg_highlight = "#2c313a",
    dark3 = "#3e4452",
    dark5 = "#282c34",
    blue5 = "#61afef",
    magenta2 = "#c678dd",
    error = "#f44747",
    warning = "#ff8800",
    info = "#d7deea",
    hint = "#dcdfe4",
    git = {
      add = "#109868",
      change = "#6183bb",
      delete = "#9A353D",
      conflict = "#bb7a61",
    },
    gitSigns = {
      add = "#109868",
      change = "#6183bb",
      delete = "#9A353D",
    },
    popup_back = "#282c34",
    search_orange = "#613214",
    search_blue = "#5e81ac",
    teal = "#519ABA",
    orange = "#FF8800",
    cyan_test = "#4EC9B0",
    purple_test = "#C586C0",
    dark_purple_test = "#5c6370",
    folder_bg = "#51afef",
  }

  local c = palette -- Alias for ease of use
  local options =
  { styles = { comments = "italic", functions = "NONE", keywords = "bold", strings = "NONE", variables = "NONE" } }

  -- Now we fill the highlight groups with the above colors
  theme.highlights = {
    Foo = { bg = c.magenta2, fg = c.fg },

    Comment = { fg = c.comment, style = options.styles.comments }, -- any comment
    ColorColumn = { bg = c.black },                              -- used for the columns set with 'colorcolumn'
    Conceal = { fg = c.dark5 },                                  -- placeholder characters substituted for concealed text (see 'conceallevel')
    Cursor = { fg = c.bg, bg = c.fg },                           -- character under the cursor
    lCursor = { fg = c.bg, bg = c.fg },                          -- the character under the cursor when |language-mapping| is used (see 'guicursor')
    CursorIM = { fg = c.bg, bg = c.fg },                         -- like Cursor, but used when in IME mode |CursorIM|
    CursorColumn = { bg = c.bg_highlight },                      -- Screen-column at the cursor, when 'cursorcolumn' is set.
    CursorLine = { bg = c.bg_highlight },                        -- Screen-line at the cursor, when 'cursorline' is set. Low-priority if foreground (ctermfg OR guifg) is not set.
    Directory = { fg = c.blue },                                 -- directory names (and other special names in listings)
    DiffAdd = { bg = c.git.add },                                -- diff mode: Added line |diff.txt|
    DiffChange = { bg = c.git.change },                          -- diff mode: Changed line |diff.txt|
    DiffDelete = { bg = c.git.delete },                          -- diff mode: Deleted line |diff.txt|
    DiffText = { bg = c.search_blue },                           -- diff mode: Changed text within a changed line |diff.txt|
    EndOfBuffer = { fg = c.bg },                                 -- filler lines (~) after the end of the buffer. By default, this is highlighted like |hl-NonText|.
    ErrorMsg = { fg = c.error },                                 -- error messages on the command line
    VertSplit = { fg = c.dark3 },                                -- the column separating vertically split windows
    WinSeparator = { fg = c.dark3, bold = true },                -- the column separating vertically split windows
    Folded = { fg = c.blue, bg = c.dark5 },                      -- line used for closed folds
    FoldColumn = { bg = c.bg, fg = c.comment },                  -- 'foldcolumn'
    SignColumn = { bg = c.bg, fg = c.fg_gutter },                -- column where |signs| are displayed
    SignColumnSB = { bg = c.bg_highlight, fg = c.fg_gutter },    -- column where |signs| are displayed
    Substitute = { bg = c.yellow, fg = c.bg },                   -- |:substitute| replacement text highlighting
    LineNr = { fg = c.fg_gutter },                               -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
    CursorLineNr = { fg = c.blue },                              -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
    MatchParen = { fg = c.orange, bold = true },                 -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
    ModeMsg = { fg = c.white, bold = true },                     -- 'showmode' message (e.g., "-- INSERT -- ")
    MsgArea = { fg = c.white },                                  -- Area for messages and cmdline
    MoreMsg = { fg = c.blue },                                   -- |more-prompt|
    NonText = { fg = c.dark3 },                                  -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
    Normal = { fg = c.fg, bg = c.bg },                           -- normal text
    NormalNC = { fg = c.fg, bg = c.bg },                         -- normal text in non-current windows
    NormalSB = { fg = c.fg, bg = c.bg_highlight },               -- normal text in sidebar
    NormalFloat = { fg = c.fg, bg = c.popup_back },              -- Normal text in floating windows.
    FloatBorder = { fg = c.blue, bg = c.popup_back },
    Pmenu = { bg = c.bg_highlight, fg = c.fg },                  -- Popup menu: normal item.
    PmenuSel = { bg = c.dark_purple_test },                      -- Popup menu: selected item.
    PmenuSbar = { bg = c.bg },                                   -- Popup menu: scrollbar.
    PmenuThumb = { bg = c.dark3 },                               -- Popup menu: Thumb of the scrollbar.
    Question = { fg = c.blue },                                  -- |hit-enter| prompt and yes/no questions
    QuickFixLine = { bg = c.bg_highlight, bold = true },         -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
    Search = { bg = c.search_orange, fg = c.bg },                -- Last search pattern highlighting (see 'hlsearch'). Also used for similar items that need to stand out.
    IncSearch = { bg = c.search_orange, fg = c.bg },             -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
    SpecialKey = { fg = c.dark3 },                               -- Unprintable characters: text displayed differently from what it really is. But not 'listchars' whitespace. |hl-Whitespace|
    SpellBad = { sp = c.error, undercurl = true },               -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
    SpellCap = { sp = c.warning, undercurl = true },             -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
    SpellLocal = { sp = c.info, undercurl = true },              -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
    SpellRare = { sp = c.hint, undercurl = true },               -- Word that is recognized by the spellchecker as one that is hardly ever used. |spell| Combined with the highlighting used otherwise.
    StatusLine = { fg = c.fg, bg = c.bg_highlight },             -- status line of current window
    StatusLineNC = { fg = c.comment, bg = c.bg_highlight },      -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
    TabLine = { bg = c.bg_highlight, fg = c.comment },           -- tab pages line, not active tab page label
    TabLineFill = { bg = c.bg },                                 -- tab pages line, where there are no labels
    TabLineSel = { fg = c.bg, bg = c.blue },                     -- tab pages line, active tab page label
    Title = { fg = c.blue, bold = true },                        -- titles for output from ":set all", ":autocmd" etc.
    Visual = { bg = c.dark_purple_test },                        -- Visual
  }
end

local function mycolorscheme2()
  local c = {
    none = "NONE",
    bg_dark = "#1E1E1E",
    -- bg = "#2A2A2A",
    bg = "#000000",
    bg_highlight = "#363636",
    fg = "#D4D4D4",
    fg_dark = "#A0A0A0",
    fg_gutter = "#4B5263",
    dark5 = "#73797E",
    blue = "#61AFEF",
    cyan = "#56B6C2",
    -- blue1 = "#223E55",
    blue1 = "green",
    blue2 = "#2B6F77",
    -- blue5 = "#0D3A58",
    blue5 = "red",
    blue7 = "#4E88B4",
    magenta = "#C678DD",
    magenta2 = "#7A36C1",
    purple = "#5D4B7E",
    orange = "#D19A66",
    yellow = "#E5C07B",
    green = "#98C379",
    green1 = "#58B19F",
    green2 = "#7EC7A2",
    red1 = "#D45E51",
    black = "#282C34",
    red = "#D45E51",
    error = "#D45E51",
    warning = "#FFAF00",
    info = "#0DB9D7",
    hint = "#10B981",
    success = "#10B981",
    diff = {
      add = "#31392B",
      change = "#283040",
      delete = "#332D2E",
      text = "#2C5372",
    },
    git = {
      change = "#2188FF",
      add = "#28A745",
      delete = "#D73A49",
      conflict = "#E36209",
      text = "#79B8FF",
    },
    gitSigns = {
      add = "#587C0C",
      change = "#0C7D9D",
      delete = "#94151B",
    },
    border = "#3E4451",
    border_highlight = "#C0CAF5",
    bg_popup = "#333842",
    bg_statusline = "#22262E",
    bg_sidebar = "#252931",
    bg_float = "#2D3139",
    bg_search = "#3E4451",
    bg_visual = "#3E4451",
    bg_diff = "#34324A",
    fg_sidebar = "#8B949E",
    fg_float = "#C8D0E0",
    fg_diff = "#C8D0E0",
    fg_diff_text = "#C8D0E0",
    bold = "#FFFFFF", -- Set bold text color to white
    italic = "#D4D4D4", -- Set italic text color to a lighter shade of gray
  }

  -- local options =
  -- { transparent = false, styles = { comments = "italic", keywords = "bold", functions = "italic,bold" } }
  --
  local highlights = {
    Foo = { bg = c.magenta2, fg = c.fg },
    Comment = { fg = c.fg_dark, italic = true },
    ColorColumn = { bg = c.black },
    Conceal = { fg = c.dark5 },
    Cursor = { fg = c.bg, bg = c.fg },
    lCursor = { fg = c.bg, bg = c.fg },
    CursorIM = { fg = c.bg, bg = c.fg },
    CursorColumn = { bg = c.bg_highlight },
    CursorLine = { bg = c.bg_highlight },
    Delimiter = { fg = "#ffffff" },
    Directory = { fg = c.blue },
    DiffAdd = { bg = c.diff.add },
    DiffChange = { bg = c.diff.change },
    DiffDelete = { bg = c.diff.delete },
    DiffText = { bg = c.diff.text },
    EndOfBuffer = { fg = c.bg },
    ErrorMsg = { fg = c.error },
    VertSplit = { fg = c.border },
    WinSeparator = { fg = c.border, bold = true },
    Folded = { fg = c.blue, bg = c.fg_gutter },
    FoldColumn = { bg = c.bg, fg = c.fg_dark },
    SignColumn = { bg = c.bg, fg = c.fg_gutter },
    SignColumnSB = { bg = c.bg_sidebar, fg = c.fg_gutter },
    Substitute = { bg = c.red, fg = c.black },
    LineNr = { fg = c.fg_gutter },
    CursorLineNr = { fg = c.dark5 },
    MatchParen = { fg = c.orange, bold = true },
    ModeMsg = { fg = c.fg_dark, bold = true },
    MsgArea = { fg = c.fg_dark },
    MoreMsg = { fg = c.blue },
    NonText = { fg = c.dark3 },
    Normal = { fg = c.fg, bg = c.bg },
    NormalNC = { fg = c.fg, bg = c.bg_dark },
    NormalSB = { fg = c.fg_sidebar, bg = c.bg_sidebar },
    NormalFloat = { fg = c.fg_float, bg = c.bg_float },
    FloatBorder = { fg = c.border_highlight, bg = c.bg_float },
    FloatTitle = { fg = c.border_highlight, bg = c.bg_float },
    Pmenu = { bg = c.bg_popup, fg = c.fg },
    PmenuSel = { bg = c.bg_visual },
    PmenuSbar = { bg = c.bg_float },
    PmenuThumb = { bg = c.fg_gutter },
    Question = { fg = c.blue },
    QuickFixLine = { bg = c.bg_visual, bold = true },
    Search = { bg = c.bg_search, fg = c.fg },
    IncSearch = { bg = c.orange, fg = c.black },
    SpecialKey = { fg = c.dark3 },
    SpellBad = { sp = c.error, undercurl = true },
    SpellCap = { sp = c.warning, undercurl = true },
    SpellLocal = { sp = c.info, undercurl = true },
    SpellRare = { sp = c.hint, undercurl = true },
    StatusLine = { fg = c.fg_sidebar, bg = c.bg_statusline },
    StatusLineNC = { fg = c.fg_gutter, bg = c.bg_statusline },
    TabLine = { bg = c.bg_statusline, fg = c.fg_gutter },
    TabLineFill = { bg = c.black },
    TabLineSel = { fg = c.black, bg = c.blue },
    Title = { fg = c.blue, bold = true },
    Visual = { bg = c.bg_visual },
    VisualNOS = { bg = c.bg_visual },
    WarningMsg = { fg = c.warning },
    Whitespace = { fg = c.fg_gutter },
    WildMenu = { bg = c.bg_visual },
    Constant = { fg = c.orange },
    String = { fg = c.green },
    Character = { fg = c.green },
    Identifier = { fg = c.magenta },
    Function = { fg = c.blue, bold = true },
    Statement = { fg = c.magenta },
    Operator = { fg = c.blue5 },
    Keyword = { fg = c.cyan, bold = true },
    PreProc = { fg = c.cyan },
    Type = { fg = c.blue1 },
    Special = { fg = c.blue1 },
    Debug = { fg = c.orange },
    Underlined = { underline = true },
    Bold = { bold = true },
    Italic = { italic = true },
    Error = { fg = c.error },
    Todo = { bg = c.yellow, fg = c.bg },
    DiagnosticError = { fg = c.error },
    DiagnosticWarn = { fg = c.warning },
    DiagnosticInfo = { fg = c.info },
    DiagnosticHint = { fg = c.hint },
    DiagnosticUnderlineError = { undercurl = true, sp = c.error },
    DiagnosticUnderlineWarn = { undercurl = true, sp = c.warning },
    DiagnosticUnderlineInfo = { undercurl = true, sp = c.info },
    DiagnosticUnderlineHint = { undercurl = true, sp = c.hint },

    -- Diagnostic related
    -- DiagnosticVirtualTextError = { bg = util.darken(c.error, 0.1), fg = c.error },
    -- DiagnosticVirtualTextWarn = { bg = util.darken(c.warning, 0.1), fg = c.warning },
    -- DiagnosticVirtualTextInfo = { bg = util.darken(c.info, 0.1), fg = c.info },
    -- DiagnosticVirtualTextHint = { bg = util.darken(c.hint, 0.1), fg = c.hint },

    -- LSP
    LspReferenceText = { bg = c.bg_highlight },
    LspReferenceRead = { bg = c.bg_highlight },
    LspReferenceWrite = { bg = c.bg_highlight },
    LspDiagnosticsDefaultError = { fg = c.error },
    LspDiagnosticsDefaultWarning = { fg = c.warning },
    LspDiagnosticsDefaultInformation = { fg = c.info },
    LspDiagnosticsDefaultHint = { fg = c.hint },

    -- Treesitter
    -- These will link to the appropriate groups above
    ["@debug"] = { link = "@debug" },
    ["@define"] = { link = "@define" },
    ["@structure"] = { link = "@structure" },
    ["@include"] = { link = "@include" },
    ["@constant"] = { link = "Constant" },
    ["@function"] = { link = "Function" },
    ["@label"] = { link = "Label" },
    ["@comment"] = { link = "Comment" },
    ["@doctag"] = { link = "Type" },
    ["@constructor"] = { link = "Special" },
    ["@parameter"] = { link = "Identifier" },
    ["@annotation"] = { link = "PreProc" },
    ["@attribute"] = { link = "PreProc" },
    ["@boolean"] = { link = "Boolean" },
    ["@character"] = { link = "Character" },
    ["@conditional"] = { link = "Conditional" },
    ["@constant.builtin"] = { link = "Special" },
    ["@constant.macro"] = { link = "Define" },
    ["@error"] = { link = "Error" },
    ["@exception"] = { link = "Exception" },
    ["@field"] = { link = "Identifier" },
    ["@float"] = { link = "Float" },
    ["@function.builtin"] = { link = "Special" },
    ["@function.macro"] = { link = "Macro" },
    ["@keyword"] = { link = "Keyword" },
    ["@keyword.function"] = { link = "Keyword" },
    ["@keyword.operator"] = { link = "Operator" },
    ["@keyword.return"] = { link = "Keyword" },
    ["@method"] = { link = "Function" },
    ["@namespace"] = { link = "Include" },
    ["@none"] = { link = "Ignore" },
    ["@number"] = { link = "Number" },
    ["@operator"] = { link = "Operator" },
    ["@parameter.reference"] = { link = "Identifier" },
    ["@preproc"] = { link = "PreProc" },
    ["@property"] = { link = "Identifier" },
    ["@punctuation.bracket"] = { link = "Delimiter" },
    ["@punctuation.delimiter"] = { link = "Delimiter" },
    ["@punctuation.special"] = { link = "Delimiter" },
    ["@repeat"] = { link = "Repeat" },
    ["@storageclass"] = { link = "StorageClass" },
    ["@string"] = { link = "String" },
    ["@string.regex"] = { link = "String" },
    ["@string.escape"] = { link = "SpecialChar" },
    ["@symbol"] = { link = "Identifier" },
    ["@tag"] = { link = "Label" },
    ["@tag.attribute"] = { link = "Identifier" },
    -- Additional groups based on tree-sitter
    ["@tag.delimiter"] = { link = "Delimiter" },
    ["@text"] = { link = "Normal" },
    ["@text.strong"] = { link = "Bold" },
    ["@text.emphasis"] = { link = "Italic" },
    ["@text.underline"] = { link = "Underlined" },
    ["@text.strike"] = { link = "Strikethrough" },
    ["@text.title"] = { link = "Title" },
    ["@text.literal"] = { link = "String" },
    ["@text.uri"] = { link = "Underlined" },
    ["@text.reference"] = { link = "Constant" },
    ["@type"] = { link = "Type" },
    ["@type.builtin"] = { link = "Type" },
    ["@variable"] = { link = "Identifier" },
    ["@variable.builtin"] = { link = "Special" },
  }

  for group, spec in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, spec)
  end
end

-- mycolorscheme2()
