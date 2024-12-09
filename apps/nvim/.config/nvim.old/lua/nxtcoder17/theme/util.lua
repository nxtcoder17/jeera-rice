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
		vim.cmd(string.format("highlight! link %s %s", group, params.link))
		-- vim.cmd.highlight({ "link", group, params.link, bang = true })
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

-- M.colors = require("nxtcoder17.colors")

M.None = "None"

-- [copied from tokyonight.nvim](https://github.com/folke/tokyonight.nvim/blob/ce91ba480070c95f40753e4663e32b4632ac6db3/lua/tokyonight/util.lua#L9C1-L13C4)
---@param c  string
local function rgb(c)
	c = string.lower(c)
	return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

-- [copied from tokyonight.nvim](https://github.com/folke/tokyonight.nvim/blob/ce91ba480070c95f40753e4663e32b4632ac6db3/lua/tokyonight/util.lua#L27C1-L42C1)
---@param foreground string foreground color
---@param background string background color
---@param alpha number|string number between 0 and 1. 0 results in bg, 1 results in fg
M.blend = function(foreground, alpha, background)
	alpha = type(alpha) == "string" and (tonumber(alpha, 16) / 0xff) or alpha
	local bg = rgb(background)
	local fg = rgb(foreground)

	local blendChannel = function(i)
		local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
		return math.floor(math.min(math.max(0, ret), 255) + 0.5)
	end

	return string.format("#%02x%02x%02x", blendChannel(1), blendChannel(2), blendChannel(3))
end

M.darken = function(hex, amount)
	return M.blend(hex, amount, "#000000")
end

M.lighten = function(hex, amount)
	return M.blend(hex, amount, "#ffffff")
end

return M
