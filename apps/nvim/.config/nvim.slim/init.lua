local has_new_ui, new_ui = pcall(require, "vim._core.ui2")
if has_new_ui then
  new_ui.enable({})
end

-- STEP: disabling builtin plugins, as most of them are super slow
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1

vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1

vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1

vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_rplugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_shada_plugin = 1

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

-- i don't use any of these providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

-- [source](https://nanotipsforvim.prose.sh/using-pcall-to-make-your-config-more-stable)
_G.Require = function(module)
  local ok, mod = pcall(require, module)
  if ok then
    return mod
  end
  vim.api.nvim_echo({"[ERROR] while loading module: " .. module }, "ErrorMsg")
  print("ERROR while loading module: ", module)
end

---@param pkg any
_G.R = function(pkg)
  package.loaded[pkg] = nil
  return Require(pkg)
end

---pretty print for lua datastructures
_G.P = function(...)
  vim.print(vim.inspect(...))
end

_G.NewLogger = function(name, level)
  level = level or "debug"
  return Require("plenary.log").new({
    plugin = name,
    level = level,

    outfile = require("plenary.path"):new(vim.fn.stdpath("cache"), "log", name .. ".log").filename,
  })
end

_G.bin_lookup = function(bin)
  local handle = io.popen("command -v " .. vim.fn.shellescape(bin) .. " 2>/dev/null")
  if not handle then
    return false
  end
  local result = handle:read("*a")
  handle:close()
  return result ~= ""
end

_G.notify_if_not_installed = function(binaries)
  local has_error = false
  for _, item in ipairs(binaries) do
    if not bin_lookup(item) then
      vim.notify_debug(string.format("[filetype: %s] binary '%s' is not installed", vim.bo.filetype, item))
      has_error = true
    end
  end

  return not has_error
end

-- _G.Logger = _G.NewLogger("global-logger")

-- INFO: neovim configuration directory
vim.g.nvim_dir = vim.fn.stdpath("config")

-- INFO: directory at which vim has been started
vim.g.project_root_dir = vim.fn.getcwd()

vim.notify_warn = function(...)
  vim.notify(..., vim.log.levels.WARN)
end

vim.notify_debug = function(...)
  vim.notify(..., vim.log.levels.DEBUG)
end

vim.notify_error = function(...)
  vim.notify(..., vim.log.levels.ERROR)
end

vim.notify_info = function(...)
  vim.notify(..., vim.log.levels.INFO)
end

-- STEP: vim options
vim.opt.number = true
vim.opt.numberwidth = 2

-- global statusline h:statusline
vim.opt.laststatus=3
vim.opt.showtabline=2

vim.opt.swapfile = false

-- no awkward horizontal shifting due to GitSigns, or Diagnostics
vim.opt.signcolumn = "yes:2"

vim.opt.wrap = true

-- show list characters
vim.opt.list = true
vim.opt.listchars = {
  ["eol"] = "↲",
  -- ["tab"] = "»·",
  ["tab"] = "·",
  ["space"] = "␣",
  ["trail"] = "-",
  ["extends"] = "☛",
  -- ["precedes"] = "☚",

  ["conceal"] = "┊",
  ["nbsp"] = "☠",
}

-- Tab, Spaces and Indentations
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2 -- spaces per tab when using >> or <<

vim.opt.expandtab = false

vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.shiftround = true
-- Copy Previous Indentation
vim.opt.smartindent = true
vim.opt.copyindent = true
vim.opt.autoindent = true

vim.opt.wildoptions = "pum"
vim.opt.pumblend = 1
vim.opt.pumheight = 20

vim.list_extend(vim.opt.wildignore, {
  "node_modules",
  ".git",
  ".next",
  -- "build",
  "dist",
})

-- completion
vim.opt.completeopt = "menuone,noselect,noinsert"

-- Fast Scrolling
vim.opt.ttimeoutlen = 10
vim.opt.timeoutlen = 500
vim.opt.ttyfast = true
vim.opt.updatetime = 50
-- opt.lazyredraw = false

-- search
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.hlsearch = true

-- replace
vim.opt.inccommand = "split" -- shows live incremental status of substitution in split buffer

-- no comment on new lines
vim.cmd([[au! BufEnter * set fo-=c fo-=r fo-=o]])

-- clipboard
-- opt.clipboard = "unnamedplus"
vim.opt.ttyfast = true
-- opt.lazyredraw = true

-- colors
vim.opt.termguicolors = true
vim.cmd([[
  let &t_Cs = "\e[4:3m"
  let &t_Ce = "\e[4:0m"
]])
vim.opt.updatetime = 100

-- buffers
vim.opt.switchbuf = "useopen,usetab,newtab"

vim.o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

vim.opt.formatoptions = vim.opt.formatoptions + "j" -- remove comment leader when joining comment lines
vim.opt.formatoptions = vim.opt.formatoptions + "n" -- smart auto-indenting inside numbered lists

vim.o.diffopt = "internal,filler,closeoff,indent-heuristic,linematch:60,algorithm:histogram"

--- KEYMAPS
local keymap = vim.keymap.set
local opts = { silent = true, noremap = true }

local function opt(desc)
  return { silent = true, noremap = true, desc = desc }
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
-- Require("keymaps.wordmotion").setup()

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
    -- ["bash"] = {
    --   "bash",
    --   "--rcfile",
    --   string.format("<(pushd %s; pushd %s; source $HOME/.bashrc)", vim.g.project_root_dir, dir),
    -- },
    -- ["bash"] = {
    --   "bash",
    --   "-i",
    --   "-c",
    --   -- string.format("pushd %s >/dev/null; pushd %s >/dev/null; exec bash", vim.g.project_root_dir, dir),
    --   string.format("pushd %s; pushd %s; exec bash", vim.g.project_root_dir, dir),
    -- },
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

-- PLUGINS
--
-- [Bootstrap lazy.nvim](https://lazy.folke.io/installation)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)


local function setup_fzf()
	return {
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = true,
		config = function()
			require("plugins.fzf")
		end,
		init = function()
			local actions = Require("fzf-lua.actions")
			local fzf = Require("fzf-lua")

			fzf.setup({
				"telescope",
				fzf_opts = {
					["--layout"] = "reverse",
					["--pointer"] = "👉",
					["--tiebreak"] = "index",
				},
				hls = {
					border = "FloatBorder",
					preview_border = "FloatBorder",
				},
				file_icon_padding = " ",
				global_resume = true,
				global_resume_query = true,
				global_resume_prompt = "resume: ",
				multiprocess = false,

				oldfiles = {
					include_current_session = true,
				},

				previewers = {
					builtin = {
						syntax_limit_b = 1024 * 100, -- 100KB
					},
				},

				winopts = {
					preview = {
						horizontal = "right:40%",
					},
					height = 0.3, -- window height
					width = 1, -- window width
					row = 1, -- window row position (0=top, 1=bottom)
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
					-- cmd = { "rg", "--files" },
					prompt = "Files ❯ ",
					cwd_prompt = false,
					fzf_opts = {
						["--no-separator"] = "",
						["--no-scrollbar"] = "",
					},
					-- git_icons = false,
					-- file_icons = false,
				},

				keymaps = {
					prompt = "Keymaps ❯ ",
					winopts = {
						preview = {
							vertical = "right:20%",
						},
					},
					-- fzf = {
					--   ["ctrl-g"] = "select-all+accept",
					-- },
				},

				lsp_definitions = {
					jump_to_single_result = true,
					jump_to_single_result_action = require("fzf-lua.actions").file_vsplit,
				},
				lsp_implementations = {
					jump_to_single_result = true,
				},
				lsp_references = {
					ignore_current_line = true,
				},

				grep = {
					no_esc = true,
					formatter = "path.filename_first",
				},

				live_grep = {
					multiline = true
					-- multiprocess = false,
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
					["alt-f"] =  function(selected)
						vim.print(vim.inspect(selected))
					end,
				},
			})

			vim.cmd("FzfLua register_ui_select")
			
		end,
	}
end

local function setup_mini_nvim()
	return {
		"nvim-mini/mini.nvim",
		branch = "stable",
		-- init = function()
		--   Require("plugins.mini.mini-base16")
		-- end,
		config = function()
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
				DEBUG = { duration = 1 },
				ERROR = { duration = 2000 },
				WARN = { duration = 2000 },
				INFO = { duration = 2000 },
			})

			Require("mini.git").setup()
			Require("mini.sessions").setup()

			Require("plugins.mini.mini-comments")
			Require("plugins.mini.mini-hipatterns")
			Require("plugins.mini.mini-statusline")
		end,
	}
end

local function setup_oil()
    return {
      "stevearc/oil.nvim",
      ---@module 'oil'
      ---@type oil.SetupOpts
      opts = {
        default_file_explorer = true,
        view_options = {
          show_hidden = true,
        },
        keymaps = {
          ["<M-o>"] = { "actions.close", mode = "n" },
        },
      },
      -- Optional dependencies
      dependencies = { { "nvim-mini/mini.icons", opts = {} } },
      -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
      -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
      lazy = true,
      keys = {
        { "<M-o>", "<Cmd>Oil<CR>", mode = "n" },
      },
    }
end

require("lazy").setup({
	setup_fzf(),
	setup_mini_nvim(),
	setup_oil(),
}, {
  ui = {
    border = "rounded",
  },
  change_detection = {
    enabled = true,
    notify = true,
  },
})

