vim.keymap.set("n", "sn", function()
  vim.diagnostic.goto_next({
    severity = { min = "WARN", max = "ERROR" },
  })
end)

vim.keymap.set("n", "sp", function()
  vim.diagnostic.goto_prev({
    severity = { min = "WARN", max = "ERROR" },
  })
end)

vim.keymap.set("n", "se", vim.diagnostic.open_float)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help)
vim.keymap.set("n", "<M-CR>", vim.lsp.buf.code_action)
vim.keymap.set("n", "f;", function() vim.lsp.buf.format({async = true}) end)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "sr", vim.lsp.buf.rename)
