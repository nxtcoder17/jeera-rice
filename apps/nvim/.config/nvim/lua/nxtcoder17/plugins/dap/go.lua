local M = {}

local dap = require("dap")
local utils = require("nxtcoder17.plugins.dap.utils")

--[[
NOTE: dap-configurations `console` support 3 options:
- internalConsole
- integratedTerminal
- externalTerminal
--]]

-- [source](nvim-dap-go)
M.setup = function()
  -- dap.defaults.fallback.force_integrated_terminal = true
  dap.defaults.fallback.force_external_terminal = true
  dap.defaults.fallback.external_terminal = {
    command = '/usr/bin/alacritty';
    args = {'-e'};
  }

  dap.set_log_level("TRACE")
  dap.configurations.go = {
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
          -- env = {
          --   hello = "hi",
          -- },
          -- envFile = {
          --     "${workspaceFolder}/.env",
          --     "${workspaceFolder}/.secrets/env",
          -- },
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
          -- envFile = {
          --     "${workspaceFolder}/.env",
          --     "${workspaceFolder}/.secrets/env",
          -- },
      },

      {
          type = "go",
          name = "Debug Package with Args",
          request = "launch",
          -- program = "${fileDirname}",
          program = function()
            return utils.choose_dir("program dir", vim.fn.expand("%:p:h"), nil)
          end,
          -- env = {
          --   RECONCILE_PERIOD = "30s",
          --   RELEASE_VERSION = "10",
          -- },
          env = function()
            local d = ""
            vim.ui.input({ prompt =  "env dir > ", default = vim.fn.expand("%:p:h") }, function(input)
              d = input
            end)
            local x = utils.read_env_file(d .. "/.env")
            local y = utils.read_env_file(d .. "/.secrets/env")
            local z =  vim.tbl_deep_extend("force", y, x or {})
            print(vim.inspect(z))
            return z
          end,
          -- env = function()
          --   return utils.choose_dir("Env Dir", vim.fn.expand("%:p:h"), function(d)
          --     local t =  {
          --       d .. "/.secrets/env",
          --       -- d .. "/.env",
          --     }
          --
          --     local env = {}
          --     for i, envFile in ipairs(t) do
          --       local e = utils.read_env_file(envFile, {debug = false})
          --       env = vim.tbl_extend("force", env, e)
          --     end
          --
          --     print(vim.inspect(env))
          --     return env
          --   end)
          -- end,
          -- envFile = function() 
          --   return  utils.choose_dir("Env Dir", vim.fn.expand("%:p:h"), function(d)
          --     local t =  {
          --       d .. "/.secrets/env",
          --       d .. "/.env",
          --     }
          --     print(vim.inspect(t))
          --     return t
          --   end)
          -- end,
          args = utils.get_arguments,
          -- console = "integratedTerminal",
          console = "externalTerminal",
          -- internalTerminal = true,
          -- externalTerminal = true,
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
          args = { "dap", "-l", "127.0.0.1:${port}", "--check-go-version=false" },
      },
      options = {
          initialize_timeout_sec = 20,
      },
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
              "--log",
              "--log-output=dap",
          },
      },
      -- initialize_timeout_sec = 20,
  }

  dap.adapters.delve = {
      type = "server",
      port = "${port}",
      executable = {
          command = "dlv",
          args = { "dap", "-l", "127.0.0.1:${port}", "--check-go-version", "false", "--log", "--log-output=dap", "-r", "stdout:/tmp/dlv.stdout" },
      },
      -- options = {
      --     initialize_timeout_sec = 20,
      -- },
  }
end

return M
