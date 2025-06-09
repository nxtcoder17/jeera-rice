local MiniStatusline = Require("mini.statusline")

local check_macro_recording = function()
	if vim.fn.reg_recording() ~= "" then
		return "Recording @" .. vim.fn.reg_recording()
	else
		return ""
	end
end

local function lsp_progress()
	vim.cmd.redrawstatus()
	return vim.lsp.status()
end

local function active_status_line()
	local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
	local git = MiniStatusline.section_git({ trunc_width = 75 })
	local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
	local filename = MiniStatusline.section_filename({ trunc_width = 140 })
	local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
	local location = MiniStatusline.section_location({ trunc_width = 120 })

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
		{ hl = "MiniStatuslineFileinfo", strings = { lsp_progress() } },
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
