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

  if vim.fn.mode() == "n" then
    vim.cmd("FzfLua grep_cword")
  elseif vim.fn.mode() == "v" then
    vim.cmd("FzfLua grep_visual")
  end
end

return grep_with_fzf
