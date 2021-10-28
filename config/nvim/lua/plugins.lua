require("packer").startup(function()
  use("wbthomason/packer.nvim")

  use("lewis6991/impatient.nvim")

  -- syntax
  use("sheerun/vim-polyglot")

  -- color schemes
  use({
    "mcchrish/zenbones.nvim",
    requires = "rktjmp/lush.nvim",
  })
  use("shaunsingh/nord.nvim")
  use("sainnhe/everforest")
  use("sainnhe/gruvbox-material")
  use("maaslalani/nordbuddy")
  use("norcalli/nvim-colorizer.lua")

  use("tpope/vim-surround")
  use("tpope/vim-commentary")
  use("mbbill/undotree")
  use("kevinhwang91/nvim-hlslens")
  use("mg979/vim-visual-multi")

  -- status line
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
  })

  -- coc lsp
  -- use {'neoclide/coc.nvim', branch = 'release'}
  use({ "junegunn/fzf", run = "./install --bin" })
  use({
    "ibhagwan/fzf-lua",
    requires = {
      "vijaymarupudi/nvim-fzf",
      "kyazdani42/nvim-web-devicons",
    },
  })
  use("kevinhwang91/rnvimr")
  use("bayne/vim-dot-http")

  -- tmux
  use("christoomey/vim-tmux-navigator")
  use("psliwka/vim-smoothie")

  -- LSP
  use("neovim/nvim-lspconfig")
  use("folke/lsp-colors.nvim") --  better diagonstics colors
  use("hrsh7th/nvim-compe")
  use("onsails/lspkind-nvim")
  use("folke/lua-dev.nvim")
  use("williamboman/nvim-lsp-installer")
  use("nvim-lua/lsp-status.nvim")
  use("jose-elias-alvarez/nvim-lsp-ts-utils")
  use("ray-x/lsp_signature.nvim")

  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup({})
    end,
  })

  -- Code Beauty
  use("mhartington/formatter.nvim")

  -- AutoCompletion

  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-nvim-lua" },
      { "ray-x/cmp-treesitter" },
      { "SirVer/ultisnips" },
      { "quangnguyen30192/cmp-nvim-ultisnips" },
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-vsnip" },
      { "hrsh7th/vim-vsnip" },
      { "hrsh7th/vim-vsnip-integ" },
      { "Saecki/crates.nvim" },
      { "f3fora/cmp-spell" },
    },
  })
  use({
    "andersevenrud/compe-tmux",
    branch = "cmp",
  })

  -- Treesitter
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  use("windwp/nvim-autopairs")
  use("p00f/nvim-ts-rainbow")
  use("JoosepAlviste/nvim-ts-context-commentstring")
  use("andymass/vim-matchup")
  use("nvim-treesitter/nvim-treesitter-refactor")
  use("windwp/nvim-ts-autotag")

  -- Telescope
  use("nvim-lua/popup.nvim")
  use("nvim-lua/plenary.nvim")
  use("nvim-telescope/telescope.nvim")
  use("nvim-telescope/telescope-fzy-native.nvim")
  use("nvim-telescope/telescope-project.nvim")
  --
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

  use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } })

  -- Better profiling output for startup.
  use({ "dstein64/vim-startuptime", cmd = "StartupTime" })
end)

-- git signs
-- require('gitsigns').setup {
--   signcolumn = false,  -- Toggle with `:Gitsigns toggle_signs`
--   numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
--   linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
--   word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
-- }

-- Setting up Nord Colorscheme
vim.g.nord_contrast = true
vim.g.nord_borders = true
-- require("nord").set()
vim.cmd([[ colorscheme nordbuddy ]])

require("colorizer").setup()

-- Extensions

------------------------\ Highlight Search
require("hlslens").setup({
  calm_down = true,
  nearest_only = true,
  nearest_float_when = "always",
})
