local ls = require("luasnip")

-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local fmta = require("luasnip.extras.fmt").fmta

local snippets, autosnippets = {}, {}

local variable_declaration = s(
  "vardecl",
  fmta(
    [[variable "<var_name>" {
<choice>
}]],
    {
      var_name = i(1, "name"),

      choice = c(2, {
        fmta(
          [[type = <var_type>
  description = <var_description>]],
          {
            var_type = i(1, "string"),
            var_description = i(2, "description"),
          }
        ),
        fmta(
          [[
  type = <var_type>
  description = <var_description>
  validation {
    error_message = "<error_message>"
    condition = anytrue([
    <condition>
    ])
  }
]],
          {
            var_type = i(1, "string"),
            var_description = i(2, "description"),
            error_message = i(3, "message"),
            condition = i(4, "condition"),
          }
        ),
      }),
    }
  )
)

table.insert(snippets, variable_declaration)

return snippets, autosnippets
