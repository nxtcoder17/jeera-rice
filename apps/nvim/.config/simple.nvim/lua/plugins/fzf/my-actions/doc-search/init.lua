local fzf = require("fzf-lua")

local function doc_search()
  local ft = vim.bo.filetype

  if ft == "go" then
    require("plugins.fzf.my-actions.doc-search.go").functions()
  elseif ft == "lua" then
    require("plugins.fzf.my-actions.doc-search.lua").modules()
  else
    -- Show language picker
    fzf.fzf_exec({ "go", "lua" }, {
      prompt = "Language ❯ ",
      actions = {
        ["default"] = function(selected)
          if selected and #selected > 0 then
            if selected[1] == "go" then
              require("plugins.fzf.my-actions.doc-search.go").functions()
            elseif selected[1] == "lua" then
              require("plugins.fzf.my-actions.doc-search.lua").modules()
            end
          end
        end,
      },
    })
  end
end

return doc_search
