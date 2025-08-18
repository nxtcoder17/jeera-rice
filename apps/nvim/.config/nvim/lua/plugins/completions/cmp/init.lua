local luasnip = Require("luasnip")

-- local log = Require("plenary.log").new({ plugin = "cmp", level = "debug" })

local cmp = Require("cmp")

-- Debounce timer
local timer = vim.uv.new_timer()

vim.api.nvim_create_autocmd({ "TextChangedI", "TextChangedP" }, {
	pattern = "*",
	callback = function()
		timer:stop()
		timer:start(
			400,
			0,
			vim.schedule_wrap(function()
				cmp.complete()
			end)
		)
	end,
})

-- Stop timer if you leave insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		timer:stop()
	end,
})

cmp.register_source("go:imports", Require("plugins.completions.cmp.sources.go-imports"))
-- cmp.register_source("nvim-hl-groups", Require("plugins.cmp-sources.nvim-hl-groups"))

-- vim.api.nvim_create_autocmd({ "TextChangedI", "TextChangedP" }, {
-- 	callback = function()
-- 		local line = vim.api.nvim_get_current_line()
-- 		local cursor = vim.api.nvim_win_get_cursor(0)[2]
--
-- 		local prefix = line:sub(1, col)
--
-- 		if #prefix:match("%w*$") >= 3 then
-- 			cmp.complete()
-- 		end
-- 	end,
-- 	pattern = "*",
-- })

cmp.setup({
	completion = {
		autocomplete = false,
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},

	preselect = cmp.PreselectMode.None,

	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
		-- completion = cmp.config.window.bordered({
		-- 	-- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
		-- 	-- border = "rounded",
		-- 	-- col_offset = -3,
		-- 	-- side_padding = 0,
		-- }),
		-- documentation = cmp.config.window.bordered({
		-- 	-- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
		-- 	-- border = "rounded",
		-- 	-- col_offset = -3,
		-- 	-- side_padding = 0,
		-- }),
	},

	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<C-n>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
				return
			end
			fallback()
		end),
		["<C-p>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
				return
			end
			fallback()
		end),
		["<Tab>"] = cmp.mapping(function(fallback)
			if luasnip.expand() then
				luasnip.expand()
				return
			end

			if luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
				return
			end

			-- if cmp.visible() then
			-- 	cmp.select_next_item()
			-- 	return
			-- end

			fallback()
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
				return
			end

			-- if cmp.visible then
			-- 	cmp.select_prev_item()
			-- end

			fallback()
		end, { "i", "s" }),
	}),

	sources = cmp.config.sources({
		{ name = "nvim_lsp", priority = 100 },
		{ name = "luasnip", options = { show_autosnippets = true }, priority = 100 },
		{ name = "nvim_lsp_signature_help", priority = 100 },

		{ name = "lazydev", priority = 80 },
		{ name = "nvim_lua", priority = 80 },

		{ name = "go:imports", priority = 60, keyword_length = 2 },
	}),
})
