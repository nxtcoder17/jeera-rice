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
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

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
		{ name = "codeium" },
		{ name = "luasnip", label = "[luasnip]", max_item_count = 3 },
		-- { name = "buffer", option = {
		-- 	keyword_pattern = [[\w+]],
		-- } },

		{ name = "nvim_lsp", label = "[lsp]", max_item_count = 5 },
		-- {
		-- 	name = "fuzzy_buffer",
		-- 	max_item_count = 10,
		-- 	label = "[buffer]",
		-- 	group_index = 3,
		-- 	option = {
		-- 		get_bufnrs = function()
		-- 			local bufs = {}
		-- 			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		-- 				local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
		-- 				if buftype ~= "nofile" and buftype ~= "prompt" then
		-- 					bufs[#bufs + 1] = buf
		-- 				end
		-- 			end
		-- 			return bufs
		-- 		end,
		-- 	},
		-- },
		{ name = "nvim_lsp_signature_help", label = "[lsp signature]" },
		{ name = "cmp_tabnine" },
		-- { name = "copilot", group_index = 2 },
		{ name = "treesitter", group_index = 2, label = "[treesitter]" },
		{ name = "path", max_item_count = 10, group_index = 2, label = "[path]" },
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

local hlGroups = {
	PmenuSel = { bg = "#282C34", fg = "NONE" },
	-- PmenuSel = { bg = "#87ab9e", fg = "NONE" },
	-- Pmenu = { fg = "#C5CDD9", bg = "#22252A" },
	Pmenu = { fg = "#C5CDD9", bg = "#0c1129" },
	CmpItemAbbrDeprecated = { fg = "#7E8294", bg = "NONE", strikethrough = true },
	CmpItemAbbrMatch = { fg = "#82AAFF", bg = "NONE", bold = true },
	CmpItemAbbrMatchFuzzy = { fg = "#82AAFF", bg = "NONE", bold = true },
	CmpItemMenu = { fg = "#C792EA", bg = "NONE", italic = true },
	CmpItemKindField = { fg = "#EED8DA", bg = "#B5585F" },
	CmpItemKindProperty = { fg = "#EED8DA", bg = "#B5585F" },
	CmpItemKindEvent = { fg = "#EED8DA", bg = "#B5585F" },
	CmpItemKindText = { fg = "#C3E88D", bg = "#9FBD73" },
	CmpItemKindEnum = { fg = "#C3E88D", bg = "#9FBD73" },
	CmpItemKindKeyword = { fg = "#C3E88D", bg = "#9FBD73" },
	CmpItemKindConstant = { fg = "#FFE082", bg = "#D4BB6C" },
	CmpItemKindConstructor = { fg = "#FFE082", bg = "#D4BB6C" },
	CmpItemKindReference = { fg = "#FFE082", bg = "#D4BB6C" },
	CmpItemKindFunction = { fg = "#EADFF0", bg = "#A377BF" },
	CmpItemKindStruct = { fg = "#EADFF0", bg = "#A377BF" },
	CmpItemKindClass = { fg = "#EADFF0", bg = "#A377BF" },
	CmpItemKindModule = { fg = "#EADFF0", bg = "#A377BF" },
	CmpItemKindOperator = { fg = "#EADFF0", bg = "#A377BF" },
	CmpItemKindVariable = { fg = "#C5CDD9", bg = "#7E8294" },
	CmpItemKindFile = { fg = "#C5CDD9", bg = "#7E8294" },
	CmpItemKindUnit = { fg = "#F5EBD9", bg = "#D4A959" },
	CmpItemKindSnippet = { fg = "#F5EBD9", bg = "#D4A959" },
	CmpItemKindFolder = { fg = "#F5EBD9", bg = "#D4A959" },
	CmpItemKindMethod = { fg = "#DDE5F5", bg = "#6C8ED4" },
	CmpItemKindValue = { fg = "#DDE5F5", bg = "#6C8ED4" },
	CmpItemKindEnumMember = { fg = "#DDE5F5", bg = "#6C8ED4" },
	CmpItemKindInterface = { fg = "#D8EEEB", bg = "#58B5A8" },
	CmpItemKindColor = { fg = "#D8EEEB", bg = "#58B5A8" },
	CmpItemKindTypeParameter = { fg = "#D8EEEB", bg = "#58B5A8" },
}

function _G.ResetCmpHl()
	for key, value in pairs(hlGroups) do
		vim.api.nvim_set_hl(0, key, value)
	end
end

ResetCmpHl()
