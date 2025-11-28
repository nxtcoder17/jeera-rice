local autocmds = vim.api.nvim_create_augroup("my.autocmds", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = autocmds,
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", priority = 250, timeout = 200 })
  end,
})

-- jump back to where you left the buffer
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  group = autocmds,
  pattern = "*",
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.opt.tags:append("./vendor/tags")
vim.opt.tags:append("./node_modules/tags")

-- ctags
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = autocmds,
  -- pattern = "*",
  callback = function()
    coroutine.wrap(function()
      local co = coroutine.running()
      require("plenary.job")
        :new({
          command = "bash",
          args = {
            "-c",
            "fd -t file --ignore-vcs --exclude tags --exclude 'lazy-lock.json' -c never > /tmp/list.txt && ctags --sort=yes --tag-relative=always -L /tmp/list.txt",
            -- "ctags -R .",
          },
          cwd = vim.g.project_root_dir,
          -- on_exit = function(j, return_val)
          --   -- vim.print(j:result())
          --   -- print(return_val)
          --   for _, v in ipairs(j:result()) do
          --     print(v)
          --   end
          -- end,
        })
        :sync()
      coroutine.yield()
    end)()
  end,
})
