local M = {}

_G.R = function(pkg)
	package.loaded[pkg or "functions.dev"] = nil
	return require(pkg or "functions.dev")
end

M.closeFloating = function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local config = vim.api.nvim_win_get_config(win)
		if config.relative ~= "" then
			vim.api.nvim_win_close(win, false)
			-- print("Closing window", win)
		end
	end
end

M.impl = function()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local sorters = require("telescope.sorters")
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local implement_interface = function(prompt_bufnr)
		actions.close(prompt_bufnr)
		local entry = action_state.get_selected_entry()
		vim.api.nvim_command(":GoImpl " .. entry.value)
	end

	function my_custom_picker(results)
		pickers.new(opts, {
			prompt_title = "Select interface to implement",
			finder = finders.new_table(results),
			sorter = sorters.fuzzy_with_index_bias(),
			attach_mappings = function(_, map)
				map("i", "<cr>", implement_interface)
				return true
			end,
		}):find()
	end

	d = vim.lsp.diagnostic.get_all()
	local bufnr = vim.api.nvim_get_current_buf()
	l = {}
	curr_diagnostics = d[bufnr]

	for _, w in ipairs(curr_diagnostics) do
		-- print(vim.inspect(w))
		msg = w.message
		match = string.match(msg, "does not implement")
		if match == nil then
		else
			op = string.gsub(msg, "(.*(does not implement ))", "")
			op = string.gsub(op, "(( .missing method ).*)", "")
			table.insert(l, op)
		end
	end

	for _, v in ipairs(d) do
		for _, w in ipairs(v) do
			msg = w.message
			match = string.match(msg, "does not implement")

			if match == nil then
			else
				op = string.gsub(msg, "(.*(does not implement ))", "")
				op = string.gsub(op, "(( .missing method ).*)", "")
				table.insert(l, op)
			end
		end
	end
	my_custom_picker(l)
end

return M
