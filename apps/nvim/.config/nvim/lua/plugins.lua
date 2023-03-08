-- Install packer
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
	vim.cmd([[packadd packer.nvim]])
end

-- local packer_grp = vim.api.nvim_create_augroup("Packer", { clear = true })
-- vim.api.nvim_create_autocmd("BufWritePost", {
-- 	command = "source <afile> | PackerCompile",
-- 	group = packer_grp,
-- 	pattern = vim.fn.expand("$MYVIMRC"),
-- })

require("packer").startup(function()
	use({ "wbthomason/packer.nvim" })
	use_rocks("base64")
	use_rocks("lrexlib-pcre")
	--
	use({
		"neovim/nvim-lspconfig",
		config = function()
			require("nxtcoder17.plugins.lspconfig")
		end,
		requires = {
			"folke/neodev.nvim",
			{
				"williamboman/mason.nvim",
				config = function()
					require("mason").setup()
				end,
			},
			"williamboman/mason-lspconfig.nvim",
			-- Useful status updates for LSP
			{
				"j-hui/fidget.nvim",
				config = function()
					require("fidget").setup({ window = { blend = 0 } })
				end,
			},
			"b0o/schemastore.nvim",
			"folke/lsp-colors.nvim",
			{
				"jose-elias-alvarez/null-ls.nvim",
				config = function()
					require("nxtcoder17.plugins.null-ls")
				end,
			},
		},
	})

	use({
		"echasnovski/mini.nvim",
		branch = "stable",
		config = function()
			require("nxtcoder17.plugins.mini")
		end,
	})

	use({
		"windwp/nvim-spectre",
		config = function()
			require("nxtcoder17.plugins.nvim-spectre")
		end,
	})

	use({
		"ibhagwan/fzf-lua",
		config = function()
			require("nxtcoder17.plugins.fzf-lua")
		end,
	})

	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"edolphin-ydf/goimpl.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
			{ "gbrlsnchs/telescope-lsp-handlers.nvim" },
			{ "debugloop/telescope-undo.nvim" },
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "natecraddock/telescope-zf-native.nvim" },
			-- {
			-- 	"nvim-telescope/telescope-smart-history.nvim",
			-- 	requires = {
			-- 		"kkharji/sqlite.lua",
			-- 	},
			-- },
		},
		config = function()
			require("nxtcoder17.plugins.telescope")
		end,
	})

	use({
		"~/workspace/nxtcoder17/github/http-cli",
		config = function()
			require("http-cli").setup({ envFile = function() return string.format("%s/%s", vim.env.PWD, ".tools/gqlenv.yml") end, })
		end,
	})

	use({ "kevinhwang91/rnvimr" })
	use({ "alexghergh/nvim-tmux-navigation" })
	use({ "mg979/vim-visual-multi" })
	use({ "kazhala/close-buffers.nvim" })

	use({
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup({
				render = "background",
				enable_tailwind = "true",
			})
		end,
	})

	use({
		"luukvbaal/stabilize.nvim",
		event = "BufReadPost",
		config = function()
			require("stabilize").setup()
		end,
	})

	-- completions
	use({
		"hrsh7th/nvim-cmp",
		-- event = "BufReadPost",
		config = function()
			require("nxtcoder17.plugins.nvim-cmp")
		end,
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			{
				"L3MON4D3/LuaSnip",
				config = function()
					require("nxtcoder17.plugins.luasnip")
				end,
			},
			{ "hrsh7th/cmp-nvim-lua" },
			{ "onsails/lspkind.nvim" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "andersevenrud/cmp-tmux" },
			-- { "tzachar/cmp-tabnine", run = "./install.sh" },
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/cmp-buffer" },
			{ "tzachar/cmp-fuzzy-buffer" },
			{ "tzachar/fuzzy.nvim" },
			-- {
			--   "zbirenbaum/copilot.lua",
			--   event = "VimEnter",
			--   config = function()
			--     vim.defer_fn(function()
			--       require("copilot").setup()
			--     end, 100)
			--   end,
			-- },
		},
	})

	use({ "fladson/vim-kitty" })

	-- colorschemes
	use({
		"rebelot/kanagawa.nvim",
		config = function()
			require("nxtcoder17.plugins.kanagawa")
		end,
	})

	use({
		"sainnhe/everforest",
		config = function()
			-- require("nxtcoder17.plugins.colorschemes.everforest")
		end,
	})

	use({
		"olimorris/onedarkpro.nvim",
		config = function()
			require("nxtcoder17.plugins.colorschemes.onedarkpro")
		end,
	})

	use({
		"sainnhe/gruvbox-material",
		config = function()
			-- require("nxtcoder17.plugins.gruvbox-material")
		end,
	})

	use({
		"folke/tokyonight.nvim",
		config = function()
			-- require("nxtcoder17.plugins.tokyonight")
		end,
	})

	use({
		"catppuccin/nvim",
		as = "catppuccin",
		config = function()
			-- require("nxtcoder17.plugins.catppuccin")
		end,
	})

	-- treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nxtcoder17.plugins.treesitter")
			require("treesitter-context").setup()
		end,
		requires = {
			{ "nvim-treesitter/nvim-treesitter-context" },
			{ "nvim-treesitter/nvim-treesitter-refactor", after = "nvim-treesitter" },
			{ "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" },
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				after = "nvim-treesitter",
			},
			{ "p00f/nvim-ts-rainbow", event = "BufReadPre", after = "nvim-treesitter" },
			{ "nvim-treesitter/playground", after = "nvim-treesitter" },
		},
	})

	use({
		"ziontee113/syntax-tree-surfer",
		after = "nvim-treesitter",
		config = function()
			local sts = require("syntax-tree-surfer")

			local opts = { noremap = true, silent = true }

			vim.keymap.set("n", "<M-v>", function() -- only jump to variable_declarations
				-- sts.targeted_jump({ "variable_declaration" })
				sts.filtered_jump({ "variable_declaration" }, true)
			end, opts)

			vim.keymap.set("n", "<M-f>", function() -- only jump to functions
				sts.targeted_jump({ "function", "arrrow_function", "function_definition" })
				--> In this example, the Lua language schema uses "function",
				--  when the Python language uses "function_definition"
				--  we include both, so this keymap will work on both languages
			end, opts)

			vim.keymap.set("n", "<A-m>", function()
				sts.filtered_jump("default", true) --> true means jump forward
			end, opts)
		end,
	})

	use({
		"mfussenegger/nvim-dap",
		config = function()
			require("nxtcoder17.plugins.dap")
		end,
		requires = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			{ "jbyuki/one-small-step-for-vimkind", module = "osv" },
		},
	})

	-- golang
	use({
		"ray-x/go.nvim",
		config = function()
			require("go").setup()
		end,
		requires = {
			"ray-x/guihua.lua",
		},
		ft = "go",
	})

	use({
		"klen/nvim-test",
		config = function()
			require("nvim-test").setup()
		end,
	})

	-- git
	use({ "sindrets/diffview.nvim" })

	-- use({
	--   "luukvbaal/statuscol.nvim",
	--   config = function()
	--     require("statuscol").setup()
	--   end,
	-- })
	--
	-- folding
	use({
		"kevinhwang91/nvim-ufo",
		requires = "kevinhwang91/promise-async",
		config = function()
			require("nxtcoder17.plugins.nvim-ufo")
		end,
	})

	-- term
	use({
		"chomosuke/term-edit.nvim",
		tag = "v1.*",
		config = function()
			require("term-edit").setup({
				prompt_end = "😎 ",
			})
		end,
	})

	use({
		"akinsho/toggleterm.nvim",
		tag = "*",
		config = function()
			require("toggleterm").setup()
		end,
	})

	use({
		"jcdickinson/codeium.nvim",
		requires = {
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("codeium").setup({})
		end,
	})

	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
	})

	use({
		"nanozuki/tabby.nvim",
		config = function()
			require("tabby").setup()
		end,
	})

	-- session manager
	use({
		"jedrzejboczar/possession.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("nxtcoder17.plugins.possession")
		end,
	})

	-- navigation
	use({
		"stevearc/aerial.nvim",
		config = function()
			require("aerial").setup()
		end,
	})

	-- chatgpt
	-- use({
	-- 	"jackMort/ChatGPT.nvim",
	-- 	config = function()
	-- 		require("chatgpt").setup()
	-- 	end,
	-- 	requires = {
	-- 		"MunifTanjim/nui.nvim",
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-telescope/telescope.nvim",
	-- 	},
	-- })
end)

vim.cmd("colorscheme kanagawa")
