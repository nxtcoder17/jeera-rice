Require("diffview").setup({
	enhanced_diff_hl = true,
	hooks = {
		-- read [source](https://github.com/kevinhwang91/nvim-ufo/issues/57#issuecomment-1520854713)
		diff_buf_read = function(bufnr)
			vim.opt_local.foldlevel = 99
			vim.opt_local.foldenable = false
		end,
		diff_buf_win_enter = function(bufnr)
			vim.opt_local.foldlevel = 99
			vim.opt_local.foldenable = false
		end,
	},
	default_args = {
		DiffViewOpen = { "--imply-local" },
	},
	keymaps = {
		view = {
			{ "n", "sn", "]c", { noremap = true, silent = true } },
			{ "n", "sp", "[c", { noremap = true, silent = true } },
		},
		file_panel = {
			-- disabling the defaults
			{
				"n",
				"s",
				"<Nop>",
				desc = "it defaults to stage current entry, but s is my go-to key, which is used almost everywhere else, so will map it to a different thing",
			},
			{
				"n",
				"S",
				"<Nop>",
				desc = "it defaults to staging every entries. it is dangerous, so disabling it",
			},
			{ "n", "U", "<Nop>", desc = "it defaults to unstaging everything, it is dangerous, so disabling it" },

			-- enabling my keymaps
			{ "n", "sl", "<cmd>wincmd l<CR>" },
			-- { "n", "sl",  function() end},
			{
				"n",
				"s+",
				function()
					require("diffview").emit("toggle_stage_entry")
				end,
				desc = "staging a file",
			},
			-- { "n", "-", "<Nop>" },
			-- {
			-- 	"n",
			-- 	"sca",
			-- 	"<Cmd>Git commit --amend <bar> wincmd J<CR>",
			-- 	{ desc = "Commit staged changes, with --amend flag" },
			-- },
			-- {
			-- 	"n",
			-- 	"sc",
			-- 	"<Cmd>Git commit <bar> wincmd J<CR>",
			-- 	{ desc = "Commit staged changes" },
			-- },
		},
	},
})
