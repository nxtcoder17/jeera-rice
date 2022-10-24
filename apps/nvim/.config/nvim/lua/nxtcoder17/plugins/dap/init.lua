require("nvim-dap-virtual-text").setup({
  commented = true,
})

local dap, dapui = require("dap"), require("dapui")
dapui.setup({}) -- use default
dap.listeners.after.event_initialized["dapui_config"] = function()
  print("dapui opened")
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  print("dapui closed")
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  print("dapui closed")
  dapui.close()
end

vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "⭐️", texthl = "", linehl = "", numhl = "" })

local function setupLua()
  local dap = require("dap")

  dap.configurations.lua = {
    {
      type = "nlua",
      request = "attach",
      name = "Attach to running Neovim instance",
      host = function()
        local value = vim.fn.input("Host [127.0.0.1]: ")
        if value ~= "" then
          return value
        end
        return "127.0.0.1"
      end,
      port = function()
        local val = tonumber(vim.fn.input("Port: ", "54321"))
        assert(val, "Please provide a port number")
        return val
      end,
    },
  }

  dap.adapters.nlua = function(callback, config)
    callback({ type = "server", host = config.host, port = config.port })
  end
end

setupLua()
