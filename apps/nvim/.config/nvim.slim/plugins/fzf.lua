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
		-- fzf = {
		--   ["ctrl-g"] = "select-all+accept",
		-- },
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
		no_esc = true,
		formatter = "path.filename_first",
	},

	live_grep = {
		multiline = true
		-- multiprocess = false,
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
		["alt-f"] =  function(selected)
			vim.print(vim.inspect(selected))
		end,
	},
})

---@param dir? string
---@param query? string
local funciton find_files(dir, query)
	dir = dir or vim.loop.cwd()
	query = query or ""

	-- fzf_lua.setup({ files = { cmd = "rg --files" } })
	fzf.files({
		-- cmd = "fd --type file --follow --hidden --exclude .git",
		-- cmd = "rg --files",
		ignore_current_file = true,
		cwd = dir,
		query = query,
		cwd_prompt = dir ~= vim.g.project_root_dir,
		multiprocess = false,
		actions = {
			["ctrl-f"] = function(_, opts)
				local q = fzf.get_last_query()
				print("last query", q)
				if dir ~= vim.g.project_root_dir then
					return find_files(vim.g.project_root_dir, q)
				end
				return find_files(nil, q)
			end,
		},
	})
end

vim.keymap.set("n", "sf", find_files)

---@param dir string
---@param query string
local function grep_with_fzf(dir, query)
	dir = dir or vim.fn.getcwd()
	query = query or ""

	if vim.fn.mode() == "n" or vim.fn.mode() == "t" then
		fzf.live_grep_native({
			cwd = dir,
			query = query,
			multiprocess = false,
			actions = {
				["ctrl-f"] = function(_, opts)
					local q = fzf.get_last_query()
					if dir ~= vim.g.project_root_dir then
						return grep_with_fzf(vim.g.project_root_dir, q)
					end
					return grep_with_fzf(dir, q)
				end,
			},
		})
	elseif vim.fn.mode() == "v" then
		fzf.grep_visual({
			cwd = dir,
			query = query,
			multiprocess = false,
			-- rg_opts = rg_opts,
		})
	end
end

vim.cmd([[ cnoreabbrev cd lua require('plugins.fzf.my-actions.choose-tab-dir')()<CR>]])

local function find_tabs()
	local tab_names = {}
	local tab_name_to_win_id = {}
	local tabbar = require("plugins.ui.tabbar")

	for tabidx, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
		local win_id = vim.api.nvim_tabpage_get_win(tabnr)
		local tab_name = tabidx .. " " .. tabbar.get_tab_name(tabnr)
		table.insert(tab_names, tab_name)

		tab_name_to_win_id[tab_name] = { win_id = win_id, tabnr = tabnr }
	end

	require("fzf-lua").fzf_exec(tab_names, {
		prompt = "Tabs ❯ ",
		actions = {
			["default"] = function(selected, opts)
				local info = tab_name_to_win_id[selected[1]]
				vim.api.nvim_set_current_win(info.win_id)
			end,
			["ctrl-d"] = function(selected, opts)
				vim.cmd("tabclose " .. selected[1])
			end,
			["ctrl-r"] = function(selected, opts)
				local info = tab_name_to_win_id[selected[1]]
				tabbar.rename_tab(info.tabnr)
			end,
		},
	})
end

vim.keymap.set("n", "tl", find_tabs)
vim.keymap.set({ "n", "v" }, "ff", Require("plugins.fzf.my-actions.grep"))
vim.keymap.set({ "n" }, "FF", function()
	Require("plugins.fzf.my-actions.grep")(vim.fn.getcwd(), vim.fn.expand("<cword>"))
end)
vim.keymap.set({ "n", "v", "x" }, "f;", Require("plugins.fzf.my-actions.quicklist"))
vim.keymap.set("n", "s/", "<cmd>FzfLua grep_curbuf multiprocess=false<CR>")
vim.keymap.set("n", "sb", "<Cmd>FzfLua buffers<CR>")
