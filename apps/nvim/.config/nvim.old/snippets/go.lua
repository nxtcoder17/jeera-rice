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
local strings = require("nxtcoder17.functions.strings")

local snippets, autosnippets = {}, {}

local envitem = s(
	"envitem",
	fmt('{} {} `env:"{}" required:"{}"`', {
		i(1, "var"),
		i(2, "string"),
		d(3, function(args)
			return sn(nil, i(1, strings.snake_case_all_uppercase(args[1][1])))
		end, { 1 }),
		i(4, "true"),
	})
)
table.insert(snippets, envitem)

local rr = postfix(
	{ trig = ".rr", match_pattern = ".*" },
	fmta(
		[[if <p1> := <match>; <p2> != nil {
        return <p3>
      }
      <p4>
    ]],
		{
			p1 = i(1, "err"),
			match = f(function(_, snip)
				return snip.env.POSTFIX_MATCH:gsub("%s+", "")
			end),
			p2 = rep(1),
			p3 = rep(1),
			p4 = i(0),
		}
	)
)

local nn = postfix(
	{ trig = ".nn", match_pattern = ".*" },
	fmta(
		[[if <err> != nil {
        <expr>
      }
    ]],
		{
			err = f(function(_, snip)
				return snip.env.POSTFIX_MATCH:gsub("%s+", "")
			end),
			expr = i(1, "// body"),
		}
	)
)

local df = postfix({ trig = ".df", match_pattern = ".*" }, {
	t('fmt.Printf("%+v\\n", '),
	f(function(_, snip)
		return snip.env.POSTFIX_MATCH
	end),
	t(")"),
})

local pFor = postfix(
	{ trig = ".for", match_pattern = ".*" },
	fmt(
		[[
for {} := range {} {{
  {}
}}
]],
		{
			i(1, "i"),
			f(function(_, snip)
				return snip.env.POSTFIX_MATCH
			end),
			i(0, "//body"),
		}
	)
)

table.insert(snippets, rr)
table.insert(snippets, nn)
table.insert(snippets, df)
table.insert(snippets, pFor)

local t1 = s(
	{ trig = "rx[.](%d)", regTrig = true },
	fmt(
		[[
    let {} = "asdfasfj";
    console.log({})
    ]],
		{
			i(1, "v"),
			rep(1),
		}
	),
	{ t("hello world", {}), f(function(_, snip)
		return snip.captures[1]
	end) }
)

table.insert(snippets, t1)

local func = s(
	"func",
	c(1, {
		fmta(
			[[
    func(<p1>) {
      <p2>
    }
    ]],
			{
				p1 = i(1, ""),
				p2 = i(2, "//body"),
			}
		),
		fmta(
			[[
    func <p1>(<p2>) <p3> {
      <p4>
    }
    ]],
			{
				p1 = i(1, "name"),
				p2 = i(2, ""),
				p3 = i(3, ""),
				p4 = i(0),
			}
		),
		fmta(
			[[
    func (<p1>) <p2>(<p3>) <p4> {
      <p5>
    }
    ]],
			{
				p1 = i(1, "type"),
				p2 = i(2, "name"),
				p3 = i(3, ""),
				p4 = i(4, ""),
				p5 = i(5, "//body"),
			}
		),
	})
)

table.insert(snippets, func)

return snippets, autosnippets
