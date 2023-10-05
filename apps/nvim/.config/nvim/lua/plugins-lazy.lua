local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	print("installing lazy.nvim")
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

local events = {
	BufEnter = "BufEnter",
	BufRead = "BufRead",
	BufReadPost = "BufReadPost",
	BufWinEnter = "BufWinEnter",
	UIEnter = "UIEnter",
	InsertEnter = "InsertEnter",
	VeryLazy = "VeryLazy",
}

local function colorschemes()
	return {
		-- {
		--   "folke/tokyonight.nvim",
		--   lazy = false,
		--   priority = 1000,
		--   opts = {},
		-- },
		-- {
		--   "sainnhe/gruvbox-material",
		--   lazy = false,
		--   -- config = function()
		--   -- 	require("plugins.gruvbox-material")
		--   -- end,
		-- },
		{
			"rebelot/kanagawa.nvim",
			lazy = false,
			event = events.VeryLazy,
			init = function()
				require("plugins.kanagawa")
				vim.cmd("colorscheme kanagawa")
			end,
		},
		--   {
		--     "towolf/vim-helm",
		--     ft = { "gotmpl", "gotexttmpl", "yaml" },
		--   },
	}
end

local function fuzzy_finders()
	return {
		{
			"nvim-telescope/telescope.nvim",
			-- event = events.UIEnter,
			-- event = events.BufWinEnter,
			dependencies = {
				"nvim-lua/plenary.nvim",
				{ "nvim-tree/nvim-web-devicons", event = events.VeryLazy },
				{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", event = events.VeryLazy },
				{ "gbrlsnchs/telescope-lsp-handlers.nvim", event = events.VeryLazy, after = "nvim-lspconfig" },
				{ "nvim-telescope/telescope-ui-select.nvim", event = events.VeryLazy },
				-- { "nvim-telescope/telescope-dap.nvim" },
				-- {
				--   "nvim-telescope/telescope-smart-history.nvim",
				--   requires = {
				--     "kkharji/sqlite.lua",
				--   },
				-- },
			},
			config = function()
				require("plugins.telescope")
				require("telescope").load_extension("fzf")
				require("telescope").load_extension("lsp_handlers")
				require("telescope").load_extension("ui-select")
				-- require("telescope").load_extension("dap")
				require("keymaps-for-plugins").telescope_keymaps()
			end,
			cmd = {
				"Telescope",
			},
			keys = {
				"sf",
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
			-- event = events.BufWinEnter,
			init = function()
				require("keymaps-for-plugins").rnvimr_keymaps()
			end,
		},
	}
end

local function navigation()
	return {
		{
			"alexghergh/nvim-tmux-navigation",
			event = events.UIEnter,
			init = function()
				require("keymaps-for-plugins").nvim_tmux_navigator_keymaps()
			end,
		},

		{
			"chaoren/vim-wordmotion",
			event = events.BufRead,
			config = function()
				require("keymaps-for-plugins").vim_wordmotion_mappings()
			end,
		},
	}
end

local function session_managers()
	return {
		{
			"jedrzejboczar/possession.nvim",
			cmd = {
				"PossessionLoad",
				"PossessionSave",
				"PossessionList",
				"PossessionDelete",
				"PossessionRename",
			},
			-- event = events.UIEnter,
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				require("plugins.possession")
			end,
		},
	}
end

local function syntax()
	return {
		{
			"nvim-treesitter/nvim-treesitter",
			event = events.BufReadPost,
			config = function()
				require("plugins.treesitter")
			end,
			dependencies = {
				{ "nvim-treesitter/nvim-treesitter-textobjects" },
				{ "JoosepAlviste/nvim-ts-context-commentstring" },
				{ "nvim-treesitter/playground" },
			},
		},
		{
			"nvim-treesitter/nvim-treesitter-context",
			event = events.BufReadPost,
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
			event = events.BufReadPost,
			config = function()
				require("plugins.syntax-tree-surfer")
			end,
		},
		{
			"utilyre/sentiment.nvim",
			event = events.BufReadPost,
			config = function()
				require("sentiment").setup({})
			end,
		},
		{
			"kevinhwang91/nvim-ufo",
			dependencies = "kevinhwang91/promise-async",
			event = "BufReadPost", -- needed for folds to load properly
			config = function()
				require("plugins.nvim-ufo")
			end,
			-- keys = {
			-- 	{
			-- 		"zr",
			-- 		function()
			-- 			require("ufo").openFoldsExceptKinds({ "comment" })
			-- 		end,
			-- 		desc = " 󱃄 Open All Folds except comments",
			-- 	},
			-- 	{
			-- 		"zm",
			-- 		function()
			-- 			require("ufo").closeAllFolds()
			-- 		end,
			-- 		desc = " 󱃄 Close All Folds",
			-- 	},
			-- },
			-- init = function()
			-- 	-- INFO fold commands usually change the foldlevel, which fixes folds, e.g.
			-- 	-- auto-closing them after leaving insert mode, however ufo does not seem to
			-- 	-- have equivalents for zr and zm because there is no saved fold level.
			-- 	-- Consequently, the vim-internal fold levels need to be disabled by setting
			-- 	-- them to 99
			-- 	vim.opt.foldlevel = 99
			-- 	vim.opt.foldlevelstart = 99
			-- end,
			-- opts = {
			-- 	provider_selector = function(_, ft, _)
			-- 		-- INFO some filetypes only allow indent, some only LSP, some only
			-- 		-- treesitter. However, ufo only accepts two kinds as priority,
			-- 		-- therefore making this function necessary :/
			-- 		local lspWithOutFolding = { "markdown", "bash", "sh", "bash", "zsh", "css", "html", "python" }
			-- 		if vim.tbl_contains(lspWithOutFolding, ft) then
			-- 			return { "treesitter", "indent" }
			-- 		end
			-- 		return { "lsp", "indent" }
			-- 	end,
			-- 	-- open opening the buffer, close these fold kinds
			-- 	-- use `:UfoInspect` to get available fold kinds from the LSP
			-- 	close_fold_kinds = { "imports" },
			-- 	open_fold_hl_timeout = 500,
			-- 	-- fold_virt_text_handler = foldTextFormatter,
			-- },
		},

		-- {
		--   "kevinhwang91/nvim-ufo",
		--   dependencies = { "kevinhwang91/promise-async" },
		--   event = events.BufReadPost,
		--   oonfig = function()
		--     -- vim.o.foldcolumn = "1" -- '0' is not bad
		--     -- vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
		--     -- vim.o.foldlevelstart = 99
		--     -- vim.o.foldenable = true
		--     --
		--     -- -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
		--     -- vim.keymap.set("n", "zR", require("ufo").openAllFolds)
		--     -- vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
		--     --
		--     -- -- require("ufo").setup()
		--     require("plugins.nvim-ufo")
		--   end,
		-- },
	}
end

local function lsp()
	return {
		{
			"williamboman/mason.nvim",
			cmd = { "Mason" },
			opts = {
				ensure_installed = {
					"eslint_d",
					"stylua",
					"gofumpt",
					"goimports_reviser",
					"golines",
					"tree-sitter-cli",
					"shellcheck",
					"shfmt",
					"delve",

					-- formatters

					--lsp
					"bash-language-server",
					"lua-language-server",
					"typescript-language-server",
					"tailwindcss-language-server",
					"gopls",
					"pyright",
					"terraform-ls",
				},
			},
			config = function()
				require("mason").setup()
			end,
			dependencies = {
				{
					"WhoIsSethDaniel/mason-tool-installer.nvim",
					config = function()
						require("plugins.mason-tool-installer")
					end,
				},
			},
		},
		{
			"neovim/nvim-lspconfig",
			event = events.BufReadPost,
			config = function()
				require("plugins.lspconfig")
			end,
			-- commit = "67f151e84daddc86cc65f5d935e592f76b9f4496",
			dependencies = {
				{ "folke/neodev.nvim", ft = "lua" },
				"williamboman/mason-lspconfig.nvim",
				"b0o/schemastore.nvim",
			},
		},
		{
			"hinell/lsp-timeout.nvim",
			dependencies = { "neovim/nvim-lspconfig" },
		},

		{
			"creativenull/efmls-configs-nvim",
			event = events.BufRead,
			after = "nvim-lspconfig",
			version = "v0.2.x", -- tag is optional
			dependencies = { "neovim/nvim-lspconfig" },
		},

		{
			"olexsmir/gopher.nvim",
			ft = "go",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-treesitter/nvim-treesitter",
			},
			config = function()
				require("gopher").setup()
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

local function completions()
	return {
		{
			"hrsh7th/nvim-cmp",
			version = false,
			event = events.InsertEnter,
			dependencies = {
				{ "hrsh7th/cmp-nvim-lsp" },
				{ "lukas-reineke/cmp-rg" },
				{ "hrsh7th/cmp-cmdline" },
				{ "saadparwaiz1/cmp_luasnip" },
				{
					"L3MON4D3/LuaSnip",
					config = function()
						require("plugins.luasnip")
						require("keymaps-for-plugins").luasnip_keymaps()
					end,
				},
				{ "onsails/lspkind.nvim" },
			},
			config = function()
				require("plugins.nvim-cmp")
			end,
		},

		{
			"zbirenbaum/copilot.lua",
			event = events.BufReadPost,
			config = function()
				require("keymaps-for-plugins").copilot_mappings()
				vim.defer_fn(function()
					require("copilot").setup({
						panel = { enabled = false },
						filetypes = {
							["*"] = true,
						},
						suggestion = {
							enabled = true,
							auto_trigger = true,
							keymap = nil,
						},
					})
				end, 100)
			end,
		},

		-- {
		-- 	"ms-jpq/coq_nvim",
		-- 	lazy = false,
		-- 	branch = "coq",
		-- 	dependencies = {
		-- 		{ "ms-jpq/coq.artifacts", branch = "artifacts" },
		-- 		{ "ms-jpq/coq.thirdparty", branch = "3p" },
		-- 	},
		-- 	config = function()
		-- 		require("plugins.coq")
		-- 	end,
		-- },
	}
end

local function search_and_replace()
	return {
		{
			"windwp/nvim-spectre",
			cmd = {
				"Spectre",
			},
			config = true,
		},
		{
			"mg979/vim-visual-multi",
			keys = { "<C-n>" },
		},
	}
end

local function dap()
	return {
		{
			"mfussenegger/nvim-dap",
			-- event = events.BufReadPost,
			-- event = events.VeryLazy,
			cmd = { "DapContinue" },
			config = function()
				require("plugins.dap")
			end,
			dependencies = {
				"rcarriga/nvim-dap-ui",
				-- "theHamsta/nvim-dap-virtual-text",
				-- { "jbyuki/one-small-step-for-vimkind", module = "osv" },
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
			-- event = events.VeryLazy,
			keys = { "st" },
			version = "*",
			config = function()
				require("plugins.toggleterm")
				require("keymaps-for-plugins").toggleterm_keymaps()
			end,
		},
		{
			"samjwill/nvim-unception",
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
				-- Optional settings go here!
				-- e.g.) vim.g.unception_open_buffer_in_new_tab = true
			end,
		},
	}
end

local function status_and_tab_bars()
	return {
		{
			"nanozuki/tabby.nvim",
			event = events.UIEnter,
			config = function()
				require("plugins.tabby")
			end,
		},
	}
end

local function ui()
	return {
		{
			"luukvbaal/stabilize.nvim",
			event = events.VeryLazy,
			config = function()
				-- require("stabilize").setup()
			end,
		},
		{
			"stevearc/dressing.nvim",
			event = events.VeryLazy,
			opts = {},
		},
		{
			"echasnovski/mini.nvim",
			event = events.UIEnter,
			branch = "stable",
			config = function()
				require("plugins.mini")
			end,
		},

		{
			"nvchad/nvim-colorizer.lua",
			ft = { "javascriptreact", "css", "html", "javascript", "typescript", "typescriptreact", "svelte", "vue" },
			event = events.BufReadPost,
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
					},
				})
			end,
		},

		{
			"nyngwang/NeoZoom.lua",
			cmd = {
				"NeoZoomToggle",
			},
			config = function()
				require("neo-zoom").setup({})
				require("keymaps-for-plugins").neozoom_mappings()
			end,
		},

		{ "ellisonleao/glow.nvim", ft = "markdown", config = true, cmd = "Glow" },
		{
			"toppair/peek.nvim",
			ft = "markdown",
			build = "deno task --quiet build:fast",
			config = function()
				require("plugins.peek-nvim")
			end,
		},

		{
			"AckslD/messages.nvim",
			cmd = {
				"Messages",
			},
			config = function()
				require("messages").setup()
				_G.Msg = function(...)
					require("messages.api").capture_thing(...)
				end
			end,
		},

		{
			"folke/noice.nvim",
			event = events.VeryLazy,
			dependencies = {
				"MunifTanjim/nui.nvim",
			},
			config = function()
				require("plugins.noice")
			end,
		},
	}
end

local function http_clients()
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
						return string.format("%s/%s", vim.env.PWD, ".tools/gqlenv.yml")
					end,
				})
			end,
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
		{
			"NeogitOrg/neogit",
			lazy = true,
			dependencies = {
				"nvim-lua/plenary.nvim", -- required
				"nvim-telescope/telescope.nvim", -- optional
				"sindrets/diffview.nvim", -- optional
				-- "ibhagwan/fzf-lua",          -- optional
			},
			cmd = {
				"Neogit",
			},
			config = true,
		},
	}
end

local function lua_rocks()
	return {
		{
			"theHamsta/nvim_rocks",
			event = events.VeryLazy,
			build = "pipx install hererocks && hererocks . -j2.1.0-beta3 -r3.0.0 && cp nvim_rocks.lua lua",
			config = function()
				-- require("plugins.nvim_rocks").list_installed()
				vim.schedule(function()
					print("syncing luarocks")
					require("plugins.nvim_rocks").install("base64")
				end)
				-- os.execute("luarocks install base64")
				-- ---- Add here the packages you want to make sure that they are installed
				-- local nvim_rocks = require("nvim_rocks")
				-- nvim_rocks.ensure_installed("base64")
			end,
		},
	}
end

local plugins = {}

vim.list_extend(plugins, colorschemes())
vim.list_extend(plugins, fuzzy_finders())
vim.list_extend(plugins, file_managers())
vim.list_extend(plugins, navigation())
vim.list_extend(plugins, session_managers())
vim.list_extend(plugins, syntax())
vim.list_extend(plugins, lsp())
vim.list_extend(plugins, completions())
vim.list_extend(plugins, search_and_replace())
vim.list_extend(plugins, dap())
vim.list_extend(plugins, terminals())
vim.list_extend(plugins, status_and_tab_bars())
vim.list_extend(plugins, ui())
vim.list_extend(plugins, http_clients())
vim.list_extend(plugins, git_clients())
vim.list_extend(plugins, lua_rocks())

require("lazy").setup(plugins)
