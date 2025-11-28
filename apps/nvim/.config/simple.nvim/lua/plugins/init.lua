-- Bootstrap lazy.nvim
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

local plugins = {
  {
    -- general purpose lua development utilities
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- lazy = true,
    event = "UIEnter",
    -- event = "Lazy",
    config = function()
      Require("plugins.fzf-lua")
      Require("plugins.fzf-lua.keymaps")
    end,
    -- cmd = {
    -- 	"Fzf",
    -- 	"FzfLua",
    -- },
    -- keys = { "sf", "cd", "f;" },
  },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    event = "BufReadPost",
    config = function()
      Require("plugins.luasnip")
      Require("plugins.luasnip.keymaps")
    end,
  },
  {
    "echasnovski/mini.nvim",
    -- event = "UIEnter",
    event = "BufReadPre",
    branch = "stable",
    config = function()
      require("plugins.mini")
    end,
  },

  {
    "nxtcoder17/http-cli",
    -- dir = "~/workspace/nxtcoder17/http-cli",
    build = "task build",
    cmd = {
      "Gql",
      "Http",
    },
    ft = "yaml",
    config = function()
      require("http-cli").setup({
        envFile = function()
          local v = os.getenv("HTTP_CLI_ENV")
          if v ~= "" then
            return v
          end

          local paths = {
            vim.fn.getcwd() .. "/.secrets/http-cli-env.yml",
            vim.g.project_root_dir .. "/.secrets/http-cli-env.yml",
          }

          for _, path in ipairs(paths) do
            if Require("functions.fs").exists(path) then
              return path
            end
          end
        end,
      })
    end,
  },

  {
    "kevinhwang91/rnvimr",
    cmd = {
      "RnvimrToggle",
    },
    keys = {
      { "<M-o>", "<Cmd>RnvimrToggle<CR>", mode = "n" },
      { "<M-o>", "<C-\\><C-n>:RnvimrToggle<CR>", mode = "t" },
    },
  },

  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall" },
    opts = { max_concurrent_installers = 10 },
    lazy = true,
    config = function()
      require("mason").setup()
    end,
  },

  -- lint
  {
    "mfussenegger/nvim-lint",
    event = "BufReadPost",
    config = function()
      Require("plugins.linter-and-formatter").linter()
    end,
  },

  -- formatter
  {
    "stevearc/conform.nvim",
    event = "BufRead",
    config = function()
      Require("plugins.linter-and-formatter").formatter()
    end,
  },

  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPost",
    config = function()
      require("plugins.treesitter")
    end,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      -- {
      --   "yorickpeterse/nvim-tree-pairs",
      --   config = function()
      ---     require("tree-pairs").setup()
      --   end,
      -- },
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
          require("ts_context_commentstring").setup({
            enable_autocmd = false,
            languages = {
              gotmpl = {
                __default = "{{- /* %s */}}",
              },
              gotexttmpl = {
                __default = "{{- /* %s */}}",
              },
              gohtmltmpl = {
                __default = "{{- /* %s */}}",
              },
              -- terraform = "# %s",
              -- proto = "// %s",
              -- kdl = "// %s",
              -- gotexttmpl = "{{- /* %s */}}",
              -- gohtmltmpl = "{{- /* %s */}}",
            },
          })
        end,
      },
      -- {
      --   "andymass/vim-matchup",
      --   event = "BufWinEnter",
      --   init = function()
      --     vim.g.matchup_matchparen_offscreen = { method = "popup", fullwidth = 1, syntax_hl = 1 }
      --     vim.g.matchup_matchparen_deferred = 1
      --   end,
      -- },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    dependencies = { "nvim-treesitter" },
    config = function()
      require("treesitter-context").setup()
    end,
  },
  {
    "ziontee113/syntax-tree-surfer",
    dependencies = {
      "nvim-treesitter",
    },
    event = "BufReadPost",
    config = function()
      require("plugins.syntax-tree-surfer")
    end,
  },
  {
    -- enhanced highlighting for semantic match pairs
    "utilyre/sentiment.nvim",
    event = "BufReadPost",
    config = function()
      require("sentiment").setup()
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("plugins.colorschemes.catppuccin")
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewFileHistory",
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewRefresh",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
    },
    config = function()
      require("plugins.diffview")
    end,
  },
  {
    "ms-jpq/coq_nvim",
    init = function()
      vim.g.coq_settings = {
        auto_start = true, -- if you want to start COQ at startup
        -- Your COQ settings here
      }
    end,
  },
}

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  ui = {
    border = "rounded",
  },

  spec = plugins,
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
})
