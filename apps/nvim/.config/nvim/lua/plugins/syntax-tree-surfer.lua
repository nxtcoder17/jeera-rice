local sts = require("syntax-tree-surfer")

local Utils = require("functions.utils")

local opts = { noremap = true, silent = true }

-- vim.keymap.set("n", "<M-v>", function() -- only jump to variable_declarations
--   -- sts.targeted_jump({ "variable_declaration" })
--   sts.filtered_jump({ "variable_declaration" }, true)
-- end, opts)
--
-- vim.keymap.set("n", "<M-f>", function() -- only jump to functions
--   sts.targeted_jump({ "function", "arrrow_function", "function_definition" })
--   --> In this example, the Lua language schema uses "function",
--   --  when the Python language uses "function_definition"
--   --  we include both, so this keymap will work on both languages
-- end, opts)
--
-- vim.keymap.set("n", "<A-m>", function()
--   sts.filtered_jump("default", true) --> true means jump forward
-- end, opts)

local statement_like_nodes = {
  "import_declaration",
  "type_declaration",
  "function_declration",
  "method_declaration",
  "const_declaration",

  "if_statement",
  "else_statement",
  "return_statement",
  "for_statement",
  "switch_statement",

  -- jsx
  "jsx_element",
}

vim.keymap.set("n", "<C-j>", function() -- jump to all that you specify
  sts.filtered_jump(statement_like_nodes, true)
  vim.cmd("normal zz")
end, Utils.merge_tables(opts, { desc = "jumping to next statement like nodes" }))

vim.keymap.set("n", "<C-k>", function() -- jump to all that you specify
  sts.filtered_jump(statement_like_nodes, false)
  vim.cmd("normal zz")
end, Utils.merge_tables(opts, { desc = "jumping to previous statement like nodes" }))

local function_like_nodes = {
  -- golang
  "import_declaration",
  "type_declaration",
  "function_declaration",
  "method_declaration",
  "const_declaration",

  -- lua
  "function_definition",
}

vim.keymap.set("n", "<C-S-j>", function()
  sts.filtered_jump(function_like_nodes, true)
  vim.cmd("normal zz")
end, Utils.merge_tables(opts, { desc = "jumping to next function like nodes" }))

vim.keymap.set("n", "<C-S-k>", function()
  sts.filtered_jump(function_like_nodes, false)
  vim.cmd("normal zz")
end, Utils.merge_tables(opts, { desc = "jumping to previous function like nodes" }))
