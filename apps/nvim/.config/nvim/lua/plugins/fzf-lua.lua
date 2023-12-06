local actions = require("fzf-lua.actions")

local fzf = require("fzf-lua")
fzf.setup({
  "telescope",
  fzf_opts = {
    ["--layout"] = "reverse",
    ["--pointer"] = "👉",
  },
  file_icon_padding = " ",
  global_resume = true,
  global_resume_query = true,
  global_resume_prompt = "resume: ",

  fzf_colors = {
    -- ["fg"] = { "fg", "CursorLine" },
    ["fg"] = { "fg", "@keyword.operator" },
    ["bg"] = { "bg", "Normal" },
    -- ["hl"] = { "fg", "Comment" },
    ["hl"] = { "fg", "Statement" },
    ["fg+"] = { "fg", "Normal" },
    ["bg+"] = { "bg", "CursorLine" },
    ["hl+"] = { "fg", "Statement" },
    ["info"] = { "fg", "PreProc" },
    ["prompt"] = { "fg", "Conditional" },
    ["pointer"] = { "fg", "Exception" },
    ["marker"] = { "fg", "Keyword" },
    ["spinner"] = { "fg", "Label" },
    ["header"] = { "fg", "Comment" },
    ["gutter"] = { "bg", "Normal" },
  },

  winopts = {
    preview = {
      horizontal = "right:40%",
    },
    height = 0.3, -- window height
    width = 1,  -- window width
    row = 1,    -- window row position (0=top, 1=bottom)
    col = 0.50, -- window col position (0=left, 1=right)
    border = {
      "╭",
      "─",
      "╮",
      "│",
      "╯",
      "─",
      "╰",
      "│",
    },
  },

  files = {
    prompt = "Files ❯ ",
    cwd_prompt = false,
    fzf_opts = {
      ["--no-separator"] = "",
      ["--no-scrollbar"] = "",
    },
  },

  actions = {
    buffers = {
      -- providers that inherit these actions:
      --   buffers, tabs, lines, blines
      ["default"] = actions.buf_edit,
      ["ctrl-s"] = actions.buf_split,
      ["ctrl-v"] = actions.buf_vsplit,
      ["ctrl-t"] = actions.buf_tabedit,
      ["ctrl-d"] = { actions.buf_del, actions.resume },
    },
  },
})

vim.api.nvim_create_user_command("ReloadFzfLua", function()
  R("plugins.fzf-lua")
end, { nargs = 0 })
