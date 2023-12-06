local function grep_with_fzf()
  vim.cmd("FzfLua grep_cword")
end

return grep_with_fzf
