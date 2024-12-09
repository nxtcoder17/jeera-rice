vim.g.coq_settings = {
  auto_start = true,
  display = {
    ghost_text = { enabled = false },
    preview = {
      enabled = false,
      border = "shadow",
    },
  },
  limits = {
    completion_auto_timeout = 0.5,
  },
  match = {
    max_results = 30,
  },
  keymap = {
    pre_select = true,
  },
  -- display = {
  --   icons = {
  --     mode = "short",
  --   },
  --   pum = {
  --     y_max_len = 5,
  --     --      y_ratio=,
  --     x_max_len = 60,
  --   },
  --   preview = {
  --     positions = {
  --       ["south"] = 1,
  --       ["east"] = 2,
  --       ["north"] = 3,
  --       ["west"] = 4,
  --     },
  --   },
  -- },
}

vim.cmd([[COQnow --shut-up]])

-- vim.cmd([[
--  ino <silent><expr> <CR> pumvisible() ? (complete_info().selected == -1 ? "\<C-n><C-y>" : "\<C-y>") : "\<CR>"
-- ]])
vim.defer_fn(function()
  vim.o.completeopt = "menu,preview,noinsert,menuone"
end, 1000)

require("coq_3p")({
  { src = "nvimlua", short_name = "nLUA" },
  { src = "vimtex",  short_name = "vTEX" },
  { src = "demo" },
  { src = "copilot", short_name = "COP", accept_key = "<Tab>" },
  {
    src = "repl",
    sh = "zsh",
    shell = { p = "python", n = "node" },
    max_lines = 99,
    deadline = 500,
    unsafe = { "rm", "poweroff", "mv", "trash", "kill" },
  },
  { src = "bc", short_name = "MATH", precision = 6 },
})
