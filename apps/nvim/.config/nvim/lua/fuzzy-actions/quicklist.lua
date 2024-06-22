local utils = require("functions.utils")

local function quicklist()
  local choices = {
    ["[buf] format"] = function()
      vim.lsp.buf.format({ async = false })
      vim.cmd("write")
    end,
    ["[util] base64 encode"] = utils.base64_encode,
    ["[util] base64 decode"] = utils.base64_decode,
  }

  local choices_keys = {}
  for k, _ in pairs(choices) do
    table.insert(choices_keys, k)
  end

  require("fzf-lua").fzf_exec(choices_keys, {
    prompt = "Action ❯ ",
    actions = {
      -- Use fzf-lua builtin actions or your own handler
      ["default"] = function(selected, opts)
        print(selected[1])
        local fn = choices[selected[1]]
        local v = fn()
        print(v)
      end,
    },
  })
end

vim.keymap.set({ "n", "v" }, "f;", quicklist, { desc = "Quicklist" })

--[[
hello
aGVsbG8=
hello
--]]

return quicklist
