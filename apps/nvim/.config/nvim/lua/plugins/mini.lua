require("mini.comment").setup({
  options = {
    custom_commentstring = function()
      return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
    end,
  },
  mappings = {
    comment = "s;",
    comment_line = "s;",
  },
})

local hipatterns = require("mini.hipatterns")
hipatterns.setup({
  highlighters = {
    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

    -- Highlight hex color strings (`#rrggbb`) using that color
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})
vim.cmd([[ hi! MiniHipatternsTodo guifg=#2e6b99 guibg=#0d1e2b gui=italic ]])

require("mini.indentscope").setup({
  draw = {
    delay = 2,
    animation = require("mini.indentscope").gen_animation.none(),
  },
})

local miniGrp = vim.api.nvim_create_augroup("MiniGrp", {})

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
  mappings = {
    add = "ys",
    delete = "ds",
    replace = "cs",
    find = "",         -- Find surrounding (to the right)
    find_left = "",    -- Find surrounding (to the left)
    highlight = "",    -- Highlight surrounding
    update_n_lines = "", -- Update `n_lines`
  },
})

require("mini.align").setup({})

-- require("mini.tabline").setup({})

-- vim.cmd([[ hi! link MiniStatuslineDevinfo CmpItemKindFile ]])
-- vim.cmd([[ hi! link MiniStatuslineFilename CmpItemKindFile ]])
-- vim.cmd([[ hi! link MiniStatuslineFileinfo CmpItemKindFile ]])

require("mini.statusline").setup({
  set_vim_settings = false,
})
