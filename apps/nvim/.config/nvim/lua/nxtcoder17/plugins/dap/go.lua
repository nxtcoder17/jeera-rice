local M = {}

local dap = require("dap")
local utils = require("nxtcoder17.plugins.dap.utils")

-- [source](nvim-dap-go)
M.setup = function()
	dap.set_log_level("TRACE")
	dap.configurations.go = {
		{
			name = "debug a file",
			type = "go",
			request = "launch",
			program = "${file}",
			debugAdapter = "dlv",
			showLog = true,
			-- console = "externalTerminal",
			console = "internalTerminal",
			internalTerminal = true,
			externalTerminal = true,
			-- env = {
			--   hello = "hi",
			-- },
			envFile = {
				"${workspaceFolder}/.env",
				"${workspaceFolder}/.secrets/env",
			},
		},

		{
			type = "go",
			name = "Debug Package",
			request = "launch",
			-- program = "${fileDirname}",
			program = utils.choose_program_dir,
			envFile = {
				"${workspaceFolder}/.env",
				"${workspaceFolder}/.secrets/env",
			},
		},

		{
			type = "go",
			name = "Debug Package with Args",
			request = "launch",
			-- program = "${fileDirname}",
			program = utils.choose_program_dir,
			envFile = {
				"${workspaceFolder}/.env",
				"${workspaceFolder}/.secrets/env",
			},
			args = utils.get_arguments,
		},

		{
			type = "go_test",
			name = "Test Package",
			request = "launch",
			mode = "test",
			program = utils.choose_program_dir,
			env = {
				PROJECT_ROOT = "/home/nxtcoder17/workspace/kloudlite/operator",
			},
		},
	}

	dap.adapters.go = {
		type = "server",
		port = "${port}",
		executable = {
			command = "dlv",
			args = { "dap", "-l", "127.0.0.1:${port}", "--check-go-version=false"},
		},
		initialize_timeout_sec = 20,
	}

	dap.adapters.go_test = {
		type = "executable",
		port = "${port}",
		executable = {
			command = "dlv",
			args = {
				"dap",
				"--listen",
				"127.0.0.1:${port}",
				"--headless",
				"true",
				"--api-version",
				"2",
				"--check-go-version",
				"false",
				" --only-same-user",
				"false",
				"--",
				"-test.v",
				"-test.paniconexit0",
			},
		},
		initialize_timeout_sec = 20,
	}

	dap.adapters.delve = {
		type = "server",
		port = "${port}",
		executable = {
			command = "dlv",
			args = { "dap", "-l", "127.0.0.1:${port}", "--check-go-version", "false" },
		},
		options = {
			initialize_timeout_sec = 20,
		},
	}
end

return M
