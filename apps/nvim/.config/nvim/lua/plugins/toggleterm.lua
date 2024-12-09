require("toggleterm").setup({
	highlights = {
		FloatBorder = {
			link = "Comment",
		},
	},
	auto_scroll = true,
	float_opts = {
		border = "curved",
	},
})

local function toggleterm_keymaps()
	-- local tmux_terminals = {}
	-- vim.keymap.set({ "n" }, "sg", function()
	-- 	-- Utils.system_call("tmux list-sessions -F #{session_name}:#{pane_current_path}")
	-- 	local dir = vim.fn.getcwd()
	-- 	if tmux_terminals[dir] ~= nil then
	-- 		tmux_terminals[dir]()
	-- 		return
	-- 	end
	--
	-- 	local term = require("toggleterm.terminal").Terminal:new({
	-- 		cmd = string.format(
	-- 			[[
	-- 		tmux new-session -A -s %s -c %s
	--      ]],
	-- 			vim.fs.basename(vim.fn.getcwd()),
	-- 			vim.fn.getcwd()
	-- 		),
	-- 		start_in_insert = true,
	-- 		dir = vim.fn.getcwd(),
	-- 		direction = "float",
	-- 	})
	-- 	tmux_terminals[dir] = function()
	-- 		term:toggle()
	-- 	end
	-- 	term:toggle()
	-- 	return
	-- end, opts)

	local terminals = {}
	vim.keymap.set({ "n" }, "st", function()
		local dir = vim.fn.getcwd()
		if terminals[dir] ~= nil then
			terminals[dir]()
			return
		end

		local init_cmd = {
			["fish"] = string.format([[ fish --init-command "pushd %s; pushd %s" ]], vim.g.project_root_dir, vim.fn.getcwd()),
			["bash"] = string.format([[ bash --init-file <(pushd %s; pushd %s) ]], vim.g.project_root_dir, vim.fn.getcwd()),
			["zsh"] = string.format([[ zsh -c "pushd %s; pushd %s; zsh -i" ]], vim.g.project_root_dir, vim.fn.getcwd()),
		}
		local term = require("toggleterm.terminal").Terminal:new({
			cmd = init_cmd[vim.fs.basename(os.getenv("SHELL"))],
			start_in_insert = true,
			dir = vim.fn.getcwd(),
			direction = "float",
		})
		terminals[dir] = function()
			term:toggle()
		end
		term:toggle()
	end, { noremap = true, silent = true, desc = "opens up a terminal in tab loccal working directory" })
end

toggleterm_keymaps()
