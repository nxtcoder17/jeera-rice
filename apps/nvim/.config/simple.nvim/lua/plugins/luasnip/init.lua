local ls = Require("luasnip")

-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local fmt = Require("luasnip.extras.fmt").fmt
local types = Require("luasnip.util.types")

ls.setup({
  history = true,
  enable_autosnippets = true,
  update_events = "TextChanged,TextChangedI",
  -- delete_check_events = "TextChanged",

  -- for nvim cmp: START
  region_check_events = "InsertEnter",
  delete_check_events = "TextChanged,InsertLeave",
  -- for nvim cmp: END

  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "●", "LuasnipChoiceNode" } },
      },
    },

    -- [types.insertNode] = {
    -- 	active = {
    -- 		virt_text = { { "●", "LuasnipInsertNode" } },
    -- 	},
    -- },
  },
})

local snippet_paths = {
  vim.g.nvim_dir .. "/snippets",
  vim.g.project_root_dir .. "/.nvim/snippets",
  vim.g.project_root_dir .. "/.tools/nvim/snippets",
}

Require("luasnip.loaders.from_lua").load({
  paths = snippet_paths,
})

Require("luasnip.loaders.from_snipmate").lazy_load({
  paths = snippet_paths,
})

vim.keymap.set({ "i", "s", "x" }, "<C-e>", function()
  require("luasnip").expand()
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-l>", function()
  if require("luasnip").choice_active() then
    require("luasnip").change_choice(1)
  end
end, { silent = true, noremap = true, desc = "[luasnip] move to next choice" })

vim.keymap.set({ "i", "s" }, "<C-h>", function()
  if require("luasnip").choice_active() then
    require("luasnip").change_choice(-1)
  end
end, { silent = true, noremap = true, desc = "[luasnip] move to previous choice" })

-- INFO: code below fixes issue with luasnip extmarks not disappearing
local group = vim.api.nvim_create_augroup("UserLuasnip", { clear = true })
local ns = vim.api.nvim_create_namespace("UserLuasnipNS")

local function delete_extmarks()
  local extmarks = vim.api.nvim_buf_get_extmarks(0, ns, 0, -1, {})
  for _, extmark in ipairs(extmarks) do
    vim.api.nvim_buf_del_extmark(0, ns, extmark[1])
  end
end

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "LuasnipChoiceNodeLeave",
  callback = delete_extmarks,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = group,
  callback = delete_extmarks,
})
