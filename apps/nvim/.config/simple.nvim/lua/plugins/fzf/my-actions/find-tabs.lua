local function find_tabs()
	local tab_names = {}
	local tab_name_to_win_id = {}
	local tabbar = require("plugins.ui.tabbar")

	for tabidx, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
		local win_id = vim.api.nvim_tabpage_get_win(tabnr)
		local tab_name = tabidx .. " " .. tabbar.get_tab_name(tabnr)
		table.insert(tab_names, tab_name)

		tab_name_to_win_id[tab_name] = { win_id = win_id, tabnr = tabnr }
	end

	require("fzf-lua").fzf_exec(tab_names, {
		prompt = "Tabs ❯ ",
		actions = {
			["default"] = function(selected, opts)
				local info = tab_name_to_win_id[selected[1]]
				vim.api.nvim_set_current_win(info.win_id)
			end,
			["ctrl-d"] = function(selected, opts)
				vim.cmd("tabclose " .. selected[1])
			end,
			["ctrl-r"] = function(selected, opts)
				local info = tab_name_to_win_id[selected[1]]
				tabbar.rename_tab(info.tabnr)
			end,
		},
	})
end

return find_tabs
