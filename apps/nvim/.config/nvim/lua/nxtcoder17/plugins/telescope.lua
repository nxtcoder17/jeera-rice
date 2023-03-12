local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local themes = require("telescope.themes")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local utils = require("telescope.utils")

local function findCmd()
	if vim.fn.executable("fd") then
		return { "fd", "-t", "f", "-H", "-E", ".git", "--strip-cwd-prefix" }
	end
	if vim.fn.executable("rg") then
		return { "rg", "--files", "--iglob", "!.git", "--hidden" }
	end
end

local ivyCustomLayoutConfig = {
	bottom_pane = {
		height = 17,
	},
}

telescope.setup({
	defaults = {
		-- copied from nvchad/nvim
		vimgrep_arguments = {
			"rg",
			"-L",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
		},
		prompt_prefix = "   ",
		selection_caret = "  ",
		entry_prefix = "  ",
		initial_mode = "insert",
		selection_strategy = "reset",
		sorting_strategy = "ascending",
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				prompt_position = "top",
				preview_width = 0.55,
				results_width = 0.8,
			},
			vertical = {
				mirror = false,
			},
			bottom_pane = {
				preview_width = 0.40,
				-- preview_cutoff = 70,
			},
			width = 0.87,
			height = 0.80,
			-- preview_cutoff = 120,
			-- preview_cutoff = 40,
		},
		file_sorter = require("telescope.sorters").get_fuzzy_file,
		file_ignore_patterns = { "node_modules" },
		generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
		path_display = { "truncate" },
		winblend = 0,
		border = {},
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		color_devicons = true,
		set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
		qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
		-- Developer configurations: Not meant for general override
		buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
		mappings = {
			n = { ["q"] = require("telescope.actions").close },
		},
	},
	extensions = {
		fzf = {
			fuzzy = false,
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
		},
		["ui-select"] = {
			themes.get_ivy({
				layout_config = ivyCustomLayoutConfig,
			}),
		},
		["goimpl"] = {
			themes.get_ivy({
				layout_config = ivyCustomLayoutConfig,
			}),
		},
		possession = {
			themes.get_ivy({
				layout_config = ivyCustomLayoutConfig,
			}),
		},
		-- lsp_handlers = {
		--     code_action = {
		--         telescope = require("telescope.themes").get_cursor({}),
		--     },
		-- },
	},
	pickers = {
		find_files = {
			theme = "ivy",
			layout_config = ivyCustomLayoutConfig,
			find_command = findCmd,
			prompt_title = "  Looking for files",
			results_title = "",
		},
		lsp_references = {
			theme = "ivy",
			layout_config = ivyCustomLayoutConfig,
			prompt_title = "  Looking for references",
			results_title = "",
		},
		lsp_definitions = {
			theme = "ivy",
			layout_config = ivyCustomLayoutConfig,
			results_title = "",
		},
		grep_string = {
			theme = "ivy",
			layout_config = ivyCustomLayoutConfig,
			results_title = "",
		},
		current_buffer_fuzzy_find = {
			theme = "ivy",
			layout_config = ivyCustomLayoutConfig,
			results_title = "",
		},
		buffers = {
			theme = "ivy",
			layout_config = ivyCustomLayoutConfig,
			results_title = "",
			mappings = {
				n = {
					["<C-d>"] = actions.delete_buffer,
				},
				i = {
					["<C-d>"] = actions.delete_buffer,
				},
			},
		},
		quickfix = {
			theme = "dropdown",
			-- theme = "ivy",
			-- layout_strategy = "bottom_pane",
			layout_config = {
				width = function(_, max_width, _)
					return max_width - 10
				end,
				height = function(_, _, max_lines)
					return 27
					-- return max_lines - 15
				end,
			},
		},
	},
})

-- telescope.load_extension("fzf")
telescope.load_extension("zf-native")
telescope.load_extension("undo")
telescope.load_extension("ui-select")
telescope.load_extension("goimpl")
telescope.load_extension("possession")
telescope.load_extension("lsp_handlers")

local M = {}
M.grep = function()
	telescope_builtin.grep_string({
		results_title = "",
		prompt_title = " Grep word",
		search = vim.fn.input({ prompt = "   Grep for word > ", default = vim.fn.expand("<cword>") }),
		-- search = vim.fn.input("   Grep for word> ", vim.fn.expand("<cword>")),
		use_regex = true,
	})
end

local function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local hasTabby = function()
	return packer_plugins["tabby.nvim"] and packer_plugins["tabby.nvim"].loaded
end

local goto_window = function(prompt_bufnr)
	actions.close(prompt_bufnr)
	local entry = action_state.get_selected_entry()
	-- make vim show the given window
	vim.api.nvim_set_current_win(entry.value)
end

M.tabs = function()
	local windows = {}

	-- local bufs = vim.api.nvim_list_bufs()
	-- for _, bufnr in ipairs(bufs) do
	-- 	local bufName = vim.api.nvim_buf_get_name(bufnr)
	-- 	local bufLabel = trim(string.sub(vim.api.nvim_buf_get_name(bufnr), vim.fn.getcwd():len() + 2))
	--
	-- 	if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_get_current_buf() ~= bufnr and bufName ~= "" then
	-- 		table.insert(windows, {
	-- 			ordinal = bufLabel,
	-- 			display = bufLabel,
	-- 			value = bufnr,
	-- 		})
	-- 	end
	-- end

	local tabs = vim.api.nvim_list_tabpages()
	for tabidx, tabnr in ipairs(tabs) do
		local windownrs = vim.api.nvim_tabpage_list_wins(tabnr)

		local tabLabel = tabidx .. "[TAB]"
		if hasTabby() then
			tabLabel = tabidx .. " [TAB] ( " .. require("tabby.util").get_tab_name(tabnr) .. " )"
		end

		for windownr, windowid in ipairs(windownrs) do
			local bufnr = vim.api.nvim_win_get_buf(windowid)
			local bufLabel = trim(string.sub(vim.api.nvim_buf_get_name(bufnr), vim.fn.getcwd():len() + 2))

			if vim.fn.buflisted(bufnr) > 0 then
				local bufstr = tabLabel .. " " .. bufLabel

				table.insert(windows, {
					ordinal = bufstr,
					display = bufstr,
					value = windowid,
				})
			end
		end
	end

	pickers.new(
		themes.get_ivy({
			layout_config = {
				bottom_pane = {
					height = 15,
				},
				-- results_height = 10,
			},
		}),
		{
			results_title = "",
			prompt_title = "Fuzzy Search your tabs, here",
			finder = finders.new_table({
				results = windows,
				entry_maker = function(x)
					return x
				end,
			}),
			sorter = sorters.get_fzy_sorter({}),
			attach_mappings = function(item, map)
				-- use our custom action to go the window id
				map("i", "<CR>", goto_window)
				map("n", "<CR>", goto_window)
				return true
			end,
		}
	):find()
end

M.dapActions = function()
	local dap, dapui = require("dap"), require("dapui")
	items = {
		{ key = "start", value = dap.continue, desc = "start dap server" },
		{ key = "continue", value = dap.continue },
		{ key = "end", value = dap.close },
		{ key = "toggle breakpoint", value = dap.toggle_breakpoint },
		{
			key = "conditional breakpoint",
			value = function()
				---@diagnostic disable-next-line: param-type-mismatch
				dap.set_breakpoint(vim.fn.input("[Breakpoint Condition] > "))
			end,
		},
		{ key = "run to cursor", value = dap.run_to_cursor },
		{ key = "close dap ui", value = dapui.close },
		{ key = "step over", value = dap.step_over },
		{ key = "step into", value = dap.step_into },
		{ key = "step out", value = dap.step_out },
	}

	m = {}
	for _, item in ipairs(items) do
		table.insert(m, {
			ordinal = item.key,
			display = item.key,
			value = item.value,
		})
	end

	pickers.new(themes.get_ivy(), {
		results_title = "DAP Actions",
		prompt_title = "Hub for dap actions",
		finder = finders.new_table({
			results = m,
			entry_maker = function(x)
				return x
			end,
		}),
		sorter = sorters.get_fzy_sorter({}),
		attach_mappings = function(prompt_bufnr, map)
			return actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				selection.value()
			end)
		end,
	}):find()
end

local make_entry = require("telescope.make_entry")
local flatten = vim.tbl_flatten
local filter = vim.tbl_filter
local Path = require("plenary.path")

local get_open_filelist = function(grep_open_files, cwd)
	if not grep_open_files then
		return nil
	end

	local bufnrs = filter(function(b)
		if 1 ~= vim.fn.buflisted(b) then
			return false
		end
		return true
	end, vim.api.nvim_list_bufs())
	if not next(bufnrs) then
		return
	end

	local filelist = {}
	for _, bufnr in ipairs(bufnrs) do
		local file = vim.api.nvim_buf_get_name(bufnr)
		table.insert(filelist, Path:new(file):make_relative(cwd))
	end
	return filelist
end

M.live_files = function()
	local cwd = vim.loop.cwd()

	local finder = finders.new_job(function(prompt)
		local execCmd = { "rg", "--threads", "3", "--files", "--iglob", "!.git", "--hidden", "--sort", "path" }

		local isForProject = false

		if prompt:sub(1, 2) == "^p" then
			searchQuery = prompt:sub(3)
			table.insert(execCmd, vim.g.root_dir)
			isForProject = true
		end

		-- local cmd = string.format("%s | sed 's|%s||g'", table.concat(execCmd, " "), vim.g.root_dir .. "/")
		-- local cmd = string.format("cd %s && %s", isForProject and vim.g.root_dir or cwd, table.concat(execCmd, " "))
		local cmd = table.concat(execCmd, " ")

		return { "sh", "-c", cmd }
		-- return { "sh", "-c", table.concat(execCmd, " ") }
	end, function(item)
		-- print("item: ", item)
		return {
			ordinal = item,
			display = function(entry)
				local hl_group
				local display = utils.transform_path({}, entry.value)

				display = vim.fn.substitute(display, vim.g.root_dir, "", "g")

				display, hl_group = utils.transform_devicons(entry.value, display, false)
				if entry.value:find(vim.g.root_dir) then
					display = entry.value:sub(#vim.g.root_dir + 2)
				end

				-- display = display:gsub(vim.g.root_dir, "")
				-- print("display:", display, vim.g.root_dir)

				if hl_group then
					return display, { { { 1, 3 }, hl_group } }
				else
					return display
				end
			end,
			value = item,
		}
	end, nil, cwd)

	local conf = require("telescope.config").values
	pickers.new(themes.get_ivy({ layout_config = ivyCustomLayoutConfig }), {
		prompt_title = "Live Files",
		results_title = "",
		finder = finder,
		previewer = conf.grep_previewer({}),
		sorter = sorters.get_generic_fuzzy_sorter(),
		-- sorter = conf.file_sorter({}),
		-- sorter = sorters.get_fzy_sorter(),
		attach_mappings = function(_, map)
			map("i", "<c-space>", actions.to_fuzzy_refine)
			return true
		end,
	}):find()
end

M.live_grep = function(opts)
	-- local vimgrep_arguments = opts.vimgrep_arguments or conf.vimgrep_arguments
	local vimgrep_arguments = { "rg", "--files", "--iglob", "!.git", "--hidden", "-L" }
	local search_dirs = opts.search_dirs
	local grep_open_files = opts.grep_open_files
	opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()

	local filelist = get_open_filelist(grep_open_files, opts.cwd)
	if search_dirs then
		for i, path in ipairs(search_dirs) do
			search_dirs[i] = vim.fn.expand(path)
		end
	end

	print(vim.inspect(vimgrep_arguments))
	-- table.insert(vimgrep_arguments, "--files")

	local additional_args = {}
	if opts.additional_args ~= nil then
		if type(opts.additional_args) == "function" then
			additional_args = opts.additional_args(opts)
		elseif type(opts.additional_args) == "table" then
			additional_args = opts.additional_args
		end
	end

	if opts.type_filter then
		additional_args[#additional_args + 1] = "--type=" .. opts.type_filter
	end

	if type(opts.glob_pattern) == "string" then
		additional_args[#additional_args + 1] = "--glob=" .. opts.glob_pattern
	elseif type(opts.glob_pattern) == "table" then
		for i = 1, #opts.glob_pattern do
			additional_args[#additional_args + 1] = "--glob=" .. opts.glob_pattern[i]
		end
	end

	local args = flatten({ vimgrep_arguments, additional_args or {} })
	-- opts.__inverted, opts.__matches = opts_contain_invert(args)

	local live_grepper = finders.new_job(function(prompt)
		if not prompt or prompt == "" then
			return nil
		end

		local search_list = {}

		local searchQuery = prompt

		print("prompt", prompt)
		if prompt:sub(1, 2) == "^p" then
			searchQuery = prompt:sub(3)
			table.insert(search_list, vim.g.root_dir)
		end

		if grep_open_files then
			search_list = filelist
		elseif search_dirs then
			search_list = search_dirs
		end

		-- return flatten({ args, "--", prompt, search_list })
		return flatten({ args, "--", searchQuery, search_list })
	end, opts.entry_maker or make_entry.gen_from_vimgrep(opts), opts.max_results, opts.cwd)

	opts = vim.tbl_extend("force", opts, themes.get_ivy({ layout_config = ivyCustomLayoutConfig }))

	pickers.new(opts, {
		prompt_title = "Live Grep",
		results_title = "",
		finder = live_grepper,
		previewer = conf.grep_previewer(opts),
		-- TODO: It would be cool to use `--json` output for this
		-- and then we could get the highlight positions directly.
		sorter = sorters.highlighter_only(opts),
		attach_mappings = function(_, map)
			map("i", "<c-space>", actions.to_fuzzy_refine)
			return true
		end,
	}):find()
end

return M

-- -- Custom Find Command
-- local findCmd
-- if vim.fn.executable("fd") then
--   findCmd = { "fd", "-t", "f", "-H", "-E", ".git", "--strip-cwd-prefix" }
-- elseif vim.fn.executable("rg") then
--   findCmd = { "rg", "--files", "--iglob", "!.git", "--hidden" }
-- end
--
-- -- Don't preview the binaries
-- local previewers = require("telescope.previewers")
-- local Job = require("plenary.job")
--
-- local previewMaker = function(filepath, bufnr, opts)
--   filepath = vim.fn.expand(filepath)
--   Job
--       :new({
--         command = "file",
--         args = { "--mime-type", "-b", filepath },
--         on_exit = function(j)
--           local mime_type = vim.split(j:result()[1], "/")[1]
--           if mime_type == "text" then
--             previewers.buffer_previewer_maker(filepath, bufnr, opts)
--           else
--             -- maybe we want to write something to the buffer here
--             vim.schedule(function()
--               vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
--             end)
--           end
--         end,
--       })
--       :sync()
-- end
--
-- telescope.setup({
--   defaults = {
--     previewer = previewMaker,
--     cache_picker = {
--       num_pickers = -1,
--     },
--   },
--   extensions = {
--     fzf = {
--       fuzzy = true,
--       override_generic_sorter = true,
--       override_file_sorter = true,
--       case_mode = "smart_case",
--     },
--     lsp_handlers = {
--       code_action = {
--         telescope = themes.get_dropdown({}),
--       },
--       call_heirarchy = {
--         telescope = themes.get_dropdown({}),
--       },
--       symbol = {
--         telescope = themes.get_ivy({}),
--       },
--       location = {
--         telescope = themes.get_ivy({}),
--       },
--     },
--   },
--   pickers = {
--     find_files = {
--       theme = "ivy",
--       find_command = findCmd,
--       prompt_title = "  Looking for files",
--     },
--     lsp_references = {
--       theme = "ivy",
--       prompt_title = "  Looking for references",
--     },
--     lsp_definitions = {
--       theme = "ivy",
--     },
--     grep_string = {
--       theme = "ivy",
--     },
--     current_buffer_fuzzy_find = {
--       theme = "ivy",
--     },
--     buffers = {
--       theme = "ivy",
--       mappings = {
--         n = {
--           ["<C-d>"] = actions.delete_buffer,
--         },
--         i = {
--           ["<C-d>"] = actions.delete_buffer,
--         },
--       },
--     },
--   },
-- })
--
-- telescope.load_extension("fzf")
-- -- telescope.load_extension("treesitter")
-- telescope.load_extension("lsp_handlers")
--
-- -- telescope.load_extension("dap")
--
-- local M = {}
--
-- -- M.grep = function()
-- -- 	telescope_builtin.grep_string({
-- -- 		prompt_title = " Grep word",
-- -- 		search = vim.fn.input("   Grep for word> ", vim.fn.expand("<cword>")),
-- -- 		use_regex = true,
-- -- 	})
-- -- end
-- --
-- -- M.nvim_config = function()
-- -- 	telescope_builtin.find_files({
-- -- 		prompt_title = "  Nvim Config",
-- -- 		cwd = "~/me/jeera-rice",
-- -- 		layout_strategy = "horizontal",
-- -- 		layout_config = { preview_width = 0.65, width = 0.75, height = 0.5 },
-- -- 		theme = "ivy",
-- -- 	})
-- -- end
-- --
-- -- M.jeera_rice = function()
-- -- 	telescope_builtin.find_files({
-- -- 		prompt_title = "  Jeera Rice",
-- -- 		cwd = "~/me/jeera-rice",
-- -- 		theme = "ivy",
-- -- 	})
-- -- end
-- --
-- -- M.list_sessions = function()
-- -- 	require("session-lens").search_session()
-- -- end
-- --
-- -- -- Docker Images
-- -- M.dockerImages = function()
-- -- 	pickers.new({
-- -- 		theme = "ivy",
-- -- 		results_title = "Docker Images",
-- -- 		finder = finders.new_oneshot_job({ "sh", "-c", "docker images | tail +2 " }),
-- -- 		sorter = sorters.get_fuzzy_file(),
-- -- 		mappings = {
-- -- 			n = {
-- -- 				["<C-d>"] = function(args) end,
-- -- 			},
-- -- 			i = {
-- -- 				["<C-d>"] = function(args) end,
-- -- 			},
-- -- 		},
-- -- 	}):find()
-- -- end
-- --
-- -- local goto_window = function(prompt_bufnr)
-- -- 	actions.close(prompt_bufnr)
-- -- 	local entry = action_state.get_selected_entry()
-- -- 	-- make vim show the given window
-- -- 	vim.api.nvim_set_current_win(entry.value)
-- -- end
-- --
-- -- local getTabLabel = function(tabnr)
-- -- 	-- return "[TAB] " .. tabnr
-- -- 	-- return tabnr .. " [TAB] "
-- -- 	return ""
-- -- end
-- --
-- -- local getTabName = nil
-- --
-- -- local hasTabby = function()
-- -- 	return packer_plugins["tabby.nvim"] and packer_plugins["tabby.nvim"].loaded
-- -- end
-- --
-- -- local function trim(s)
-- -- 	return (s:gsub("^%s*(.-)%s*$", "%1"))
-- -- end
-- --
-- -- M.buffers = function()
-- -- 	local windows = {}
-- --
-- -- 	local bufs = vim.api.nvim_list_bufs()
-- -- 	for _, bufnr in ipairs(bufs) do
-- -- 		print(bufnr)
-- -- 		local bufName = vim.api.nvim_buf_get_name(bufnr)
-- -- 		local bufLabel = trim(string.sub(vim.api.nvim_buf_get_name(bufnr), vim.fn.getcwd():len() + 2))
-- --
-- -- 		if
-- -- 			vim.fn.buflisted(bufnr)
-- -- 			and vim.api.nvim_buf_is_loaded(bufnr)
-- -- 			and vim.api.nvim_get_current_buf() ~= bufnr
-- -- 			and bufName ~= ""
-- -- 		then
-- -- 			table.insert(windows, {
-- -- 				ordinal = bufLabel,
-- -- 				display = bufLabel,
-- -- 				-- value = bufnr,
-- -- 				value = vim.fn.winbufnr(bufnr),
-- -- 			})
-- -- 		end
-- -- 	end
-- --
-- -- 	pickers.new(themes.get_ivy(), {
-- -- 		results_title = "Buffers",
-- -- 		prompt_title = "Fuzzy Search your buffers, and switch to them",
-- -- 		finder = finders.new_table({
-- -- 			results = windows,
-- -- 			entry_maker = function(x)
-- -- 				return x
-- -- 			end,
-- -- 		}),
-- -- 		sorter = sorters.get_fzy_sorter({}),
-- -- 		attach_mappings = function(item, map)
-- -- 			-- use our custom action to go the window id
-- -- 			map("i", "<CR>", goto_window)
-- -- 			map("n", "<CR>", goto_window)
-- -- 			return true
-- -- 		end,
-- -- 	}):find()
-- -- end
-- --
-- -- M.tabs = function()
-- -- 	local windows = {}
-- --
-- -- 	local bufs = vim.api.nvim_list_bufs()
-- -- 	for _, bufnr in ipairs(bufs) do
-- -- 		local bufName = vim.api.nvim_buf_get_name(bufnr)
-- -- 		local bufLabel = trim(string.sub(vim.api.nvim_buf_get_name(bufnr), vim.fn.getcwd():len() + 2))
-- --
-- -- 		if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_get_current_buf() ~= bufnr and bufName ~= "" then
-- -- 			table.insert(windows, {
-- -- 				ordinal = bufLabel,
-- -- 				display = bufLabel,
-- -- 				value = bufnr,
-- -- 			})
-- -- 		end
-- -- 	end
-- --
-- -- 	local tabs = vim.api.nvim_list_tabpages()
-- -- 	for tabidx, tabnr in ipairs(tabs) do
-- -- 		local windownrs = vim.api.nvim_tabpage_list_wins(tabnr)
-- --
-- -- 		for windownr, windowid in ipairs(windownrs) do
-- -- 			local bufnr = vim.api.nvim_win_get_buf(windowid)
-- -- 			local bufLabel = string.sub(vim.api.nvim_buf_get_name(bufnr), vim.fn.getcwd():len() + 2)
-- --
-- -- 			if getTabName == nil then
-- -- 				if hasTabby() then
-- -- 					local tn = require("tabby.util").get_tab_name
-- -- 					getTabLabel = function(tabnr, idx)
-- -- 						return idx .. " [TAB] ( " .. tn(tabnr) .. " )"
-- -- 					end
-- -- 				end
-- -- 				getTabName = "from:tabby"
-- -- 			end
-- --
-- -- 			local bufstr = getTabLabel(tabnr, tabidx) .. " " .. bufLabel
-- --
-- -- 			table.insert(windows, {
-- -- 				ordinal = bufstr,
-- -- 				display = bufstr,
-- -- 				value = windowid,
-- -- 			})
-- -- 		end
-- -- 	end
-- --
-- -- 	pickers.new(themes.get_ivy(), {
-- -- 		results_title = "Tabs",
-- -- 		prompt_title = "Fuzzy Search your tabs, here",
-- -- 		finder = finders.new_table({
-- -- 			results = windows,
-- -- 			entry_maker = function(x)
-- -- 				return x
-- -- 			end,
-- -- 		}),
-- -- 		sorter = sorters.get_fzy_sorter({}),
-- -- 		attach_mappings = function(item, map)
-- -- 			-- use our custom action to go the window id
-- -- 			map("i", "<CR>", goto_window)
-- -- 			map("n", "<CR>", goto_window)
-- -- 			return true
-- -- 		end,
-- -- 	}):find()
-- -- end
-- --
-- -- M.actions = function()
-- -- 	items = {
-- -- 		{
-- -- 			key = "Buffer Delete Nameless",
-- -- 			value = function()
-- -- 				require("close_buffers").wipe({ type = "nameless" })
-- -- 			end,
-- -- 		},
-- --
-- -- 		{
-- -- 			key = "Buffer Delete Others",
-- -- 			value = function()
-- -- 				require("close_buffers").wipe({ type = "other" })
-- -- 			end,
-- -- 		},
-- --
-- -- 		{
-- -- 			key = "Base64 Encode",
-- -- 			value = Fn().b64Encode,
-- -- 		},
-- --
-- -- 		{
-- -- 			key = "Base64 Decode",
-- -- 			value = Fn().b64Decode,
-- -- 		},
-- -- 	}
-- --
-- -- 	m = {}
-- -- 	for _, item in ipairs(items) do
-- -- 		table.insert(m, {
-- -- 			ordinal = item.key,
-- -- 			display = item.key,
-- -- 			value = item.value,
-- -- 		})
-- -- 	end
-- --
-- -- 	pickers.new(themes.get_ivy(), {
-- -- 		results_title = "Nxt Actions",
-- -- 		prompt_title = "Hub for some common actions",
-- -- 		finder = finders.new_table({
-- -- 			results = m,
-- -- 			entry_maker = function(x)
-- -- 				return x
-- -- 			end,
-- -- 		}),
-- -- 		sorter = sorters.get_fzy_sorter({}),
-- -- 		attach_mappings = function(prompt_bufnr, map)
-- -- 			return actions.select_default:replace(function()
-- -- 				actions.close(prompt_bufnr)
-- -- 				local selection = action_state.get_selected_entry()
-- -- 				selection.value()
-- -- 			end)
-- -- 		end,
-- -- 	}):find()
-- -- end
-- --
-- -- M.dapActions = function()
-- -- 	local dap, dapui = require("dap"), require("dapui")
-- -- 	items = {
-- -- 		{ key = "start", value = dap.continue },
-- -- 		{ key = "continue", value = dap.continue },
-- -- 		{ key = "end", value = dap.close },
-- -- 		{ key = "toggle breakpoint", value = dap.toggle_breakpoint },
-- -- 		{
-- -- 			key = "conditional breakpoint",
-- -- 			value = function()
-- -- 				dap.set_breakpoint(vim.fn.input("[Condition] > "))
-- -- 			end,
-- -- 		},
-- -- 		{ key = "run to cursor", value = dap.run_to_cursor },
-- -- 		{ key = "close dap ui", value = dapui.close },
-- -- 		{ key = "step over", value = dap.step_over },
-- -- 		{ key = "step into", value = dap.step_into },
-- -- 		{ key = "step out", value = dap.step_out },
-- -- 	}
-- --
-- -- 	m = {}
-- -- 	for _, item in ipairs(items) do
-- -- 		table.insert(m, {
-- -- 			ordinal = item.key,
-- -- 			display = item.key,
-- -- 			value = item.value,
-- -- 		})
-- -- 	end
-- --
-- -- 	pickers.new(themes.get_ivy(), {
-- -- 		results_title = "DAP Actions",
-- -- 		prompt_title = "Hub for dap actions",
-- -- 		finder = finders.new_table({
-- -- 			results = m,
-- -- 			entry_maker = function(x)
-- -- 				return x
-- -- 			end,
-- -- 		}),
-- -- 		sorter = sorters.get_fzy_sorter({}),
-- -- 		attach_mappings = function(prompt_bufnr, map)
-- -- 			return actions.select_default:replace(function()
-- -- 				actions.close(prompt_bufnr)
-- -- 				local selection = action_state.get_selected_entry()
-- -- 				selection.value()
-- -- 			end)
-- -- 		end,
-- -- 	}):find()
-- -- end
-- --
-- return M
