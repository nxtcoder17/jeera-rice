local function map(mode, key, value, opts)
  vim.api.nvim_set_keymap(mode, key, value, opts)
end

local function nmap(key, value, opts) map('n', key, value, opts) end
local function vmap(key, value, opts) map('v', key, value, opts) end
local function cmap(key, value, opts) map('c', key, value, opts) end
local function imap(key, value, opts) map('i', key, value, opts) end
local function tmap(key, value, opts) map('t', key, value, opts) end

local globalOpts = { noremap = true, silent = true }

local function nnoremap(key, value) nmap(key, value, globalOpts) end
local function vnoremap(key, value) vmap(key, value, globalOpts) end
local function cnoremap(key, value) cmap(key, value, globalOpts) end
local function tnoremap(key, value) tmap(key, value, globalOpts) end
local function inoremap(key, value) imap(key, value, { noremap = true, silent = true, expr = true }) end

tnoremap('<Esc>', '<C-\\><C-n>')

nnoremap('Q', '')
nnoremap('cc', '')
nnoremap(';', ':')

nnoremap('<BS>', ':nohlsearch<CR>')
nnoremap('Y', '"+y')
vnoremap('Y', '"+y')

nnoremap('<M-o>', ':RnvimrToggle<CR>')
tnoremap('<M-o>', '<C-\\><C-n>:RnvimrToggle<CR>')

vim.cmd 'cnoremap wqa wq \\| qa'
vim.cmd 'cnoremap wq w \\| q'
-- cnoremap('wqa', 'wq | qa')

nnoremap('s', '')

-- it does not work with nnoremap
nmap('s<space>', 'gcc', {})
vmap('s<space>', 'gcc', {})

-- [S]exy save
nnoremap('ss', ':w<CR>')

-- [S]exy splits
nnoremap('si', ':vsplit<CR>')
nnoremap('sm', ':split<CR>')

-- [S]exy split navigation
nnoremap('sh', '<C-w>h')
nnoremap('sl', '<C-w>l')
nnoremap('sj', '<C-w>j')
nnoremap('sk', '<C-w>k')

nnoremap('<M-h>', ':TmuxNavigateLeft<CR>')
nnoremap('<M-j>', ':TmuxNavigateDown<CR>')
nnoremap('<M-k>', ':TmuxNavigateUp<CR>')
nnoremap('<M-l>', ':TmuxNavigateRight<CR>')

nnoremap('<F2>', ':!eslint_d  --fix "%"<CR>\\|redraw')
-- vim.api.nvim_set_keymap('n', '<F2>', ':!eslint_d --fix "%"<CR>\\|redraw', {})

nnoremap('sf', ':Telescope find_files<CR>' )
nnoremap('<S-f>', ':Telescope grep_string<CR>')
nnoremap('sb', ':Telescope buffers<CR>')

inoremap('<C-space>', 'compe#complete()')

nnoremap('C-S-<Right>', ':vert resize +10')
nnoremap('C-S-<Left>', ':vert resize -10')
nnoremap('C-S-<Up>', ':resize +10')
nnoremap('C-S-<Down>', ':resize -10')

