local source = {}

local all_hl_groups = vim.api.nvim_get_hl(0, {})

local items = {}

for k, v in pairs(all_hl_groups) do
  -- [source](https://github.com/hrsh7th/nvim-cmp/blob/e1f1b40790a8cb7e64091fb12cc5ffe350363aa0/lua/cmp/entry.lua#L117)
  table.insert(items, {
    label = "hl-" .. k,
    insertText = k,
    filterText = "hl-" .. string.lower(k),
    insertTextFormat = require("cmp.types").lsp.InsertTextFormat.Snippet,
    detail = vim.inspect(v),
  })
end

source.new = function()
  local self = setmetatable({}, { _index = source })
  self.items = items
  return self
end

source.get_keyword_pattern = function()
  -- match only the hl- prefix
  -- based on: https://github.com/hrsh7th/cmp-emoji/blob/e8398e2adf512a03bb4e1728ca017ffeac670a9f/lua/cmp_emoji/init.lua#L15

  -- local prefix = "hl-"
  return [=[\%([[:space:]"'`]\|^\)\zshl-\w*]=]
end
--
source.is_available = function()
  return vim.bo.filetype == "lua"
end

source.complete = function(self, _params, callback)
  callback({ items = items, isIncomplete = false })
end

source.get_trigger_characters = function()
  return { "hl-" }
end

return source
