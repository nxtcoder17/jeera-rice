local dap = require("dap")
local api = vim.api

local function overrideKHover()
	local keymap_restore = {}

	dap.listeners.after["event_initialized"]["me"] = function()
		for _, buf in pairs(api.nvim_list_bufs()) do
			local keymaps = api.nvim_buf_get_keymap(buf, "n")
			for _, keymap in pairs(keymaps) do
				if keymap.lhs == "K" then
					table.insert(keymap_restore, keymap)
					api.nvim_buf_del_keymap(buf, "n", "K")
				end
				if keymap.lhs == "s]" then
					table.insert(keymap_restore, keymap)
					api.nvim_buf_del_keymap(buf, "n", "s]")
				end
				if keymap.lhs == "sx" then
					table.insert(keymap_restore, keymap)
					api.nvim_buf_del_keymap(buf, "n", "sx")
				end

				if keymap.lhs == "sc" then
					table.insert(keymap_restore, keymap)
					api.nvim_buf_del_keymap(buf, "n", "sx")
				end
			end
		end
		vim.keymap.set("n", "K", require("dap.ui.widgets").hover, { silent = true })
		vim.keymap.set("n", "s]", dap.step_over, { silent = true })
		vim.keymap.set("n", "sx", dap.toggle_breakpoint, { silent = true })
		vim.keymap.set("n", "sc", function()
			vim.ui.input({
				prompt = "Breakpoint Condition > ",
				default = "",
			}, function(input)
				dap.set_breakpoint(input)
			end)
		end, { silent = true })
	end

	dap.listeners.after["event_terminated"]["me"] = function()
		for _, keymap in pairs(keymap_restore) do
			vim.keymap.set(
				keymap.mode,
				keymap.lhs,
				keymap.rhs or "<nop>",
				{ silent = keymap.silent == 1, buffer = keymap.buffer }
			)
			-- api.nvim_buf_set_keymap(keymap.buffer, keymap.mode, keymap.lhs, keymap.rhs, {
			-- 	silent = keymap.silent == 1,
			-- })
		end
		keymap_restore = {}
	end
end

-- overrideKHover()
