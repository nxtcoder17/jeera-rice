local M = {}

local c = Require("plugins.colorschemes.lib.color")

function M.lighten(hex, amount)
	amount = amount > 1 and amount / 100
	return c(hex):blend("#FFFFFF", amount):to_hex()
end

function M.darken(hex, amount)
	amount = amount > 1 and amount / 100
	return c(hex):blend("#000000", amount):to_hex()
end

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
--   hl("MyHighlightGroup", { fg = "#ff0000", bg = "#000000", style = "bold" })
function M.hl(group, params)
	if params.link ~= nil then
		vim.cmd.highlight({ args = { "link", group, params.link }, bang = true })
		-- vim.cmd.highlight("link", group, params.link)
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
		vim.cmd.highlight({ args = { group, hlargs }, bang = true })
	end
end

M.None = "None"

M.Theme = function(palette)
	local theme = palette

	function theme:modify(fn)
		if fn ~= nil then
			fn(self)
		end

		return self
	end

	function theme:set_hl_groups(fn)
		self.theme_hl_groups_fn = fn
		return self
	end

	function theme:use_hl_groups()
		self.theme_hl_groups_fn(self)
	end

	-- function theme:palette()
	-- 	return theme
	-- end

	return setmetatable(theme, {
		__index = function(self, key)
			if key == "palette" then
				return self
			end
		end,
	})
end

return M
