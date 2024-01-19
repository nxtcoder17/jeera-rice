local sorters = require("telescope.sorters")
local conf = require("telescope.config").values

-- TODO: make this prompt use fzf filters
vim.api.nvim_create_user_command("Todo", function(opts)
  require("fzf-lua").grep({ search = "TODO|HACK|NOTE|FIXME" })

  -- local query = "TODO|HACK|NOTE|FIXME"
  --
  -- if #opts.fargs > 0 then
  --   query = table.concat(opts.fargs, "|")
  -- end
  --
  -- require("telescope.builtin").grep_string({
  --   search = query,
  --   default_text = query,
  --   sorter = sorters.get_fzy_sorter(),
  -- })
end, {
  nargs = "*",
  complete = function(_arglead, _cmdline, _cursorpos)
    return { "TODO", "HACK", "NOTE", "FIXME" }
  end,
})

-- TODO: hi
-- HACK: hi
vim.api.nvim_create_user_command("X", function(opts)
  vim.print(vim.fn.luaeval(opts.args))
end, { nargs = 1 })

vim.api.nvim_create_user_command("InlayHintsToggle", function()
  vim.g.inlay_hints_enabled = not vim.g.inlay_hints_enabled
  print("Inlay hints " .. (vim.g.inlay_hints_enabled and "enabled" or "disabled"))
  vim.cmd("LspRestart gopls")
  vim.cmd("e!")
end, { nargs = 0 })

vim.api.nvim_create_user_command("Dragon", function(opts)
  vim.cmd("!dragon -x %")
end, { nargs = 0 })

vim.api.nvim_create_user_command("DeleteNameless", function()
  return require("functions.buffers").delete_nameless()
end, { nargs = 0 })
