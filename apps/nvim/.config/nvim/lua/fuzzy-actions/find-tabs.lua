local function find_tabs()
  local tab_names = {}
  local tab_name_to_win_id = {}

  for tabidx, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
    local win_id = vim.api.nvim_tabpage_get_win(tabnr)
    -- local tab_name = tabidx .. " [TAB] " .. require("tabby.util").get_tab_name(tabnr)
    local tab_name = tabidx .. " " .. require("tabby.util").get_tab_name(tabnr)
    table.insert(tab_names, tab_name)

    tab_name_to_win_id[tab_name] = win_id
  end

  require("fzf-lua").fzf_exec(tab_names, {
    prompt = "Tabs ❯ ",
    actions = {
      -- Use fzf-lua builtin actions or your own handler
      ["default"] = function(selected, opts)
        local win_id = tab_name_to_win_id[selected[1]]
        vim.api.nvim_set_current_win(win_id)
      end,
      ["ctrl-d"] = function(selected, opts)
        vim.cmd("tabclose " .. selected[1])
      end,
    },
  })
end

return find_tabs
