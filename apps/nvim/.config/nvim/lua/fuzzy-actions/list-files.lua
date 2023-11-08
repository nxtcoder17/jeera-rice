local fzf = require("fzf-lua")
local actions = require("fzf-lua.actions")

local M = {}

-- @param dir string
function M.with_fzf(dir)
  dir = dir or vim.loop.cwd()

  local fzf_opts = {}
  if dir ~= vim.g.nxt.project_root_dir then
    fzf_opts = {
      ["--header"] = string.format("'%s'", "📂 " .. dir:sub(#vim.g.nxt.project_root_dir + 2)),
    }
  end

  fzf.fzf_exec("rg --threads 3 --files --iglob !.git --hidden --sort path", {
    prompt = string.format("Files ❯ "),
    fzf_opts = fzf_opts,
    fn_transform = function(x)
      return fzf.make_entry.file(x, {
        file_icons = true,
        color_icons = true,
        strip_cwd_prefix = true,
      })
    end,
    cwd = dir,
    actions = {
      ["default"] = actions.file_edit,
      ["ctrl-s"] = actions.file_split,
      ["ctrl-v"] = actions.file_vsplit,
      ["ctrl-t"] = actions.file_tabedit,
      ["ctrl-q"] = actions.file_sel_to_qf,
      ["ctrl-f"] = function()
        if dir ~= vim.g.nxt.project_root_dir then
          return M.with_fzf(vim.g.nxt.project_root_dir)
        end
        return M.with_fzf()
      end,
    },
  })
end

return M
