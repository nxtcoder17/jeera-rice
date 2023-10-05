local dap = require("dap")
local Utils = require("functions.utils")

-- current dap session id, will be stored in `vim.t.dap_session`
dap.listeners.after["event_initialized"]["me"] = function()
  vim.keymap.set("n", "s<leader>", dap.step_over, { silent = true })
  vim.keymap.set("n", "sds", dap.continue, { silent = true })
  vim.t.dap_session = dap.session().id
end

dap.listeners.after["event_terminated"]["me"] = function()
  vim.keymap.set("n", "s<leader>", "<nop>", { silent = true })
  vim.keymap.set("n", "sds", "<nop>", { silent = true })
  vim.t.dap_session = nil
end

local logger = Utils.new_logger("dap-session-keymaps")

vim.keymap.set("n", "sd", "<nop>")

-- vim.keymap.set("n", "sdk", require("dap.ui.widgets").hover, { silent = true })

vim.keymap.set("n", "sdk", function()
  require("dapui").eval(vim.fn.expand("<cexpr>"), { enter = true })
end)

vim.keymap.set("v", "sdk", function()
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

-- vim.keymap.set("n", "sdd", function()
--   vim.cmd("80vsplit")
--   vim.cmd("wincmd l")
--   vim.cmd("e /tmp/debug.stdout")
--   vim.cmd("wincmd G")
-- end)

-- dap repl split

function repl_single_dap_session()
  -- (without dapui)
  vim.keymap.set("n", "sdr", function()
    dap.repl.toggle({}, "80vsplit")
    vim.cmd("wincmd l")
  end)

  -- (with dapui)
  -- vim.keymap.set("n", "sdr", function()
  --   require("dapui").toggle({ reset = true })
  -- end)

  vim.keymap.set("n", "sdR", function()
    dap.run_last()
  end)
end

local function findSession(id)
  if id == nil then
    return dap.session()
  end
  for _, session in pairs(dap.sessions()) do
    if session.id == id then
      return session
    end
  end
end

local function disconnect(session)
  logger.debug("killing dap session: ", session.id)
  -- dap.disconnect(session)
  dap.terminate(session)
  dap.close(session)
end

function repl_multiple_dap_sessions()
  local repl_state = { visible = false, dap_session = nil } -- { visiblity, dap_session_id }
  vim.keymap.set("n", "sdr", function()
    if vim.t.dap_session ~= repl_state.dap_session then
      if repl_state.dap_session ~= nil then
        logger.debug("closing repl from previous dap_session: ", repl_state.dap_session)
        dap.repl.close()
      end

      repl_state.dap_session = vim.t.dap_session
      dap.set_session(findSession(vim.t.dap_session))
      logger.debug("opening repl for current dap session: ", repl_state.dap_session)
      dap.repl.open({}, "80vsplit")
      vim.cmd("wincmd l")
      repl_state.visible = true
    else
      dap.repl.toggle({}, "80vsplit")
      if not repl_state.visible then
        vim.cmd("wincmd l")
        repl_state.visible = true
      else
        repl_state.visible = false
      end
    end
  end)

  vim.keymap.set("n", "sdR", function()
    dap.set_session(findSession(vim.t.dap_session))
    -- dap.run_last()
  end)

  vim.api.nvim_create_user_command("DapKillSession", function()
    local session = findSession(vim.t.dap_session)
    if session ~= nil then
      disconnect(session)
    end
  end, { nargs = 0 })
end

repl_multiple_dap_sessions()
