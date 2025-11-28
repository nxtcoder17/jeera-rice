local function on_attach(client, bufnr)
  local opts = { silent = true, buffer = bufnr, remap = false }

  if client.supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end

  -- vim.lsp.semantic_tokens.enable(false)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
    title = "",
  })

  if client ~= nil and client.server_capabilities ~= nil then
    -- client.server_capabilities.semanticTokensProvider = nil
    client.server_capabilities.semanticTokensProvider = {}
  end

  -- vim.api.nvim_create_autocmd("CursorHold", {
  --   buffer = bufnr,
  --   callback = function()
  --     local float_opts = {
  --       focusable = false,
  --       close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
  --       border = "rounded",
  --       source = "always",
  --       prefix = " ",
  --       scope = "cursor",
  --     }
  --     vim.diagnostic.open_float(nil, float_opts)
  --   end,
  -- })

  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set({ "n", "v" }, "<M-CR>", vim.lsp.buf.code_action, opts)
  -- vim.keymap.set("n", "f;", function()
  --   vim.lsp.buf.format({ async = false })
  -- end, opts)

  -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gr", "<Cmd>Fzf lsp_references<CR>", opts)
  -- vim.keymap.set("n", "gr", function()
  -- 	require("telescope.builtin").lsp_references({ include_current_line = false, show_line = false })
  -- end, opts)
  vim.keymap.set("n", "gd", "<Cmd>Fzf lsp_definitions jump1=true<CR>", opts)
  vim.keymap.set("n", "gD", "<Cmd>Fzf lsp_typedefs<CR>", opts)
  vim.keymap.set("n", "gi", "<Cmd>Fzf lsp_implementations<CR>", opts)
  vim.keymap.set("n", "sr", vim.lsp.buf.rename, opts)
end

return on_attach
