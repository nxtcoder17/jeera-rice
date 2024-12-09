local Job = require("plenary.job")

local M = {}

--[[
NOTE: if you use `coroutine.wrap`, then you have 2 choices to dictate how coroutine woud be executed
  - if you do `coroutine.wrap(function() end):start()`, then it would be executed asynchronously in the background, away from neovim main event loop
  - if you do `coroutine.wrap(function() end):sync()`, then it would be executed synchronously in the main event loop, and you would have to follow up this sync() call with coroutine.yield(). But this way BLOCKS neovim UI
--]]

M.list_installed = function()
  coroutine.wrap(function()
    local co = coroutine.running()
    Job:new({
      command = "bash",
      args = { "-c", "bin/luarocks list --porcelain" },
      cwd = string.format("%s/.local/share/nvim/lazy/nvim_rocks", os.getenv("HOME")),
      on_exit = function(j, return_val)
        -- vim.print(j:result())
        -- print(return_val)
        for _, v in ipairs(j:result()) do
          print(v)
        end
      end,
    }):sync()
    coroutine.yield()
  end)()

  -- os.execute([[ cd ~/.local/share/nvim/lazy/nvim_rocks && bin/luarocks install base64 ]])
end

M.install = function(rock_name)
  coroutine.wrap(function()
    local co = coroutine.running()
    Job:new({
      command = "bash",
      args = {
        "-c",
        string.format(
          "bin/luarocks show '%s' --porcelain > /dev/null 2>&1 || bin/luarocks install '%s'",
          rock_name,
          rock_name
        ),
      },
      cwd = string.format("%s/.local/share/nvim/lazy/nvim_rocks", os.getenv("HOME")),
      on_exit = function(j, return_val)
        for _, v in ipairs(j:result()) do
          print(v)
        end
      end,
    }):start()
  end)()
end

M.uninstall = function(rock_name)
  coroutine.wrap(function()
    local co = coroutine.running()
    Job:new({
      command = "bash",
      args = {
        "-c",
        string.format(
          "bin/luarocks show '%s' --porcelain > /dev/null 2>&1 && bin/luarocks remove '%s'",
          rock_name,
          rock_name
        ),
      },
      cwd = string.format("%s/.local/share/nvim/lazy/nvim_rocks", os.getenv("HOME")),
      on_exit = function(j, return_val)
        for _, v in ipairs(j:result()) do
          print(v)
        end
      end,
    }):start()
  end)()
end

return M
