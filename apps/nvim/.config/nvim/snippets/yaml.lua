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
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local postfix = require("luasnip.extras.postfix").postfix

local snippets, autosnippets = {}, {}

local gql_query = s(
	"gql_query",
	fmta(
		[[
---
label: <p1>
query: |+
  <p2>
variables:
  <p3>
---

]],
		{
			p1 = i(1, "query name"),
			p2 = i(2, "gql query"),
			p3 = i(3, "variables"),
		}
	)
)

table.insert(snippets, gql_query)

return snippets, autosnippets
