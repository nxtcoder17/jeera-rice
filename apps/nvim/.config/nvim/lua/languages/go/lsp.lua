notify_if_not_installed({
  "gopls",
  "gofumpt",
  "delve",
  "gotests",
  "gomodifytags",
  "impl",
  "iferr",
  "json-to-struct",
})

vim.lsp.config("gopls", {
  filetypes = { "go", "gomod", "gowork", "gotmpl", "gotexttmpl", "gohtmltmpl" },
  root_markers = { "go.mod" },
  single_file_support = true,
  on_attach = Require("lsp.on_attach"),
  settings = {
    gopls = {
      completeUnimported = false,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
      staticcheck = false,
      gofumpt = false,

      directoryFilters = { "-.git", "-node_modules", "-vendor", "-bin" },

      semanticTokens = false,
      hints = {
        ignoredError = true,
      },
    },
  },
})

vim.lsp.enable("gopls")
