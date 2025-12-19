-- Simple: Ultra-minimal colorscheme
-- Only 4 syntax colors: keywords, strings, functions, everything else

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "simple"
vim.o.background = "dark"

-- Palettes
local cool = {
  background = "#181818",
  surface = "#252525",
  text = "#c0caf5",
  comment = "#565f89",
  keyword = "#bb9af7", -- purple
  string = "#9ece6a", -- green
  fn = "#7aa2f7", -- blue
  error = "#f7768e",
  warning = "#e0af68",
}

local warm = {
  background = "#1c1917",
  surface = "#292524",
  text = "#e7e5e4",
  comment = "#78716c",
  keyword = "#fb923c", -- orange
  string = "#5eead4", -- teal
  fn = "#fbbf24", -- amber
  error = "#ef4444",
  warning = "#facc15",
}

local mono = {
  background = "#121212",
  surface = "#1e1e1e",
  text = "#d4d4d4",
  comment = "#6b6b6b",
  keyword = "#e2e2e2", -- bright white
  string = "#a0a0a0", -- gray
  fn = "#c8c8c8", -- light gray
  error = "#cf6679",
  warning = "#d4a656",
}

local gruv = {
  background = "#282828",
  surface = "#3c3836",
  text = "#ebdbb2",
  comment = "#928374",
  keyword = "#fe8019", -- orange
  string = "#b8bb26", -- green
  fn = "#83a598", -- aqua
  error = "#fb4934",
  warning = "#fabd2f",
}

local gruvmute = {
  background = "#282828", -- dark charcoal
  surface = "#3c3836", -- dark brownish gray
  -- text = "#d4be98", -- warm sand
  text = "#baae99", -- warm sand
  comment = "#7c6f64", -- muted taupe
  keyword = "#a9b1d6",  -- soft lavender
  string = "#a9b665", -- sage green
  fn = "#7daea3", -- muted aqua
  error = "#ea6962", -- clay red
  warning = "#d8a657", -- golden ochre
}

local p = gruvmute

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Absolute minimum
hi("Normal", { fg = p.text, bg = "NONE" })
hi("Comment", { fg = p.comment, italic = true })
hi("Variable", { fg = p.text })
hi("@variable", { link = "Variable" })
hi("Identifier", { link = "Normal" })
hi("Special", { fg = p.text })
hi("String", { fg = p.string })
hi("Function", { fg = p.fn })
hi("Keyword", { fg = p.keyword })
hi("Statement", { link = "Keyword" })

-- UI essentials
hi("Visual", { bg = p.surface })
hi("Search", { fg = p.background, bg = p.warning })
hi("CursorLine", { bg = p.surface })
hi("LineNr", { fg = p.comment })
hi("Pmenu", { fg = p.text, bg = p.surface })
hi("PmenuSel", { bg = p.comment })

-- Diagnostics
hi("DiagnosticError", { fg = p.error })
hi("DiagnosticWarn", { fg = p.warning })

-- FzfLua
hi("FzfLuaHeaderBind", { fg = p.keyword })
hi("FzfLuaHeaderText", { fg = p.text })
hi("FzfLuaPathColNr", { fg = p.comment })
hi("FzfLuaPathLineNr", { fg = p.string })
hi("FzfLuaBufNr", { fg = p.comment })
hi("FzfLuaTabTitle", { fg = p.fn })
hi("FzfLuaLiveSym", { fg = p.keyword })
hi("FzfLuaFzfMatch", { fg = p.warning, bold = true })
hi("FzfLuaFzfPointer", { fg = p.warning })
hi("FzfLuaFzfMarker", { fg = p.warning })
hi("IncSearch", { fg = p.background, bg = p.warning })
