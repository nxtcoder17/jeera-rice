local fzf = require("fzf-lua")

---@param dir string
local function choose_tab_dir(dir)
  dir = dir or vim.fn.getcwd()

  local cmd = string.format(
    "fd -H --exclude .git --threads 1 -t d -c never . %s | tail -n +2",
    vim.g.nxt_fns.relative_from_project_root(dir)
  )
  print("dir", dir, "cmd", cmd)

  local fzf_opts = {}
  if dir ~= vim.g.nxt.project_root_dir then
    fzf_opts = {
      ["--header"] = string.format("'%s'", "📂 " .. dir:sub(#vim.g.nxt.project_root_dir + 2)),
    }
  end

  fzf.fzf_exec(cmd, {
    prompt = "Choose Tab Directory ❯ ",
    fzf_opts = fzf_opts,
    actions = {
      ["default"] = function(selected, _opts)
        vim.t.tab_dir = selected[1]
        vim.cmd(string.format("silent! windo tcd %s", selected[1]))
      end,
    },
  })
end

return choose_tab_dir
