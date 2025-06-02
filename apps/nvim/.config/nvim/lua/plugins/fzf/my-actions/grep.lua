---@param dir string
---@param query string
local function grep_with_fzf(dir, query, call_depth)
	dir = dir or vim.fn.getcwd()
	query = query or ""
	call_depth = call_depth or 0

	-- logger.debug("called", "dir", dir, "query", query, "call-depth", call_depth)

	-- print("called", "dir", dir, "query", query, "call-depth", call_depth)

	local fzf = Require("fzf-lua")

	if vim.fn.mode() == "n" or vim.fn.mode() == "t" then
		query = vim.fn.expand("<cword>")

		fzf.live_grep_native({
			cwd = dir,
			query = query,
			multiprocess = false,
			actions = {
				["ctrl-f"] = function(_, opts)
					local q = fzf.get_last_query()
					if dir ~= vim.g.project_root_dir then
						return grep_with_fzf(vim.g.project_root_dir, q, 1)
					end
					return grep_with_fzf(vim.fn.getcwd(), q)
				end,
			},
		})
	elseif vim.fn.mode() == "v" then
		-- vim.cmd("FzfLua grep_visual")
		fzf.grep_visual({
			cwd = dir,
			query = query,
			multiprocess = false,
			-- rg_opts = rg_opts,
		})
	end
end

return grep_with_fzf
