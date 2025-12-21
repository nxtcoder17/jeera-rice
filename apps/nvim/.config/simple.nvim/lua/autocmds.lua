local autocmds = vim.api.nvim_create_augroup("my.autocmds", { clear = true })

-- local function augroup(name)
-- 	return vim.api.nvim_create_augroup("my-nvim-" .. name, { clear = true })
-- end

vim.api.nvim_create_autocmd("TermOpen", {
  group = autocmds,
  callback = function()
    vim.cmd("set ft=terminal")
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = autocmds,
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", priority = 250, timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd("BufRead", {
  group = autocmds,
  pattern = "*",
  callback = function()
    vim.cmd(
      [[if &ft !~# 'commit\|rebase\|query\|Terminal\|toggleterm\|terminal\|TelescopePrompt\|TelescopeResult' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif"]]
    )
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = autocmds,
  pattern = { os.getenv("HOME") .. "/.Xresources" },
  callback = function()
    os.execute(string.format("xrdb -merge %s", os.getenv("HOME") .. "/.Xresources"))
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = autocmds,
  pattern = { "env", ".env" },
  callback = function()
    -- vim.diagnostic.disable(vim.fn.expand("<abuf>"))
    vim.diagnostic.enable(false)
  end,
})

local function file_exists(name)
  local f = io.open(name, "r")
  return f ~= nil and io.close(f)
end

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = autocmds,
  -- pattern = "*",
  callback = function()
    coroutine.wrap(function()
      local co = coroutine.running()
      if file_exists(string.format("%s/tags", vim.g.project_root_dir)) then
        require("plenary.job")
          :new({
            command = "bash",
            args = {
              "-c",
              "fd -t file --ignore-vcs --exclude tags -c never > /tmp/list.txt && ctags -L /tmp/list.txt",
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
      end
      coroutine.yield()
    end)()
  end,
})

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
