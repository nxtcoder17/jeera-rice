-- doc-search-v2/init.lua — Entry point (Simplified)

local import = require("plugins.doc-search-v2.pkg")
local engine = import("engine")
local hover = import("hover")

local M = {}

local function get_lang(ft)
  ft = ft or vim.bo.filetype
  if ft == "go" then
    return import("lang.go")
  elseif ft:match("javascript") or ft:match("typescript") then
    return import("lang.nodejs")
  end
  return nil
end

function M.search()
  local lang = get_lang()
  if lang then
    engine.search({ lang = lang })
  else
    vim.notify("No doc-search adapter for " .. vim.bo.filetype)
  end
end

function M.hover()
  local lang = get_lang()
  if lang then
    hover.show(lang)
  end
end

function M.goto_definition()
  local lang = get_lang()
  if lang then
    hover.goto_definition(lang)
  end
end

function M.clear_cache()
  import("cache").clear()
  vim.notify("doc-search cache cleared")
end

-- Commands
vim.api.nvim_create_user_command("DS", M.search, { desc = "Doc Search" })
vim.api.nvim_create_user_command("DSHover", M.hover, { desc = "Doc Hover" })
vim.api.nvim_create_user_command("DSGoto", M.goto_definition, { desc = "Doc Search Goto Definition" })
vim.api.nvim_create_user_command("DSClear", M.clear_cache, { desc = "Doc Search Clear Cache" })

return M
