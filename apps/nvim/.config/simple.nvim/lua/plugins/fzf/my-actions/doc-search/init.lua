local fzf = require("fzf-lua")

-- JS/TS filetypes
local js_filetypes = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
}

local function doc_search()
  local ft = vim.bo.filetype

  if ft == "go" then
    require("plugins.fzf.my-actions.doc-search.go").functions()
  elseif ft == "lua" then
    require("plugins.fzf.my-actions.doc-search.lua").functions()
  elseif js_filetypes[ft] then
    require("plugins.fzf.my-actions.doc-search.nodejs").functions()
  else
    -- Show language picker
    fzf.fzf_exec({ "go", "lua", "javascript/typescript" }, {
      prompt = "Language ❯ ",
      actions = {
        ["default"] = function(selected)
          if selected and #selected > 0 then
            if selected[1] == "go" then
              require("plugins.fzf.my-actions.doc-search.go").functions()
            elseif selected[1] == "lua" then
              require("plugins.fzf.my-actions.doc-search.lua").functions()
            elseif selected[1] == "javascript/typescript" then
              require("plugins.fzf.my-actions.doc-search.nodejs").functions()
            end
          end
        end,
      },
    })
  end
end

return doc_search
