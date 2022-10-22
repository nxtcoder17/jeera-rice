local M = {}

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

-- source: https://github.com/kristijanhusak/neovim-config/blob/6d52b0abd8bbdd810854c0655bc158c536210829/nvim/lua/partials/search.lua#L44
M.getSelection = function()
	vim.api.nvim_feedkeys("\027", "xvt", false)
	return vim.fn.getreg("@*")
	-- local s_start = vim.fn.getpos("'<")
	-- local s_end = vim.fn.getpos("'>")
	--
	-- vim.fn.setreg("'<", 0)
	-- vim.fn.setreg("'>", 0)
	--
	--
	-- local n_lines = math.abs(s_end[2] - s_start[2]) + 1
	-- local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
	-- lines[1] = string.sub(lines[1], s_start[3], -1)
	-- if n_lines == 1 then
	-- 	lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
	-- else
	-- 	lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
	-- end
	-- return table.concat(lines, "\n")
end

M.b64Decode = function(text)
	local b64 = require("base64")
	text = text or M.getSelection()
	print("decoding text: ", text)
	local v = b64.decode(text)
	print(v)
	os.execute(string.format("echo %s | xclip -sel clip", v))
	return v
end

M.b64Encode = function()
	local b64 = require("base64")
	text = text or M.getSelection()
	print("encoding text: ", text)
	local v = b64.encode(text)
	print(v)
	os.execute(string.format("echo %s | xclip -sel clip", v))
	return v
end

return M
