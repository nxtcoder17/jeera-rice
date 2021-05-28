-- Key Mappings

-- Thanks to Rhisabh Dwivedi [URL]: https://github.com/RishabhRD/archrice/blob/master/.config/nvim/lua/mappings.lua

local function nmap(command, value, expr)
    vim.api.nvim_set_keymap('n',command,value,{noremap = true, silent = true, expr = expr})
end

local function imap(command, value, expr)
    vim.api.nvim_set_keymap('i',command,value,{noremap = true, silent = true, expr = expr})
end

local function vmap(command, value, expr)
    vim.api.nvim_set_keymap('v',command,value,{noremap = true, silent = true, expr = expr})
end

local function tmap(command, value, expr)
    vim.api.nvim_set_keymap('t',command,value,{noremap = true, silent = true, expr = expr})
end


vim.g.mapleader = ' '

-- Nvim Comment
vim.cmd [[ nmap s<space> gcc ]]
vim.cmd [[ vmap s<space> gc ]]

-- Must haves
nmap('Q', '<nop>')

-- Must haves
nmap('Q', '<nop>')

-- Making my vim-flow against the `s` key
nmap('s', '<nop>')
nmap('ss', ':w<CR>')
nmap('sd', ':bd<CR>')
nmap('sl', '<C-w>l')
nmap('sh', '<C-w>h')
nmap('sj', '<C-w>j')
nmap('sk', '<C-w>k')
nmap('si', ':vsplit<CR>')
nmap('sm', ':split<CR>')
nmap('Y', '"+y')
vmap('Y', '"+y')

nmap ('s4', '<leader>c<space>')

-- Telescope Shortcuts
nmap('sf', ":lua require'telescope.builtin'.find_files{hidden = true, folllow = true}<CR>")
nmap('<C-f>', ":lua require'telescope.builtin'.live_grep{}<CR>")

-- Vim Tmux Navigator

nmap('<M-h>', ':TmuxNavigateLeft<cr>')
nmap('<M-j>', ':TmuxNavigateDown<cr>')
nmap('<M-k>', ':TmuxNavigateUp<cr>')
nmap('<M-l>', ':TmuxNavigateRight<cr>')
nmap(';', ':')


-- RnVimR
nmap('<M-o>', ':RnvimrToggle<CR>')
tmap('<M-o>', '<C-\\><C-n>:RnvimrToggle<CR>')
tmap('<M-i>', '<C-\\><C-n>:RnvimrResize<CR>')
