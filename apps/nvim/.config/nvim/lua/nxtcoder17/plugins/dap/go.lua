local dap = require("dap")

dap.adapters.go = function(callback, config)
  local port = 34789
  vim.defer_fn(function()
    callback({ type = "server", host = "127.0.0.1", port = port })
  end, 100)
end

dap.configurations = {
  {
    type = "go",
    name = "Debug",
    request = "launch",
    program = "${file}",
  },
}

vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "⭐️", texthl = "", linehl = "", numhl = "" })
