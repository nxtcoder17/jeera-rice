local actions = require("fzf-lua.actions")

vim.cmd([[
  hi! link FzfFg @operator
  hi! link FzfBg Normal
  hi! link FzfHl @variable
  hi! link FzfFgPlus Normal
  hi! link FzfBgPlus CursorLine
  hi! link FzfHlPlus Statement
  hi! link FzfInfo PreProc
  hi! link FzfPrompt Conditional
  hi! link FzfPointer Exception
  hi! link FzfMarker Keyword
  hi! link FzfSpinner Label
  hi! link FzfHeader Comment
  hi! link FzfGutter Normal
]])

local fzf = require("fzf-lua")
fzf.setup({
	"telescope",
	fzf_opts = {
		["--layout"] = "reverse",
		["--pointer"] = "👉",
		["--tiebreak"] = "index",
	},
	file_icon_padding = " ",
	global_resume = true,
	global_resume_query = true,
	global_resume_prompt = "resume: ",

	fzf_colors = {
		["fg"] = { "fg", "FzfFg" },
		["bg"] = { "bg", "FzfBg" },
		["hl"] = { "fg", "FzfHl" },
		["fg+"] = { "fg", "FzfFgPlus" },
		["bg+"] = { "bg", "FzfBgPlus" },
		["hl+"] = { "fg", "FzfHlPlus" },
		["info"] = { "fg", "FzfInfo" },
		["prompt"] = { "fg", "FzfPrompt" },
		["pointer"] = { "fg", "FzfPointer" },
		["marker"] = { "fg", "FzfMarker" },
		["spinner"] = { "fg", "FzfSpinner" },
		["header"] = { "fg", "FzfHeader" },
		["gutter"] = { "bg", "FzfGutter" },
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

vim.api.nvim_create_user_command("ReloadFzfLua", function()
	R("plugins.fzf-lua")
end, { nargs = 0 })
