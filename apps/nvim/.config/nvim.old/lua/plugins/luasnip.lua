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
local types = require("luasnip.util.types")

ls.setup({
  history = true,
  enable_autosnippets = true,
  update_events = "TextChanged,TextChangedI",
  delete_check_events = "TextChanged",
  ext_opts = {
    [types.choiceNode] = {
      active = {
        -- virt_text = { { "●", "GruvboxOrange" } },
        virt_text = { { "●", "@keyword.operator" } },
      },
    },
    [types.insertNode] = {
      active = {
        virt_text = { { "●", "@method.call" } },
      },
    },
  },
})

local snippet_paths = {
  vim.g.nxt.nvim_dir .. "/snippets",
  vim.g.nxt.project_root_dir .. "/.nvim/snippets",
  vim.g.nxt.project_root_dir .. "/.tools/nvim/snippets",
}

require("luasnip.loaders.from_lua").load({
  paths = snippet_paths,
})

require("luasnip.loaders.from_snipmate").lazy_load({
  paths = snippet_paths,
})
