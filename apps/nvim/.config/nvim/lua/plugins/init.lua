-- [Bootstrap lazy.nvim](https://lazy.folke.io/installation)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local function fuzzy_finders()
	return {
		{
			"ibhagwan/fzf-lua",
			commit = "86b77a661ff38bf08b1ceb5a6c3c257285a42a4d",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			lazy = true,
			-- event = "UIEnter",
			-- event = "Lazy",
			config = function()
				require("plugins.fzf")
			end,
			cmd = {
				"Fzf",
				"FzfLua",
			},
			keys = { "sf", "cd", "f;" },
		},
	}
end

local function colorschemes()
	return {
		{
			"rebelot/kanagawa.nvim",
			event = "UIEnter",
			-- priority = 1000,
			config = function()
				Require("plugins.colorschemes")
			end,
		},
	}
end

local function syntax()
	return {
		{
			"nvim-treesitter/nvim-treesitter",
			event = "BufReadPost",
			config = function()
				require("plugins.treesitter")
			end,
			dependencies = {
				{ "nvim-treesitter/nvim-treesitter-textobjects" },
				-- {
				--   "yorickpeterse/nvim-tree-pairs",
				--   config = function()
				---     require("tree-pairs").setup()
				--   end,
				-- },
				{
					"JoosepAlviste/nvim-ts-context-commentstring",
					config = function()
						require("ts_context_commentstring").setup({
							enable_autocmd = false,
							languages = {
								-- gotmpl = "{{- /* %s */}}",
								gotmpl = {
									__default = "{{- /* %s */}}",
								},
								gotexttmpl = {
									__default = "{{- /* %s */}}",
								},
								gohtmltmpl = {
									__default = "{{- /* %s */}}",
								},
								-- terraform = "# %s",
								-- proto = "// %s",
								-- kdl = "// %s",
								-- gotexttmpl = "{{- /* %s */}}",
								-- gohtmltmpl = "{{- /* %s */}}",
							},
						})
					end,
				},
				-- {
				--   "andymass/vim-matchup",
				--   event = "BufWinEnter",
				--   init = function()
				--     vim.g.matchup_matchparen_offscreen = { method = "popup", fullwidth = 1, syntax_hl = 1 }
				--     vim.g.matchup_matchparen_deferred = 1
				--   end,
				-- },
				{ "nvim-treesitter/playground" },
			},
		},
		{
			"nvim-treesitter/nvim-treesitter-context",
			event = "BufReadPost",
			dependencies = { "nvim-treesitter" },
			config = function()
				require("treesitter-context").setup()
			end,
		},
		{
			"ziontee113/syntax-tree-surfer",
			dependencies = {
				"nvim-treesitter",
			},
			event = "BufReadPost",
			config = function()
				require("plugins.treesitter.syntax-tree-surfer")
			end,
		},
		{
			-- enhanced highlighting for semantic match pairs
			"utilyre/sentiment.nvim",
			event = "BufReadPost",
			config = function()
				require("sentiment").setup()
			end,
		},

		{
			"kevinhwang91/nvim-ufo",
			dependencies = "kevinhwang91/promise-async",
			-- event = "BufReadPost", -- needed for folds to load properly
			cmd = {
				"UfoEnable",
				"UfoDisable",
			},
			config = function()
				require("plugins.treesitter.nvim-ufo")
			end,
		},
	}
end

local function lsp()
	return {
		{
			"williamboman/mason.nvim",
			cmd = { "Mason", "MasonInstall" },
			opts = { max_concurrent_installers = 10 },
			config = function()
				require("mason").setup()

				Require("plugins.lsp.languages.go").setup_mason()
				Require("plugins.lsp.languages.c").setup_mason()
				Require("plugins.lsp.languages.lua").setup_mason()
				Require("plugins.lsp.languages.typescript").setup_mason()
				Require("plugins.lsp.languages.deno").setup_mason()
				Require("plugins.lsp.languages.html").setup_mason()
				Require("plugins.lsp.languages.htmx").setup_mason()
				Require("plugins.lsp.languages.nix").setup_mason()
				Require("plugins.lsp.languages.python").setup_mason()
				Require("plugins.lsp.languages.docker").setup_mason()
				Require("plugins.lsp.languages.bash").setup_mason()
				Require("plugins.lsp.languages.css").setup_mason()
				Require("plugins.lsp.languages.tailwindcss").setup_mason()
				Require("plugins.lsp.languages.terraform").setup_mason()
				Require("plugins.lsp.languages.graphql").setup_mason()
				Require("plugins.lsp.languages.protobuf").setup_mason()
				Require("plugins.lsp.languages.sql").setup_mason()

				Require("plugins.lsp.formatter").setup_mason()
			end,
		},
		{
			"neovim/nvim-lspconfig",
			event = "BufReadPost",
			config = function()
				require("plugins.lsp")
			end,
			-- commit = "67f151e84daddc86cc65f5d935e592f76b9f4496",
			dependencies = {
				{ "folke/neodev.nvim", ft = "lua" },
				-- "williamboman/mason-lspconfig.nvim",
				"b0o/schemastore.nvim",
			},
		},
		-- {
		-- 	"creativenull/efmls-configs-nvim",
		-- 	event = "BufRead",
		-- 	after = "nvim-lspconfig",
		-- 	version = "v0.2.x", -- tag is optional
		-- 	dependencies = { "neovim/nvim-lspconfig" },
		-- },
		{
			"stevearc/conform.nvim",
			event = "BufRead",
			after = "nvim-lspconfig",
			config = function()
				Require("plugins.lsp.formatter").setup_formatters()
			end,
		},

		{
			"olexsmir/gopher.nvim",
			ft = "go",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-treesitter/nvim-treesitter",
			},
			config = function()
				Require("gopher").setup()
			end,
		},
		{
			"folke/trouble.nvim",
			dependencies = {
				"neovim/nvim-lspconfig",
			},
			cmd = {
				"Trouble",
				"TroubleToggle",
				"TroubleRefresh",
			},
			config = true,
		},
	}
end

local function git_clients()
	return {
		{
			"sindrets/diffview.nvim",
			cmd = {
				"DiffviewFileHistory",
				"DiffviewOpen",
				"DiffviewClose",
				"DiffviewRefresh",
				"DiffviewToggleFiles",
				"DiffviewFocusFiles",
			},
			config = function()
				require("plugins.diffview")
			end,
		},
	}
end

local function navigation()
	return {
		{
			"alexghergh/nvim-tmux-navigation",
			keys = {
				{
					"<M-h>",
					function()
						require("nvim-tmux-navigation").NvimTmuxNavigateLeft()
					end,
					mode = "n",
				},
				{
					"<M-l>",
					function()
						require("nvim-tmux-navigation").NvimTmuxNavigateRight()
					end,
					mode = "n",
				},
				{
					"<M-j>",
					function()
						require("nvim-tmux-navigation").NvimTmuxNavigateDown()
					end,
					mode = "n",
				},
				{
					"<M-k>",
					function()
						require("nvim-tmux-navigation").NvimTmuxNavigateUp()
					end,
					mode = "n",
					desc = "Go up",
				},
			},
		},

		{
			"chaoren/vim-wordmotion",
			event = "BufReadPost",
			keys = {
				{ "cw", "ce", mode = "n" },
				{ "cW", "cE", mode = "n" },
			},
			-- config = function()
			--   require("keymaps-for-plugins").vim_wordmotion_mappings()
			-- end,
		},

		-- {
		-- 	"ludovicchabant/vim-gutentags",
		-- 	config = function()
		-- 		vim.g.gutentags_ctags_exclude = {
		-- 		  "@.gitignore"
		-- 		}
		-- 	end,
		-- },

		{
			"mg979/vim-visual-multi",
			lazy = true,
			keys = { "<C-n>" },
		},
	}
end

local function completions()
	return {
		{
			"L3MON4D3/LuaSnip",
			event = "BufReadPost",
			config = function()
				Require("plugins.completions.luasnip")
			end,
		},

		{
			"hrsh7th/nvim-cmp",
			-- commit = "b555203ce4bd7ff6192e759af3362f9d217e8c89",

			-- "yioneko/nvim-cmp",
			-- branch = "perf",
			event = "InsertEnter",
			after = "LuaSnip",
			dependencies = {
				-- { "L3MON4D3/LuaSnip" },
				{ "hrsh7th/cmp-nvim-lsp-signature-help" },
				{ "hrsh7th/cmp-nvim-lsp" },
				-- { "lukas-reineke/cmp-rg" },
				{ "hrsh7th/cmp-cmdline" },
				{ "andersevenrud/cmp-tmux" },
				{ "saadparwaiz1/cmp_luasnip" },
				{ "FelipeLema/cmp-async-path" },
				{ "quangnguyen30192/cmp-nvim-tags" },
				{ "onsails/lspkind.nvim" },
			},
			config = function()
				-- Require("plugins.completions.luasnip")
				Require("plugins.completions.cmp")
			end,
		},

		-- INFO: supermaven is just much better than Copilot
		{
			"supermaven-inc/supermaven-nvim",
			commit = "2d9f42e0dcf57a06dce5bf8b23db427ae3b7799f",
			-- event = events.InsertEnter,
			-- lazy = true,
			cmd = {
				"SupermavenStart",
				"SupermavenStop",
				"SupermavenUseFree",
				"SupermavenStatus",
			},
			config = function()
				require("supermaven-nvim").setup({
					keymaps = {
						accept_suggestion = "<M-l>",
						-- clear_suggestion = "<C-]>",
					},
					disable_inline_completion = false, -- disables inline completion for use with cmp
					-- disable_keymaps = true,
				})
			end,
		},
	}
end

local function search_and_replace()
	return {
		{
			"windwp/nvim-spectre",
			lazy = true,
			cmd = {
				"Spectre",
			},
			config = true,
		},
	}
end

local function neovim_development()
	return {
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "luvit-meta/library", words = { "vim%.uv" } },
				},
			},
		},
		{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
	}
end

local function mini_nvim()
	return {
		{
			"echasnovski/mini.nvim",
			-- event = "UIEnter",
			event = "BufReadPre",
			branch = "stable",
			config = function()
				require("plugins.mini")
			end,
		},
	}
end

local function editor_ui_enhancements()
	return {
		{
			"luukvbaal/stabilize.nvim",
			event = "BufReadPost",
			config = function()
				require("stabilize").setup()
			end,
		},
		{
			"stevearc/dressing.nvim",
			event = "BufReadPost",
			config = function()
				require("dressing").setup({
					-- insert_only = false,
					-- start_in_insert = false,
					relative = "editor",
				})
			end,
		},
		{
			"nvchad/nvim-colorizer.lua",
			ft = { "javascriptreact", "css", "html", "javascript", "typescript", "typescriptreact", "svelte", "vue" },
			event = "BufReadPost",
			config = function()
				require("colorizer").setup({
					filetypes = {
						"javascriptreact",
						"css",
						"html",
						"javascript",
						"typescript",
						"typescriptreact",
						"svelte",
						"vue",
					},
					user_default_options = {
						tailwind = true,
						css = true,
					},
				})
			end,
		},

		{
			"nyngwang/NeoZoom.lua",
			cmd = {
				"NeoZoomToggle",
			},
			keys = {
				{ "sz", "<cmd>NeoZoomToggle<CR>", mode = "n", desc = "Neozoom Toggle", silent = true, noremap = true },
			},
			config = function()
				require("neo-zoom").setup({})
			end,
		},

		{ "ellisonleao/glow.nvim", ft = "markdown", config = true, cmd = "Glow" },

		{
			"nanozuki/tabby.nvim",
			-- event = "UIEnter",
			event = "BufReadPre",
			config = function()
				require("plugins.ui.tabby")
			end,
		},

		-- {
		-- 	"toppair/peek.nvim",
		-- 	ft = "markdown",
		-- 	build = "deno task --quiet build:fast",
		-- 	config = function()
		-- 		require("plugins.peek-nvim")
		-- 	end,
		-- },

		-- {
		-- 	"folke/twilight.nvim",
		-- 	event = "BufReadPost",
		-- },

		-- {
		--   "folke/noice.nvim",
		--   event = events.VeryLazy,
		--   dependencies = {
		--     "MunifTanjim/nui.nvim",
		--   },
		--   config = function()
		--     require("plugins.noice")
		--   end,
		-- },
	}
end

local function nxtcoder17_plugins()
	return {
		{
			-- "nxtcoder17/http-cli",
			dir = "~/workspace/nxtcoder17/http-cli",
			build = "task build",
			cmd = {
				"Gql",
				"Http",
			},
			ft = "yaml",
			config = function()
				require("http-cli").setup({
					envFile = function()
						-- return string.format("%s/%s", vim.env.PWD, ".secrets/gqlenv.yml")
						return string.format("%s/%s", vim.env.PWD, ".secrets/http-cli-env.yml")
					end,
				})
			end,
		},
		-- {
		-- 	dir = "~/workspace/nxtcoder17/minimal.nvim",
		-- 	-- lazy = true,
		-- },
	}
end

local function debugging()
	return {
		{
			"mfussenegger/nvim-dap",
			event = "BufReadPost",
			config = function()
				require("plugins.dap")
			end,
			dependencies = {
				"rcarriga/nvim-dap-ui",
				"nvim-neotest/nvim-nio",
				-- "theHamsta/nvim-dap-virtual-text",
				-- { "jbyuki/one-small-step-for-vimkind", module = "osv" },
			},
		},
	}
end

local function file_managers()
	return {
		{
			"kevinhwang91/rnvimr",
			cmd = {
				"RnvimrToggle",
			},
			keys = {
				{ "<M-o>", "<Cmd>RnvimrToggle<CR>", mode = "n" },
				{ "<M-o>", "<C-\\><C-n>:RnvimrToggle<CR>", mode = "t" },
			},
		},
	}
end

local function terminals()
	return {
		{
			"chomosuke/term-edit.nvim",
			ft = { "toggleterm", "terminal" },
			version = "v1.*",
			config = function()
				require("term-edit").setup({
					prompt_end = "😎 ",
				})
			end,
		},
		{
			"akinsho/toggleterm.nvim",
			-- event = "UIEnter",
			keys = { "st" },
			version = "*",
			config = function()
				require("plugins.toggleterm")
			end,
		},
		{
			"samjwill/nvim-unception",
			lazy = true,
			init = function()
				vim.g.unception_open_buffer_in_new_tab = true
				vim.api.nvim_create_autocmd("User", {
					pattern = "UnceptionEditRequestReceived",
					callback = function()
						-- Toggle the terminal off.
						local ok, toggleterm = pcall(require, "toggleterm")
						if ok then
							toggleterm.toggle()
						end
					end,
				})
			end,
		},
	}
end

local plugins = {}
vim.list_extend(plugins, fuzzy_finders())
vim.list_extend(plugins, colorschemes())
vim.list_extend(plugins, syntax())
vim.list_extend(plugins, lsp())
vim.list_extend(plugins, debugging())
vim.list_extend(plugins, git_clients())
vim.list_extend(plugins, navigation())
vim.list_extend(plugins, completions())
vim.list_extend(plugins, search_and_replace())
vim.list_extend(plugins, neovim_development())
vim.list_extend(plugins, editor_ui_enhancements())
vim.list_extend(plugins, mini_nvim())
vim.list_extend(plugins, nxtcoder17_plugins())
vim.list_extend(plugins, file_managers())
vim.list_extend(plugins, terminals())

require("lazy").setup(plugins, {
	ui = {
		border = "rounded",
	},
	change_detection = {
		enabled = true,
		notify = false,
	},
})
