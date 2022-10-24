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

require("luasnip.loaders.from_lua").load({ paths = { vim.g.nvim_dir .. "/snippets" } })

ls.setup({
	history = true,
	update_events = "TextChanged,TextChangedI",
	delete_check_events = "TextChanged",
})

ls.add_snippets("lua", {
	s("hi", fmt("hi hello", {})),
})

require("luasnip.loaders.from_snipmate").lazy_load({ paths = { vim.g.nvim_dir .. "/snippets" } })
