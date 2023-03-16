local M = {}

local dap = require("dap")
local utils = require("nxtcoder17.plugins.dap.utils")

--[[
NOTE: dap-configurations `console` support 3 options:
- internalConsole
- integratedTerminal
- externalTerminal
--]]
function default_go_configurations()
  return {
    {
      name = "debug a file",
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
        local x = utils.read_env_file(vim.loop.cwd() .. "/.env")
        local y = utils.read_env_file(vim.loop.cwd() .. "/.secrets/env")
        return vim.tbl_deep_extend("force", y, x or {})
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
      request = "launch",
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
        print(vim.inspect(z))
        return z
      end,
      args = utils.get_arguments,
      console = "externalTerminal",
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
end

function default_go_adapters()
  dap.adapters.go = {
    type = "server",
    port = "${port}",
    executable = {
      -- command = "dlv",
      -- args = {
      --   "dap",
      --   "-l",
      --   "127.0.0.1:${port}",
      --   "--headless",
      --   "true",
      --   "--api-version",
      --   "2",
      --   "--check-go-version",
      --   "false",
      -- },
      command = "bash",
      args = {
        "-c",
        "dlv dap -l 127.0.0.1:${port} --api-version 2 --check-go-version false --allow-non-terminal-interactive 2>&1 | tee /tmp/debug.stdout",
      },
    },
    options = {
      initialize_timeout_sec = 20,
    },
    enrich_config = utils.adapter_inject_env,
  }

  -- dap.adapters.go_test = {
  -- 	type = "executable",
  -- 	port = "${port}",
  -- 	executable = {
  -- 		command = "dlv",
  -- 		args = {
  -- 			-- intellij like, copied from intellij command
  -- 			"dap",
  -- 			"--listen",
  -- 			"127.0.0.1:${port}",
  -- 			"--headless",
  -- 			"true",
  -- 			"--api-version",
  -- 			"2",
  -- 			"--check-go-version",
  -- 			"false",
  -- 			" --only-same-user",
  -- 			"false",
  -- 			"--",
  -- 			"-test.v",
  -- 			"-test.paniconexit0",
  -- 			"--log",
  -- 			"--log-output=dap",
  -- 		},
  -- 	},
  -- 	-- initialize_timeout_sec = 20,
  -- }

  dap.adapters.delve = {
    type = "server",
    port = "${port}",
    enrich_config = utils.adapter_inject_env,
    executable = {
      -- command = "dlv",
      -- args = {
      --   "dap",
      --   "-l",
      --   "127.0.0.1:${port}",
      --   "--check-go-version",
      --   "false",
      --   "--allow-non-terminal-interactive",
      --   "--log",
      --   "--log-output=dap",
      -- },
      command = "bash",
      args = {
        "-c",
        -- "dlv dap -l 127.0.0.1:${port} --check-go-version false --allow-non-terminal-interactive | tee /tmp/debug.stdout",
        "dlv debug --headless -l 127.0.0.1:${port} -r stdout:/tmp/debug.stdout",
      },
    },
    -- options = {
    --     initialize_timeout_sec = 20,
    -- },
  }
end

-- [source](nvim-dap-go)
M.setup = function()
  dap.set_log_level("TRACE")
  dap.defaults.fallback.focus_terminal = true
  dap.defaults.fallback.force_external_terminal = true
  dap.defaults.fallback.external_terminal = {
    command = "/usr/bin/alacritty",
    args = { "-e" },
  }

  projectDapFile = vim.g.root_dir .. "/.tools/nvim/dap/go.lua"
  if utils.file_exists(projectDapFile) then
    vim.cmd("so " .. projectDapFile)
  end

  local goConfigs = default_go_configurations()
  for _, cfg in ipairs(goConfigs) do
    table.insert(dap.configurations.go or {}, cfg)
  end
  default_go_adapters()
end

return M
