local lang_comments = {
	gotmpl = "{{- /* %s */}}",
	terraform = "# %s",
	proto = "// %s",
	kdl = "// %s",
	gotexttmpl = "{{- /* %s */}}",
	gohtmltmpl = "{{- /* %s */}}",
}

require("mini.comment").setup({
	options = {
		custom_commentstring = function()
			-- return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
			local v = lang_comments[vim.bo.filetype]
			if v ~= nil then
				return v
			end
			return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
		end,
	},
	mappings = {
		comment = "s;",
		comment_visual = "s;",
		comment_line = "s;",
	},
})

local hipatterns = require("mini.hipatterns")
local function build_highlight_pattern(keyword)
	return "%f[%w]()" .. keyword .. "()%f[%s]"
end

hipatterns.setup({
	highlighters = {
		fixme = { pattern = build_highlight_pattern("FIXME:"), group = "MiniHipatternsFixme" }, -- FIXME: example
		hack = { pattern = build_highlight_pattern("HACK:"), group = "MiniHipatternsHack" }, -- HACK: example
		todo = { pattern = build_highlight_pattern("TODO:"), group = "MiniHipatternsTodo" }, -- TODO: example
		info = { pattern = build_highlight_pattern("INFO:"), group = "MiniHipatternsInfo" }, -- INFO: example
		error = { pattern = build_highlight_pattern("ERROR:"), group = "MiniHipatternsFixme" }, -- ERROR: example

		-- Highlight hex color strings (`#rrggbb`) using that color
		hex_color = hipatterns.gen_highlighter.hex_color(),
	},
})

-- INFO: hello world
-- INFO:hello world

if vim.g.nxt_fns.is_light_theme() then
	vim.cmd([[ hi! MiniHipatternsTodo guifg=#336699 guibg=#f5f5f5 gui=bold ]])
	vim.cmd([[ hi! MiniHipatternsHack guifg=#996633 guibg=#f5f5f5 gui=bold ]])
	vim.cmd([[ hi! MiniHipatternsNote guifg=#009999 guibg=#f5f5f5 gui=bold ]])
	vim.cmd([[ hi! MiniHipatternsInfo guifg=#0066cc guibg=#f5f5f5 gui=bold ]])

	vim.cmd([[ hi! MiniStatuslineDevinfo guifg=#707059 guibg=#dadbad gui=italic ]])
	vim.cmd([[ hi! MiniStatuslineFileinfo guifg=#707059 guibg=#dadbad gui=italic ]])
else
	vim.cmd([[ hi! MiniHipatternsTodo guifg=#759cbd guibg=#1f272e gui=bold ]])
	vim.cmd([[ hi! MiniHipatternsHack guifg=#dea27c guibg=#1f272e gui=bold ]])
	vim.cmd([[ hi! MiniHipatternsNote guifg=#4799a1 guibg=#1f272e gui=bold ]])
	vim.cmd([[ hi! MiniHipatternsInfo guifg=#033580 guibg=#8dcf5f gui=bold ]])
	vim.cmd([[ hi! MiniHipatternsFixme guifg=#000000 guibg=#d65e84 gui=bold ]])
end

-- require("mini.indentscope").setup({
--   draw = {
--     delay = 2,
--     animation = require("mini.indentscope").gen_animation.none(),
--   },
-- })
--
-- local miniGrp = vim.api.nvim_create_augroup("MiniGrp", {})
--
-- vim.api.nvim_create_autocmd("InsertEnter", {
--   group = miniGrp,
--   pattern = "*",
--   callback = function()
--     _G.MiniIndentscope.undraw()
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("InsertLeave", {
--   group = miniGrp,
--   pattern = "*",
--   callback = function()
--     _G.MiniIndentscope.draw()
--   end,
-- })

require("mini.pairs").setup({})

require("mini.surround").setup({
	mappings = {
		add = "ys",
		delete = "ds",
		replace = "cs",
		find = "", -- Find surrounding (to the right)
		find_left = "", -- Find surrounding (to the left)
		highlight = "", -- Highlight surrounding
		update_n_lines = "", -- Update `n_lines`
	},
})

require("mini.align").setup({})

local MiniStatusline = require("mini.statusline")

local check_macro_recording = function()
	if vim.fn.reg_recording() ~= "" then
		return "Recording @" .. vim.fn.reg_recording()
	else
		return ""
	end
end

function active_status_line()
  -- stylua: ignore start
  local mode, mode_hl     = MiniStatusline.section_mode({ trunc_width = 120 })
  local git               = MiniStatusline.section_git({ trunc_width = 75 })
  local diagnostics       = MiniStatusline.section_diagnostics({ trunc_width = 75 })
  local filename          = MiniStatusline.section_filename({ trunc_width = 140 })
  local fileinfo          = MiniStatusline.section_fileinfo({ trunc_width = 120 })
  local location          = MiniStatusline.section_location({ trunc_width = 120 })

  local from_project_root = vim.fn.getcwd():sub(#vim.g.nxt.project_root_dir + 2)
  if from_project_root ~= "" then
    from_project_root = "📂 " .. from_project_root
  end

  -- Usage of `MiniStatusline.combine_groups()` ensures highlighting and
  -- correct padding with spaces between groups (accounts for 'missing'
  -- sections, etc.)
  return MiniStatusline.combine_groups({
    { hl = mode_hl,                 strings = { mode } },
    { hl = 'MiniStatuslineDevinfo', strings = { git, diagnostics } },
    '%<', -- Mark general truncate point
    { hl = 'MiniStatuslineFilename', strings = { filename } },
    '%=', -- End left alignment
    { hl = "MiniStatuslineFilename", strings = { check_macro_recording() } },
    { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
    { hl = 'MiniStatuslineFileinfo', strings = { from_project_root } },
    { hl = mode_hl,                  strings = { location } },
  })
	-- stylua: ignore end
end

MiniStatusline.setup({
	set_vim_settings = false,
	content = {
		active = active_status_line,
	},
})
