local M = {}

--- Get the word under cursor or partial word being typed
local function get_current_word()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2]

	-- Find the start of the word
	local start = col
	while start > 0 and line:sub(start, start):match("[%w_]") do
		start = start - 1
	end
	start = start + 1

	-- Extract the partial word
	local word = line:sub(start, col)
	return word, start, col
end

--- Delete the partial word under cursor
local function delete_partial_word(start_col, end_col)
	local line = vim.api.nvim_get_current_line()
	local row = vim.api.nvim_win_get_cursor(0)[1]

	-- Delete from start to cursor position
	local new_line = line:sub(1, start_col - 1) .. line:sub(end_col + 1)
	vim.api.nvim_buf_set_lines(0, row - 1, row, false, { new_line })

	-- Move cursor to the position where we deleted
	vim.api.nvim_win_set_cursor(0, { row, start_col - 1 })
end

--- Tag completion using fzf-lua
function M.complete_tags()
	local fzf = require("fzf-lua")
	local actions = require("fzf-lua.actions")

	-- Get the current word being typed
	local current_word, start_col, end_col = get_current_word()

	-- Custom action to insert the selected tag
	local function insert_tag(selected, opts)
		if not selected or #selected == 0 then
			return
		end

		-- Parse the selected tag line
		-- Format: "tagname	filename	/pattern/;"	kind
		local tag_line = selected[1]
		local tag_name = tag_line:match("^([^%s\t]+)")

		if not tag_name then
			return
		end

		-- Delete the partial word
		delete_partial_word(start_col, end_col)

		-- Insert the completed tag name
		vim.api.nvim_put({ tag_name }, "c", true, true)

		-- Return to insert mode
		vim.cmd("startinsert!")
	end

	-- Call fzf-lua tags with custom configuration
	fzf.tags({
		query = current_word,
		prompt = "Complete❯ ",
		winopts = {
			height = 0.4,
			width = 0.9,
			row = 0.5,
			preview = {
				layout = "horizontal",
				horizontal = "right:50%",
			},
		},
		actions = {
			["default"] = insert_tag,
			["ctrl-v"] = false, -- Disable split actions in insert mode
			["ctrl-x"] = false,
			["ctrl-t"] = false,
		},
		-- Show preview with file context
		previewer = "builtin",
	})
end

return M
