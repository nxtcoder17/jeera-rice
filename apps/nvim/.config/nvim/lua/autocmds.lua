local group = vim.api.nvim_create_augroup("autocmds", {
  clear = true,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = group,
  callback = function()
    vim.cmd("set ft=terminal")
  end,
})

vim.api.nvim_create_autocmd("BufRead", {
  group = group,
  pattern = "*",
  callback = function()
    vim.cmd(
      [[if &ft !~# 'commit\|rebase\|query\|Terminal\|toggleterm\|terminal\|TelescopePrompt\|TelescopeResult' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif"]]
    )
  end,
})

-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
--   group = group,
--   pattern = "*",
--   callback = function()
--     skip_types = {
--       "help",
--       "TelescopePrompt",
--       "TelescopeResult",
--       "query",
--       "Terminal",
--       "toggleterm",
--       "terminal",
--     }
--
--     for _, v in ipairs(skip_types) do
--       if vim.bo.filetype == "" or vim.bo.filetype == v then
--         return
--       end
--     end
--
--     if vim.fn.mode() ~= "n" then
--       vim.cmd("stopinsert")
--     end
--   end,
-- })

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = group,
  pattern = { os.getenv("HOME") .. "/.Xresources" },
  callback = function()
    os.execute(string.format("xrdb -merge %s", os.getenv("HOME") .. "/.Xresources"))
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = group,
  pattern = { "env", ".env" },
  callback = function()
    -- vim.diagnostic.disable(vim.fn.expand("<abuf>"))
    vim.diagnostic.disable(0)
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile" }, {
  group = group,
  pattern = { "flake.nix" },
  callback = function()
    vim.cmd(string.format("-1r %s/templates/flake.nix", vim.fn.stdpath("config")))
  end,
})
