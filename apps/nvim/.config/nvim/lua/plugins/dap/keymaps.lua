local dap = require("dap")
local Utils = require("functions.utils")

_G.dap_sessions = {}

vim.t.current_dap_repl_dir = nil

-- current dap session id, will be stored in `vim.t.dap_session`
dap.listeners.after["event_initialized"]["me"] = function()
  vim.keymap.set("n", "s<leader>", dap.step_over, { silent = true })
  vim.keymap.set("n", "sds", dap.continue, { silent = true })
  -- vim.t.dap_session = dap.session()
  -- dap.repl.toggle({}, "80vsplit")
  dap_sessions[vim.fn.getcwd()] = dap.session()
  vim.t.current_dap_repl_dir = vim.fn.getcwd()
  dap.repl.toggle({}, "80vsplit")
end

dap.listeners.after["event_terminated"]["me"] = function()
  vim.keymap.set("n", "s<leader>", "<nop>", { silent = true })
  vim.keymap.set("n", "sds", "<nop>", { silent = true })
  dap_sessions[vim.fn.getcwd()] = nil
end

local logger = Utils.new_logger("dap-session-keymaps")

vim.keymap.set("n", "sd", "<nop>")

-- vim.keymap.set("n", "sdk", require("dap.ui.widgets").hover, { silent = true })

vim.keymap.set("n", "sdk", function()
  require("dapui").eval(vim.fn.expand("<cexpr>"), { enter = true })
end)

vim.keymap.set("n", "sde", function()
  require("dapui").float_element("watches", { enter = true })
end, { silent = true })

-- vim.keymap.set("v", "sde", function()
--   require("dapui").float_element("watches", { enter = true })
-- end, { silent = true })

-- vim.keymap.set("n", "<leader>dk", require("dap.ui.widgets").hover, { silent = true })
-- vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { silent = true })

vim.keymap.set("n", "sdb", dap.toggle_breakpoint, { silent = true })

vim.keymap.set("n", "sdc", function()
  vim.ui.input({
    prompt = "Breakpoint Condition > ",
    default = "",
  }, function(input)
    dap.set_breakpoint(input)
  end)
end, { silent = true })

vim.keymap.set("n", "sdl", function()
  vim.ui.input({
    prompt = "Logpoint Message > ",
    default = "",
  }, function(input)
    dap.set_breakpoint(nil, nil, input)
  end)
end)

vim.keymap.set("n", "sdr", function()
  local curr_dir = vim.fn.getcwd()
  local dsession = dap_sessions[curr_dir]
  print("pre toggle", curr_dir)
  if dsession ~= nil then
    if vim.t.current_dap_repl_dir ~= nil and vim.t.current_dap_repl_dir ~= curr_dir then
      dap.repl.close()
    end
    dap.set_session(dsession)
    dap.repl.toggle({}, "80vsplit")
    vim.t.current_dap_repl_dir = curr_dir
    print("post toggle")
  end
end)

vim.keymap.set("n", "sdR", function()
  local session = dap_sessions[vim.fn.getcwd()]
  if session ~= nil then
    dap.set_session(session)
    dap.terminate()
    dap.run_last()
    return
  end

  vim.notify("No previous session found", vim.log.levels.WARN)
end)

vim.api.nvim_create_user_command("DapKillSession", function()
  local session = dap_sessions[vim.fn.getcwd()]
  if session ~= nil then
    dap.set_session(session)
    dap.terminate()
  end
end, { nargs = 0 })
