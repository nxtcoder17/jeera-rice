local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  local packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end

local packer = require("packer")

local events = {
  BufReadPost = "BufReadPost",
  BufReadPre = "BufReadPre",
  BufEnter = "BufEnter",
  InsertEnter = "InsertEnter",
  VimEnter = "VimEnter",
};

local FileTypes = {
  javscript = {"javascript", "typescript"},
  react = {"javascriptreact", "typescriptreact"},
  javascriptreact = {"javascript", "typescript", "javascriptreact", "typescriptreact"},
};

local function withLsp()
  local first = "nvim-lspconfig"
  use({
    "neovim/nvim-lspconfig", event = events.BufReadPost,
    config = function() require("lsp") end,
    requires = {
      { "williamboman/nvim-lsp-installer", after = first },
      { "stevearc/aerial.nvim", after=first,
        config = function() 
          require("aerial").setup({})
        end
      },
      { "folke/lsp-colors.nvim", after = first},
      -- { "tami5/lspsaga.nvim", after = "nvim-lspconfig", config = function()
      -- 		require("lspsaga").setup()
      -- end }
    },
  })
end

local function withTS()
  local first = "nvim-treesitter"
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    event = "BufEnter",
    config = function()
      require("plugins_dir.treesitter")
    end,
    requires = {
      {"MaxMEllon/vim-jsx-pretty", event = events.BufEnter, ft=FileTypes.react},
      { "nvim-treesitter/nvim-treesitter-refactor", after = first},
      { "nvim-treesitter/nvim-treesitter-textobjects", after = first},
      -- { "RRethy/nvim-treesitter-textsubjects", after = "nvim-treesitter" },
      {'andymass/vim-matchup', event= events.VimEnter},
      {'windwp/nvim-ts-autotag', event=events.BufReadPre, after=first},
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        after = first,
        ft = FileTypes.javascriptreact,
      },
      { 
        "p00f/nvim-ts-rainbow", 
        commit ="7e1af3e61b8f529031",
        event = events.BufReadPre 
      },
      { 'andymass/vim-matchup', after=first },
      -- {
      --   "numToStr/Comment.nvim",
      --   after = first,
      --   event = events.BufReadPost,
      --   config = function()
      --     require("plugins_dir.comment-nvim")
      --   end,
      -- },
    },
  })
end

local function withTelescope()
  local first = "telescope.nvim"
  use({
    "nvim-telescope/telescope.nvim",
    -- event = "VimEnter",
    config = function()
      require("plugins_dir.telescope")
    end,
    requires = {
      {"nvim-lua/popup.nvim"},
      {"nvim-lua/plenary.nvim"},
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    },
  })
end

local function withCodingSetup()
  -- syntax highlighting
  use({ "mboughaba/i3config.vim", ft = "i3config" })
  use({ "fladson/vim-kitty", ft = "kitty" })
  use{ "sheerun/vim-polyglot"}
  use({"nxtcoder17/graphql-cli", run = "pnpm i", config = function()
    require("graphql-cli").setup({
        command = "Gql"
      })
  end})

  -- color schemes
  use({ "folke/tokyonight.nvim", disable = false })
  use({ "rebelot/kanagawa.nvim", config = function() require("plugins_dir.colorscheme") end })
  use({ "kevinhwang91/rnvimr", commit = "e93671b4ea8" }) -- something broke in latest, i could not do splits

  use({ "github/copilot.vim", event = events.OnInsert, opt=true }) -- copilot is bottleneck, for poor startup, and lags telescope
  use({ "tpope/vim-commentary"})

  use({
    "ellisonleao/glow.nvim",
    ft = "markdown",
    event="BufRead",
    config = function()
      vim.g.glow_binary_path = vim.fn.stdpath("data") .. "bin"
      vim.g.glow_border = "rounded"
    end,
  })

  use({
    'dcampos/nvim-snippy',
    event=events.InsertEnter,
    config = function()
      require("snippy").setup({})
    end
  })

  -- info: language: markdown
  use({ "davidgranstrom/nvim-markdown-preview", ft = "markdown", event=events.BufReadPost })

  use({ "tpope/vim-surround", event = events.InsertEnter })
  use({ "chaoren/vim-wordmotion", event = events.InsertEnter })
  use({ "mg979/vim-visual-multi", event = events.BufReadPost })
  
  use({'simrat39/symbols-outline.nvim', event = events.BufReadPost, after="nvim-lspconfig" })

  use({
    "windwp/nvim-autopairs",
    event = events.InsertEnter,
    after = "nvim-cmp",
    config = function()
      require("nvim-autopairs").setup({})

      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
    end,
  })

  use({"caenrique/nvim-toggle-terminal", event = events.BufReadPost })

  -- AutoCompletion
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lua" },
      { "ray-x/cmp-treesitter" },
      { "Saecki/crates.nvim" },
      { "dcampos/cmp-snippy" },
      { "f3fora/cmp-spell" },
      {
        "hrsh7th/cmp-copilot",
        config = function()
          require("plugins_dir.copilot")
        end,
      },
    },
    -- event = "InsertEnter",
    event = events.BufReadPost,
    config = function()
      require("plugins_dir.nvim-cmp")
    end,
  })

  -- kubernetes
  use({ "andrewstuart/vim-kubernetes", ft = "yaml", event = events.BufReadPost })

  -- auto session
  use({
    "rmagatti/auto-session",
    config = function()
      vim.o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
      require("auto-session").setup({
        log_level = "info",
        -- auto_session_enabled = true,
        auto_session_enabled = true,
        auto_restore_enabled = true,
        auto_session_suppress_dirs = { "~/" },
        auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
      })
    end,
  })

  -- search and replace
  use({
    'nvim-pack/nvim-spectre', 
    event = events.BufReadPost,
    config = function() require('spectre').setup() end,
  })

  use({"lukas-reineke/indent-blankline.nvim", event="BufReadPre",
      config = function() 
        require("indent_blankline").setup()
      end
    })

  use({"sindrets/diffview.nvim", event = events.BufReadPre})
end

local function withAsthetics()
  use({
    "luukvbaal/stabilize.nvim",
    event = events.BufReadPost,
    config = function()
      require("stabilize").setup()
    end,
  })

  -- use({
  --   "beauwilliams/focus.nvim", 
  --   event = events.VimEnter, 
  --   config = function() 
  --     require("focus").setup({
  --       enable = false,
  --       autoresize = false,
  --       cursorline = false
  --     })
  --   end
  -- })

  use({
    "folke/todo-comments.nvim",
    event = events.BufReadPre,
    config = function()
      require("plugins_dir.todo-comments")
    end,
  })

  --  align vertically based on search
  use({ "godlygeek/tabular", event = events.BufReadPost })

  use({"j-hui/fidget.nvim", config = function() 
    require("fidget").setup()
  end})

  -- tabs with names
  use({
    "nanozuki/tabby.nvim",
    commit="2ac781cae7aedade8def03d48a3a0616dce279ae",
    event = events.VimEnter,
    config = function() require("tabby").setup() end,
  })

  -- buffers
  use("kazhala/close-buffers.nvim")

  use({
    "kevinhwang91/nvim-hlslens",
    event = "BufReadPost",
    config = function()
      require("hlslens").setup({
        calm_down = true,
        nearest_only = true,
        nearest_float_when = "always",
      })
    end,
  })

  use({
    "norcalli/nvim-colorizer.lua",
    event = events.BufReadPre,
    config = function()
      require("colorizer").setup()
    end,
  })

  -- back to where you left
  use("farmergreg/vim-lastplace")

  -- status line
  use({
    "nvim-lualine/lualine.nvim",
    requires = {
      { "kyazdani42/nvim-web-devicons" },
      -- { "arkav/lualine-lsp-progress" },
    },
    event = "BufEnter",
    config = function()
      require("plugins_dir.lualine")
    end,
  })

  use({
    "ibhagwan/fzf-lua",
    event = "BufReadPost",
    requires = {
      "kyazdani42/nvim-web-devicons",
      { "junegunn/fzf", run = "./install --bin" },
    },
    config = function()
      require("plugins_dir.fzf-lua")
    end
  })

  -- tmux
  use("christoomey/vim-tmux-navigator")
end

local function minimalPackages()
  require("packer").startup({ function()
    _G.use = use

    use("wbthomason/packer.nvim")
    use({ "dstein64/vim-startuptime", cmd = "StartupTime" })
    use("lewis6991/impatient.nvim") -- for faster neovim

    -- use({
    --   "nathom/filetype.nvim",
    --   config = function()
    --     vim.g.did_load_filetypes = 1
    --   end,
    -- })

    withTelescope()
    withLsp()
    withTS()

    withCodingSetup()
    withAsthetics()

    end,
    config = {
      profile = { enable = true, threshold = 1 }
    }
  })
end

local function packages()
	require("packer").startup(function()
		-- for faster neovim
		use("lewis6991/impatient.nvim")

		use({
			"nathom/filetype.nvim",
			config = function()
				vim.g.did_load_filetypes = 1
			end,
		})

		use({"caenrique/nvim-toggle-terminal", event = "BufEnter"})

		use({
			"antoinemadec/FixCursorHold.nvim",
		})


		use("wbthomason/packer.nvim")

		-- osc copy
		use("ojroques/vim-oscyank")

		-- lsp symbols
		-- use("simrat39/symbols-outline.nvim")

		-- back to where you left
		use("farmergreg/vim-lastplace")

		-- search code
		use("dyng/ctrlsf.vim")
		use("nvim-pack/nvim-spectre")

		-- debugger
		use("Pocco81/DAPInstall.nvim")
		use({
			"mfussenegger/nvim-dap",
			ft = { "javascript" },
			requires = {
				{ "rcarriga/nvim-dap-ui", ft = { "javascript" }, after = "nvim-dap" },
				{
					"theHamsta/nvim-dap-virtual-text",
					ft = { "javascript" },
					after = "nvim-dap",
					config = function()
						vim.g.dap_virtual_text = true
						require("nvim-dap-virtual-text").setup()
					end,
				},
			},
		})

		-- copilot
		use({ "github/copilot.vim", event = "InsertEnter" })

		-- markdown
		use({ "davidgranstrom/nvim-markdown-preview", ft = "markdown" })

		-- syntax highlighting
		use({ "mboughaba/i3config.vim", ft = "i3config" })

		-- use({ "lukas-reineke/indent-blankline.nvim", event = "BufRead" })

		--  align
		use({ "godlygeek/tabular", event = "BufRead" })

		-- helm
		use({ "towolf/vim-helm", ft = "helm" })

		-- golang
		-- use({
		-- 	"ray-x/go.nvim",
		-- 	ft = "go",
		-- 	config = function()
		-- 		require("go").setup()
		-- 	end,
		-- })

		-- todo tracking
		use({
			"folke/todo-comments.nvim",
			event = "BufReadPre",
			config = function()
				require("todo-comments").setup()
			end,
		})


		-- auto-sessions
		use({
			"rmagatti/auto-session",
			config = function()
				vim.o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
				require("auto-session").setup({
					log_level = "info",
					-- auto_session_enabled = true,
					auto_session_enabled = true,
					auto_restore_enabled = true,
					auto_session_suppress_dirs = { "~/" },
					auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
				})
			end,
		})

		-- toggle term
		-- use{"akinsho/toggleterm.nvim"}

		-- tab helpers
		use({
			"nanozuki/tabby.nvim",
			event = "VimEnter",
			config = function()
				require("tabby").setup()
			end,
		})

		-- AutoPairs
		use({
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			after = "nvim-cmp",
			config = function()
				require("nvim-autopairs").setup({})

				local cmp_autopairs = require("nvim-autopairs.completion.cmp")
				local cmp = require("cmp")
				cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
			end,
		})

		-- syntax
		use{ "sheerun/vim-polyglot" }
		use({ "fladson/vim-kitty", ft = "kitty" })
		use({
			"ellisonleao/glow.nvim",
			ft = "markdown",
			event="BufRead",
			config = function()
				vim.g.glow_binary_path = vim.fn.stdpath("data") .. "bin"
				vim.g.glow_border = "rounded"
			end,
		})

		-- color schemes
		use({
			"folke/tokyonight.nvim",
			{ "rebelot/kanagawa.nvim" },
		})

		use({
			"norcalli/nvim-colorizer.lua",
			event = "BufReadPre",
			config = function()
				require("colorizer").setup()
			end,
		})

		-- Motion
		use({ "chaoren/vim-wordmotion", event = "InsertEnter" })
		use({ "tpope/vim-surround", event = "InsertEnter" })
		-- use("mbbill/undotree")
		use({
			"kevinhwang91/nvim-hlslens",
			event = "BufReadPost",
			config = function()
				require("hlslens").setup({
					calm_down = true,
					nearest_only = true,
					nearest_float_when = "always",
				})
			end,
		})
		use({ "mg979/vim-visual-multi", event = "BufReadPost" })
		use({ "chrisbra/NrrwRgn", event = "BufReadPost" })

		-- kubernetes
		use({ "andrewstuart/vim-kubernetes", ft = "yaml" })

		-- status line
		use({
			"nvim-lualine/lualine.nvim",
			requires = {
				{ "kyazdani42/nvim-web-devicons" },
				{ "arkav/lualine-lsp-progress" },
			},
			event = "BufEnter",
			config = function()
				require("plugins_dir.lualine")
			end,
		})

		use({
			"ibhagwan/fzf-lua",
			event = "BufReadPost",
			requires = {
				"kyazdani42/nvim-web-devicons",
				{ "junegunn/fzf", run = "./install --bin" },
			},
		})

		-- file explorer
		use({ "kevinhwang91/rnvimr", commit = "e93671b4ea8" }) -- something broke in latest, i could not do splits

		-- tmux
		use("christoomey/vim-tmux-navigator")
		use("psliwka/vim-smoothie")

		-- LSP
		use({
			"neovim/nvim-lspconfig",
			event = "BufReadPost",
			config = function()
				require("lsp")
			end,
			requires = {
				{ "williamboman/nvim-lsp-installer", after = "nvim-lspconfig" },
				{ "stevearc/aerial.nvim", config = function() 
						require("aerial").setup({})
					end
				},
				{ "folke/lsp-colors.nvim", after = "nvim-lspconfig" },
				-- { "tami5/lspsaga.nvim", after = "nvim-lspconfig", config = function() 
				-- 		require("lspsaga").setup()
				-- end }
        {"j-hui/fidget.nvim", config = function() 
          require"fidget".setup{}
        end }
			
			},
		})

		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			-- commit = "4e4b58f8e994",
			event = "BufEnter",
			config = function()
				require("plugins_dir.treesitter")
			end,
			requires = {
				{"MaxMEllon/vim-jsx-pretty", event="BufEnter"},
				{ "nvim-treesitter/nvim-treesitter-refactor", after = "nvim-treesitter" },
				{ "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" },
				-- { "RRethy/nvim-treesitter-textsubjects", after = "nvim-treesitter" },
				{'andymass/vim-matchup', event="VimEnter"},
				{
					"JoosepAlviste/nvim-ts-context-commentstring",
					after = "nvim-treesitter",
					ft = { "javascript", "javascriptreact" },
				},
				{ "p00f/nvim-ts-rainbow", event = "BufReadPre" },
				{
					"numToStr/Comment.nvim",
					after = "nvim-treesitter",
					event = "BufReadPost",
					config = function()
						require("plugins_dir.comment-nvim")
					end,
				},
			},
		})

		use({ 
			'dcampos/nvim-snippy', 
			event="InsertEnter",
			config = function() 
				require("snippy").setup({})
			end
		})

		-- use({
		--   "ray-x/lsp_signature.nvim",
		--   event = "BufRead",
		--   config = function()
		--     require("lsp_signature").setup()
		--   end,
		-- })

		use({
			"folke/trouble.nvim",
			requires = "kyazdani42/nvim-web-devicons",
		})

		-- Code Beauty
		-- use("mhartington/formatter.nvim")

		-- Buffer Management
		use({ "kevinhwang91/nvim-bqf", ft = "qf" })
		use({
			"luukvbaal/stabilize.nvim",
			event = "VimEnter",
			config = function()
				require("stabilize").setup()
			end,
		})

		-- TextObj
		-- use("terryma/vim-expand-region")
		use("kana/vim-textobj-user")
		use("kana/vim-textobj-indent")
		use("kana/vim-textobj-line")
		use("kana/vim-textobj-entire")
		use("kana/vim-textobj-function")
		use("kana/vim-textobj-underscore")

		-- wild mode
		use({ "gelguy/wilder.nvim", run = ":UpdateRemotePlugins", event = "VimEnter" })


		-- Telescope
		use("nvim-lua/popup.nvim")
		use("nvim-lua/plenary.nvim")
		use({
			"nvim-telescope/telescope.nvim",
			event = "VimEnter",
			config = function()
				require("plugins_dir.telescope")
			end,
			-- after="tabby.nvim",
			requires = {
				{ "nvim-telescope/telescope-project.nvim" },
				{ "nvim-telescope/telescope-dap.nvim", after = "nvim-dap", ft = { "javascript" } },
			},
		})
		use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

		-- use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } })

		-- Better profiling output for startup.
		use({ "dstein64/vim-startuptime", cmd = "StartupTime" })

		-- buffers
		use("kazhala/close-buffers.nvim")

		-- maximise vim split window
		use("szw/vim-maximizer")

		-- dot-http
		-- use({ "nxtcoder17/vim-dot-http", ft = "http" })

		-- async
		use("tpope/vim-dispatch")

		if packer_bootstrap then
			require("packer").sync()
		end
	end)
end

-- packages()
minimalPackages()
