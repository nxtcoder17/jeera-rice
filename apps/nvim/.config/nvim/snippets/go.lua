-- require("luasnip.session.snippet_collection").clear_snippets("go")

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

local envitem = s(
  "envitem",
  fmt('{} {} `env:"{}" required:"{}"`', {
    i(1, "var"),
    i(2, "string"),
    d(3, function(args)
      return sn(nil, i(1, string.upper(args[1][1])))
    end, { 1 }),
    i(4, "true"),
  })
)
table.insert(snippets, envitem)

local ifErr = postfix(".nn", {
  f(function(_, parent)
    return "[" .. parent.env.POSTFIX_MATCH .. "]"
  end, {}),
})
table.insert(snippets, ifErr)

return snippets, autosnippets
