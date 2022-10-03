local cmp = require("cmp")

local icons = {
	Text = "📝",
	Method = "  ",
	Field = " λ ",
	Function = " ⨍ ",
	Constructor = "   ",
	Variable = "[]",
	Class = "  ",
	Interface = "ﰮ ",
	Module = "  ",
	Property = " 襁 ",
	Unit = "   ",
	Value = "  ",
	Enum = " 練",
	Keyword = "  ",
	Snippet = "  ",
	Color = "  ",
	File = "  ",
	Folder = "  ",
	EnumMember = "  ",
	Constant = "∁",
	Struct = "▓",
	Event = "",
	Operator = " ",
	TypeParameter = "  ",
}

cmp.setup({
	snippet = {
		expand = function(args)
			require("snippy").expand_snippet(args.body)
		end
	},
	window = {},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),

	sources = cmp.config.sources({
		{ name = "nvim_lsp_signature_help" },
		{ name = "nvim_lsp", max_item_count = 15, group_index = 1 },
		-- { name = "ultisnips" },
		-- { name = "copilot", group_index = 2 },
		{ name = "treesitter", group_index = 2 },
		{ name = "path", max_item_count = 10, group_index = 2 },
		{ name = "tmux", max_item_count = 10, group_index = 5 },
	}, {
		{ name = "buffer", max_item_count = 5, group_index = 5 },
	}),

	formatting = {
		format = function(entry, vim_item)
			vim_item.kind = string.format("%s (%s)", icons[vim_item.kind], vim_item.kind)
			vim_item.menu = ""
			return vim_item
		end,
	},
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		-- { name = "buffer" },
		{ name = "cmdline" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

-- Setup lspconfig.
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
require("lspconfig")["gopls"].setup({
	capabilities = capabilities,
})
