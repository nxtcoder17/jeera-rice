local maps = require("lib.mapping")

local M = {}

maps.resetKeys("S", "s", "H", "M", "L", "Q", "'", "<C-.>", "<C-[", "<C-]>", ";")

-- ; to :
maps.nnoremap(";", ":")

vim.g.mapleader = "'"

-- j/k to virtual gj/gk
maps.nnoremap("j", "gj")
maps.nnoremap("k", "gk")

-- copy to system clipboard
maps.nnoremap("cc", '"+Y')
maps.vnoremap("cc", '"+y')

-- maps.vnoremap("scc", ":OSCYank<CR>")

-- cancel highlighting
-- maps.nnoremap("<BS>", ":set nohls <CR>|:HlSearchLensToggle <CR>|:HlSearchLensToggle <CR>")
maps.nnoremap(
	"<BS>",
	":set nohls <CR>|:HlSearchLensToggle <CR>|:HlSearchLensToggle <CR> |:lua require('functions').closeFloating()<CR>"
)

-- Resizing Splits
maps.nnoremap("<C-M-Right>", ":vert resize +10<CR>")
maps.nnoremap("<C-M-Left>", ":vert resize -10<CR>")
maps.nnoremap("<C-M-Up>", ":resize +10<CR>")
maps.nnoremap("<C-M-Down>", ":resize -10<CR>")

-- comment/uncomment
maps.nmap("s;", "gcc", {})
maps.vmap("s;", "gcc", {})

maps.tnoremap("<Esc>", "<C-\\><C-n>")

-- saving file
maps.nnoremap("ss", ":w<CR>")

-- split navigation
maps.nnoremap("sh", "<C-w>h<CR>")
maps.nnoremap("sl", "<C-w>l<CR>")
maps.nnoremap("sj", "<C-w>j<CR>")
maps.nnoremap("sk", "<C-w>k<CR>")

-- buffer management
maps.nnoremap("sdb", ":BDelete this<CR>")
maps.nnoremap("sdo", ":BDelete other<CR>")
maps.nnoremap("sda", ":BDelete all<CR>")
maps.nnoremap("sdn", ":BDelete nameless<CR>")

-- Debugging
-- maps["nnoremap"]("qt", ":Telescope dap configurations<CR>")
-- maps["nnoremap"]("qq", ":Telescope dap commands<CR>")

-- Iterate Quickfix list
maps.nnoremap("s[", ":cprev<CR>")
maps.nnoremap("s]", ":cnext<CR>")
maps.nnoremap("qo", ":copen<CR>")
maps.nnoremap("qc", ":cclose<CR>")

-- maps['nnoremap']('tt', ':ToggleTerm<CR>')
maps.nnoremap("tt", ":ToggleTerm<CR>")

-- making splits
maps.nnoremap("si", ":vsplit<CR>")
maps.nnoremap("sm", ":split<CR>")

-- file explorer | word grepper
maps.nnoremap("sf", ":Telescope find_files<CR>")
maps.nnoremap("ff", ":lua require'plugins_dir.telescope'.grep()<CR>")

local function lspNative()
	-- rename variable
	maps.nnoremap("sr", ":lua vim.lsp.buf.rename()<CR>")

	-- jump to next / prev warning/error
	maps.nnoremap("sn", ":lua vim.diagnostic.goto_next({ severity = {min='WARN', max='ERROR'}})<CR>")
	maps.nnoremap("sp", ":lua vim.diagnostic.goto_prev({ severity = {min='WARN', max='ERROR'}})<CR>")

	--show line diagnositcs
	maps.nnoremap("se", ":lua vim.diagnostic.open_float()<CR>")

	-- lsp formatting
	maps.nnoremap("f;", "<cmd>lua vim.lsp.buf.format({async = true })<CR>")

	maps.nnoremap("K", "<Cmd>lua vim.lsp.buf.hover()<CR>")
	maps.inoremap("<C-k>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")

	-- code actions
	maps.nnoremap("<M-CR>", ":Telescope lsp_code_actions<CR>")
	maps.vnoremap("<M-CR>", ":Telescope lsp_code_actions<CR>")

	-- formatting
	-- maps.nnoremap("f;", ":lua vim.lsp.buf.formatting()<CR>")

	-- commands
	maps.nnoremap("gd", ":Telescope lsp_definitions<CR>")
	maps.nnoremap("gr", ":Telescope lsp_references<CR>")
	maps.nnoremap("gi", ":Telescope lsp_implementations<CR>")
	maps.nnoremap("gdd", ":Telescope lsp_document_diagnostics<CR>")
	maps.nnoremap("gds", ":Telescope lsp_document_symbols<CR>")
	maps.nnoremap("gwd", ":Telescope lsp_workspace_diagnostics<CR>")
	maps.nnoremap("gws", ":Telescope lsp_workspace_symbols<CR>")
end

-- lspNative()

-- function _G.CodeFormatting()
--   maps.nmap("f;", "")
--   -- formatting
--   if vim.bo.filetype == "lua" then
--     maps.nmap("f;", "<cmd>!stylua --indent-width 2 --indent-type Spaces %<CR> <bar> <cmd>e!<CR>")
--     return
--   end

--   if vim.bo.filetype == "javascript" or vim.bo.filetype == "typescript" or vim.bo.filetype == "javascriptreact" then
--     maps.nmap("f;", ":lua vim.lsp.buf.formatting()<CR>")
--     return
--   end

--   if vim.bo.filetype == "sh" then
--     -- maps.nmap("f;", ":!shfmt -i 2 -w -ci '%' <CR>|:e!<CR>")
--     maps.nmap("f;", "<cmd>!shfmt -i 2 -w -ci '%' <CR> <bar> <cmd>e!<CR>")
--     return
--   end

--   if vim.bo.filetype == "go" then
--     maps.nmap("f;", ":!gofmt -w '%'<CR>|:e!<CR>")
--     return
--   end

--   if vim.bo.filetype == "make" then
--     maps.nmap("f;", "")
--     return
--   end
-- end

-- vim.api.nvim_create_autocmd("BufReadPre", {
--   pattern = "*",
--   callback = _G.CodeFormatting,
-- })

local function withFuzzyFinders()
	maps.nnoremap("<leader>f", "<cmd>:Telescope current_buffer_fuzzy_find<CR>")
	maps.nnoremap("sb", "<cmd>Telescope buffers<CR>")
end

withFuzzyFinders()

-- rnvimr (file explorer)
maps.nnoremap("<M-o>", ":RnvimrToggle<CR>")
maps.tnoremap("<M-o>", "<C-\\><C-n>:RnvimrToggle<CR>")
-- because, rnvimr shits wqa
maps.cnoremap("wqa", "wa! | qa")

-- for tabs
-- maps.nnoremap("tn", "<cmd>tabnew<CR>")
maps.nnoremap("tn", "<cmd>tabnew<CR>|:windo tcd " .. vim.g.root_dir .. "<CR>")
maps.nnoremap("te", "<cmd>tabedit % |:windo tcd " .. vim.g.root_dir .. "<CR>")
maps.nnoremap("tl", "<cmd>lua require('plugins_dir.telescope').tabs()<CR>")

-- .Source: https://gist.github.com/benfrain/97f2b91087121b2d4ba0dcc4202d252f
-- Keep search results centred
maps.nnoremap("n", "nzzzv")
maps.nnoremap("N", "Nzzzv")
maps.nnoremap("J", "mzJ`z")

-- from:plugin / navigator.nvim
vim.g.tmux_navigator_no_mappings = 1
maps.nnoremap("<M-h>", "<cmd>lua require'nvim-tmux-navigation'.NvimTmuxNavigateLeft()<CR>")
maps.nnoremap("<M-l>", "<cmd>lua require'nvim-tmux-navigation'.NvimTmuxNavigateRight()<CR>")
maps.nnoremap("<M-j>", "<cmd>lua require'nvim-tmux-navigation'.NvimTmuxNavigateDown()<CR>")
maps.nnoremap("<M-k>", "<cmd>lua require'nvim-tmux-navigation'.NvimTmuxNavigateUp()<CR>")

-- lsp
vim.cmd("command! -nargs=0 Root execute 'windo tcd g:root_dir'")
vim.cmd("command! -nargs=1 Cd execute 'windo tcd <f-args> <CR>'")
--
vim.cmd("cnoreabbrev tcd windo tcd")
