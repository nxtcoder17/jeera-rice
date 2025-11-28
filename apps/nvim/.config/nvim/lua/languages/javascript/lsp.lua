notify_if_not_installed({
  "typescript-language-server",
  "biome",
  "deno",
})

vim.lsp.config("ts_ls", {
  root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lock" },
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  single_file_support = true,
  on_attach = function(client, bufnr)
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
    -- client.server_capabilities.document_formatting = false
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    Require("lsp.on_attach")(client, bufnr)
  end,
})

vim.lsp.config("biome", {})

vim.lsp.config("denols", {
  root_markers = { "deno.lock", "deno.json" },
  settings = {
    deno = {
      enable = true,
      lint = true,
      suggest = {
        imports = {
          hosts = {
            ["https://deno.land"] = true,
          },
        },
      },
    },
  },
  on_attach = Require("lsp.on_attach"),
})

vim.lsp.enable({ "ts_ls", "biome", "denols" })

require("languages.css.lsp")
