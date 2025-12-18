-- LSP
if not notify_if_not_installed({
  "css-lsp",
  "tailwindcss-language-server",
}) then
  vim.notify_error("[css] failed to start LSP")
  return
end

vim.lsp.config("cssls", {
  on_attach = Require("lsp.on_attach"),
  settings = {
    css = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
      },
    },
    scss = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
      },
    },
    less = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
      },
    },
  },
})

vim.lsp.config("tailwindcss", {
  filetypes = { "javascriptreact", "typescriptreact", "html", "css", "typescript.tsx", "javascript.jsx" },
  settings = {},
})

vim.lsp.enable({ "cssls", "tailwindcss" })
