-- vim.o.background = "dark"
-- Require(string.format("plugins.colorschemes.kanagawa.%s", vim.o.background))

-- local system_theme = os.getenv("SYSTEM_THEME")
-- if system_theme ~= vim.o.background then
-- 	vim.o.background = system_theme
-- 	-- print("system_theme", system_theme, "vim.o.background", vim.o.background)
-- 	return Require(string.format("plugins.colorschemes.kanagawa.%s", system_theme))
-- 	-- local colors = Require(string.format("plugins.colorschemes.kanagawa.%s", system_theme))
-- 	-- vim.schedule(function()
-- 	-- 	Require("kanagawa").compile()
-- 	-- end)
-- 	-- return colors
-- end
--
-- return Require(string.format("plugins.colorschemes.kanagawa.%s", system_theme))

local M = {}

--- @class HLGroupParams
--- @field fg string|nil The foreground color of the highlight group. (Optional)
--- @field bg string|nil The background color of the highlight group. (Optional)
--- @field style string|nil The text style of the highlight group. (Optional). See |:help attr-list| for more information.
--- @field sp string|nil The special color for the highlight group. (Optional)
--- @field link string|nil The name of another highlight group to link to. (Optional) See |:help highlight-links| for more information.

--- Adds a highlight group with the specified parameters.
--- @param group string The name of the highlight group.
--- @param params HLGroupParams A table containing the highlight parameters. The table may have the following keys:
-- Example:
-- hl("MyHighlightGroup", { fg = "#ff0000", bg = "#000000", style = "bold" })
function M.hl(group, params)
	if params.link ~= nil then
		vim.cmd.highlight("link", group, params.link)
		return
	end

	local hlargs = ""

	if params.bg ~= nil then
		hlargs = hlargs .. " guibg=" .. params.bg
	end

	if params.fg ~= nil then
		hlargs = hlargs .. " guifg=" .. params.fg
	end

	if params.style ~= nil then
		hlargs = hlargs .. " gui=" .. params.style

		if params.sp ~= nil then
			hlargs = hlargs .. " guisp=" .. params.sp
		end
	end

	-- print("len", #hlargs, hlargs)
	if #hlargs > 0 then
		vim.cmd.highlight(group, hlargs)
	end
end

M.None = "None"

return M
