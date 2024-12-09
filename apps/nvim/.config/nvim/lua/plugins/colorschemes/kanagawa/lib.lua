local M = {}

local c = Require("kanagawa.lib.color")

function M.lighten(hex, amount)
	amount = amount > 1 and amount / 100
	return c(hex):blend("#FFFFFF", amount):to_hex()
end

function M.darken(hex, amount)
	amount = amount > 1 and amount / 100
	return c(hex):blend("#000000", amount):to_hex()
end

return M
