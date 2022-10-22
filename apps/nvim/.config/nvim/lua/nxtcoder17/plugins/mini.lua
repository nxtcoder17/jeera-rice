require("mini.comment").setup({
  mappings = {
    comment = "s;",
    comment_line = "s;",
  },
  hooks = {
    pre = function()
      require('ts_context_commentstring.internal').update_commentstring()
    end,
    post = function() end,
  },
})

require("mini.indentscope").setup({
  draw = {
    delay = 2,
    animation = require("mini.indentscope").gen_animation("none"),
  },
})

local miniGrp = vim.api.nvim_create_augroup("MiniGrp",{})

vim.api.nvim_create_autocmd("InsertEnter", {
  group = miniGrp,
  pattern = "*",
  callback = function()
    _G.MiniIndentscope.undraw()
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = miniGrp,
  pattern = "*",
  callback = function()
    _G.MiniIndentscope.draw()
  end,
})

require("mini.pairs").setup({})

require("mini.surround").setup({
  mappings  = {
    add     = "ssa",
    delete  = "ssd",
    replace = "cs",

    find           = '', -- Find surrounding (to the right)
    find_left      = '', -- Find surrounding (to the left)
    highlight      = '', -- Highlight surrounding
    update_n_lines = '', -- Update `n_lines`
  },
})

require("mini.align").setup({})

-- require("mini.statusline").setup({
--   set_vim_settings = false,
-- })

-- require("mini.sessions").setup({
--   autoread =true,
--   autowrite = true,
--   directory = ("%s/%s").format( vim.fn.stdpath("data"), "sessions"),
--   file = ".nxtcoder17/session.vim"
-- })
