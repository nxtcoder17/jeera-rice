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
		--   config = function()
		--     -- vim.o.background = "dark"
		--     -- vim.o.background = "light"
		--     -- require("plugins.tokyonight")
		--   end,
		-- },
		{
			"nvim-colortils/colortils.nvim",
			cmd = { "Colortils" },
			lazy = true,
			config = function()
				require("colortils").setup()
			end,
		},
		{
			"catppuccin/nvim",
			config = function()
				require("plugins.colorschemes.catppuccin")
			end,
		},
		-- {
		--   "sainnhe/gruvbox-material",
		--   lazy = false,
		--   -- config = function()
		--   -- 	require("plugins.gruvbox-material")
		--   -- end,
		-- },
		-- {
		--   "rebelot/kanagawa.nvim",
		--   lazy = false,
		--   event = events.VeryLazy,
		--   init = function()
		--   	require("plugins.kanagawa")
		--   	vim.o.background = "light"
		--   	vim.cmd("colorscheme kanagawa-lotus")
		--   end,
		-- },
		--   {
		--     "towolf/vim-helm",
		--     ft = { "gotmpl", "gotexttmpl", "yaml" },
		--   },
		-- {
		--   "mcchrish/zenbones.nvim",
		--   dependencies = {
		--     "rktjmp/lush.nvim",
		--   },
		--   config = function()
		--     require("plugins.colorschemes.zenbones")
		--   end,
		-- },
		-- {
		--   "RRethy/nvim-base16",
		--   config = function()
		--     -- require("plugins.colorschemes.base16")
		--   end,
		-- },
		-- {
		--   "neanias/everforest-nvim",
		--   version = false,
		--   lazy = false,
		--   priority = 1000, -- make sure to load this before all the other start plugins
		--   -- Optional; default configuration will be used if setup isn't called.
		--   config = function()
		--     -- vim.opt.background = "light"
		--     -- require("plugins.tokyonight")
		--     -- require("plugins.colorschemes.everforest")
		--     -- vim.cmd([[colorscheme everforest]])
		--   end,
		-- },
		-- {
		--   "EdenEast/nightfox.nvim",
		--   config = function()
		--     require("plugins.colorschemes.nightfox")
		--   end,
		-- },
	}
end

local function fuzzy_finders()
	return {
		{
			"nvim-telescope/telescope.nvim",
			-- event = events.UIEnter,
			-- event = events.BufWinEnter,
			lazy = true,
			dependencies = {
				"nvim-lua/plenary.nvim",
				{ "nvim-tree/nvim-web-devicons" },
				{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
				{ "gbrlsnchs/telescope-lsp-handlers.nvim", after = "nvim-lspconfig" },
				{ "nvim-telescope/telescope-ui-select.nvim" },
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
			end,
			cmd = {
				"Telescope",
			},
		},
		{
			"ibhagwan/fzf-lua",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			init = function()
				vim.cmd([[ cnoreabbrev cd lua require('fuzzy-actions.choose-tab-dir')()<CR>]])
			end,
			config = function()
				require("plugins.fzf-lua")
			end,
			keys = {
				{ "sf", require("fuzzy-actions.find-files") },
				{ "tl", require("fuzzy-actions.find-tabs"), mode = "n", desc = "Find Tabs" },
				{ "ff", require("fuzzy-actions.grep"), mode = "n", desc = "Grep" },
				{ "s/", "<Cmd>FzfLua grep_curbuf<CR>", mode = "n", desc = "Grep Current Buffer" },
				{ "sb", "<Cmd>FzfLua buffers<CR>", mode = "n", desc = "Pick Buffer" },
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
			event = events.BufRead,
			keys = {
				{ "cw", "ce", mode = "n" },
				{ "cW", "cE", mode = "n" },
			},
			-- config = function()
			--   require("keymaps-for-plugins").vim_wordmotion_mappings()
			-- end,
		},

		{ "kevinhwang91/nvim-bqf", ft = "qf" },
		-- {
		-- 	"ludovicchabant/vim-gutentags",
		-- 	config = function()
		-- 		vim.g.gutentags_ctags_exclude = {
		-- 		  "@.gitignore"
		-- 		}
		-- 	end,
		-- },
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
			lazy = true,
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
				-- {
				--   "yorickpeterse/nvim-tree-pairs",
				--   config = function()
				--     require("tree-pairs").setup()
				--   end,
				-- },
				{
					"JoosepAlviste/nvim-ts-context-commentstring",
					config = function()
						vim.g.skip_ts_context_commentstring_module = true
						require("ts_context_commentstring").setup({
							enable_autocmd = false,
							config = {
								gotmpl = "{{- /* %s */}}",
								terraform = "# %s",
								proto = "// %s",
								kdl = "// %s",
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
		},

		{
			"bagohart/minimal-narrow-region.nvim",
			event = "BufReadPost",
			config = function()
				vim.b.narrow_region_active = false

				vim.keymap.set("x", "s]", function()
					if vim.b.narrow_region_active then
						require("minimal-narrow-region").NarrowRegionClose()
						return
					end
					require("minimal-narrow-region").NarrowRegionOpen()
				end, { silent = true })
				-- vim.api.nvim_create_user_command("Region", function()
				--   if vim.b.narrow_region_active then
				--     require("minimal-narrow-region").NarrowRegionClose()
				--     return
				--   end
				--   require("minimal-narrow-region").NarrowRegionClose()
				-- end, {})
			end,
		},
	}
end

local function lsp()
	local neovim_native_lsp = {
		{
			"williamboman/mason.nvim",
			cmd = { "Mason" },
			opts = { max_concurrent_installers = 10 },
			build = function()
				local ensure_installed = {
					"tree-sitter-cli",

					-- lua
					"lua-language-server",
					"stylua",

					-- javascript
					"typescript-language-server",
					"tailwindcss-language-server",
					"eslint_d",
					"emmet-language-server",

					-- bash
					"bash-language-server",
					"shellcheck",
					"shfmt",

					-- golang
					"gopls",
					"gofumpt",
					"delve",
					"gotests",
					"gomodifytags",
					"impl",
					"iferr",
					"json-to-struct",

					-- graphql
					"graphql-language-service-cli",

					-- dockerfile
					"dockerfile-language-server",

					--python
					"pyright",

					-- terraform
					"terraform-ls",
					"tflint",

					-- linter
					"efm",
				}

				vim.cmd("MasonInstall " .. table.concat(ensure_installed, " "))
			end,
			config = function()
				require("mason").setup()
			end,
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

		-- {
		-- 	"hinell/lsp-timeout.nvim",
		-- 	dependencies = { "neovim/nvim-lspconfig" },
		-- },

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
		-- {
		--   "j-hui/fidget.nvim",
		--   event = events.BufReadPost,
		--   config = function()
		--     require("fidget").setup({})
		--   end,
		-- },
	}

	local coc_lsp = {
		{
			"neoclide/coc.nvim",
			branch = "release",
			event = events.VeryLazy,
			config = function()
				require("plugins.coc")
			end,
		},
	}

	return neovim_native_lsp
end

local function completions()
	local nvim_cmp = {
		{
			"hrsh7th/nvim-cmp",
			version = false,
			event = events.InsertEnter,
			dependencies = {
				{ "hrsh7th/cmp-nvim-lsp" },
				{ "lukas-reineke/cmp-rg" },
				{ "hrsh7th/cmp-cmdline" },
				{ "andersevenrud/cmp-tmux" },
				{ "saadparwaiz1/cmp_luasnip" },
				{ "FelipeLema/cmp-async-path" },
				{ "quangnguyen30192/cmp-nvim-tags" },
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
			"Exafunction/codeium.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"hrsh7th/nvim-cmp",
			},
			event = events.BufReadPost,
			config = function()
				require("codeium").setup({})
			end,
		},
		{
			-- it does not work with lazy loading
			"TabbyML/vim-tabby",
			-- event = events.InsertEnter,
			config = function()
				vim.g.tabby_keybinding_accept = "<M-l>"
			end,
		},

		-- {
		--   "zbirenbaum/copilot.lua",
		--   event = events.BufReadPost,
		--   config = function()
		--     require("keymaps-for-plugins").copilot_mappings()
		--     vim.defer_fn(function()
		--       require("copilot").setup({
		--         panel = { enabled = false },
		--         filetypes = {
		--           ["*"] = true,
		--         },
		--         suggestion = {
		--           enabled = true,
		--           auto_trigger = true,
		--           keymap = nil,
		--         },
		--       })
		--     end, 100)
		--   end,
		-- },
	}

	local coq_nvim = {
		{
			"ms-jpq/coq_nvim",
			lazy = false,
			branch = "coq",
			dependencies = {
				{ "ms-jpq/coq.artifacts", branch = "artifacts" },
				{ "ms-jpq/coq.thirdparty", branch = "3p" },
			},
			config = function()
				require("plugins.coq")
			end,
		},
	}

	local coc_nvim = {}
	return nvim_cmp
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
		{
			"mg979/vim-visual-multi",
			lazy = true,
			keys = { "<C-n>" },
		},
	}
end

local function dap()
	return {
		{
			"mfussenegger/nvim-dap",
			event = events.BufReadPost,
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
			event = events.BufReadPost,
			config = function()
				require("stabilize").setup()
			end,
		},
		{
			"stevearc/dressing.nvim",
			after = "BufReadPost",
			config = function()
				require("dressing").setup({
					insert_only = false,
					start_in_insert = false,
				})
			end,
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
			"toppair/peek.nvim",
			ft = "markdown",
			build = "deno task --quiet build:fast",
			config = function()
				require("plugins.peek-nvim")
			end,
		},

		{
			"folke/twilight.nvim",
			event = "BufReadPost",
		},

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
			keys = {},
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
				"ibhagwan/fzf-lua", -- optional
			},
			cmd = {
				"Neogit",
			},
			config = true,
		},
		-- {
		--   "tpope/vim-fugitive",
		-- },
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
					require("plugins.nvim_rocks").install("lpeg")
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

require("lazy").setup(plugins, {
	ui = {
		border = "rounded",
	},
	change_detection = {
		enabled = true,
		notify = false,
	},
})
