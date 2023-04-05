require("nvim-dap-virtual-text").setup({
  commented = true,
})

local dap, dapui = require("dap"), require("dapui")
dapui.setup({})

dap.listeners.after.event_initialized["dapui_config"] = function()
  -- dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "⭐️", texthl = "", linehl = "DapStoppedLinehl", numhl = "" })
vim.api.nvim_set_hl(0, "DapStoppedLinehl", { bg = "#555530" })

require("plugins.dap.keymaps")
require("plugins.dap.languages.go").setup()
require("plugins.dap.languages.lua").setup()
