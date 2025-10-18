local luasnip = require("luasnip")

local function feedkeys(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), "n", false)
end

vim.keymap.set("i", "<Tab>", function()
  if luasnip.expandable() then
    luasnip.expand()
  elseif luasnip.expand_or_locally_jumpable() then
    luasnip.expand_or_jump()
  else
    -- fallback: actually insert a Tab
    feedkeys("<Tab>")
  end
end, { silent = true, desc = "Expand or jump through snippets, fallback to Tab" })

-- SHIFT+TAB → jump backwards / fallback
vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    feedkeys("<S-Tab>")
  end
end, { silent = true, desc = "Jump backward through snippet, fallback to Shift-Tab" })

-- CTRL+L → cycle through snippet choices (if applicable)
vim.keymap.set({ "i", "s" }, "<C-l>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end, { silent = true, desc = "Cycle forward through snippet choices" })

-- CTRL+H → cycle backward through snippet choices
vim.keymap.set({ "i", "s" }, "<C-h>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(-1)
  end
end, { silent = true, desc = "Cycle backward through snippet choices" })

vim.keymap.set({ "i", "s" }, "<C-c>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })
