require("globals")
require("settings")
require("keymaps")
require("plugins-lazy")
require("functions")

-- infinite redrawing as neovim + tmux + kitty runs into some serious rendering issues
local timer = vim.loop.new_timer()
if timer ~= nil then
  timer:start(
    1000,
    500,
    vim.schedule_wrap(function()
      if vim.bo.filetype ~= "" then
        vim.cmd("redraw!")
      end
    end)
  )
end

