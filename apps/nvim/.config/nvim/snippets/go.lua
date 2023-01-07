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
-- / => {
--   "hello": "world"
-- }

local rr = postfix(
  { trig = ".rr", match_pattern = ".*" },
  fmt(
    [[
if {} := {match}; {} != nil {{
  return {}
}}
{}
]]   ,
    {
      i(1, "err"),
      match = f(function(_, snip)
        return snip.env.POSTFIX_MATCH:gsub("%s+", "")
      end),
      rep(1),
      rep(1),
      i(0),
    }
  )
)

local nn = postfix(
  { trig = ".nn", match_pattern = ".*" },
  fmt(
    [[
if {} != nil {{
  {}
}}
]]   ,
    {
      f(function(_, snip)
        return snip.env.POSTFIX_MATCH:gsub("%s+", "")
      end),
      i(0, "// body"),
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
]]   ,
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

return snippets, autosnippets
