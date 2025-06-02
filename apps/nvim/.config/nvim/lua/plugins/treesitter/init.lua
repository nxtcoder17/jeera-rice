Require("nvim-treesitter.configs").setup({
	-- ensure_installed = "all",
	-- ignore_install = { "javascript", "typescript", "bash", "go", "lua", "yaml", "json" },
	ensure_installed = {
		"nix",
		"go",
		"gowork",
		"lua",
		"vim",
		"vimdoc",
		"json",
		"yaml",
		"c",
		"cpp",
		"css",
		"diff",
		"dockerfile",
		"editorconfig",
		"html",
		"javascript",
		"typescript",
		"tsx",
		"graphql",
		"bash",
		"terraform",
		"proto",
		"markdown",
		"markdown_inline",
	},
	query_linter = {
		enable = true,
		use_virtual_text = true,
		lint_events = { "BufWrite", "CursorHold" },
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
		disable = function(_, bufnr)
			return vim.api.nvim_buf_line_count(bufnr) > 1500
		end,
	},

	incremental_selection = {
		enable = true,
		keymaps = {
			-- IntelliJ like behaviour
			init_selection = "<C-w>",
			node_incremental = "<C-w>",
			-- scope_incremental = false,
			node_decremental = "<C-S-w>",
		},
	},
	indent = { enable = false },
	matchup = {
		enable = true,
		include_match_words = true,
	},
	autotag = {
		enable = true,
	},
	-- nvim autopairs
	autopairs = { enable = true },
	-- Rainbow Delimiters
	rainbow = {
		enable = true,
		extended_mode = true, -- Highlight also non-parentheses delimiters, like HTML, jsx elements
		max_file_lines = 1000,
		colors = {
			"#D3ECA7",
			"#a5a58d",
			"#4FD3C4",
			"#7C99AC",
		}, -- table of hex strings
	},

	-- refactor = {
	--   smart_rename = {
	--     enable = true,
	--     keymaps = { smart_rename = "grr" },
	--   },
	--   highlight_definitions = { enable = true },
	--   -- navigation = {
	--   --   enable = true,
	--   --   keymaps = {
	--   --     goto_definition_lsp_fallback = "gnd",
	--   --     -- list_definitions = "gnD",
	--   --     -- list_definitions_toc = "gO",
	--   --     -- @TODOUA: figure out if I need the 2 below
	--   --     goto_next_usage = "<a-*>", -- is this redundant?
	--   --     goto_previous_usage = "<a-#>", -- also this one?
	--   --   },
	--   -- },
	--   -- highlight_current_scope = {enable = true}
	-- },

	textobjects = {
		lsp_interop = {
			enable = true,
			-- border = "none",
			border = "single",
			peek_definition_code = {
				["<leader>df"] = "@function.outer",
				["sK"] = "@function.outer",
				["<leader>dF"] = "@class.outer",
			},
		},

		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ab"] = "@block.outer",
				["ib"] = "@block.inner",
				["ac"] = "@call.outer",
				["ic"] = "@call.inner",
			},
		},

		playground = {},
	},
})

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.gotmpl = {
	install_info = {
		url = "https://github.com/qvalentin/tree-sitter-go-template",
		branch = "helm-ls",
		files = { "src/parser.c" },
	},
	filetype = { "gotmpl", "gotexttmpl", "gohtmltmpl" },
	used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl", "yaml" },
}

Require("plugins.treesitter.buf-highlight-lag-fix")
