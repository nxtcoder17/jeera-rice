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
		pickers.new({}, {
			prompt_title = "Select interface to implement",
			finder = finders.new_table(results),
			sorter = sorters.fuzzy_with_index_bias(),
			attach_mappings = function(_, map)
				map("i", "<cr>", implement_interface)
				return true
			end,
		}):find()
	end

	local bufnr = vim.api.nvim_get_current_buf()
	d = vim.lsp.diagnostic.get_line_diagnostics(bufnr, vim.fn.line(".") - 1, nil, nil)
	for _, block in ipairs(d) do
		if block.code == "InvalidTypeArg" then
			print(block.code)
			print(block.message)

			local _, _, sVar, iName = string.find(block.message, "(.+) does not satisfy (.+) [(].*")
			print(sVar, iName)

			local params = vim.lsp.util.make_position_params(0, nil)
			params.context = {
				includeDeclaration = true,
			}

			local name = "textDocument/typeDefinition"
			vim.lsp.buf_request(0, name, params, function(err, result, ctx, config)
				local client = vim.lsp.get_client_by_id(ctx.client_id)
				local handler = client.handlers[name] or vim.lsp.handlers[name]
				print(vim.inspect(result))
				if result == nil then
					return nil
				end
				pos = { result[1].range.start.line + 1, result[1].range.start.character }
				print(vim.inspect(pos))
				vim.api.nvim_win_set_cursor(0, pos)
				vim.cmd("GoImpl " .. iName)
				vim.cmd("e!")
			end)
		end
	end
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
