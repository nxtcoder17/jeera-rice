local cmp = require("cmp")

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")

cmp.setup({
	preselect = cmp.PreselectMode.None,
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	window = {
		completion = {
			winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
			col_offset = -3,
			side_padding = 0,
		},
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete({}),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

		["<Tab>"] = cmp.mapping(function(fallback)
			if luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
				return
			end

			if cmp.visible() then
				return
			end

			if has_words_before() then
				cmp.complete()
				return
			end

			fallback()
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
				return
			end

			if cmp.visible then
				cmp.select_prev_item()
			end

			fallback()
		end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp", label = "[lsp]", max_item_count = 10, group_index = 1, priority = 1 },
		{ name = "luasnip", label = "[luasnip]", max_item_count = 3, group_index = 2, priority = 2 },
		{ name = "codeium", group_index = 3, priority = 3 },
		-- { name = "buffer", option = {
		-- 	keyword_pattern = [[\w+]],
		-- } },

		{
			name = "fuzzy_buffer",
			max_item_count = 7,
			label = "[buffer]",
			group_index = 4,
			priority = 4,
			option = {
				get_bufnrs = function()
					local bufs = {}
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
						if buftype ~= "nofile" and buftype ~= "prompt" then
							bufs[#bufs + 1] = buf
						end
					end
					return bufs
				end,
			},
		},
		{ name = "nvim_lsp_signature_help", label = "[lsp signature]", group_index = 5 },
		{ name = "cmp_tabnine", group_index = 6 },
		-- { name = "copilot", group_index = 2 },
		{ name = "treesitter", group_index = 7, label = "[treesitter]" },
		{ name = "path", max_item_count = 10, group_index = 8, label = "[path]" },
		-- {
		-- 	name = "tmux",
		-- 	option = {
		-- 		all_panes = true,
		-- 		max_item_count = 10,
		-- 		group_index = 4,
		-- 		label = "[tmux]",
		-- 	},
		-- },
	}),
	sorting = {
		priority_weight = 2,
		comparators = {
			cmp.config.compare.order,
		},
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			local menu = ({
				buffer = "buffer",
				nvim_lsp = "lsp",
				luasnip = "luaSnip",
				nvim_lua = "lua",
				latex_symbols = "laTeX",

				codeium = "⚡",

				fuzzy_buffer = "fzf",
				cmp_tabnine = "⚡",
				treesitter = "treesitter",
				nvim_lsp_signature_help = "lsp signature",
				path = "path",
				tmux = "tmux",
			})[entry.source.name]

			local kind = require("lspkind").cmp_format({ mode = "symbol", maxwidth = 50 })(entry, vim_item)
			local strings = vim.split(kind.kind, "%s", { trimempty = true })
			kind.kind = " " .. (strings[1] or "") .. " "
			-- kind.menu = "    (" .. (strings[2] or "") .. ")"
			kind.menu = "    (" .. (menu or "") .. ")"

			return kind
		end,
	},
	-- experimental = {
	--   ghost_text = true,
	-- },
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = "buffer" },
	}),
})

cmp.setup.cmdline({ "/" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "buffer" },
		{ name = "path" },
	}),
})
cmp.setup.cmdline({ ":" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "cmdline" },
	}),
})
