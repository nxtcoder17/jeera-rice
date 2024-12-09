vim.g.home = os.getenv("HOME")
vim.g.root_dir = vim.fn.getcwd()
vim.g.nvim_dir = vim.fn.stdpath("config")

-- disabling builtins
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

_G.R = function(pkg)
  package.loaded[pkg or "nxtcoder17.functions.dev"] = nil
  return require(pkg or "nxtcoder17.functions.dev")
end

_G.Fn = function()
  return R("nxtcoder17.functions")
end

pcall(require, "nxtcoder17.functions.go-return")

pcall(require, "nxtcoder17.settings")
pcall(require, "nxtcoder17.plugins")
pcall(require, "nxtcoder17.keymaps")
-- pcall(require, "nxtcoder17.commands")
require("nxtcoder17.commands")
pcall(require, "nxtcoder17.autocmds")

local timer = vim.loop.new_timer()

timer:start(
  1000,
  500,
  vim.schedule_wrap(function()
    if vim.bo.filetype ~= "" then
      -- print("redrawed ...")
      -- vim.cmd("redraw! | e!")
      vim.cmd("redraw!")
      -- vim.api.nvim_command('echomsg "test"')
    end
  end)
)

vim.cmd("colorscheme kanagawa")
