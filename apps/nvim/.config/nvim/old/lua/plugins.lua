local fn = vim.fn

local packer = require("packer")
local globals = require("core.globals")

local events = {
	BufReadPost = "BufReadPost",
	BufReadPre = "BufReadPre",
	BufEnter = "BufEnter",
	InsertEnter = "InsertEnter",
	VimEnter = "VimEnter",
}

local FileTypes = {
	javscript = { "javascript", "typescript" },
	react = { "javascriptreact", "typescriptreact" },
	javascriptreact = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
}

local function colors()
	use({
		"rebelot/kanagawa.nvim",
		config = function()
			local defaultColors = require("kanagawa.colors").setup()
			local colors = {
				nxtSelection1 = "#273e5e",
				MiniIndentscopeSymbol = "red",
			}

			local overrides = {
				Visual = {
					bg = colors.nxtSelection1,
				},
				TSException = {
					fg = defaultColors.oniViolet,
				},
				TSKeywordReturn = {
					fg = defaultColors.lightBlue,
				},
				javascriptTSVariableBuiltin = {
					fg = defaultColors.lightBlue,
				},
			}

			vim.opt.fillchars:append({
				horiz = "━",
				horizup = "┻",
				horizdown = "┳",
				vert = "┃",
				vertleft = "┨",
				vertright = "┣",
				verthoriz = "╋",
			})

			require("kanagawa").setup({
				globalStatus = true,
				transparent = true,
				overrides = overrides,
				colors = colors,
				specialReturn = { fg = defaultColors.lightBlue },
			})

			vim.cmd("colorscheme kanagawa")
			-- require("kanagawa").setup({})
		end,
	})

	use({
		"folke/tokyonight.nvim",
		config = function()
			vim.g.tokyonight_style = "night"
			vim.g.tokyonight_italic_functions = true
			vim.g.tokyonight_transparent = true
			vim.g.tokyonight_italic_variables = true
		end,
	})

	-- vim.cmd("colorscheme kanagawa")
end

local function fileManager()
	use({ "kevinhwang91/rnvimr" })
end

local function treesitter()
	local first = "nvim-treesitter"
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		event = "BufEnter",
		config = function()
			require("plugins_dir.treesitter")
		end,
		requires = {
			{ "MaxMEllon/vim-jsx-pretty", event = events.BufEnter, ft = FileTypes.react },
			{ "nvim-treesitter/nvim-treesitter-refactor", after = first },
			{ "nvim-treesitter/nvim-treesitter-textobjects", after = first },
			-- { "RRethy/nvim-treesitter-textsubjects", after = "nvim-treesitter" },
			{ "windwp/nvim-ts-autotag", event = events.BufReadPre, after = first },
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				after = first,
				ft = FileTypes.javascriptreact,
			},
			{
				"p00f/nvim-ts-rainbow",
				-- commit = "7e1af3e61b8f529031",
				event = events.BufReadPre,
			},
			{ "andymass/vim-matchup", after = first },
			{ "nvim-treesitter/playground", after = first },
		},
	})

	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({
				disable_filetype = { "TelescopePrompt", "vim" },
			})
		end,
	})
end

local function fuzzyFinders()
	-- telescope
	local first = "telescope.nvim"
	use({
		"nvim-telescope/telescope.nvim",
		-- event = "VimEnter",
		config = function()
			require("plugins_dir.telescope")
		end,
		requires = {
			{ "nvim-lua/popup.nvim" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
			{ "nvim-telescope/telescope-symbols.nvim" },
			{
				"nvim-telescope/telescope-frecency.nvim",
				config = function()
					require("telescope").load_extension("frecency")
				end,
				requires = { "tami5/sqlite.lua" },
			},
			{ "gbrlsnchs/telescope-lsp-handlers.nvim" },
		},
	})

	-- FZF lua
	use({
		"ibhagwan/fzf-lua",
		event = "BufReadPost",
		requires = {
			"kyazdani42/nvim-web-devicons",
			{ "junegunn/fzf", run = "./install --bin" },
		},
		config = function()
			require("plugins_dir.fzf-lua")
		end,
	})
end

local function findAndReplace()
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

	use({ "mg979/vim-visual-multi" })
end

local function completionEngine()
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "ray-x/cmp-treesitter" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "dcampos/nvim-snippy" },
			{ "dcampos/cmp-snippy" },
			{ "saadparwaiz1/cmp_luasnip" },
			{
				-- "L3MON4D3/LuaSnip",
				-- config = function()
				-- 		require('nvim.plugins.luasnip.snippet_manager').setup()
				-- 		require('nvim.plugins.luasnip.snippets').setup()
				-- end,
			},
		},
		event = events.BufReadPost,
		config = function()
			require("plugins_dir.nvim-cmp-new")
		end,
	})
end

local function lsp()
	local lspconfig = "nvim-lspconfig"
	use({
		"neovim/nvim-lspconfig",
		event = events.BufReadPost,
		config = function()
			require("plugins_dir.lspconfig")
		end,
		requires = {
			{ "williamboman/nvim-lsp-installer", after = lspconfig },
			{ "folke/lsp-colors.nvim", after = lspconfig },
		},
	})

	use({ "folke/neodev.nvim" })

	use({
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			require("plugins_dir.null-ls")
		end,
	})

	-- use({ "j-hui/fidget.nvim", config = function()
	-- 	require("fidget").setup()
	-- end,
	-- })
end

local function syntax()
	use({
		"sheerun/vim-polyglot",
		config = function() end,
	})
	use({ "mboughaba/i3config.vim", ft = "i3config" })
	use({ "fladson/vim-kitty", ft = "kitty" })
end

local function languages()
	use({
		"ray-x/go.nvim",
		event = events.BufReadPost,
		ft = "go",
		config = function()
			require("go").setup()
		end,
	})
end

local function apiClients()
	use({
		"~/workspace/nxtcoder17/graph-cli",
		config = function()
			require("graphql-cli").setup({
				command = "Gql",
				envFile = function()
					return string.format("%s/%s", vim.env.PWD, ".tools/gqlenv.yml")
				end,
			})
		end,
	})

	-- kubernetes
	use({ "andrewstuart/vim-kubernetes", ft = "yaml", event = events.BufReadPost })
end

local function commenting()
	use({ "tpope/vim-commentary" })
	use({
		"folke/todo-comments.nvim",
		event = events.BufReadPre,
		config = function()
			require("plugins_dir.todo-comments")
		end,
	})
end

local function tui()
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
		"luukvbaal/stabilize.nvim",
		event = events.BufReadPost,
		config = function()
			require("stabilize").setup()
		end,
	})

	use({ "godlygeek/tabular" })

	use({
		"nanozuki/tabby.nvim",
		event = events.VimEnter,
		config = function()
			require("tabby").setup({})
		end,
	})

	use("kazhala/close-buffers.nvim")

	use({ "farmergreg/vim-lastplace", event = events.VimEnter })

	use({
		"stevearc/dressing.nvim",
		config = function()
			require("dressing").setup({})
		end,
	})

	--[[
	use({
		"rcarriga/nvim-notify",
		config = function()
			require("nxtcoder17.plugins.nvim-notify")
		end,
	})
	--]]
end

local function motions()
	use({ "alexghergh/nvim-tmux-navigation" })

	use({
		"echasnovski/mini.nvim",
		branch = "stable",
		disable = false,
		config = function()
			require("mini.indentscope").setup({
				draw = {
					delay = 2,
					animation = require("mini.indentscope").gen_animation("none"),
				},
			})

			vim.api.nvim_create_autocmd("InsertEnter", {
				pattern = "*",
				callback = function()
					_G.MiniIndentscope.undraw()
				end,
			})
			vim.api.nvim_create_autocmd("InsertLeave", {
				pattern = "*",
				callback = function()
					_G.MiniIndentscope.draw()
				end,
			})
		end,
	})

	use({
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	})
end

local function session()
	use({
		"rmagatti/auto-session",
		config = function()
			vim.o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
			require("auto-session").setup({
				log_level = "error",
				auto_session_enabled = true,
				auto_restore_enabled = true,
				auto_session_suppress_dirs = { "~/" },
				auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
			})
		end,
	})
end

local function debugging()
	use({ "mfussenegger/nvim-dap" })
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
	use({
		"leoluz/nvim-dap-go",
		config = function()
			require("dap-go").setup()
		end,
	})
	-- use({ "Pocco81/dap-buddy.nvim" })
end

vim.cmd([[packadd packer.nvim]])
require("packer").startup({
	function()
		_G.use = use
		_G.use_rocks = use_rocks

		use({ "wbthomason/packer.nvim", opt = true })
		use("lewis6991/impatient.nvim") -- for faster neovim
		use({
			"nathom/filetype.nvim",
			config = function()
				vim.g.did_load_filetypes = 1
			end,
		})
		syntax()
		colors()
		motions()
		fileManager()
		treesitter()
		fuzzyFinders()
		findAndReplace()
		completionEngine()
		lsp()
		apiClients()
		debugging()
		commenting()
		tui()
		languages()
		session()
	end,
	config = {
		profile = { enable = true, threshold = 1 },
	},
})

-- vim.cmd(string.format("autocmd BufWritePost %s :PackerCompile", vim.fn.expand("%s")))
