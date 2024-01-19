------ Nvim Core KeyMappings ------
local keymap = vim.keymap.set
local opts = { silent = true, noremap = true }

-- resets
vim.keymap.set({ "n", "v" }, "s", "<Nop>", opts)
vim.keymap.set({ "n" }, "<C-t>", "<Nop>", opts)
-- vim.keymap.set({ "n", "v" }, "f", "<Nop>")

-- vim.keymap.del("n", "<C-w>")
vim.keymap.set({ "n", "v" }, ";", ":", opts)

vim.keymap.set("n", "j", "gj", opts)
vim.keymap.set("n", "k", "gk", opts)

vim.keymap.set("t", "<esc>", "<C-\\><C-N>", opts)
vim.keymap.set({ "n", "v" }, "cc", '"+y', opts)

-- resetting paste behavior
-- keymap("x", "p", [["_dp]], opts)
--- black hole registers
-- vim.keymap.set({ "v" }, "p", '"0p', opts)
-- vim.keymap.set({ "v" }, "x", '"0x', opts)
-- vim.keymap.set({ "v" }, "d", '"0d', opts)

vim.g.mapleader = ","

vim.keymap.set({ "n", "v" }, "ss", ":w<CR>", opts)

-- making splits
vim.keymap.set("n", "si", ":vsplit<CR>", opts)
vim.keymap.set("n", "sm", ":split<CR>", opts)

-- only split
vim.keymap.set("n", "sx", ":only<CR>", opts)
vim.keymap.set("n", "s0", ":tabonly<CR>", opts)

-- making splits
vim.keymap.set("n", "scc", function()
  local f = vim.fn.expand("%:p")
  local from_project_root = f:sub(#vim.g.nxt.project_root_dir + 2)

  local lineNr = vim.fn.line(".")

  vim.fn.setreg("+", from_project_root .. ":" .. lineNr)
end, { noremap = true, silent = true, desc = "Copy file path, including line number to system clipboard" })

-- split resize
vim.keymap.set({ "n" }, "<C-M-Left>", "<Cmd>vertical resize -5<CR>", opts)
vim.keymap.set({ "n" }, "<C-M-Right>", "<Cmd>vertical resize +5<CR>", opts)
vim.keymap.set({ "n" }, "<C-M-Up>", "<Cmd>resize -5<CR>", opts)
vim.keymap.set({ "n" }, "<C-M-Down>", "<Cmd>resize +5<CR>", opts)

-- better copy pasting
vim.keymap.set("n", "sp", '"_dP', opts)

-- -- clean other buffers
-- vim.keymap.set("n", "x", function() require("mini.bufremove").wipeout(buf_id, force) end)

-- split navigation
vim.keymap.set("n", "sh", "<C-w>h<CR>", opts)
vim.keymap.set("n", "sl", "<C-w>l<CR>", opts)
vim.keymap.set("n", "sj", "<C-w>j<CR>", opts)
vim.keymap.set("n", "sk", "<C-w>k<CR>", opts)

-- quickfix list
vim.keymap.set("n", "s]", "<cmd>cnext<CR>", opts)
vim.keymap.set("n", "s[", "<cmd>cprev<CR>", opts)

-- tabs
-- vim.cmd("cnoreabbrev tcd silent! windo tcd")
vim.keymap.set("n", "tn", "<cmd>tabnew<CR>|:windo tcd " .. vim.g.nxt.project_root_dir .. "<CR>", opts)
vim.keymap.set("n", "te", "<cmd>tabedit % |:windo tcd " .. vim.g.nxt.project_root_dir .. "<CR>", opts)

-- search centered
vim.keymap.set("n", "n", "nzz", opts)
vim.keymap.set("n", "N", "Nzz", opts)
vim.keymap.set("n", "*", "*zz", opts)
vim.keymap.set("n", "#", "#zz", opts)
vim.keymap.set("n", "g*", "g*zz", opts)
vim.keymap.set("n", "g#", "g#zz", opts)

local function closeFloating()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if not vim.api.nvim_win_is_valid(win) then
      return
    end
    local config = vim.api.nvim_win_get_config(win)
    if config and config.relative ~= "" then
      local _result, _err = pcall(function()
        vim.api.nvim_win_close(win, true)
      end)
    end
  end
end

--vim.keymap.set("n", "<BS>", ":set nohls <CR>|:lua closeFloating() <CR>", opts)
vim.keymap.set("n", "<BS>", function()
  closeFloating()
  vim.cmd("nohls")
end, opts)
vim.keymap.set("n", "<Esc>", ":nohls<CR>")

-- creating scratch files
vim.api.nvim_create_user_command("Scratch", function()
  vim.cmd("vne | setlocal buftype=nofile | setlocal bufhidden=hide | setlocal noswapfile")
end, {})

vim.api.nvim_create_user_command("LspClearLog", function()
  -- /home/nxtcoder17/.local/state/nvim/lsp.log
  os.execute(string.format("rm -rf %s/lsp.log", os.getenv("XDG_STATE_HOME") or os.getenv("HOME") .. "/.local/state"))
end, {})

-- because rnvimr shits wqa
vim.keymap.set("c", "wqa", "wa! | qa!", opts)
