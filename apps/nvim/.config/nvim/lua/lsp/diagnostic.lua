vim.diagnostic.config({
  underline = {
    severity = {
      min = vim.diagnostic.severity.HINT,
      max = vim.diagnostic.severity.ERROR,
    },
  },
  -- virtual_text = {
  --   -- prefix = "☠ ",
  --   prefix = " ● ",
  --   severity = vim.diagnostic.severity.ERROR,
  --   only_current_line = true,
  -- },
  virtual_text = false,
  signs = {
    severity = {
      min = vim.diagnostic.severity.HINT,
      max = vim.diagnostic.severity.ERROR,
    },
    text = {
      [vim.diagnostic.severity.HINT] = "⚡",
      [vim.diagnostic.severity.INFO] = "»",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.ERROR] = "🔥",
    },
    -- linehl = {
    -- 	[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
    -- 	[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
    -- 	[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
    -- 	[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
    -- },
    numhl = {
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
    },
  },
  -- virtual_lines = {
  -- 	min = min_severity,
  -- 	max = vim.diagnostic.severity.ERROR,
  -- },
  float = {
    source = "always",
    focusable = false,
    border = "single",
  },
})

vim.diagnostic.config({
  update_in_insert = false,
})

-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
--   -- delay update diagnostics
--   update_in_insert = false,
-- })

vim.keymap.set("n", "sn", function()
  local severity = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severity.ERROR }
  local ft = vim.bo.filetype
  if ft == "typescript" or ft == "typescript.tsx" or ft == "typescriptreact" then
    severity.min = vim.diagnostic.severity.HINT
  end
  vim.diagnostic.goto_next({ severity = severity })
end, { silent = true, remap = false })

vim.keymap.set("n", "sp", function()
  local severity = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severity.ERROR }
  local ft = vim.bo.filetype
  if ft == "typescript" or ft == "typescript.tsx" or ft == "typescriptreact" then
    severity.min = vim.diagnostic.severity.HINT
  end
  vim.diagnostic.goto_prev({ severity = severity })
end, { silent = true, remap = false })

vim.keymap.set("n", "se", vim.diagnostic.open_float, { silent = true, remap = false })
