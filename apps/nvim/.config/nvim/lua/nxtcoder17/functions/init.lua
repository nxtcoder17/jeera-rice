local b64 = require("base64")

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

M.get_selection = function()
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")

	local start_row, start_col = start_pos[2], start_pos[3]
	local end_row, end_col = end_pos[2], end_pos[3]

	local bufnr = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_text(bufnr, start_row - 1, start_col - 1, end_row - 1, end_col, {})

	return table.concat(lines, "\n")
end

M.b64Decode = function(text, opts)
	text = text or M.get_selection()
	opts = opts or { debug = false }
	if opts.debug then
		print("[b64Decode] decoding text: ", text)
	end
	local v = b64.decode(text)
	if opts.debug then
		print("[b64Decode]", v)
	end
	os.execute(string.format("echo -n %s | xclip -sel clip", v))
	return v
end

M.b64Encode = function(text, opts)
	text = text or M.get_selection()
	opts = opts or { debug = false }
	if opts.debug then
		print("[b64Encode]", "encoding text: ", text)
	end
	local v = b64.encode(text)
	if opts.debug then
		print("[b64Encode]", v)
	end
	os.execute(string.format("echo -n %s | xclip -sel clip", v))
	return v
end

return M
