require("packer").startup(function()
  use("wbthomason/packer.nvim")

  use("lewis6991/impatient.nvim")

  -- syntax
  use("sheerun/vim-polyglot")
  use("fladson/vim-kitty")

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
  -- use("/jose-elias-alvarez/null-ls.nvim")
  use("ray-x/lsp_signature.nvim")
  use("glepnir/lspsaga.nvim")

  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
  })

  -- Code Beauty
  use("mhartington/formatter.nvim")

  -- Buffer Management
  use({ "kevinhwang91/nvim-bqf", ft = "qf" })

  -- TextObj
  use("terryma/vim-expand-region")

  use("kana/vim-textobj-user")
  use("kana/vim-textobj-indent")
  use("kana/vim-textobj-line")
  use("kana/vim-textobj-entire")
  use("kana/vim-textobj-function")
  use("kana/vim-textobj-underscore")

  -- wild mode
  use({ "gelguy/wilder.nvim", run = ":UpdateRemotePlugins" })

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
  use("nvim-treesitter/nvim-treesitter-refactor")
  use("nvim-treesitter/nvim-treesitter-textobjects")

  use("windwp/nvim-autopairs")
  use("p00f/nvim-ts-rainbow")
  use("JoosepAlviste/nvim-ts-context-commentstring")
  use("andymass/vim-matchup")
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

  -- buffers
  use("famiu/bufdelete.nvim")

  -- navigator
  use({ "ray-x/navigator.lua", requires = { "ray-x/guihua.lua", run = "cd lua/fzy && make" } })

  -- debugging
  use("puremourning/vimspector")
  use("szw/vim-maximizer")
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

-- wilder
-- vim.call([[ wilder#setup({'modes': [':', '/', '?']}) ]])

vim.cmd([[
  let g:expand_region_text_objects = {
        \ 'iw'  :0,
        \ 'iW'  :0,
        \ 'i"'  :0,
        \ 'i''' :0,
        \ 'i]'  :1,
        \ 'ib'  :1,
        \ 'iB'  :1,
        \ 'il'  :1,
        \ 'ip'  :1,
        \ 'ie'  :0,
        \ }
]])

vim.cmd([[ map <C-w> <Plug>(expand_region_expand) ]])
