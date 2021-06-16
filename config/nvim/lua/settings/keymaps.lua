-- Key Mappings

local function map(mode, key, value)
  vim.api.nvim_set_keymap(mode, key, value, { silent = true } )
end

local function noremap(mode, key, value)
  vim.api.nvim_set_keymap(mode, key, value, { silent = false, noremap = true })
end

local function noremapX(mode, key, value)
  vim.api.nvim_set_keymap(mode, key, value, { silent = true, noremap = true, expr = true })
end

local function nmap(key,value) map('n', key, value) end
local function vmap(key,value) map('v', key, value) end

local function nnoremap(key,value) noremap('n', key, value) end
local function inoremap(key,value) noremap('i', key, value) end
local function vnoremap(key,value) noremap('v', key, value) end
local function tnoremap(key,value) noremap('t', key, '<C-\\><C-n>' .. value) end

local function inoremapX(key,value) noremapX('i', key, value) end


-- vim.g.mapleader = ' '

-- -- THe must haves
-- nnoremap('Q', '<nop>')
-- nnoremap('cc', '<nop>')
-- nnoremap(';', ':')
-- nnoremap('<BS>', ':nohlsearch<CR>')

-- -- Copy to Clipboard  --don't know why mappingis not working in lua
-- vim.cmd [[ nnoremap Y "+y ]]
-- vim.cmd [[ vnoremap Y "+y ]] 
-- -- nmap('Y', '"+y')
-- -- vmap('Y', '"+y')

-- -- The sexy [s]
-- nnoremap('s', '<nop>')

-- -- [S]exy commenting
-- nmap('s<space>', 'gcc')
-- vmap('s<space>', 'gc')

-- -- [S]exy file Save
-- nnoremap('ss', ':w<CR>')

-- -- [S]exy buffer Delete
-- nnoremap('sd', ':bdelete<CR>')

-- -- [S]exy window splits
-- nnoremap('si', ':vsplit<CR>')
-- nnoremap('sm', ':split<CR>')

-- -- [S]exy Split Navigation
-- nnoremap('sh', '<C-w>h')
-- nnoremap('sl', '<C-w>l')
-- nnoremap('sj', '<C-w>j')
-- nnoremap('sk', '<C-w>k')

-- -- [S]exy Telescope
-- nnoremap('sf',  ":lua require'telescope.builtin'.find_files{hidden = true, folllow = true}<CR>")
-- nnoremap('<S-f>', ":lua require'telescope.builtin'.live_grep{}<CR>")

-- -- Vim Tmux Navigator
-- nnoremap('<M-h>', ':TmuxNavigateLeft<cr>')
-- nnoremap('<M-l>', ':TmuxNavigateRight<cr>')
-- nnoremap('<M-k>', ':TmuxNavigateUp<cr>')
-- nnoremap('<M-j>', ':TmuxNavigateDown<cr>')

-- nnoremap('<M-Left>', ':TmuxNavigateLeft<cr>')
-- nnoremap('<M-Right>', ':TmuxNavigateRight<cr>')
-- nnoremap('<M-Up>', ':TmuxNavigateUp<cr>')
-- nnoremap('<M-Down>', ':TmuxNavigateDown<cr>')

-- -- -- RnVimR
-- nnoremap('<M-o>', ':RnvimrToggle<CR>')
-- tnoremap('<M-o>', ':RnvimrToggle<CR>')
-- tnoremap('<M-i>', ':RnvimrResize<CR>')

-- -- Nvim Compe
-- inoremapX('<TAB>', 'pumvisible() ? "\\<C-n>" : "\\<TAB>"')
-- inoremapX('<S-TAB>', 'pumvisible() ? "\\<C-p>" : "\\<C-h>"')
