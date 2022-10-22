local packerGrp = vim.api.nvim_create_augroup("Packer", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
	command = "source <afile> | PackerCompile",
	group = packerGrp,
	pattern = "init.lua",
})

local FileTypes = {
	javscript = { "javascript", "typescript" },
	react = { "javascriptreact", "typescriptreact" },
	javascriptreact = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
}

local events = {
	BufReadPost = "BufReadPost",
	BufReadPre = "BufReadPre",
	BufEnter = "BufEnter",
	InsertEnter = "InsertEnter",
	VimEnter = "VimEnter",
}

local function useLSP()
	use({
		"neovim/nvim-lspconfig",
		after = "nvim-cmp",
		event = events.BufReadPost,
		config = function()
			require("nxtcoder17.plugins.lspconfig")
		end,
		requires = {
			{ "b0o/schemastore.nvim" },
			{ "folke/lsp-colors.nvim", after = "nvim-lspconfig" },
			-- { "williamboman/nvim-lsp-installer", after = "nvim-lspconfig" },
		},
	})

	vim.lsp.handlers["$/progress"] = function(_, result, ctx)
		local client_id = ctx.client_id

		local val = result.value
		if not val.kind then
			return
		end
		-- print(val.message)
	end

	-- use({
	-- 	"rcarriga/nvim-notify",
	-- 	config = function()
	-- 		require("nxtcoder17.plugins.nvim-notify")
	-- 	end,
	-- })
end

local function useSyntaxes()
	use({
		"sheerun/vim-polyglot",
		config = function() end,
	})
	use({ "mboughaba/i3config.vim", ft = "i3config" })
	use({ "fladson/vim-kitty", ft = "kitty" })
end

local function useApiClients()
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

local function debugging()
	use({
		"mfussenegger/nvim-dap",
		config = function()
			require("nxtcoder17.plugins.dap")
		end,
		requires = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-telescope/telescope-dap.nvim",
			{ "jbyuki/one-small-step-for-vimkind", module = "osv" },
		},
	})
	-- use({
	--   "leoluz/nvim-dap-go",
	--   config = function()
	--     -- require("dap-go").setup()
	--   end,
	-- })
	-- use({ "Pocco81/dap-buddy.nvim" })
end

vim.cmd([[packadd packer.nvim]])
require("packer").startup({
	function()
		_G.use = use
		_G.use_rocks = use_rocks

		use({ "wbthomason/packer.nvim", opt = true })
		use({ "kevinhwang91/rnvimr" })
		use({
			"williamboman/mason.nvim",
			config = function()
				require("mason").setup({})
			end,
		})

		use_rocks("base64")

		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			-- event = "BufEnter",
			config = function()
				require("nxtcoder17.plugins.treesitter")
				require("treesitter-context").setup()
			end,
			requires = {
				{ "MaxMEllon/vim-jsx-pretty", event = events.BufEnter, ft = FileTypes.react },
				{ "nvim-treesitter/nvim-treesitter-refactor", after = "nvim-treesitter" },
				{ "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" },
				-- { "RRethy/nvim-treesitter-textsubjects", after = "nvim-treesitter" },
				{ "andymass/vim-matchup", event = events.VimEnter },
				{ "windwp/nvim-ts-autotag", event = events.BufReadPre, after = "nvim-treesitter" },
				{
					"JoosepAlviste/nvim-ts-context-commentstring",
					after = "nvim-treesitter",
					-- ft = FileTypes.javascriptreact,
				},
				{ "p00f/nvim-ts-rainbow", event = events.BufReadPre },
				{ "andymass/vim-matchup", after = "nvim-treesitter" },
				{ "nvim-treesitter/playground", after = "nvim-treesitter" },
				{ "nvim-treesitter/nvim-treesitter-context" },
			},
		})

		use({ "tpope/vim-commentary" })
		use({
			"folke/todo-comments.nvim",
			event = events.BufReadPre,
			config = function()
				-- require("nxtcoder17.todo-comments")
				-- require("plugins_dir.todo-comments")
			end,
		})

		use({
			"nvim-telescope/telescope.nvim",
			config = function()
				pcall(require, "nxtcoder17.plugins.telescope")
				-- require("plugins_dir.telescope")
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
				pcall(require, "nxtcoder17.plugins.fzf-lua")
				-- require("plugins_dir.fzf-lua")
			end,
		})

		use({ "folke/tokyonight.nvim" })

		use({
			"rebelot/kanagawa.nvim",
			config = function()
				require("nxtcoder17.plugins.kanagawa")
			end,
		})

		use({ "folke/neodev.nvim" })

		use({
			"jose-elias-alvarez/null-ls.nvim",
			config = function()
				require("nxtcoder17.plugins.null-ls")
			end,
		})

		use({
			"hrsh7th/nvim-cmp",
			requires = {
				{ "neovim/nvim-lspconfig" },
				{ "hrsh7th/cmp-nvim-lsp" },
				{ "hrsh7th/cmp-buffer", after = "nvim-cmp" },
				{ "hrsh7th/cmp-path", after = "nvim-cmp" },
				{ "ray-x/cmp-treesitter", after = "nvim-cmp" },
				{ "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" },
				{ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
				{
					"L3MON4D3/LuaSnip",
					after = "nvim-cmp",
					-- config = function()
					--   require('nvim.plugins.luasnip.snippet_manager').setup()
					--   require('nvim.plugins.luasnip.snippets').setup()
					-- end,
				},
			},
			event = events.BufReadPost,
			config = function()
				require("nxtcoder17.plugins.nvim-cmp")
			end,
		})

		use({
			"echasnovski/mini.nvim",
			config = function()
				require("nxtcoder17.plugins.mini")
			end,
		})

		useLSP()
		useSyntaxes()
		useApiClients()
		debugging()
		use({ "alexghergh/nvim-tmux-navigation" })
		use({
			"nanozuki/tabby.nvim",
			event = events.VimEnter,
			config = function()
				require("tabby").setup({})
			end,
		})

		use({
			"nvim-lualine/lualine.nvim",
			requires = {
				{ "kyazdani42/nvim-web-devicons" },
				-- { "arkav/lualine-lsp-progress" },
			},
			event = "BufEnter",
			config = function()
				require("nxtcoder17.plugins.lualine")
			end,
		})

		use({
			"luukvbaal/stabilize.nvim",
			event = events.BufReadPost,
			config = function()
				require("stabilize").setup()
			end,
		})

		use({
			"stevearc/dressing.nvim",
			config = function()
				require("dressing").setup({})
			end,
		})

		use({
			"lewis6991/gitsigns.nvim",
			config = function()
				require("nxtcoder17.plugins.gitsigns")
			end,
		})

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
	end,
})
