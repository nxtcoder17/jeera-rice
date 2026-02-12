-- Palettes
-- local cool = {
--   background = "#181818",
--   surface = "#252525",
--   text = "#c0caf5",
--   comment = "#565f89",
--   keyword = "#bb9af7", -- purple
--   string = "#9ece6a", -- green
--   fn = "#7aa2f7", -- blue
--   error = "#f7768e",
--   warning = "#e0af68",
-- }

local p = loadfile(vim.fn.stdpath("config") .. "/colors/generated/" .. vim.o.background .. ".lua")()

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
hi("Type", { link = "Keyword" })
hi("@type.builtin.go", { link = "Type" })

-- UI essentials
hi("Visual", { bg = require("lib.color").darken(p.comment, 70) })
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

-- typescript
hi("@type.builtin.typescript", { link = "Type" })
