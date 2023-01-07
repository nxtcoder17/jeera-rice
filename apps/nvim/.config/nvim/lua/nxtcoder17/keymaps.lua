------ Nvim Core KeyMappings ------

-- resets
vim.keymap.set({ "n", "v" }, ";", ":")
vim.keymap.set({ "n", "v" }, "f", "<Nop>")

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

vim.keymap.set("t", "<esc>", "<C-\\><C-N>")
vim.keymap.set({ "n", "v" }, "cc", '"+y')

-- vim.g.mapleader = 'f'

-- [ the 's' key ]
vim.keymap.set({ "n", "v" }, "s", "<Nop>", { silent = true, noremap = true })
vim.keymap.set("n", "ss", ":w<CR>")

-- making splits
vim.keymap.set("n", "si", ":vsplit<CR>")
vim.keymap.set("n", "sm", ":split<CR>")

-- split navigation
vim.keymap.set("n", "sh", "<C-w>h<CR>")
vim.keymap.set("n", "sl", "<C-w>l<CR>")
vim.keymap.set("n", "sj", "<C-w>j<CR>")
vim.keymap.set("n", "sk", "<C-w>k<CR>")

-- tabs
vim.cmd("cnoreabbrev tcd silent! windo tcd")
vim.keymap.set("n", "tn", "<cmd>tabnew<CR>|:windo tcd " .. vim.g.root_dir .. "<CR>", { silent = true })
vim.keymap.set("n", "te", "<cmd>tabedit % |:windo tcd " .. vim.g.root_dir .. "<CR>", { silent = true })

vim.keymap.set("n", "<BS>", ":set nohls <CR>|:lua Fn().closeFloating() <CR>")

-- creating scratch files
vim.api.nvim_create_user_command("Scratch", function()
  vim.cmd("vne | setlocal buftype=nofile | setlocal bufhidden=hide | setlocal noswapfile")
end, {})

-- because rnvimr shits wqa
vim.keymap.set("c", "wqa", "wa! | qa!")

-- [Non-core Keymappings]

-- telescope
vim.keymap.set("n", "sf", ":Telescope find_files<CR>")
vim.keymap.set("n", "ff", require("nxtcoder17.plugins.telescope").grep)
-- vim.keymap.set("n", "tl", require("nxtcoder17.plugins.telescope").tabs)
vim.keymap.set("n", "tl", require("telescope.builtin").buffers)

vim.keymap.set("n", "<M-o>", ":RnvimrToggle<CR>")
vim.keymap.set("t", "<M-o>", "<C-\\><C-n>:RnvimrToggle<CR>")


vim.keymap.set("n", "fd", require("nxtcoder17.plugins.telescope").dapActions)
vim.keymap.set("n", "f'", require("nxtcoder17.plugins.telescope").actions)

vim.keymap.set("n", "<M-k>", function()
  require("nxtcoder17.functions.treesitter-queries").jumps(nil, nil, { up = true })
end)

vim.keymap.set("n", "<M-j>", function()
  require("nxtcoder17.functions.treesitter-queries").jumps(nil, nil, { down = true })
end)

vim.keymap.set("n", "<M-Left>", require("nvim-tmux-navigation").NvimTmuxNavigateLeft)
vim.keymap.set("n", "<M-Right>", require("nvim-tmux-navigation").NvimTmuxNavigateRight)
vim.keymap.set("n", "<M-Down>", require("nvim-tmux-navigation").NvimTmuxNavigateDown)
vim.keymap.set("n", "<M-Up>", require("nvim-tmux-navigation").NvimTmuxNavigateUp)

-- [[ DAP ]]

-- luasnip
vim.cmd([[
  imap <silent><expr> <C-n> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-n>'
  smap <silent><expr> <C-n> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-n>'
  imap <silent><expr> <C-p> luasnip#choice_active() ? '<Plug>luasnip-prev-choice' : '<C-p>'
  smap <silent><expr> <C-p> luasnip#choice_active() ? '<Plug>luasnip-prev-choice' : '<C-p>'
]])
