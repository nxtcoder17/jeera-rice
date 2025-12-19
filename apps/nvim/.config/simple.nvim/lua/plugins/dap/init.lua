-- require("nvim-dap-virtual-text").setup({
--   commented = true,
-- })

local dap, dapui = Require("dap"), Require("dapui")
dapui.setup({
  layouts = {
    {
      elements = {
        "breakpoints",
        "watches",
        "stacks",
        -- "scopes",
      },
      size = 40,
      position = "left",
    },
    {
      elements = { "repl" },
      size = 10,
      position = "bottom",
    },
  },
  floating = {
    max_height = nil, -- Either absolute integer or float
    max_width = nil, -- between 0 and 1 (size relative to screen size)
  },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dap.repl.toggle({}, "80vsplit")
  -- dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "❓", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "⚠️", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "⭐️", texthl = "", linehl = "DapStoppedLinehl", numhl = "" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "dap-repl" },
  callback = function()
    vim.cmd("set wrap")
  end,
})

require("plugins.dap.keymaps")

local autocmds = vim.api.nvim_create_augroup("plugins.dap", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = autocmds,
  pattern = "dapui_events",
  callback = function()
    vim.cmd("set wrap")
  end,
})
