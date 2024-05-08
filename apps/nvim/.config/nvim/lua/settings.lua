local opt = vim.opt

-- to disable filetype based indentation, uncomment the following line
-- vim.cmd("filetype indent off")

opt.startofline = true

opt.number = true
opt.numberwidth = 4
opt.showmode = false

-- global statusline
opt.laststatus = 3

opt.cmdheight = 0

opt.splitright = true
opt.splitbelow = true

opt.swapfile = false

-- no awkward shitty horizontal shifting due to Diagnostics, GitSigns, etc.
opt.signcolumn = "yes:2"

opt.wrap = true

vim.opt.list = true
vim.opt.listchars = {
  eol = "↵",
  tab = " ",
}

-- opt.listchars:append({ eol = " 󰌑 ", tab = "" })
opt.fillchars:append({ diff = "╱" })

opt.scrolloff = 7

opt.backspace = "indent,eol,start"

opt.fileformat = "unix"
opt.fileencoding = "utf-8"

-- persistent undo
opt.undodir = { vim.fn.stdpath("cache") .. "undodir" }
opt.undofile = true

opt.listchars = {
  ["eol"] = "↲",
  -- ["tab"] = "»·",
  ["tab"] = "·",
  ["space"] = "␣",
  ["trail"] = "-",
  ["extends"] = "☛",
  ["precedes"] = "☚",

  ["conceal"] = "┊",
  ["nbsp"] = "☠",
}

-- Tab, Spaces and Indentations
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2   -- spaces per tab when using >> or <<
opt.expandtab = true -- expand tabs into spaces
opt.autoindent = true
opt.smarttab = true
opt.shiftround = true
-- Copy Previous Indentation
opt.smartindent = true
opt.copyindent = true
opt.autoindent = true

function _G.indent_with_spaces()
  -- Tab, Spaces and Indentations
  opt.tabstop = 2
  opt.softtabstop = 2
  opt.shiftwidth = 2  -- spaces per tab when using >> or <<
  opt.expandtab = true -- expand tabs into spaces
  opt.autoindent = true
  opt.smarttab = true
  opt.shiftround = true
  -- Copy Previous Indentation
  opt.smartindent = true
  opt.copyindent = true
  opt.autoindent = true
end

function _G.indent_with_tabs()
  -- using tabs for indentation, and spaces for everything else
  -- reference: https://vim.fandom.com/wiki/Indent_with_tabs,_align_with_spaces
  opt.expandtab = false
  opt.copyindent = true
  opt.preserveindent = true
  opt.softtabstop = 0
  opt.shiftwidth = 2
  opt.tabstop = 2
end

indent_with_tabs()

-- wild menu
-- opt.wildmenu = true
-- opt.wildmode = "full"
opt.wildoptions = "pum"
opt.pumblend = 1
opt.pumheight = 20
--
vim.list_extend(opt.wildignore, { "node_modules", ".git", ".next", "build", "dist" })

-- completion
opt.completeopt = "menuone,noselect"

-- Fast Scrolling
opt.ttimeoutlen = 10
opt.timeoutlen = 500
opt.ttyfast = true
opt.updatetime = 50
-- opt.lazyredraw = false

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
opt.ttyfast = true
-- opt.lazyredraw = true

-- colors
opt.termguicolors = true
vim.cmd([[
  let &t_Cs = "\e[4:3m"
  let &t_Ce = "\e[4:0m"
]])
opt.updatetime = 100

-- buffers
opt.switchbuf = "useopen,usetab,newtab"

opt.foldmethod = "manual"

vim.o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

-- augroup highlight_yank
-- autocmd!
--     autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank("IncSearch", 200)
-- augroup END

-- fold text
-- vim.cmd(
--   [[ set foldtext=substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) ]]
-- )

-- neovide settings
-- opt.guifont = "ComicCodeLigatures-Medium:h11"
opt.guifont = "ComicCodeLigatures Nerd Font Medium:h11"
vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_cursor_trail_size = 0
