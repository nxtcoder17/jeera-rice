local M = {}

local dap = Require("dap")
local utils = Require("plugins.dap.utils")

--[[
NOTE: dap-configurations `console` support 3 options:
- internalConsole
- integratedTerminal
- externalTerminal
--]]

local function default_go_configurations()
	return {
		{
			name = "Debug a file",
			type = "go",
			request = "launch",
			program = "${file}",
			debugAdapter = "dlv",
			showLog = true,
			console = "integratedConsole",
			-- console = "externalTerminal",
			-- console = "internalTerminal",
			internalTerminal = true,
			externalTerminal = true,
			env = function()
				-- local x = utils.read_env_file(vim.loop.cwd() .. "/.env")
				-- local y = utils.read_env_file(vim.loop.cwd() .. "/.secrets/env")
				-- return vim.tbl_deep_extend("force", y or {}, x or {})
				return {}
			end,
		},

		{
			name = "Debug running process",
			type = "go",
			request = "attach",
			processId = utils.filtered_pick_process,
			env = function()
				local x = utils.read_env_file(vim.loop.cwd() .. "/.env")
				local y = utils.read_env_file(vim.loop.cwd() .. "/.secrets/env")
				return vim.tbl_deep_extend("force", y or {}, x or {})
			end,
		},

		{
			type = "go",
			name = "Debug Package",
			request = "launch",
			-- program = "${fileDirname}",
			program = utils.choose_program_dir,
			envFile = function()
				local d = ""
				vim.ui.input({ prompt = "EnvFile: ", default = vim.fn.expand("%:p:h") }, function(input)
					d = input
				end)
				return {
					d,
				}
			end,
		},

		{
			type = "go",
			name = "Debug Package with Args",
			request = "remote",
			program = function()
				return utils.choose_dir("program dir", vim.fn.expand("%:p:h"), nil)
			end,
			env = function()
				local d = ""
				vim.ui.input({ prompt = "env dir > ", default = vim.fn.expand("%:p:h") }, function(input)
					d = input
				end)
				local x = utils.read_env_file(d .. "/.env")
				local y = utils.read_env_file(d .. "/.secrets/env")
				local z = vim.tbl_deep_extend("force", y, x or {})
				return z
			end,
			args = utils.get_arguments,
			console = "externalTerminal",
		},

		-- for tests
		{
			type = "go",
			name = "Debug test",
			request = "launch",
			mode = "test",
			program = "${file}",
			buildFlags = "",
		},
	}
end

local function default_go_adapters()
	dap.adapters.go = {
		type = "server",
		port = "${port}",
		executable = {
			command = "bash",
			args = {
				"-c",
				"dlv dap -l 127.0.0.1:${port} --api-version 2  --check-go-version false --allow-non-terminal-interactive 2>&1 | tee /tmp/debug.stdout",
				-- "dlv debug --accept-multiclient --headless -l 127.0.0.1:${port} --api-version 2 --allow-non-terminal-interactive 2>&1 | tee /tmp/debug.stdout",
				-- "dlv debug --continue --accept-multiclient --headless -l 127.0.0.1:${port} --api-version 2 --allow-non-terminal-interactive 2>&1 | tee /tmp/debug.stdout",
			},
		},
		options = {
			initialize_timeout_sec = 20,
		},
		enrich_config = utils.adapter_inject_env,
	}

	dap.adapters.go_local = {
		type = "server",
		-- port = "${port}",
		port = "${port}",
		-- port = math.floor(math.random() * 10000),
		executable = {
			-- command = "bash",
			command = "dlv",
			args = {
				-- "-c",
				-- "dlv dap -l 127.0.0.1:${port} --api-version 2  --check-go-version false --allow-non-terminal-interactive 2>&1 | tee /tmp/debug.stdout",
				-- "dlv dap -l 127.0.0.1:${port}",
				"dap",
				"-l",
				"127.0.0.1:8878",
				-- "dap -l 127.0.0.1:${port}",
			},
		},
		options = {
			initialize_timeout_sec = 20,
		},
		enrich_config = utils.adapter_inject_env,
	}

	dap.adapters.go_test = {
		type = "server",
		port = "${port}",
		executable = {
			command = "bash",
			args = {
				"-c",
				"dlv test --api-version 2 --allow-non-terminal-interactive 2>&1 | tee /tmp/debug.stdout",
			},
		},
		options = {
			initialize_timeout_sec = 20,
		},
		enrich_config = utils.adapter_inject_env,
	}
end

-- [source](nvim-dap-go)
M.setup = function()
	dap.set_log_level("TRACE")
	dap.defaults.fallback.focus_terminal = true
	dap.defaults.fallback.force_external_terminal = true
	-- dap.defaults.fallback.external_terminal = {
	-- 	command = "/usr/bin/alacritty",
	-- 	args = { "-e" },
	-- }

	dap.configurations.go = {}

	local projectDapFile = vim.g.project_root_dir .. "/.tools/nvim/dap/go.lua"
	if utils.file_exists(projectDapFile) then
		vim.cmd("so " .. projectDapFile)
	end

	local goConfigs = default_go_configurations()
	for _, cfg in ipairs(goConfigs) do
		table.insert(dap.configurations.go, cfg)
	end
	default_go_adapters()
end

return M
