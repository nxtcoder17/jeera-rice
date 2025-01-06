local dap = Require("dap")
local dap_utils = Require("plugins.dap.utils")

local logger = NewLogger("dap.languages.go", "info")

local M = {}

function M.setup()
	dap.configurations.go = {
		-- {
		-- 	type = "go",
		-- 	name = "Debug auth-api",
		-- 	request = "launch",
		-- 	program = vim.g.nxt.project_root_dir .. "/apps/auth",
		-- 	args = { "--dev" },
		-- 	console = "externalTerminal",
		-- 	-- externalTerminal = true,
		-- 	envFile = {
		-- 		vim.g.nxt.project_root_dir .. "/apps/auth" .. "/.secrets/env",
		-- 	},
		-- },
		{
			type = "go",
			name = "Debug",
			request = "launch",
			outputMode = "remote",
			-- program = "${fileDirname}",
			args = function()
				return load("return " .. vim.fn.input({ prompt = "Run Args: ", default = [[{ "--dev", }]] }))()
			end,
			program = function()
				return vim.fn.getcwd()
			end,
			envFile = {
				".secrets/env",
			},
		},
	}

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
		-- enrich_config = utils.adapter_inject_env,
		enrich_config = function(current_config, on_new_config)
			local new_config = dap_utils.evaluate_config(current_config)
			logger.debug("new config", new_config)
			on_new_config(new_config)
		end,
	}
end

return M
