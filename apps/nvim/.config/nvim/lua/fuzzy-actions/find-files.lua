---@param dir string
---@param query string
local function find_files(dir, query)
  local fzf = require("fzf-lua")
  local actions = require("fzf-lua.actions")

  dir = dir or vim.loop.cwd()
  query = query or ""

  local fzf_opts = {}
  if dir ~= vim.g.nxt.project_root_dir then
    fzf_opts = vim.tbl_extend(
      "force",
      fzf_opts,
      { ["--header"] = string.format("%s", "📂 " .. dir:sub(#vim.g.nxt.project_root_dir + 2)) }
    )
  end

  -- fzf.fzf_exec("rg --threads 3 --files --iglob !.git --hidden --sort path", {
  local cmd = "rg --threads 3 --files --iglob !.git --hidden --sort path"
  -- local cmd = "fd --hidden --color=never --type f --follow --exclude .git"

  -- local filepath = vim.fn.expand("%")
  -- if filepath ~= "" then
  --   vim.print(string.format("using proximity-sort over %s", filepath))
  --   cmd = string.format("%s | proximity-sort %s", cmd, filepath)
  -- end

  fzf.fzf_exec(cmd, {
    query = query,
    prompt = string.format("Files ❯ "),
    fzf_opts = fzf_opts,
    -- fd_opts = "--color=never --type f --hidden --follow --exclude .git",
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
      ["ctrl-f"] = function(_, opts)
        local q = fzf.get_last_query(opts)
        if dir ~= vim.g.nxt.project_root_dir then
          return find_files(vim.g.nxt.project_root_dir, q)
        end
        return find_files("", q)
      end,
    },
  })
end

-- ---@param dir string
-- ---@param query string
-- local function find_files(dir, query)
--   dir = dir or vim.loop.cwd()
--   query = query or ""
--
--   local fzf_opts = {}
--   if dir ~= vim.g.nxt.project_root_dir then
--     fzf_opts = vim.tbl_extend("force", fzf_opts, {
--       -- ["--header"] = string.format("'%s'", "📂 " .. dir:sub(#vim.g.nxt.project_root_dir + 2)),
--       ["--query"] = (query and query or ""),
--     })
--   end
--
--   fzf.files({
--     ignore_current_file = true,
--     cwd = dir,
--     fzf_opts = fzf_opts,
--     -- fzf_opts = { ["--header"] = string.format("'%s'", "📂 " .. dir:sub(#vim.g.nxt.project_root_dir + 2)) },
--     actions = {
--       ["ctrl-f"] = function(_, opts)
--         local q = fzf.get_last_query(opts)
--         if dir ~= vim.g.nxt.project_root_dir then
--           return find_files(vim.g.nxt.project_root_dir, q)
--         end
--         return find_files(nil, q)
--       end,
--     },
--   })
-- end

return find_files
