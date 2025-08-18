local function quicklist()
	local fn = Require("functions")

	local actions = {
		{
			label = "[code] format",
			action = function()
				Require("conform").format({ lsp_format = "fallback" })
				-- vim.lsp.buf.format({ async = false })
				vim.cmd("write")
			end,
		},
		{
			label = "[mini.sessions] new session",
			action = function()
				vim.ui.input({ prompt = "session name: " }, function(input)
					Require("mini.sessions").write(input)
				end)
			end,
		},
		{
			label = "[mini.sessions] select session",
			action = function()
				Require("mini.sessions").select()
			end,
		},
		{
			label = "[mini.sessions] delete session",
			action = function()
				Require("mini.sessions").delete()
			end,
		},
		{
			label = "[mini.sessions] write session",
			action = function()
				local sessions = {}
				for k, _ in pairs(Require("mini.sessions").detected) do
					table.insert(sessions, k)
				end

				print("sessions", vim.inspect(sessions))
				vim.ui.select(sessions, {
					prompt = "Select Session",
					-- with format_item, every entry will be called via `format_item(item)`
					-- format_item = function(item)
					-- 	return "I'd like to choose " .. item
					-- end,
				}, function(choice)
					if not choice then
						return
					end
					Require("mini.sessions").write(choice)
				end)
			end,
		},
		{
			label = "[base64] encode",
			action = fn.base64_encode,
		},
		{
			label = "[base64] decode",
			action = fn.base64_decode,
		},
		{
			label = "Toggle Inlay Hints",
			action = function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			end,
		},
	}

	local choices_keys = {}
	local choices_map = {}
	for k, v in pairs(actions) do
		table.insert(choices_keys, v.label)
		choices_map[v.label] = v.action
	end

	Require("fzf-lua").fzf_exec(choices_keys, {
		prompt = "Action ❯ ",
		actions = {
			-- Use fzf-lua builtin actions or your own handler
			["default"] = function(selected, opts)
				local handler = choices_map[selected[1]]
				if not handler then
					return
				end
				handler()
			end,
		},
	})
end

return quicklist
