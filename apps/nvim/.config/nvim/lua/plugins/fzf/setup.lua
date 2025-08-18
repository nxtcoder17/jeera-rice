local actions = Require("fzf-lua.actions")

local fzf = Require("fzf-lua")
fzf.setup({
	"telescope",
	fzf_opts = {
		["--layout"] = "reverse",
		["--pointer"] = "👉",
		["--tiebreak"] = "index",
	},
	hls = {
		border = "FloatBorder",
		preview_border = "FloatBorder",
	},
	file_icon_padding = " ",
	global_resume = true,
	global_resume_query = true,
	global_resume_prompt = "resume: ",
	multiprocess = false,

	oldfiles = {
		include_current_session = true,
	},

	previewers = {
		builtin = {
			syntax_limit_b = 1024 * 100, -- 100KB
		},
	},

	winopts = {
		preview = {
			horizontal = "right:40%",
		},
		height = 0.3, -- window height
		width = 1, -- window width
		row = 1, -- window row position (0=top, 1=bottom)
		col = 0.50, -- window col position (0=left, 1=right)
		border = {
			"╭",
			"─",
			"╮",
			"│",
			"╯",
			"─",
			"╰",
			"│",
		},
	},

	files = {
		-- cmd = { "rg", "--files" },
		prompt = "Files ❯ ",
		cwd_prompt = false,
		fzf_opts = {
			["--no-separator"] = "",
			["--no-scrollbar"] = "",
		},
		-- git_icons = false,
		-- file_icons = false,
	},

	keymaps = {
		prompt = "Keymaps ❯ ",
		winopts = {
			preview = {
				vertical = "right:20%",
			},
		},
	},

	lsp_definitions = {
		jump_to_single_result = true,
		jump_to_single_result_action = require("fzf-lua.actions").file_vsplit,
	},
	lsp_implementations = {
		jump_to_single_result = true,
	},
	lsp_references = {
		ignore_current_line = true,
	},

	grep = {
		formatter = "path.filename_first",
	},

	live_grep = {
		multiprocess = false,
	},

	actions = {
		buffers = {
			-- providers that inherit these actions:
			--   buffers, tabs, lines, blines
			["default"] = actions.buf_edit,
			["ctrl-s"] = actions.buf_split,
			["ctrl-v"] = actions.buf_vsplit,
			["ctrl-t"] = actions.buf_tabedit,
			["ctrl-d"] = { actions.buf_del, actions.resume },
		},
	},
})

vim.cmd("FzfLua register_ui_select")
