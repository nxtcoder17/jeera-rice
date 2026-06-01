local has_new_ui, new_ui = pcall(require, "vim._core.ui2")
if has_new_ui then
  new_ui.enable({})
end

require("neovim-globals")
require("disable-builtin-plugins")
require("options")
Require("plugins")
require("folds")
Require("keymaps")
Require("autocmds")
Require("commands")
