---@module 'blink.cmp'
---@type blink.cmp.Config

return {
	-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
	-- 'super-tab' for mappings similar to vscode (tab to accept)
	-- 'enter' for enter to accept
	-- 'none' for no mappings
	--
	-- All presets have the following mappings:
	-- C-space: Open menu or open docs if already open
	-- C-n/C-p or Up/Down: Select next/previous item
	-- C-e: Hide menu
	-- C-k: Toggle signature help (if signature.enabled = true)
	--
	-- See :h blink-cmp-config-keymap for defining your own keymap
	keymap = {
		preset = "none",
		["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-e>"] = { "hide" },
		["<C-y>"] = { "select_and_accept" },
		["<CR>"] = { "select_and_accept", "fallback" },

		["<Up>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },
		["<C-p>"] = { "select_prev", "fallback_to_mappings" },
		["<C-n>"] = { "select_next", "fallback_to_mappings" },

		["<C-b>"] = { "scroll_documentation_up", "fallback" },
		["<C-f>"] = { "scroll_documentation_down", "fallback" },

		["<Tab>"] = { "snippet_forward", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },

		["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
	},

	enabled = function()
		return vim.bo.filetype ~= "DressingInput"
	end,

	completion = {
		menu = {
			auto_show = true,
			border = "rounded",
			scrollbar = false,
			columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name", gap = 1 } },

			draw = {
				padding = { 0, 1 }, -- padding only on right side
				components = {
					kind_icon = {
						text = function(ctx)
							return " " .. ctx.kind_icon .. ctx.icon_gap .. " "
						end,
					},
				},
			},

			-- draw = {
			-- 	padding = 1,
			-- 	gap = 2,
			-- 	components = {
			-- 		kind_icon = {
			-- 			text = function(ctx)
			-- 				local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
			-- 				return kind_icon
			-- 			end,
			-- 			-- (optional) use highlights from mini.icons
			-- 			highlight = function(ctx)
			-- 				local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
			-- 				return hl
			-- 			end,
			-- 		},
			-- 		kind = {
			-- 			-- (optional) use highlights from mini.icons
			-- 			highlight = function(ctx)
			-- 				local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
			-- 				return hl
			-- 			end,
			-- 		},
			-- 	},
			-- },
		},

		documentation = {
			auto_show = true,
			window = { border = "rounded" },
			auto_show_delay_ms = 50,
		},
	},

	signature = {
		enabled = true,
	},

	snippets = { preset = "luasnip" },

	appearance = {
		-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- Adjusts spacing to ensure icons are aligned
		nerd_font_variant = "mono",
	},

	-- Default list of enabled providers defined so that you can extend it
	-- elsewhere in your config, without redefining it, due to `opts_extend`
	sources = {
		default = { "lsp", "path", "snippets", "buffer", "go:imports" },
		providers = {
			["go:imports"] = {
				name = "go:imports",
				module = "plugins.completions.blink.sources.go-imports",
				-- opts = {
				-- 	item_kind = require("blink.cmp.types").CompletionItemKind.Variable,
				-- 	show_braces = false,
				-- 	show_documentation_window = true,
				-- },
			},
		},
	},

	-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
	-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
	-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
	--
	-- See the fuzzy documentation for more information
	-- fuzzy = { implementation = "prefer_rust_with_warning" },
	fuzzy = { implementation = "rust" },
}
