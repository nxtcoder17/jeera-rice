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
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

local snippets, autosnippets = {}, {}

local changelog_type = s(
  "changelog_type",
  fmta(
    [[
  ### <header>

  - <pos>
  ]],
    {
      header = c(1, {
        t("Added"),
        t("Changed"),
        t("Deprecated"),
        t("Removed"),
        t("Fixed"),
        t("Security"),
      }),
      pos = i(0),
    }
  )
)

table.insert(snippets, changelog_type)

return snippets, autosnippets
