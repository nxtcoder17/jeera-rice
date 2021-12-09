local maps = require("lib.mapping")

-- print(vim.inspect(maps));

-- resets
maps["nnoremap"]("s", "")
maps["vnoremap"]("s", "")
maps["nnoremap"]("q", "")
maps["snoremap"]("q", "")
maps["nnoremap"]("Q", "")
maps["vnoremap"]("Q", "")

maps["nnoremap"](";", ":")
maps["vnoremap"](";", ":")

maps["nnoremap"]("j", "gj")
maps["nnoremap"]("k", "gk")

-- copy to system clipboard
maps["nnoremap"]("cc", '"+y')
maps["vnoremap"]("cc", '"+y')

-- cancel highlighting
maps["nnoremap"]("<BS>", "nohlsearch")

-- Resizing Splits
maps["nnoremap"]("<C-S-Right>", ":vert resize +10<CR>")
maps["nnoremap"]("<C-S-Left>", ":vert resize -10<CR>")
maps["nnoremap"]("<C-S-Up>", ":resize +10<CR>")
maps["nnoremap"]("<C-S-Down>", ":resize -10<CR>")

-- comment/uncomment
maps["nmap"]("s;", "gcc", {})
maps["vmap"]("s;", "gcc", {})

maps["tnoremap"]("<Esc>", "<C-\\><C-n>")

-- saving file
maps["nnoremap"]("ss", ":up<CR>")

-- split navigation
maps["nnoremap"]("sh", "<C-w>h<CR>")
maps["nnoremap"]("sl", "<C-w>l<CR>")
maps["nnoremap"]("sj", "<C-w>j<CR>")
maps["nnoremap"]("sk", "<C-w>k<CR>")

-- buffer management
maps['nnoremap']('sdb', ':BDelete this<CR>')
maps['nnoremap']('sdo', ':BDelete other<CR>')
maps['nnoremap']('sda', ':BDelete all<CR>')
maps['nnoremap']('sdn', ':BDelete nameless<CR>')


-- making splits
maps["nnoremap"]("si", ":vsplit<CR>")
maps["nnoremap"]("sm", ":split<CR>")

-- file explorer | word grepper
maps["nnoremap"]("sf", ":lua require'plugins_dir.telescope'.find_files()<CR>")
maps["nnoremap"]("ff", ":lua require'plugins_dir.telescope'.grep()<CR>")

-- rename variable
maps["nnoremap"]("sr", ":lua vim.lsp.buf.rename()<CR>")

-- jump to next / prev error
maps["nnoremap"]("sn", ":lua vim.lsp.diagnostic.goto_next()<CR>")
maps["nnoremap"]("sp", ":lua vim.lsp.diagnostic.goto_prev()<CR>")

-- show line diagnostics
maps["nnoremap"]("se", ":lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
maps["nnoremap"]("K", "<Cmd>lua vim.lsp.buf.hover()<CR>")

-- telescope
maps["nnoremap"]("sb", ":Telescope buffers<CR>")
maps["nnoremap"]("gd", ":Telescope lsp_definitions<CR>")
maps["nnoremap"]("gr", ":Telescope lsp_references<CR>")
maps["nnoremap"]("gdd", ":Telescope lsp_document_diagnostics<CR>")
maps["nnoremap"]("gds", ":Telescope lsp_document_symbols<CR>")
maps["nnoremap"]("gwd", ":Telescope lsp_workspace_diagnostics<CR>")
maps["nnoremap"]("gws", ":Telescope lsp_workspace_symbols<CR>")

-- lsp code actions
maps["nnoremap"]("<M-CR>", ":Telescope lsp_code_actions<CR>")
maps["vnoremap"]("<M-CR>", ":Telescope lsp_code_actions<CR>")

-- rnvimr (file explorer)
maps["nnoremap"]("<M-o>", ":RnvimrToggle<CR>")
maps["tnoremap"]("<M-o>", "<C-\\><C-n>:RnvimrToggle<CR>")
-- because, rnvimr shits wqa
maps["cnoremap"]("wqa", "wa! | qa")

-- for tabs
maps["nnoremap"]("tn", ":tabnew <CR>")
maps["nnoremap"]("te", ":tabedit % <CR>")

-- [Source]: https://gist.github.com/benfrain/97f2b91087121b2d4ba0dcc4202d252f
-- Keep search results centred
maps["nnoremap"]("n", "nzzzv")
maps["nnoremap"]("N", "Nzzzv")
maps["nnoremap"]("J", "mzJ`z")

-- from:plugin / navigator.nvim'
vim.cmd([[let g:tmux_navigator_no_mappings = 1]])
maps["nnoremap"]("<M-h>", ":TmuxNavigateLeft<cr>")
maps["nnoremap"]("<M-l>", ":TmuxNavigateRight<cr>")
maps["nnoremap"]("<M-k>", ":TmuxNavigateUp<cr>")
maps["nnoremap"]("<M-j>", ":TmuxNavigateDown<cr>")

-- eslint format
maps["nnoremap"]("f;", ":!eslint_d --fix '%' <CR>|:e!<CR>")

-- vimspector
vim.api.nvim_command("command! -nargs=0 Reload :luafile $XDG_CONFIG_HOME/nvim/init.lua")

vim.api.nvim_command("command! -nargs=0 DD :call vimspector#Launch()<CR>")
vim.api.nvim_command("command! -nargs=0 Dbp :call vimspector#ToggleBreakpoint()<CR>")
vim.api.nvim_command("command! -nargs=0 Dj :call vimspector#StepOver()<CR>")
vim.api.nvim_command("command! -nargs=0 Dk :call vimspector#StepOut()<CR>")
vim.api.nvim_command("command! -nargs=0 Dl :call vimspector#StepInto()<CR>")
vim.api.nvim_command("command! -nargs=0 Dr :call vimspector#Restart()<CR>")
vim.api.nvim_command("command! -nargs=0 De :call vimspector#Reset()<CR>")

vim.api.nvim_command("command! -nargs=0 Max :MaximizerToggle")
