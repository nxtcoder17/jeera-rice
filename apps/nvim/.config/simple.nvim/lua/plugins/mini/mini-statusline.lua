local MiniStatusline = Require("mini.statusline")

local check_macro_recording = function()
	if vim.fn.reg_recording() ~= "" then
		return "Recording @" .. vim.fn.reg_recording()
	else
		return ""
	end
end

-- vim.cmd([[ autocmd LspProgress * redrawstatus ]])

local lsp_message = ""

vim.api.nvim_create_autocmd("LspProgress", {
	callback = function(ev)
		-- vim.print("[LSP Progress]: ", ev)
		-- kind
		-- message
		-- title
		-- percentage

		local value = ev.data.params.value
		if value.kind == "begin" then
			lsp_message = "LSP Starting"
			-- vim.api.nvim_ui_send("\027]9;4;1;0\027\\")
		elseif value.kind == "end" then
			lsp_message = "LSP Ready"
			-- vim.api.nvim_ui_send("\027]9;4;0\027\\")
		elseif value.kind == "report" then
			lsp_message = string.format("LSP Progress (%d %%)", value.percentage)
			-- lsp_message = string.format("Lsp Loading (%d)", value.percentage)
			-- vim.api.nvim_ui_send(string.format("\027]9;4;1;%d\027\\", value.percentage or 0))
		end
		vim.cmd("redrawstatus")
	end,
})

local function active_status_line()
	local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
	local git = MiniStatusline.section_git({ trunc_width = 75 })
	local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
	local filename = MiniStatusline.section_filename({ trunc_width = 140 })
	local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
	local location = MiniStatusline.section_location({ trunc_width = 120 })

	-- local lsp_status = vim.lsp.status()
	-- if lsp_status ~= "" then
	-- 	last_lsp_message = lsp_status
	-- end

	local from_project_root = vim.fn.getcwd():sub(#vim.g.project_root_dir + 2)
	if from_project_root ~= "" then
		from_project_root = "📂 " .. from_project_root
	end

	-- Usage of `MiniStatusline.combine_groups()` ensures highlighting and
	-- correct padding with spaces between groups (accounts for 'missing'
	-- sections, etc.)
	return MiniStatusline.combine_groups({
		{ hl = mode_hl, strings = { mode } },
		{ hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
		"%<", -- Mark general truncate point
		{ hl = "MiniStatuslineFilename", strings = { filename } },
		"%=", -- End left alignment
		{ hl = "MiniStatuslineFilename", strings = { check_macro_recording() } },
		{ hl = "MiniStatuslineFileinfo", strings = { lsp_message, trunc_width = 50 } },
		{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
		{ hl = "MiniStatuslineFileinfo", strings = { from_project_root } },
		{ hl = mode_hl, strings = { location } },
	})
end

MiniStatusline.setup({
	set_vim_settings = false,
	content = {
		active = active_status_line,
	},
})

