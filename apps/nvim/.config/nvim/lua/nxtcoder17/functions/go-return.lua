local tsQuery = require("vim.treesitter.query")

local api = vim.api
local lsp = vim.lsp

local function pp(arg)
  print(vim.inspect(arg))
end

local function suggestVarName(name)
  if name == "error" then
    return "err"
  end

  local varName = name:sub(1, 1):lower()

  for i = 2, #name - 1 do
    local c = name:sub(i, i)
    if c:match("%u") then
      varName = varName .. c:lower()
    end
  end

  return varName
  -- return name:sub(1, 1):lower()
end

local M = {}

M.point_at_function = function()
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
  -- vim.pretty_print("curr pos", p)

  for _, captures, metadata in query:iter_matches(root, bufnr) do
    -- vim.pretty_print("func name:", tsQuery.get_node_text(captures[1], bufnr), "m:", metadata[2].range)
    -- vim.pretty_print("p[1]-1", p[1] - 1, "m:", metadata[2].range)
    if p[1] - 1 == metadata[2].range[1] then
      local ct = tsQuery.get_node_text(captures[1], bufnr)
      -- vim.pretty_print("func name:", ct, "m:", metadata[2].range)

      ---@diagnostic disable-next-line: missing-parameter
      local lspParams = lsp.util.make_position_params()
      lspParams.position = {
        character = metadata[1].range[4],
        line = metadata[1].range[3],
      }

      local call_expression_pos = {
        start = { metadata[2].range[1], metadata[2].range[2] },
            ["end"] = { metadata[2].range[3], metadata[2].range[4] },
      }

      return { call_expression_pos, lspParams }
      --
      -- callStart = { metadata[2].range[1], metadata[2].range[2] }
      -- callEnd = { metadata[2].range[3], metadata[2].range[4] }
    end
  end
end

M.gen_return2 = function()
  local positions = M.point_at_function()

  local call_expression_pos = positions[1]
  local lsp_params = positions[2]

  -- vim.pretty_print("call_expression", call_expression_pos)
  -- vim.pretty_print("lsp_params", lsp_params)

  local function request(method, params, handler)
    return vim.lsp.buf_request(0, method, params, handler)
  end

  local name = "textDocument/hover"
  local x = request(name, lsp_params, function(err, result, ctx, config)
    if result == nil then
      return
    end

    -- vim.pretty_print(result.contents.value)

    ---@diagnostic disable-next-line: missing-parameter
    local funcString = vim.split(result.contents.value, "\n")[2]
    vim.pretty_print("func string:", funcString)

    local bufnr = vim.api.nvim_get_current_buf()
    local lang = vim.api.nvim_buf_get_option(bufnr, "filetype")

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

      -- (func_literal
      --   result: [(parameter_list
      --             (parameter_declaration
      --               type: (slice_type
      --                       element: (type_identifier) @funcReturn
      --                     )
      --             )
      --           )]
      -- )

      (method_declaration
        result: [(parameter_list
                  (parameter_declaration
                    type: (type_identifier) @funcReturn
                  )
                )]
      )

      (method_declaration
        result: [(parameter_list
                  (parameter_declaration
                    type: (pointer_type
                            (qualified_type
                              name: (type_identifier) @funcReturn
                              )
                            )
                  )
                )]
      )
    ]]

    local query = vim.treesitter.parse_query(lang, func_defintion_query)

    local rTable = {}

    for _, captures, _ in query:iter_matches(root) do
      local ct = tsQuery.get_node_text(captures[2], funcString)
      -- vim.pretty_print("### ct:", ct)
    end

    local retTypes = {}
    local varDec = {}

    for c, i in query:iter_captures(root) do
      -- vim.pretty_print("q text:", tsQuery.get_node_text(i, funcString))
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

    -- vim.pretty_print("varDec", varDec)

    local s = vim.api.nvim_buf_get_lines(
      bufnr,
      call_expression_pos.start[1],
      call_expression_pos.start[1] + 1,
      false
    )
    -- local s = vim.api.nvim_buf_get_lines(bufnr, 23, 2, false)
    -- pp(table.concat(varDec, ","))

    local declaration_string = table.concat(varDec, ", ") .. " := "

    s[1] = s[1]:sub(1, call_expression_pos.start[2] - 1)
        .. declaration_string
        .. s[1]:sub(call_expression_pos.start[2])
    -- vim.pretty_print("result_string:", s[1])
    vim.api.nvim_buf_set_lines(bufnr, call_expression_pos.start[1], call_expression_pos.start[1] + 1, false, s)
  end)
end

vim.api.nvim_create_user_command("XX", function()
  local m = R("nxtcoder17.functions.go-return")
  m.gen_return2()
end, {
  desc = "debug gen_return",
})

return M
