local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local themes = require("telescope.themes")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")

-- Custom Find Command
local findCmd
if vim.fn.executable("fd") then
	findCmd = { "fd", "-t", "f", "-H", "-E", ".git", "--strip-cwd-prefix" }
elseif vim.fn.executable("rg") then
	findCmd = { "rg", "--files", "--iglob", "!.git", "--hidden" }
end

-- Don't preview the binaries
local previewers = require("telescope.previewers")
local Job = require("plenary.job")

local previewMaker = function(filepath, bufnr, opts)
	filepath = vim.fn.expand(filepath)
	Job
			:new({
				command = "file",
				args = { "--mime-type", "-b", filepath },
				on_exit = function(j)
					local mime_type = vim.split(j:result()[1], "/")[1]
					if mime_type == "text" then
						previewers.buffer_previewer_maker(filepath, bufnr, opts)
					else
						-- maybe we want to write something to the buffer here
						vim.schedule(function()
							vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
						end)
					end
				end,
			})
			:sync()
end

telescope.setup({
	defaults = {
		previewer = previewMaker,
		cache_picker = {
			num_pickers = -1,
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
	pickers = {
		find_files = {
			theme = "ivy",
			find_command = findCmd,
			prompt_title = "  Looking for files",
		},
		lsp_references = {
			theme = "ivy",
			prompt_title = "  Looking for references",
		},
		lsp_definitions = {
			theme = "ivy",
		},
		grep_string = {
			theme = "ivy",
		},
		current_buffer_fuzzy_find = {
			theme = "ivy",
		},
		buffers = {
			theme = "ivy",
			mappings = {
				n = {
					["<C-d>"] = actions.delete_buffer,
				},
				i = {
					["<C-d>"] = actions.delete_buffer,
				},
			},
		},
	},
})

telescope.load_extension("fzf")
telescope.load_extension("dap")

local M = {}

M.grep = function()
	telescope_builtin.grep_string({
		prompt_title = " Grep word",
		search = vim.fn.input("   Grep for word> ", vim.fn.expand("<cword>")),
		use_regex = true,
	})
end

M.nvim_config = function()
	telescope_builtin.find_files({
		prompt_title = "  Nvim Config",
		cwd = "~/me/jeera-rice",
		layout_strategy = "horizontal",
		layout_config = { preview_width = 0.65, width = 0.75 },
		theme = "ivy",
	})
end

M.jeera_rice = function()
	telescope_builtin.find_files({
		prompt_title = "  Jeera Rice",
		cwd = "~/me/jeera-rice",
		theme = "ivy",
	})
end

M.list_sessions = function()
	require("session-lens").search_session()
end

-- Docker Images
M.dockerImages = function()
	pickers.new({
		theme = "ivy",
		results_title = "Docker Images",
		finder = finders.new_oneshot_job({ "sh", "-c", "docker images | tail +2 " }),
		sorter = sorters.get_fuzzy_file(),
		mappings = {
			n = {
				["<C-d>"] = function(args) end,
			},
			i = {
				["<C-d>"] = function(args) end,
			},
		},
	}):find()
end

local goto_window = function(prompt_bufnr)
	actions.close(prompt_bufnr)
	local entry = action_state.get_selected_entry()
	-- make vim show the given window
	vim.api.nvim_set_current_win(entry.value)
end

local getTabLabel = function(tabnr)
	-- return "[TAB] " .. tabnr
	-- return tabnr .. " [TAB] "
	return ""
end

local getTabName = nil

local hasTabby = function()
	return packer_plugins["tabby.nvim"] and packer_plugins["tabby.nvim"].loaded
end

local function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

M.buffers = function()
	local windows = {}

	local bufs = vim.api.nvim_list_bufs()
	for _, bufnr in ipairs(bufs) do
		print(bufnr)
		local bufName = vim.api.nvim_buf_get_name(bufnr)
		local bufLabel = trim(string.sub(vim.api.nvim_buf_get_name(bufnr), vim.fn.getcwd():len() + 2))

		if vim.fn.buflisted(bufnr)
				and vim.api.nvim_buf_is_loaded(bufnr)
				and vim.api.nvim_get_current_buf() ~= bufnr
				and bufName ~= ""
		then
			table.insert(windows, {
				ordinal = bufLabel,
				display = bufLabel,
				-- value = bufnr,
				value = vim.fn.winbufnr(bufnr),
			})
		end
	end

	pickers.new(themes.get_ivy(), {
		results_title = "Buffers",
		prompt_title = "Fuzzy Search your buffers, and switch to them",
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
	}):find()
end

M.tabs = function()
	local windows = {}

	local bufs = vim.api.nvim_list_bufs()
	for _, bufnr in ipairs(bufs) do
		local bufName = vim.api.nvim_buf_get_name(bufnr)
		local bufLabel = trim(string.sub(vim.api.nvim_buf_get_name(bufnr), vim.fn.getcwd():len() + 2))

		if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_get_current_buf() ~= bufnr and bufName ~= "" then
			table.insert(windows, {
				ordinal = bufLabel,
				display = bufLabel,
				value = bufnr,
			})
		end
	end

	local tabs = vim.api.nvim_list_tabpages()
	for tabidx, tabnr in ipairs(tabs) do
		local windownrs = vim.api.nvim_tabpage_list_wins(tabnr)

		for windownr, windowid in ipairs(windownrs) do
			local bufnr = vim.api.nvim_win_get_buf(windowid)
			local bufLabel = string.sub(vim.api.nvim_buf_get_name(bufnr), vim.fn.getcwd():len() + 2)

			if getTabName == nil then
				if hasTabby() then
					local tn = require("tabby.util").get_tab_name
					getTabLabel = function(tabnr, idx)
						return idx .. " [TAB] ( " .. tn(tabnr) .. " )"
					end
				end
				getTabName = "from:tabby"
			end

			local bufstr = getTabLabel(tabnr, tabidx) .. " " .. bufLabel

			table.insert(windows, {
				ordinal = bufstr,
				display = bufstr,
				value = windowid,
			})
		end
	end

	pickers.new(themes.get_ivy(), {
		results_title = "Tabs",
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
	}):find()
end

M.actions = function()
	items = {
		{
			key = "Buffer Delete Nameless",
			value = function()
				require("close_buffers").wipe({ type = "nameless" })
			end,
		},

		{
			key = "Buffer Delete Others",
			value = function()
				require("close_buffers").wipe({ type = "other" })
			end,
		},

		{
			key = "Base64 Encode",
			value = Fn().b64Encode,
		},

		{
			key = "Base64 Decode",
			value = Fn().b64Decode,
		},
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
		results_title = "Nxt Actions",
		prompt_title = "Hub for some common actions",
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

M.dapActions = function()
	local dap, dapui = require("dap"), require("dapui")
	items = {
		{ key = "start", value = dap.continue },
		{ key = "continue", value = dap.continue },
		{ key = "end", value = dap.close },
		{ key = "toggle breakpoint", value = dap.toggle_breakpoint },
		{
			key = "conditional breakpoint",
			value = function()
				dap.set_breakpoint(vim.fn.input("[Condition] > "))
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

return M
