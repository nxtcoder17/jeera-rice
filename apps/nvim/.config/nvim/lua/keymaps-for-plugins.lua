local M = {}

local opts = { silent = true, noremap = true }

M.toggleterm_keymaps = function()
  local terminals = {}

  vim.keymap.set({ "n" }, "st", function()
    local dir = vim.fn.getcwd()
    if terminals[dir] ~= nil then
      terminals[dir]()
      return
    end
    local term = require("toggleterm.terminal").Terminal:new({
      start_in_insert = true,
      dir = vim.fn.getcwd(),
      direction = "float",
    })
    terminals[dir] = function()
      term:toggle()
    end
    term:toggle()
    return
  end, opts)
end

M.rnvimr_keymaps = function()
  vim.keymap.set("n", "<M-o>", ":RnvimrToggle<CR>")
  vim.keymap.set("t", "<M-o>", "<C-\\><C-n>:RnvimrToggle<CR>")
end

M.telescope_keymaps = function()
  vim.keymap.set("n", "sb", require("telescope.builtin").buffers, opts)
  vim.keymap.set("n", "<C-;>", require("plugins.telescope").dapActions)

  -- telescope
  -- vim.keymap.set("n", "sf", ":Telescope find_files<CR>")
  vim.keymap.set("n", "sf", require("plugins.telescope").live_files)
  vim.keymap.set("n", "ff", require("plugins.telescope").grep)
  vim.keymap.set("n", "tl", require("plugins.telescope").only_tabs, { silent = true, noremap = true })
end

M.nvim_tmux_navigator_keymaps = function()
  vim.keymap.set("n", "<M-Left>", require("nvim-tmux-navigation").NvimTmuxNavigateLeft)
  vim.keymap.set("n", "<M-Right>", require("nvim-tmux-navigation").NvimTmuxNavigateRight)
  vim.keymap.set("n", "<M-Down>", require("nvim-tmux-navigation").NvimTmuxNavigateDown)
  vim.keymap.set("n", "<M-Up>", require("nvim-tmux-navigation").NvimTmuxNavigateUp)
end

M.luasnip_keymaps = function()
  vim.keymap.set({ "i", "s" }, "<C-l>", function()
    if require("luasnip").choice_active() then
      require("luasnip").change_choice(1)
    end
  end)

  vim.keymap.set({ "i", "s" }, "<C-h>", function()
    if require("luasnip").choice_active() then
      require("luasnip").change_choice(-1)
    end
  end)

  vim.keymap.set("n", "<leader>sr", function()
    require("spectre").open_visual({ select_word = true })
  end)

  vim.keymap.set("n", "<leader>r", function()
    require("replacer").run()
  end)
end

M.spider_keymaps = function()
  -- Keymaps
  vim.keymap.set({ "n", "o", "x" }, "w", function()
    require("spider").motion("w")
  end, { desc = "Spider-w" })
  vim.keymap.set({ "n", "o", "x" }, "e", function()
    require("spider").motion("e")
  end, { desc = "Spider-e" })
  vim.keymap.set({ "n", "o", "x" }, "b", function()
    require("spider").motion("b")
  end, { desc = "Spider-b" })
  vim.keymap.set({ "n", "o", "x" }, "ge", function()
    require("spider").motion("ge")
  end, { desc = "Spider-ge" })
end

return M
