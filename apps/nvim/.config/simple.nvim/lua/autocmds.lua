local autocmds = vim.api.nvim_create_augroup("my.autocmds", { clear = true })

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
