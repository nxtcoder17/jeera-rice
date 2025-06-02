---@param dir string
local function choose_tab_dir(dir)
	-- dir = dir or vim.fn.getcwd()
	dir = vim.g.project_root_dir

	local cmd = "fd -H --exclude .git -t d -c never"
	-- local cmd = "rg --files | xargs -I {} dirname {} | sort -u | grep -v '^.$'"

	local fzf_opts = {}
	if dir ~= vim.g.project_root_dir then
		fzf_opts = {
			["--header"] = string.format("%s", "📂 " .. dir:sub(#vim.g.project_root_dir + 2)),
		}
	end

	require("fzf-lua").fzf_exec(cmd, {
		prompt = "Choose Tab Directory ❯ ",
		fzf_opts = fzf_opts,
		cwd = dir,
		multiprocess = false,
		actions = {
			["default"] = function(selected, _opts)
				vim.t.tab_dir = selected[1]
				vim.cmd(string.format("silent! windo tcd %s", selected[1]))

				local ok, tabby_utils = pcall(require, "tabby.util")
				if ok then
					tabby_utils.set_tab_name(vim.api.nvim_get_current_tabpage(), selected[1])
				end
			end,
		},
	})
end

return choose_tab_dir
