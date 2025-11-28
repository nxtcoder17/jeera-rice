Require("mini.pairs").setup({})

Require("mini.surround").setup({
  mappings = {
    add = "ys",
    delete = "ds",
    replace = "cs",
    find = "", -- Find surrounding (to the right)
    find_left = "", -- Find surrounding (to the left)
    highlight = "", -- Highlight surrounding
    update_n_lines = "", -- Update `n_lines`
  },
})

-- INFO: loading this colorscheme as part of init process directly
-- Require("plugins.mini.mini-base16")

Require("mini.align").setup({})

local notify = Require("mini.notify")
notify.setup()

vim.notify = notify.make_notify({
  ERROR = { duration = 2000 },
  WARN = { duration = 2000 },
  INFO = { duration = 2000 },
})

Require("mini.git").setup()
Require("mini.sessions").setup()

Require("plugins.mini.mini-comments")
Require("plugins.mini.mini-hipatterns")
Require("plugins.mini.mini-statusline")
