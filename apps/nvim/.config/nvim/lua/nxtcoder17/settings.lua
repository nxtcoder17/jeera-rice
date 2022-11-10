local opt = vim.opt

opt.startofline = true

opt.background = "dark"

opt.number = true

-- global statusline
opt.laststatus = 3

opt.cmdheight = 0

opt.splitright = true
opt.splitbelow = true

opt.swapfile = false

-- no awkward shitty horizontal shifting due to Diagnostics, GitSigns, etc.
opt.signcolumn = "yes:2"

opt.wrap = true

opt.scrolloff = 10

opt.backspace = "indent,eol,start"

opt.fileformat = "unix"

-- persistent undo
opt.undodir = vim.fn.stdpath("cache") .. "undodir"
opt.undofile = true

-- Tab and Spaces
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2 -- spaces per tab when using >> or <<
opt.expandtab = true -- expand tabs into spaces
opt.autoindent = true
opt.smarttab = true
opt.shiftround = true

-- wild menu
-- opt.wildmenu = true
-- opt.wildmode = "full"
opt.wildoptions = "pum"
opt.pumblend = 9
opt.pumheight = 20
--
opt.wildignore:append("node_modules", ".git", ".next", "build", "dist")

-- completion
opt.completeopt = "menuone,noselect"

-- Fast Scrolling
opt.ttimeoutlen = 10
opt.timeoutlen = 500
opt.ttyfast = true
opt.updatetime = 50
opt.lazyredraw = false

-- Copy Previous Indentation
opt.smartindent = true
opt.copyindent = true
opt.autoindent = true

-- search
opt.incsearch = true
opt.smartcase = true
opt.ignorecase = true
opt.hlsearch = true

-- replace
opt.inccommand = "split" -- shows live incremental status of substitution in split buffer

-- no comment on new lines
vim.cmd([[au! BufEnter * set fo-=c fo-=r fo-=o]])

-- clipboard
-- opt.clipboard = "unnamedplus"
opt.lazyredraw = true

-- colors
opt.termguicolors = true
opt.updatetime = 100

-- buffers
opt.switchbuf = "useopen,usetab,newtab"

-- folds
opt.foldminlines = 10
-- opt.foldnestmax = 2

vim.o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- neovide settings
opt.guifont = "ComicCodeLigatures-Medium:h11"
vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_cursor_trail_size = 0

