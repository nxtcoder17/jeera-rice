-- disabling unused neovim builtin plugins
vim.g.loaded_gzip = false
vim.g.loaded_netrwPlugin = false
vim.g.loaded_tarPlugin = false
vim.g.loaded_zipPlugin = false
vim.g.loaded_2html_plugin = false
vim.g.loaded_remote_plugins = false

-- impatient
require("impatient")

require("keymaps")
require("options")
require("plugins")
require("plugins_dir")
require("lsp")
-- vim.cmd([[ source $XDG_CONFIG_HOME/nvim/coc.vim ]])
--

local dirExtension = vim.fn.getcwd() .. "/.nxtcoder17.lua"
if vim.fn.filereadable(dirExtension) > 0 then
  vim.cmd("luafile" .. dirExtension)
end
