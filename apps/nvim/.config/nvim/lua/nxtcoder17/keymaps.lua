-- resets
vim.keymap.set({ "n", "v" }, ";", ":")
vim.keymap.set({ "n", "v" }, "f", "<Nop>")

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

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

-- lsp keymaps
vim.keymap.set("n", "sn", function()
	vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severity.ERROR } })
end)
vim.keymap.set("n", "sp", function()
	vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severity.ERROR } })
end)

vim.keymap.set("n", "se", vim.diagnostic.open_float)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help)
vim.keymap.set("n", "<M-CR>", vim.lsp.buf.code_action)
vim.keymap.set("v", "<M-CR>", vim.lsp.buf.code_action)
vim.keymap.set("n", "f;", function()
	vim.lsp.buf.format({ async = true })
end)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "sr", vim.lsp.buf.rename)

-- tabs
vim.cmd("cnoreabbrev tcd windo tcd")
vim.keymap.set("n", "tn", "<cmd>tabnew<CR>|:windo tcd " .. vim.g.root_dir .. "<CR>")
vim.keymap.set("n", "te", "<cmd>tabedit % |:windo tcd " .. vim.g.root_dir .. "<CR>")

-- telescope
vim.keymap.set("n", "sf", ":Telescope find_files<CR>")
vim.keymap.set("n", "ff", require("nxtcoder17.plugins.telescope").grep)
-- vim.keymap.set("n", "tl", require("nxtcoder17.plugins.telescope").tabs)
vim.keymap.set("n", "tl", require("telescope.builtin").buffers)

-- cc
vim.keymap.set({ "n", "v" }, "cc", '"+y')

vim.keymap.set("n", "<M-o>", ":RnvimrToggle<CR>")
vim.keymap.set("t", "<M-o>", "<C-\\><C-n>:RnvimrToggle<CR>")

-- because rnvimr shits wqa
vim.keymap.set("c", "wqa", "wa! | qa!")

-- vim.keymap.set("n", "<BS>", ":set nohls <CR>|:HlSearchLensToggle <CR>|:HlSearchLensToggle <CR>|:lua Fn().closeFloating()<CR>")
vim.keymap.set("n", "<BS>", ":set nohls <CR>|:lua Fn().closeFloating() <CR>")
-- vim.keymap.set("n", "<BS>", ":set nohls<CR>")

vim.keymap.set("n", "fd", require("nxtcoder17.plugins.telescope").dapActions)
vim.keymap.set("n", "f'", require("nxtcoder17.plugins.telescope").actions)

vim.keymap.set("n", "<M-h>", require("nvim-tmux-navigation").NvimTmuxNavigateLeft)
vim.keymap.set("n", "<M-l>", require("nvim-tmux-navigation").NvimTmuxNavigateRight)
vim.keymap.set("n", "<M-j>", require("nvim-tmux-navigation").NvimTmuxNavigateDown)
vim.keymap.set("n", "<M-k>", require("nvim-tmux-navigation").NvimTmuxNavigateUp)

-- [[ DAP ]]

-- luasnip
vim.cmd([[
  imap <silent><expr> <C-n> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-n>'
  smap <silent><expr> <C-n> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-n>'
  imap <silent><expr> <C-p> luasnip#choice_active() ? '<Plug>luasnip-prev-choice' : '<C-p>'
  smap <silent><expr> <C-p> luasnip#choice_active() ? '<Plug>luasnip-prev-choice' : '<C-p>'
]])
