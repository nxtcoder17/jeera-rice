local nvim_util_fns = require("functions.neovim-utils")

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
      cmd = string.format(
        [[
      set -x _dir "$PWD"
      set -x PARENT_DIR "%s"
      pushd $PARENT_DIR > /dev/null 2>&1
      pushd $_dir > /dev/null 2>&1
      $SHELL
      ]],
        vim.g.root_dir
      ),
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
  -- vim.keymap.set("n", "<C-;>", require("plugins.telescope").dapActions)

  -- telescope
  -- vim.keymap.set("n", "sf", ":Telescope find_files<CR>")
  vim.keymap.set("n", "sf", require("plugins.telescope").list_files)
  vim.keymap.set("n", "ff", require("plugins.telescope").grep)
  vim.keymap.set("n", "<C-f>", require("plugins.telescope").grep)
  vim.keymap.set("v", "<C-f>", function()
    require("plugins.telescope").grep(nvim_util_fns.get_selection())
  end)
  vim.keymap.set("n", "tl", require("plugins.telescope").only_tabs, { silent = true, noremap = true })
  vim.keymap.set("n", "s/", ":Telescope current_buffer_fuzzy_find<CR>", { silent = true, noremap = true })
  vim.keymap.set({ "n", "v" }, "<M-;>", function()
    print("hi i have been called")
    require("plugins.custom-pickers.utility-pickers").pick()
  end, { silent = true, noremap = true })
end

M.nvim_tmux_navigator_keymaps = function()
  vim.keymap.set("n", "<M-h>", require("nvim-tmux-navigation").NvimTmuxNavigateLeft)
  vim.keymap.set("n", "<M-l>", require("nvim-tmux-navigation").NvimTmuxNavigateRight)
  vim.keymap.set("n", "<M-j>", require("nvim-tmux-navigation").NvimTmuxNavigateDown)
  vim.keymap.set("n", "<M-k>", require("nvim-tmux-navigation").NvimTmuxNavigateUp)
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

  -- vim.keymap.set("n", "<leader>sr", function()
  --   require("spectre").open_visual({ select_word = true })
  -- end)
  --
  -- vim.keymap.set("n", "<leader>r", function()
  --   require("replacer").run()
  -- end)
end

M.copilot_mappings = function()
  vim.g.copilot_no_tab_map = true
  vim.keymap.set({ "n", "i" }, "<C-CR>", function()
    -- vim.cmd("call copilot#Accept('<CR/>')")
    require("copilot.suggestion").accept()
  end)
  vim.keymap.set({ "i" }, "<C-j>", function()
    require("copilot.suggestion").next()
  end)
  vim.keymap.set({ "i" }, "<C-k>", function()
    require("copilot.suggestion").prev()
  end)
  vim.keymap.set({ "i" }, "<C-c>", function()
    require("copilot.suggestion").prev()
  end)
end

M.vim_wordmotion_mappings = function()
  vim.cmd([[
    nmap cw ce
    nmap cW cE
  ]])
end

M.neozoom_mappings = function()
  vim.keymap.set("n", "sz", ":NeoZoomToggle<CR>", { silent = true, noremap = true })
end

return M
