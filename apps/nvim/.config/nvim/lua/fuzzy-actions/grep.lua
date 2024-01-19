local fzf = require("fzf-lua")
local actions = require("fzf-lua.actions")

---@param dir string
---@param query string
local function grep_with_fzf(dir, query)
  -- dir = dir or vim.loop.cwd()
  -- query = query or ""
  --
  -- local fzf_opts = {}
  -- if dir ~= vim.g.nxt.project_root_dir then
  --   fzf_opts = vim.tbl_extend(
  --     "force",
  --     fzf_opts,
  --     { ["--header"] = string.format("'%s'", "📂 " .. dir:sub(#vim.g.nxt.project_root_dir + 2)) }
  --   )
  -- end

  vim.cmd("FzfLua grep_cword")
end

return grep_with_fzf
