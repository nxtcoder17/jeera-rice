---@param dir? string
---@param query? string
local function find_files(dir, query)
	local fzf = require("fzf-lua")

	dir = dir or vim.loop.cwd()
	query = query or ""

	fzf.files({
		ignore_current_file = true,
		cwd = dir,
		query = query,
		cwd_prompt = dir ~= vim.g.project_root_dir,
		actions = {
			["ctrl-f"] = function(_, opts)
				local q = fzf.get_last_query()
				print("last query", q)
				if dir ~= vim.g.project_root_dir then
					return find_files(vim.g.project_root_dir, q)
				end
				return find_files(nil, q)
			end,
		},
	})
end

return find_files
