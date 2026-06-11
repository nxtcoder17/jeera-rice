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

function M.search_module()
  local lang = get_lang()
  if lang then
    hover.search_module(lang)
  end
end

local function parse_doc_args(args)
  local action = "goto_definition"
  local query

  if #args == 1 then
    query = args[1]
  elseif #args > 1 then
    action = args[1]
    query = table.concat(args, " ", 2)
  end

  return action, query
end

function M.doc_command(opts)
  local lang = get_lang()
  if not lang then
    vim.notify("No doc-search adapter for " .. vim.bo.filetype)
    return
  end

  local action, query = parse_doc_args(opts.fargs or {})

  if action == "module" or action == "mod" then
    hover.search_module(lang, query)
    return
  end

  if action == "clear-cache" or action == "clear_cache" or action == "clearcache" then
    M.clear_cache()
    return
  end

  if action == "goto_definition" or action == "definition" or action == "def" or action == "goto" then
    hover.goto_definition(lang, query)
    return
  end

  vim.notify("Unknown Doc action: " .. action .. " (use 'module', 'goto_definition', or 'clear-cache')")
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
vim.api.nvim_create_user_command("Doc", M.doc_command, {
  nargs = "*",
  desc = "Doc: [type] query (default type: goto_definition)",
  complete = function(arglead, cmdline, cursorpos)
    local prefix = string.sub(cmdline, 1, cursorpos)
    local parts = vim.split(prefix, "%s+", { trimempty = true })
    local fargs = vim.list_slice(parts, 2)
    local action, _ = parse_doc_args(fargs)

    if #fargs <= 1 and (action == "goto_definition" or action == "") then
      local items = { "goto_definition", "definition", "def", "goto", "module", "mod", "clear-cache" }
      return vim.tbl_filter(function(item)
        return string.sub(item, 1, #arglead) == arglead
      end, items)
    end
    return {}
  end,
})

-- vim.keymap.set("n", "gd", M.goto_definition, { desc = "[DocSearch] Goto Definition" })
-- vim.keymap.set("n", "gf", M.search_module, { desc = "[DocSearch] Search Module" })

return M
