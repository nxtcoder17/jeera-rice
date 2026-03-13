local filetypes = {
  "javascript",
  "javascriptreact",
  "javascript.jsx",
  "typescript",
  "typescriptreact",
  "typescript.tsx",
}

-- LSP
notify_if_not_installed({
  "typescript-language-server",
  "biome",
  "deno",
})

vim.lsp.config("ts_ls", {
  root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lock" },
  filetypes = filetypes,
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

vim.lsp.enable({
  "ts_ls",
  "biome", -- linter and formatter
  "denols",
})

require("lint").linters.biome_lint = {
  cmd = "sh",
  stdin = false,
  args = {
    "-c",
    "bunx biome lint --reporter=rdjson || exit 0",
  },
  stream = "stdout",

  parser = function(output, bufnr)
    local diagnostics = {}

    local ok, decoded = pcall(vim.json.decode, output)
    if not ok or not decoded then
      return diagnostics
    end

    for _, item in ipairs(decoded.diagnostics or {}) do
      local start = item.location.range.start
      local finish = item.location.range["end"]

      table.insert(diagnostics, {
        lnum = start.line - 1,
        col = start.column - 1,
        end_lnum = finish.line - 1,
        end_col = finish.column - 1,
        message = item.message,
        code = item.code and item.code.value or nil,
        source = decoded.source and decoded.source.name or "biome",
        severity = vim.diagnostic.severity.WARN,
      })
    end

    return diagnostics
  end,
}

require("lint").linters_by_ft = {
  javascript = { "biome_lint" },
  typescript = { "biome_lint" },
}

-- LINTER
for _, ft in ipairs(filetypes) do
  -- set_linter(ft, { "eslint_d" })
  set_linter(ft, { "biome_lint" })
end

-- FORMATTER
for _, ft in ipairs(filetypes) do
  set_formatter(ft, { "eslint_d" })
end

vim.cmd("runtime! ftplugin/css.lua")
