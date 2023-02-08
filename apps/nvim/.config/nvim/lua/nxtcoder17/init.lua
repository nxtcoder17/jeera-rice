vim.g.home = os.getenv("HOME")
vim.g.root_dir = vim.fn.getcwd()
vim.g.nvim_dir = vim.fn.stdpath("config")

_G.R = function(pkg)
  package.loaded[pkg or "nxtcoder17.functions.dev"] = nil
  return require(pkg or "nxtcoder17.functions.dev")
end

_G.Fn = function()
  return R("nxtcoder17.functions")
end

pcall(require, "nxtcoder17.settings")
pcall(require, "nxtcoder17.plugins")
pcall(require, "nxtcoder17.keymaps")
-- pcall(require, "nxtcoder17.commands")
require('nxtcoder17.commands')
pcall(require, "nxtcoder17.autocmds")

-- local timer = vim.loop.new_timer()
-- timer:start(
--   1000,
--   1000,
--   vim.schedule_wrap(function()
--     print("redrawed ...")
--     vim.cmd("redraw")
--     -- vim.api.nvim_command('echomsg "test"')
--   end)
-- )
