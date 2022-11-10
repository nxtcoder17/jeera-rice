local M = {}

local function P(item)
	print(vim.inspect(item))
end

M.jumps = function(bufnr, lang, opts)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	lang = lang or vim.api.nvim_buf_get_option(bufnr, "filetype")

	opts = opts or { down = true }

	local lang_tree = vim.treesitter.get_parser(bufnr, lang)
	local syntax_tree = lang_tree:parse()
	local root = syntax_tree[1]:root()

	local curr_line_nr = vim.fn.line(".") - 1

	local row = 0
	local prev_row = 0
	-- print(name)
	for c in root:iter_children() do
		if c:type() ~= "\n" then
			if row < curr_line_nr then
				prev_row = row
			end

			if opts.up and prev_row < curr_line_nr and row >= curr_line_nr then
				break
			end

			if opts.down and row > curr_line_nr then
				break
			end

			local name = vim.treesitter.query.get_node_text(c, bufnr)
			row, c, _ = c:start()
		end
	end

	if opts.down then
		vim.fn.setcharpos(".", { bufnr, row + 1, 0, 0 })
	end

	if opts.up then
		vim.fn.setcharpos(".", { bufnr, prev_row + 1, 0, 0 })
	end

	if opts.debug then
		print(string.format("curr: %d, row: %d, prev_row: %d\n", curr_line_nr, row, prev_row))
	end
end

-- local query = vim.treesitter.parse_query(
--   "go",
--   [[
--     (method_declaration) @method
--   ]]
-- )
--
-- for _, captures, metadata in query:iter_matches(root, bufnr) do
--   P(captures[1]:start())
-- end

return M
