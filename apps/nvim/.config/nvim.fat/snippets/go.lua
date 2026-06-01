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

----------- Stolen from: tj devries ---------------
local snippet_from_nodes = ls.sn

local ts_locals = require("nvim-treesitter.locals")
local ts_utils = require("nvim-treesitter.ts_utils")

local get_node_text = vim.treesitter.get_node_text

local transforms = {
	int = function(_, _)
		return t("0")
	end,

	bool = function(_, _)
		return t("false")
	end,

	string = function(_, _)
		return t([[""]])
	end,

	error = function(_, info)
		if info then
			info.index = info.index + 1

			return c(info.index, {
				t(info.err_name),
				t(string.format('errors.Wrap(%s, "%s")', info.err_name, info.func_name)),
			})
		else
			return t("err")
		end
	end,

	-- Types with a "*" mean they are pointers, so return nil
	[function(text)
		return string.find(text, "*", 1, true) ~= nil
	end] = function(_, _)
		return t("nil")
	end,
}

local transform = function(text, info)
	local condition_matches = function(condition, ...)
		if type(condition) == "string" then
			return condition == text
		else
			return condition(...)
		end
	end

	for condition, result in pairs(transforms) do
		if condition_matches(condition, text, info) then
			return result(text, info)
		end
	end

	return t(text)
end

local handlers = {
	parameter_list = function(node, info)
		local result = {}

		local count = node:named_child_count()
		for idx = 0, count - 1 do
			local matching_node = node:named_child(idx)
			local type_node = matching_node:field("type")[1]
			table.insert(result, transform(get_node_text(type_node, 0), info))
			if idx ~= count - 1 then
				table.insert(result, t({ ", " }))
			end
		end

		return result
	end,

	type_identifier = function(node, info)
		local text = get_node_text(node, 0)
		return { transform(text, info) }
	end,
}

local function_node_types = {
	function_declaration = true,
	method_declaration = true,
	func_literal = true,
}

local function go_result_type(info)
	local cursor_node = ts_utils.get_node_at_cursor()
	local scope = ts_locals.get_scope_tree(cursor_node, 0)

	local function_node
	for _, v in ipairs(scope) do
		if function_node_types[v:type()] then
			function_node = v
			break
		end
	end

	if not function_node then
		print("Not inside of a function")
		return t("")
	end

	local query = vim.treesitter.query.parse(
		"go",
		[[
      [
        (method_declaration result: (_) @id)
        (function_declaration result: (_) @id)
        (func_literal result: (_) @id)
      ]
    ]]
	)
	for _, node in query:iter_captures(function_node, 0) do
		if handlers[node:type()] then
			return handlers[node:type()](node, info)
		end
	end
end

local go_ret_vals = function(args)
	return snippet_from_nodes(
		nil,
		go_result_type({
			index = 0,
			err_name = args[1][1],
			func_name = args[2][1],
		})
	)
end

table.insert(
	snippets,
	s(
		"efi",
		fmta(
			[[
<val>, <err> := <f>(<args>)
if <err_same> != nil {
	return <result>
}
<finish>
]],
			{
				val = i(1, "v"),
				err = i(2, "err"),
				f = i(3, "func"),
				args = i(4, "args"),
				err_same = rep(2),
				result = d(5, go_ret_vals, { 2, 3 }),
				finish = i(0),
			}
		)
	)
)

local rr = postfix(
	{ trig = ".rr", match_pattern = ".*" },
	fmta(
		[[if <err> != nil {
        return <result>
      }
     <finish>
    ]],
		{
			err = i(1, "err"),
			result = d(2, go_ret_vals, { 1, 2 }),
			finish = i(0),
		}
	)
)

table.insert(snippets, rr)

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
