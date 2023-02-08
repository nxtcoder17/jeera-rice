local re = require("rex_pcre")
local M = {}
local tsQuery = require("vim.treesitter.query")

M.go_impl = function()
	d = vim.lsp.diagnostic.get_line_diagnostics()
	for _, v in ipairs(d) do
		if v.code == "InvalidTypeArg" then
			print(v.message)
			-- local i = re.match(v.message, "(%*?%w+) does not implement")
			-- local i = re.match(v.message, "([\\*?\\w]+) does not implement")
			local i = re.match(v.message, "([\\*\\w]+\\b) does not implement (\\b[\\*\\.\\w]+\\b)")
			print(i)
		end
	end
end

M.restore_tabs = function()
	local json = require("dkjson")
	local test = assert(io.open("/tmp/abc.txt", "r"))
	local tu = require("tabby.util")
	local s = test:read("*a")
	test:close()
	local tbl, pos, err = json.decode(s, 1, nil)
	print(vim.inspect(tbl), pos, err)
	for i, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
		-- tu.set_tab_name(tabnr, string.gsub(vim.cmd("pwd"), path, ""))
		tu.set_tab_name(tabnr, re.gsub(vim.fn.getcwd(), ".*/", ""))
	end
end

local hasTabby = function()
	return packer_plugins["tabby.nvim"] and packer_plugins["tabby.nvim"].loaded
end

M.run = function()
	if hasTabby() then
		local tabs = vim.api.nvim_list_tabpages()
		vim.cmd("tabrewind")
		for tabidx, tabnr in ipairs(tabs) do
			pwd = vim.fn.getcwd()
			name = string.gsub(pwd, "(.*(/))", "")

			vim.cmd("TabRename " .. name)
			vim.cmd("tabnext")
		end

		vim.cmd("tabrewind")
	end
end

M.save_tabs = function()
	local json = require("dkjson")
	local tu = require("tabby.util")
	local tbl = {}
	for i, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
		table.insert(tbl, tu.get_tab_name(tabnr))
	end
	local s = json.encode(tbl, { indent = true })
	print(s)
	local test = assert(io.open("/tmp/abc.txt", "w"))
	test:write(s)
	test:close()
end

M.close_other_buffers = function()
	local bufs = vim.api.nvim_list_bufs()
	for _, bufnr in ipairs(bufs) do
		print(bufnr)
		local bufName = vim.api.nvim_buf_get_name(bufnr)
		local bufLabel = trim(string.sub(vim.api.nvim_buf_get_name(bufnr), vim.fn.getcwd():len() + 2))
	end
end

local pp = function(v)
	print(vim.inspect(v))
end

M.AddFieldToStruct = function(field_name, field_type)
	local api = vim.api
	local lsp = vim.lsp

	bufnr = bufnr or vim.api.nvim_get_current_buf()
	lang = lang or vim.api.nvim_buf_get_option(bufnr, "filetype")

	local parser = vim.treesitter.get_parser(bufnr, lang, {})
	local syntax_tree = parser:parse()
	local root = syntax_tree[1]:root()

	local query = vim.treesitter.parse_query(
		lang,
		[[
    (
      (composite_literal 
        type: (type_identifier) @pType
        body: (literal_value
                (keyed_element) @fieldKey
              )
      ) @value (#offset! @value)
    )
  ]]
	)

	local m = {}

	for _, captures, metadata in query:iter_matches(root, bufnr) do
		print(vim.inspect(tsQuery.get_node_text(captures[1], bufnr)))
		-- pp(getmetatable(captures[1]))
		-- pp(metadata[3].range[1])
		-- pp(metadata[3].range[2])
		m.line, m.col = metadata[3].range[1], metadata[3].range[2]
		-- pp(captures[1]:start())
		-- print(vim.inspect(captures), captures[1]:start())
	end

	local fieldName = vim.fn.expand("<cword>")
	field_name = fieldName

	-- vim.cmd("norm! 3b")
	-- local structName = vim.fn.expand("<cword>")
	-- print("fieldName", fieldName, "structName", structName)

	local p = api.nvim_win_get_cursor(0)

	local params = lsp.util.make_position_params()
	params.position = {
		-- character = p[2],
		-- line = vim.fn.line(".") - 1,
		character = m.col,
		line = m.line,
	}
	params.context = {
		includeDeclaration = true,
	}

	print(vim.inspect(params))

	local function request(method, params, handler)
		return vim.lsp.buf_request(0, method, params, handler)
	end

	local name = "textDocument/typeDefinition"
	request(name, params, function(err, result, ctx, config)
		local client = vim.lsp.get_client_by_id(ctx.client_id)
		local handler = client.handlers[name] or vim.lsp.handlers[name]
		print("HEllo ", vim.inspect(result))

		if result == nil then
			return
		end

		local start_position = result[1].range.start
		local end_position = result[1].range["end"]
		-- local start_line, start_col = start_position.line + 1, start_position.character + 1
		-- local end_line, end_col = end_position.line + 1, end_position.character

		local start_line, start_col = start_position.line, start_position.character + 1
		local end_line, end_col = end_position.line + 1, end_position.character

		local text = api.nvim_buf_get_lines(0, start_line, end_line, false)
		local new_field = string.format("%s %s", field_name, field_type)
		table.insert(text, new_field)
		api.nvim_buf_set_lines(0, start_line, end_line, false, text)
	end)
end

return M
