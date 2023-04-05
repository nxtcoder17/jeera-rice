vim.treesitter.set_query(
  "go",
  "folds",
  [[
    (method_declaration (block) @fold)
  ]]
)
