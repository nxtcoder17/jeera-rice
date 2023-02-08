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

-- local var = s(
-- 	"var",
-- 	fmta([[ {{ <p1> := get . "<p2>"}} ]], {
-- 		p1 = rep(1),
-- 		p2 = i(2, "item"),
-- 	})
-- )
--
-- table.insert(snippets, var)

return snippets, autosnippets
