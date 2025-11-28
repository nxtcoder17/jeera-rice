local binaries = {
  "clangd",
  "clangd-format",
}

local has_error = false
for _, item in ipairs(binaries) do
  if not bin_lookup(item) then
    vim.notify_warn(item .. " is not installed")
    has_error = true
  end
end

if has_error then
  return
end

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
