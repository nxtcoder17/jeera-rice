local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local postfix = require("luasnip.extras.postfix").postfix

local snippets, autosnippets = {}, {}

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

local env_item = s(
	"env.item",
	fmt('{} {} `env:"{}" required:"{}"`', {
		i(1, "var"),
		i(2, "string"),
		d(3, function(args)
			-- return sn(nil, i(1, strings.snake_case_all_uppercase(args[1][1])))
			return sn(nil, i(1, require("functions.strings").snake_case_all_uppercase(args[1][1])))
		end, { 1 }),
		i(4, "true"),
	})
)
table.insert(snippets, env_item)

local env_template = s(
	"env.template",
	fmta(
		[[
package env

import "github.com/codingconcepts/env"

type Env struct {
  <p1>
}

func LoadEnv() (*Env, error) {
	var ev Env
	if err := env.Set(&ev); err != nil {
		return nil, err
	}
	return &ev, nil
}
]],
		{ p1 = i(1, "// use env.item snippet to fill it") }
	)
)

table.insert(snippets, env_template)

-- table.insert(snippets, s("kubebuilder.marker.enum",
--   fmta("// +kubebuilder:validation:Enum=<p1>", { p1 = i(1, "item1;item2;item3") })
-- ))
--
-- table.insert(snippets, s("kubebuilder.marker.maximum",
--   fmta("// +kubebuilder:validation:Maximum=<p1>", { p1 = i(1, "17") })
-- ))

local iferr = s(
	"iferr",
	fmta(
		[[
if <err> != nil {
  return <result>
}
]],
		{
			err = i(1, "err"),
			result = i(2, "err"),
		}
	)
)

table.insert(snippets, iferr)

return snippets, autosnippets
