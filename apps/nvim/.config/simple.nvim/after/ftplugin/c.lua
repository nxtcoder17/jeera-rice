notify_if_not_installed({
  "clangd",
  "clangd-format",
})

vim.lsp.config("clangd", {
  filetypes = { "c", "cpp" },
  single_file_support = true,
  on_attach = Require("lsp.on_attach"),
  -- cmd = {
  -- 	"clangd",
  -- 	"--background-index",
  -- 	"--clang-tidy",
  -- 	"--header-insertion=iwyu",
  -- 	"--completion-style=detailed",
  -- 	"--function-arg-placeholders",
  -- 	"--fallback-style=llvm",
  -- },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
})

vim.lsp.enable("clangd")

-- LINTER
set_linter(vim.bo.filetype, { "clangtidy" })

-- FORMATTER
set_formatter(vim.bo.filetype, { "clang-format" })
