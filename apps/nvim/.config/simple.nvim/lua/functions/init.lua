local M = {}

M.join_tables = function(...)
	-- check if we have a table iterate over it, and insert it into a results table otherwise insert into a table
	local results = {}
	for _, t in ipairs({ ... }) do
		if type(t) == "table" then
			for k, v in pairs(t) do
				results[k] = v
			end
		else
			table.insert(results, t)
		end
	end

	return results
end

return M.join_tables(M, Require("functions.strings"), Require("functions.encoding"), Require("functions.buffers"))
