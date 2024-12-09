local logger = NewLogger("fzf#my-actions#grep.lua", "info")

---@param dir string
---@param query string
local function grep_with_fzf(dir, query, call_depth)
	dir = dir or vim.loop.cwd()
	query = query or ""
	call_depth = call_depth or 0

	logger.debug("called", "dir", dir, "query", query, "call-depth", call_depth)
	--
	local fzf_opts = {}
	if dir ~= vim.g.project_root_dir then
		fzf_opts = vim.tbl_extend(
			"force",
			fzf_opts,
			{ ["--header"] = string.format("'%s'", "📂 " .. dir:sub(#vim.g.project_root_dir + 2)) }
		)
	end

	local fzf = Require("fzf-lua")

	logger.debug("HERE...", "mode", vim.fn.mode(), "call-depth", call_depth)
	if vim.fn.mode() == "n" or vim.fn.mode() == "t" then
		-- vim.cmd("FzfLua grep_cword")
		fzf.grep_cword({
			cwd = dir,
			query = query,
			actions = {
				["ctrl-f"] = function(_, opts)
					local q = fzf.get_last_query()
					logger.debug("got last query:", q)
					if dir ~= vim.g.project_root_dir then
						return grep_with_fzf(vim.g.project_root_dir, q, 1)
					end
					return grep_with_fzf("", q)
				end,
			},
		})
	elseif vim.fn.mode() == "v" then
		-- vim.cmd("FzfLua grep_visual")
		fzf.grep_visual({
			cwd = dir,
			query = query,
		})
	end
end

return grep_with_fzf
