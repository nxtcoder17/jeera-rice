require('disable-builtins')
require("impatient")
-- require("packer_compiled")
require("options")
require("plugins")
require("keymaps")
require("plugins_dir")
require("autocmds")
require("lsp")

local dirExtension = vim.fn.getcwd() .. "/.nxtcoder17.lua"
if vim.fn.filereadable(dirExtension) > 0 then
    vim.cmd("luafile" .. dirExtension)
end

if vim.g.nvui then
    -- vim.opt.linespace = 4
    vim.cmd [[ 
        NvuiScrollAnimationDuration 0.2
        NvuiCursorAnimationDuration 0.1
    ]] 
end
