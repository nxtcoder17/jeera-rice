local keymap = vim.keymap.set
local opts = { silent = true, noremap = true }

local function opt(description)
  return {
    silent = true,
    noremap = true,
    desc = description,
  }
end

vim.g.mapleader = ","

-- allows pasting without yanking deleted text
keymap({ "x" }, "p", "P")

-- free's up the `s` key
keymap({ "n", "v" }, "s", "<nop>", opts)

-- why, cause i keep on typing it for some weird reason
keymap({ "c" }, "w'", "<Nop>", opts)
keymap({ "c" }, "w,", "<Nop>", opts)

keymap({ "n" }, ";", ":", opt("in normal mode, ; acts like a :"))

vim.keymap.set("n", "j", "gj", opts)
vim.keymap.set("n", "k", "gk", opts)

vim.keymap.set("t", "<esc>", "<C-\\><C-N>", opts)
vim.keymap.set({ "n", "x" }, "cc", '"+y', opts)

keymap({ "n", "v" }, "ss", ":w<CR>", opt("save buffer"))
keymap({ "n", "v" }, "si", ":vsplit<CR>", opt("vertically split current buffer"))
keymap({ "n", "v" }, "sm", ":split<CR>", opt("horizontally split current buffer"))

keymap("n", "sx", ":only<CR>", opt("closes all other windows in current tab"))
keymap("n", "s0", ":tabonly<CR>", opt("closes all other tabs"))

keymap("n", "sh", "<C-w>h<CR>", opt("focus left window split"))
keymap("n", "sl", "<C-w>l<CR>", opt("focus right window split"))
keymap("n", "sj", "<C-w>j<CR>", opt("focus down window split"))
keymap("n", "sk", "<C-w>k<CR>", opt("focus up window split"))

keymap({ "n" }, "<C-M-Left>", "<Cmd>vertical resize -5<CR>", opt("resizes verically by -5 units"))
keymap({ "n" }, "<C-M-Right>", "<Cmd>vertical resize +5<CR>", opt("resizes verically by +5 units"))
keymap({ "n" }, "<C-M-Up>", "<Cmd>resize -5<CR>", opt("resizes horizontally by -5 units"))
keymap({ "n" }, "<C-M-Down>", "<Cmd>resize +5<CR>", opt("resizes horizontally by +5 units"))

keymap("n", "s]", "<cmd>cnext<CR>", opt("quickfix list, jump to next item"))
keymap("n", "s[", "<cmd>cprev<CR>", opt("quickfix list, jump to previous item"))

keymap("n", "scc", function()
  local f = vim.fn.expand("%:p")
  local from_project_root = f:sub(#vim.g.project_root_dir + 2)

  local lineNr = vim.fn.line(".")

  vim.fn.setreg("+", from_project_root .. ":" .. lineNr)
end, opt("Copy file path, including line number to system clipboard"))

keymap("n", "scd", function()
  local f = vim.fn.expand("%:p")
  local from_project_root = f:sub(#vim.g.project_root_dir + 2)

  vim.fn.setreg("+", vim.fs.dirname(from_project_root))
end, opt("Copy directory of current buffer to system clipboard"))

vim.keymap.set(
  "n",
  "tn",
  "<cmd>tabnew<CR>|:windo tcd " .. vim.g.project_root_dir .. "<CR>",
  opt("creates an empty, new tab")
)

vim.keymap.set(
  "n",
  "te",
  "<cmd>tabedit % |:windo tcd " .. vim.g.project_root_dir .. "<CR>",
  opt("opens current buffer in a new tab")
)

keymap("n", "<BS>", function()
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

  vim.cmd("nohls")
end, opt("closes all the floating windows"))

keymap("n", "<Esc>", ":nohls<CR>", opt("resets search highlights"))

keymap("c", "wqa", "wa! | qa!", opt("save and exit"))

vim.keymap.set(
  "n",
  "tn",
  "<cmd>tabnew<CR>|:windo tcd " .. vim.g.project_root_dir .. "<CR>",
  opt("creates an empty, new tab")
)

vim.keymap.set(
  "n",
  "te",
  "<cmd>tabedit % |:windo tcd " .. vim.g.project_root_dir .. "<CR>",
  opt("opens current buffer in a new tab")
)

local function faster_tab_switching()
  -- local shift_ascii_codes = {
  -- 	["!"] = 33, -- Shift + 1
  -- 	['"'] = 34, -- Shift + 2
  -- 	["#"] = 35, -- Shift + 3
  -- 	["$"] = 36, -- Shift + 4
  -- 	["%"] = 37, -- Shift + 5
  -- 	["&"] = 38, -- Shift + 6
  -- 	["'"] = 39, -- Shift + 7
  -- 	["("] = 40, -- Shift + 8
  -- 	[")"] = 41, -- Shift + 9
  -- 	["*"] = 42, -- Shift + 0
  -- 	["+"] = 43, -- Shift + =
  -- 	[":"] = 58, -- Shift + ;
  -- 	["<"] = 60, -- Shift + ,
  -- 	[">"] = 62, -- Shift + .
  -- 	["?"] = 63, -- Shift + /
  -- 	["@"] = 64, -- Shift + 2 (on some keyboards)
  -- 	["^"] = 94, -- Shift + 6
  -- 	["_"] = 95, -- Shift + -
  -- 	["|"] = 124, -- Shift + \
  -- 	["~"] = 126, -- Shift + `
  -- }

  -- INFO: this is a hack to bind `Alt + Shift + {1-5}` to corresponding tabs in the editor, just for faster tab switching
  for key, value in pairs({ "!", "@", "#", "$", "%" }) do
    keymap({ "n", "v", "i", "t" }, "<M-" .. value .. ">", function()
      local tabnr = vim.api.nvim_list_tabpages()[key]
      local win_id = vim.api.nvim_tabpage_get_win(tabnr)
      vim.api.nvim_set_current_win(win_id)
    end, opt(string.format("binds `Alt/Meta + Shift + %d` to tab %d", key, key)))
  end
end

faster_tab_switching()

vim.keymap.set({ "n" }, "st", function()
  if vim.t.terminal ~= nil then
    if vim.api.nvim_buf_is_valid(vim.t.terminal.buf) then
      vim.t.terminal.toggle()
      return
    end
  end

  local dir = vim.fn.getcwd()

  local init_cmd = {
    ["fish"] = { "fish", "--init-command", string.format("pushd %s; pushd %s", vim.g.project_root_dir, dir) },
    ["bash"] = { "bash" },
    -- ["bash"] = { "bash", "--rcfile", string.format("<(pushd %s; pushd %s; source $HOME/.bashrc)", vim.g.project_root_dir, dir) },
    -- ["bash"] = { "bash", "-i", "-c", string.format("pushd %s >/dev/null; pushd %s >/dev/null; exec bash", vim.g.project_root_dir, dir) },
    -- ["bash"] = { "bash", "--init-file", string.format([[
    --   if [ -f ~/.bashrc ]; then
    --     echo "SOURCING ~/.bashrc" >> /tmp/term.log
    --     source ~/.bashrc
    --   else
    --     echo "FAILED to source ~/.bashrc" >> /tmp/term.log
    --   fi
    --
    --   pushd %s >/dev/null
    --   pushd %s >/dev/null
    -- ]], vim.g.project_root_dir, dir) },
    ["zsh"] = { "zsh", "-c", string.format("pushd %s; pushd %s; zsh -i", vim.g.project_root_dir, dir) },
  }

  local term = require("lazy.util").float_term(init_cmd[vim.fs.basename(os.getenv("SHELL"))], {
    cwd = dir,
    ft = "Terminal",
    size = { width = 0.7, height = 0.7 },
    persistent = true,
  })

  local on_term_visible = function()
    vim.api.nvim_set_option_value(
      "winhighlight",
      "Normal:Normal,FloatBorder:Pmenu",
      { scope = "local", win = term.win }
    )
  end

  on_term_visible()

  vim.t.terminal = {
    buf = term.buf,
    toggle = function()
      term:toggle()
      on_term_visible()
    end,
  }
end, { noremap = true, silent = true, desc = "opens up a terminal in tab local working directory" })
