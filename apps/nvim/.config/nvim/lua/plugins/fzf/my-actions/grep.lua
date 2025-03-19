local logger = NewLogger("fzf#my-actions#grep.lua", "info")

---@param dir string
---@param query string
local function grep_with_fzf(dir, query, call_depth)
	dir = dir or vim.fn.getcwd()
	query = query or ""
	call_depth = call_depth or 0

	-- logger.debug("called", "dir", dir, "query", query, "call-depth", call_depth)

	local current_file = vim.fn.expand("%:p")
	local current_line = vim.fn.line(".")
	local current_col = vim.fn.col(".")

	-- local rg_opts = {
	-- 	["--ignore-file"] = string.format("%s:%d:%d", current_file, current_line, current_col),
	-- }

	-- print("called", "dir", dir, "query", query, "call-depth", call_depth)

	local fzf = Require("fzf-lua")

	if vim.fn.mode() == "n" or vim.fn.mode() == "t" then
		-- vim.cmd("FzfLua grep_cword")
		fzf.grep_cword({
			cwd = dir,
			query = query,
			-- rg_opts = rg_opts,
			actions = {
				["ctrl-f"] = function(_, opts)
					local q = fzf.get_last_query()
					print("last query", q)
					logger.debug("got last query:", q)
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
			-- rg_opts = rg_opts,
		})
	end
end

return grep_with_fzf
