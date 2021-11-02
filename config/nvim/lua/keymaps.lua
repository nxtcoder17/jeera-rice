local function map(mode, key, value, opts)
  vim.api.nvim_set_keymap(mode, key, value, opts)
end

local function nmap(key, value, opts)
  map("n", key, value, opts)
end
local function vmap(key, value, opts)
  map("v", key, value, opts)
end
local function cmap(key, value, opts)
  map("c", key, value, opts)
end
local function imap(key, value, opts)
  map("i", key, value, opts)
end
local function tmap(key, value, opts)
  map("t", key, value, opts)
end

local globalOpts = { noremap = true, silent = true }

local function nnoremap(key, value)
  nmap(key, value, globalOpts)
end
local function vnoremap(key, value)
  vmap(key, value, globalOpts)
end
local function cnoremap(key, value)
  cmap(key, value, globalOpts)
end
local function tnoremap(key, value)
  tmap(key, value, globalOpts)
end
local function inoremap(key, value)
  imap(key, value, { noremap = true, silent = true, expr = true })
end

-- Commands
--
-- vimspector
vim.api.nvim_command("command! -nargs=0 Reload :luafile $XDG_CONFIG_HOME/nvim/init.lua")

vim.api.nvim_command("command! -nargs=0 DD :call vimspector#Launch()<CR>")
vim.api.nvim_command("command! -nargs=0 Dbp :call vimspector#ToggleBreakpoint()<CR>")
vim.api.nvim_command("command! -nargs=0 Dj :call vimspector#StepOver()<CR>")
vim.api.nvim_command("command! -nargs=0 Dk :call vimspector#StepOut()<CR>")
vim.api.nvim_command("command! -nargs=0 Dl :call vimspector#StepInto()<CR>")
vim.api.nvim_command("command! -nargs=0 Dr :call vimspector#Restart()<CR>")
vim.api.nvim_command("command! -nargs=0 De :call vimspector#Reset()<CR>")

vim.api.nvim_command("command! -nargs=0 Max :MaximizerToggle<CR>")

-- keymappings

vim.g.mapleader = ","

tnoremap("<Esc>", "<C-\\><C-n>")

nnoremap("Q", "")
nnoremap("s", "")
vnoremap("s", "")

nnoremap("<BS>", ":nohlsearch<CR>")
nnoremap("Y", '"+y')
vnoremap("Y", '"+y')

nnoremap("cc", '"+y')
vnoremap("cc", '"+y')

nnoremap(";", ":")
vnoremap(";", ":")

nmap("ss", ":up<CR>", {})

nnoremap("sh", "<C-w>h<CR>")
nnoremap("sl", "<C-w>l<CR>")
nnoremap("sj", "<C-w>j<CR>")
nnoremap("sk", "<C-w>k<CR>")

nnoremap("si", ":vsplit<CR>")
nnoremap("sm", ":split<CR>")

nnoremap("sf", ":lua require'plugins_dir.telescope'.find_files()<CR>")
nnoremap("sf", ":lua require'plugins_dir.telescope'.find_files()<CR>")
nnoremap("sb", ":Telescope buffers<CR>")

-- Trouble nvim toggle
nnoremap("st", ":TroubleToggle<CR>")

-- [Source]: https://gist.github.com/benfrain/97f2b91087121b2d4ba0dcc4202d252f
-- Keep search results centred
nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")
nnoremap("J", "mzJ`z")

-- Resizing Splits
nnoremap("<C-S-Right>", ":vert resize +10<CR>")
nnoremap("<C-S-Left>", ":vert resize -10<CR>")
nnoremap("<C-S-Up>", ":resize +10<CR>")
nnoremap("<C-S-Down>", ":resize -10<CR>")

-- Code Related
nnoremap("s;", ":!eslint_d --fix % <CR><CR> | :e!")

-- rnvimr
nnoremap("<M-o>", ":RnvimrToggle<CR>")
tnoremap("<M-o>", "<C-\\><C-n>:RnvimrToggle<CR>")

-- because, rnvimr shits wqa
cnoremap("wqa", "wa! | qa")

-- from:plugin / navigator.nvim'
vim.cmd([[let g:tmux_navigator_no_mappings = 1]])

nnoremap("<M-h>", ":TmuxNavigateLeft<cr>")
nnoremap("<M-l>", ":TmuxNavigateRight<cr>")
nnoremap("<M-k>", ":TmuxNavigateUp<cr>")
nnoremap("<M-j>", ":TmuxNavigateDown<cr>")

-- CoC based
-- vim.cmd([[cabbrev('OR', ':CocCommand editor.action.organizeImport')]])

-- comment uncomment
nmap("s;", "gcc", {})
vmap("s;", "gcc", {})

-- nvim lsp
nnoremap("gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
nnoremap("K", "<Cmd>lua vim.lsp.buf.hover()<CR>")

-- These mappings could get very slow, so must use `set timeoutlen=200`

nnoremap("sel", "<Cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<CR>")
nnoremap("se", "<Cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<CR>")
nnoremap("<leader>s", "<Cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>")

nnoremap("sr", "<Cmd>lua require('lspsaga.rename').rename()<CR>")
nnoremap("<leader>s", "<Cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>")

nnoremap("sn", "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>")
nnoremap("sN", "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>")
