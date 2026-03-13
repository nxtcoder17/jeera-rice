-- doc-search-v2/init.lua — Entry point and filetype dispatch

local import = require("plugins.doc-search-v2.pkg")
local engine = import("engine")
local hover = import("hover")

local M = {}

-- JS/TS filetypes
local js_filetypes = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
}

-- Get language adapter for current filetype
local function get_lang(ft)
  ft = ft or vim.bo.filetype
  if ft == "go" then
    return import("lang.go")
  elseif js_filetypes[ft] then
    return import("lang.nodejs")
  end
  return nil
end

-- Main search: dispatch to language adapter or show picker
function M.search()
  local lang = get_lang()
  if lang then
    engine.search({
      scope = "workspace",
      symbol_type = "all",
      lang = lang,
    })
    return
  end

  -- No adapter for this filetype — show language picker
  local fzf = require("fzf-lua")
  fzf.fzf_exec({ "go", "javascript/typescript" }, {
    prompt = "Language > ",
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then
          return
        end
        local choice = selected[1]
        local chosen_lang
        if choice == "go" then
          chosen_lang = import("lang.go")
        elseif choice == "javascript/typescript" then
          chosen_lang = import("lang.nodejs")
        end
        if chosen_lang then
          engine.search({
            scope = "workspace",
            symbol_type = "all",
            lang = chosen_lang,
          })
        end
      end,
    },
  })
end

-- Hover: show definition at cursor in float
function M.hover()
  local lang = get_lang()
  hover.show(lang)
end

-- Go to definition: jump to symbol definition
function M.goto_definition()
  local lang = get_lang()
  hover.goto_definition(lang)
end

-- Clear all caches (manual refresh)
function M.clear_cache()
  import("cache").clear()
  vim.notify("doc-search cache cleared")
end

-- Commands for testing
vim.api.nvim_create_user_command("DS", function()
  M.search()
end, { desc = "Doc Search" })
vim.api.nvim_create_user_command("DSHover", function()
  M.hover()
end, { desc = "Doc Search Hover" })
vim.api.nvim_create_user_command("DSGoto", function()
  M.goto_definition()
end, { desc = "Doc Search Goto Definition" })
vim.api.nvim_create_user_command("DSClear", function()
  M.clear_cache()
end, { desc = "Doc Search Clear Cache" })

return M
