-- Install packer
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
	vim.cmd([[packadd packer.nvim]])
end

local packer_grp = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	command = "source <afile> | PackerCompile",
	group = packer_grp,
	pattern = vim.fn.expand("$MYVIMRC"),
})

require("packer").startup(function()
	use({ "wbthomason/packer.nvim" })
	use_rocks("base64")
	--
	use({
		"neovim/nvim-lspconfig",
		config = function()
			require("nxtcoder17.plugins.lspconfig")
		end,
		requires = {
			"folke/neodev.nvim",
			"williamboman/mason.nvim",
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
		config = function()
			require("nxtcoder17.plugins.mini")
		end,
	})

	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
		},
		config = function()
			pcall(require, "nxtcoder17.plugins.telescope")
		end,
	})

	use({
		"~/workspace/nxtcoder17/github/http-cli",
		config = function()
			require("http-cli").setup({
				envFile = function()
					return string.format("%s/%s", vim.env.PWD, ".tools/gqlenv.yml")
				end,
			})
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
		"catppuccin/nvim",
		as = "catppuccin",
		config = function()
			require("nxtcoder17.plugins.catppuccin")
		end,
	})

	use({
		"luukvbaal/stabilize.nvim",
		event = "BufReadPost",
		config = function()
			require("stabilize").setup()
		end,
	})

	use({
		"hrsh7th/nvim-cmp",
		event = "BufReadPost",
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
			{ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" },
		},
	})

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
				-- ft = FileTypes.javascriptreact,
			},
			{ "p00f/nvim-ts-rainbow", event = "BufReadPre", after = "nvim-treesitter" },
			{ "nvim-treesitter/playground", after = "nvim-treesitter" },
			{
				"andymass/vim-matchup",
				event = "BufEnter",
				config = function()
					vim.g.matchup_matchparen_offscreen = { method = "status" }
				end,
			},
		},
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

	use({
		"~/workspace/nxtcoder17/neovim/dap-go",
		config = function()
			require("dap-go").setup()
		end,
	})
end)
