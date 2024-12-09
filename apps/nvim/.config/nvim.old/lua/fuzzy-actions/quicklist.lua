local function quicklist()
  local utils = require("functions.utils")

  local actions = {
    {
      label = "[buf] format",
      action = function()
        vim.lsp.buf.format({ async = false })
        vim.cmd("write")
      end,
    },
    {
      label = "[util] base64 encode",
      action = utils.base64_encode,
    },
    {
      label = "[util] base64 decode",
      action = utils.base64_decode,
    },
  }

  local choices_keys = {}
  local choices_map = {}
  for k, v in pairs(actions) do
    table.insert(choices_keys, v.label)
    choices_map[v.label] = v.action
  end

  require("fzf-lua").fzf_exec(choices_keys, {
    prompt = "Action ❯ ",
    actions = {
      -- Use fzf-lua builtin actions or your own handler
      ["default"] = function(selected, opts)
        local fn = choices_map[selected[1]]
        if not fn then
          return
        end
        fn()
      end,
    },
  })
end

-- vim.keymap.set({ "n", "v" }, "f;", quicklist, { desc = "Quicklist" })

return quicklist
