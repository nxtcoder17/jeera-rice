local exec = vim.api.nvim_command
local fn = vim.fn

-- Auto install packer.nvim if not exists
local installPath = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(installPath)) > 0 then
  exec('!git clone https://github.com/wbthomason/packer.nvim' .. ' ' .. installPath)
end
vim.cmd [[packadd packer.nvim]]
vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

local packer = require('packer')
local util = require('packer.util')

packer.init {
    compile_path = util.join_paths(vim.fn.stdpath('config'), 'packer', 'packer_compiled.vim')
}

vim.g.rainbow_active = 1

return packer.startup(function (use)
  use 'dracula/vim'
	-- Packer can manage itself as an optional plugin
	-- use 'wbthomason/packer.nvim'

  -- AutoTag Completion
  use 'windwp/nvim-ts-autotag'

  -- Navigation
  use 'tpope/vim-surround'

  -- Snippet Runner
  use { 'michaelb/sniprun', run = 'bash ./install.sh'}

	-- LSP
	use 'neovim/nvim-lspconfig'
	use 'onsails/lspkind-nvim'
	use 'kabouzeid/nvim-lspinstall'
	use 'kosayoda/nvim-lightbulb'
	use 'glepnir/lspsaga.nvim'

	-- Autocomplete
	use 'hrsh7th/nvim-compe'
	-- use 'SirVer/ultisnips'
	-- use 'honza/vim-snippets'
	use 'windwp/nvim-autopairs'
	use 'AndrewRadev/tagalong.vim'
	use 'andymass/vim-matchup'

	-- Treesitter
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	-- use 'p00f/nvim-ts-rainbow'  -- does not install with packer
	use 'luochen1990/rainbow'
	-- use { 'lukas-reineke/indent-blankline.nvim', branch = 'lua' }
	use 'JoosepAlviste/nvim-ts-context-commentstring'
	use 'romgrk/nvim-treesitter-context'

	-- Syntax
	use 'moll/vim-node'
	use 'zinit-zsh/zplugin-vim-syntax'
	use 'editorconfig/editorconfig-vim'
	use 'chrisbra/csv.vim'
	use 'junegunn/vim-easy-align'
	use 'dhruvasagar/vim-table-mode'

	-- Icons
	use 'kyazdani42/nvim-web-devicons'
	use 'ryanoasis/vim-devicons'

	-- Status Line and Bufferline
	use 'famiu/feline.nvim'
	use 'romgrk/barbar.nvim'

	-- Telescope
	use 'nvim-lua/popup.nvim'
	use 'nvim-lua/plenary.nvim'
	use 'nvim-telescope/telescope.nvim'
	use 'nvim-telescope/telescope-fzy-native.nvim'
	use 'nvim-telescope/telescope-project.nvim'
	use 'fhill2/telescope-ultisnips.nvim'

	-- Explorer
	use 'kyazdani42/nvim-tree.lua'

	-- Color
	use 'norcalli/nvim-colorizer.lua'

	-- Git
	use { 'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'} }
	use 'kdheepak/lazygit.nvim'
	use 'rhysd/committia.vim'
	use 'sindrets/diffview.nvim'

	-- Javascript
	use 'jose-elias-alvarez/nvim-lsp-ts-utils'

	-- Flutter
	use 'akinsho/flutter-tools.nvim'

  -- Markdown
  use 'npxbr/glow.nvim'

  -- Syntax Definitions
  use 'sheerun/vim-polyglot'

	-- Registers
	use 'tversteeg/registers.nvim'

	-- Move & Search & replace
	use 'windwp/nvim-spectre'
	use 'nacro90/numb.nvim'
	use 'dyng/ctrlsf.vim'
	use 'kevinhwang91/nvim-hlslens'
	use 'justinmk/vim-sneak'
	use 'kshenoy/vim-signature'
	use 'karb94/neoscroll.nvim'
	use 'dstein64/nvim-scrollview'
	use 'chaoren/vim-wordmotion'

	-- Tmux
	use 'tmux-plugins/vim-tmux-focus-events'
	use 'christoomey/vim-tmux-navigator'

	-- Colorschema
	use 'sainnhe/gruvbox-material'
	use 'sainnhe/sonokai'

	-- Commenting
	use 'tpope/vim-commentary'
	use 'folke/todo-comments.nvim'

	-- General Programming
	use 'airblade/vim-rooter'
	use 'sbdchd/neoformat'

	-- File Explorer
	use 'kevinhwang91/rnvimr'
end)

