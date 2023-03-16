local tsQuery = require("vim.treesitter.query")

local function pp(arg)
	print(vim.inspect(arg))
end

local function suggestVarName(name)
	if name == "error" then
		return "err"
	end
	return name:sub(1, 1):lower()
end

local M = {}

M.gen_return = function()
	local api = vim.api
	local lsp = vim.lsp

	bufnr = vim.api.nvim_get_current_buf()
	lang = vim.api.nvim_buf_get_option(bufnr, "filetype")

	local parser = vim.treesitter.get_parser(bufnr, lang)
	local syntax_tree = parser:parse()
	local root = syntax_tree[1]:root()

	local query = vim.treesitter.parse_query(
		lang,
		[[
      (
        (call_expression
          function: (identifier) @funcName (#offset! @funcName 0 1 0 -1)
        ) @funcCall (#offset! @funcCall 0 1 0 -1)
      )

      (
        (call_expression
          function: (selector_expression
                        field: (field_identifier) @funcName (#offset! @funcName 0 1 0 -1)
                    )
        ) @funcCall (#offset! @funcCall 0 1 0 -1)
      )
    ]]
	)

	local p = api.nvim_win_get_cursor(0)

	local lspParams = lsp.util.make_position_params()
	local callStart = { p[1], p[2] }
	local callEnd = { p[1], p[2] }

	for _, captures, metadata in query:iter_matches(root, bufnr) do
		local expressionEndLine = metadata[2].range[3]
		if p[1] - 1 == expressionEndLine then
			local ct = tsQuery.get_node_text(captures[1], bufnr)
			-- pp(ct)
			-- pp(metadata[1].range)
			lspParams.position = {
				character = metadata[1].range[4],
				line = metadata[1].range[3],
			}
			-- pp("metadata 2 the call expression")
			-- pp(metadata[2].range)
			callStart = { metadata[2].range[1], metadata[2].range[2] }
			callEnd = { metadata[2].range[3], metadata[2].range[4] }

			-- pp(callStart)
			-- pp(callEnd)
		end
	end

	local function request(method, params, handler)
		return vim.lsp.buf_request(0, method, params, handler)
	end

	local name = "textDocument/hover"
	local x = request(name, lspParams, function(err, result, ctx, config)
		if result == nil then
			return
		end

		-- pp(result)
		-- pp(result.contents.value)
		local funcString = vim.split(result.contents.value, "\n")[2]
		-- pp()

		local parser = vim.treesitter.get_string_parser(funcString, lang, {})
		local syntax_tree = parser:parse()
		local root = syntax_tree[1]:root()

		local func_defintion_query = [[
      (
        (function_declaration
          name: (identifier) @funcName
          result: (pointer_type) @funcReturn
        ) @value (#offset! @value)
      )

      (
        (function_declaration
          name: (identifier) @funcName
          result: (type_identifier) @funcReturn
        ) @value (#offset! @value)
      )

      (function_declaration
          result: [(parameter_list
            (parameter_declaration
              type: (type_identifier) @funcReturn
            )
          )]
      )

      (function_declaration
        result: [(parameter_list
                  (parameter_declaration
                    type: (qualified_type
                            name: (type_identifier) @funcReturn
                          )
                  )
                )]
      )

    ]]

		local query = vim.treesitter.parse_query(lang, func_defintion_query)
		-- pp(query.iter_captures)

		local rTable = {}

		for _, captures, _ in query:iter_matches(root) do
			local ct = tsQuery.get_node_text(captures[2], funcString)
			-- pp(ct)
		end

		local retTypes = {}
		local varDec = {}

		for c, i in query:iter_captures(root) do
			if c == 2 then
				local ct = tsQuery.get_node_text(i, funcString)
				if retTypes == nil or varDec == nil then
					retTypes = {}
					varDec = {}
				end
				table.insert(retTypes, ct)
				table.insert(varDec, suggestVarName(ct))
			end
		end

		-- pp(retTypes)
		pp(varDec)
		-- pp(callStart)
		local s = vim.api.nvim_buf_get_lines(bufnr, callStart[1], callStart[1] + 1, false)
		-- local s = vim.api.nvim_buf_get_lines(bufnr, 23, 2, false)
		-- pp(table.concat(varDec, ","))

		local declaration_string = table.concat(varDec, ", ") .. " := "

		s[1] = s[1]:sub(1, callStart[2] - 1) .. declaration_string .. s[1]:sub(callStart[2])
		vim.api.nvim_buf_set_lines(bufnr, callStart[1], callStart[1] + 1, false, s)
		-- vim.api.nvim_buf_set_extmark(
		-- 	bufnr,
		-- 	vim.api.nvim_get_current_buf(),
		-- 	callStart[1],
		-- 	callStart[1] - #declaration_string + #varDec[1],
		-- 	{
		-- 		id = vim.api.nvim_create_namespace("nvim-cmp"),
		-- 		right_gravity = false,
		-- 		hl_group = "CmpDocumentationBorder",
		-- 	}
		-- )
		-- vim.api.nvim_buf_set_extmark(
		-- 	bufnr,
		-- 	vim.api.nvim_get_current_buf(),
		-- 	callStart[1],
		-- 	callStart[1] - #declaration_string + #varDec[1],
		-- 	{
		-- 		id = vim.api.nvim_create_namespace("nvim-cmp"),
		-- 		right_gravity = true,
		-- 		hl_group = "CmpDocumentationBorder",
		-- 	}
		-- )
	end)
end

vim.api.nvim_create_user_command("XX", function()
  -- M.gen_return2()
  M.gen_return()
end, {
  desc = "debug gen_return",
})


return M
