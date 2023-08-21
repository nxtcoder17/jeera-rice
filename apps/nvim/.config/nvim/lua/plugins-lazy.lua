local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print("installing lazy.nvim")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

local events = {
  BufEnter = "BufEnter",
  BufRead = "BufRead",
  BufReadPost = "BufReadPost",
  BufWinEnter = "BufWinEnter",
  UIEnter = "UIEnter",
  InsertEnter = "InsertEnter",
  VeryLazy = "VeryLazy",
}

local function colorschemes()
  return {
    {
      "rebelot/kanagawa.nvim",
      -- lazy = true,
      -- event = events.VeryLazy,
      init = function()
        require("plugins.kanagawa")
        vim.cmd("colorscheme kanagawa")
      end,
    },
    -- {
    --   "towolf/vim-helm",
    --   ft = { "gotmpl", "gotexttmpl", "yaml" },
    -- },
  }
end

local function fuzzy_finders()
  return {
    {
      "nvim-telescope/telescope.nvim",
      -- event = events.UIEnter,
      event = events.BufWinEnter,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended

        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        { "gbrlsnchs/telescope-lsp-handlers.nvim" },
        { "nvim-telescope/telescope-ui-select.nvim" },
        { "nvim-telescope/telescope-dap.nvim" },
        -- {
        --   "nvim-telescope/telescope-smart-history.nvim",
        --   requires = {
        --     "kkharji/sqlite.lua",
        --   },
        -- },
      },
      config = function()
        require("plugins.telescope")
        require("telescope").load_extension("fzf")
        require("telescope").load_extension("lsp_handlers")
        require("telescope").load_extension("ui-select")
        require("telescope").load_extension("dap")
        require("keymaps-for-plugins").telescope_keymaps()
      end,
    },
  }
end

local function file_managers()
  return {
    {
      "kevinhwang91/rnvimr",
      event = events.BufWinEnter,
      init = function()
        require("keymaps-for-plugins").rnvimr_keymaps()
      end,
    },
  }
end

local function navigation()
  return {
    {
      "alexghergh/nvim-tmux-navigation",
      event = events.UIEnter,
      init = function()
        require("keymaps-for-plugins").nvim_tmux_navigator_keymaps()
      end,
    },

    {
      "chaoren/vim-wordmotion",
      event = events.BufRead,
      config = function()
        require("keymaps-for-plugins").vim_wordmotion_mappings()
      end,
    },
  }
end

local function session_managers()
  return {
    {
      "jedrzejboczar/possession.nvim",
      event = events.UIEnter,
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("plugins.possession")
      end,
    },
  }
end

local function syntax()
  return {
    {
      "nvim-treesitter/nvim-treesitter",
      event = events.BufReadPost,
      config = function()
        require("plugins.treesitter")
      end,
      dependencies = {
        { "nvim-treesitter/nvim-treesitter-textobjects" },
        { "JoosepAlviste/nvim-ts-context-commentstring" },
        { "nvim-treesitter/playground" },
      },
    },
    {
      "nvim-treesitter/nvim-treesitter-context",
      event = events.BufReadPost,
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
      event = events.BufReadPost,
      config = function()
        require("plugins.syntax-tree-surfer")
      end,
    },
    {
      "utilyre/sentiment.nvim",
      event = events.BufReadPost,
      config = function()
        require("sentiment").setup({})
      end,
    },
  }
end

local function lsp()
  return {
    {
      "williamboman/mason.nvim",
      event = events.UIEnter,
      opts = {
        ensure_installed = {
          "gopls",
          "bash-language-server",
          "eslint_d",
          "lua-language-server",
          "tailwindcss-language-server",
          "typescript-language-server",
          "stylua",
          "gofumpt",
          "goimports_reviser",
          "golines",
        },
      },
      config = function()
        require("mason").setup()
      end,
      dependencies = {
        {
          "WhoIsSethDaniel/mason-tool-installer.nvim",
          config = function()
            require("plugins.mason-tool-installer")
          end,
        },
      },
    },
    {
      "neovim/nvim-lspconfig",
      event = events.BufReadPost,
      config = function()
        require("plugins.lspconfig")
      end,
      dependencies = {
        { "folke/neodev.nvim", ft = "lua" },
        "williamboman/mason-lspconfig.nvim",
        "b0o/schemastore.nvim",
        -- {
        --   "jose-elias-alvarez/null-ls.nvim",
        --   config = function()
        --     require("plugins.null-ls")
        --   end,
        -- },
      },
    },

    {
      "creativenull/efmls-configs-nvim",
      after = "nvim-lspconfig",
      version = "v0.2.x", -- tag is optional
      dependencies = { "neovim/nvim-lspconfig" },
    },

    {
      "olexsmir/gopher.nvim",
      ft = "go",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        require("gopher").setup()
      end,
    },
    {
      "folke/trouble.nvim",
      event = events.BufReadPost,
      dependencies = {
        "neovim/nvim-lspconfig",
      },
      cmd = {
        "Trouble",
        "TroubleToggle",
        "TroubleRefresh",
      },
      config = function()
        require("trouble").setup({})
      end,
    },
  }
end

local function completions()
  return {
    {
      "hrsh7th/nvim-cmp",
      event = events.InsertEnter,
      dependencies = {
        { "hrsh7th/cmp-nvim-lsp" },
        { "lukas-reineke/cmp-rg" },
        { "hrsh7th/cmp-cmdline" },
        { "saadparwaiz1/cmp_luasnip" },
        {
          "L3MON4D3/LuaSnip",
          config = function()
            require("plugins.luasnip")
            require("keymaps-for-plugins").luasnip_keymaps()
          end,
        },
        { "onsails/lspkind.nvim" },
      },
      config = function()
        require("plugins.nvim-cmp")
      end,
    },

    {
      "zbirenbaum/copilot.lua",
      event = events.BufReadPost,
      config = function()
        require("keymaps-for-plugins").copilot_mappings()
        vim.defer_fn(function()
          require("copilot").setup({
            panel = { enabled = false },
            filetypes = {
              ["*"] = true,
            },
            suggestion = {
              enabled = true,
              auto_trigger = true,
              keymap = nil,
            },
          })
        end, 100)
      end,
    },
  }
end

local function search_and_replace()
  return {
    {
      "windwp/nvim-spectre",
      event = events.BufRead,
      config = function()
        require("spectre").setup()
      end,
    },
    {
      "mg979/vim-visual-multi",
      event = events.BufRead,
      keys = { "<C-n>" },
    },
  }
end

local function dap()
  return {
    {
      "mfussenegger/nvim-dap",
      event = events.BufReadPost,
      config = function()
        require("plugins.dap")
      end,
      dependencies = {
        "rcarriga/nvim-dap-ui",
        -- "theHamsta/nvim-dap-virtual-text",
        -- { "jbyuki/one-small-step-for-vimkind", module = "osv" },
      },
    },
  }
end

local function terminals()
  return {
    {
      "chomosuke/term-edit.nvim",
      ft = { "toggleterm", "terminal" },
      version = "v1.*",
      config = function()
        require("term-edit").setup({
          prompt_end = "😎 ",
        })
      end,
    },
    {
      "akinsho/toggleterm.nvim",
      event = events.VeryLazy,
      version = "*",
      config = function()
        require("plugins.toggleterm")
        require("keymaps-for-plugins").toggleterm_keymaps()
      end,
    },
    {
      "samjwill/nvim-unception",
      -- ft = { "toggleterm", "terminal" },
      -- event = events.VeryLazy,
      init = function()
        vim.g.unception_open_buffer_in_new_tab = true
        vim.api.nvim_create_autocmd("User", {
          pattern = "UnceptionEditRequestReceived",
          callback = function()
            -- Toggle the terminal off.
            local ok, toggleterm = pcall(require, "toggleterm")
            if ok then
              toggleterm.toggle()
            end
          end,
        })
        -- Optional settings go here!
        -- e.g.) vim.g.unception_open_buffer_in_new_tab = true
      end,
    },
  }
end

local function status_and_tab_bars()
  return {
    {
      "nanozuki/tabby.nvim",
      event = events.UIEnter,
      config = function()
        require("tabby").setup()
      end,
    },
  }
end

local function ui()
  return {
    {
      "luukvbaal/stabilize.nvim",
      event = events.BufReadPost,
      config = function()
        require("stabilize").setup()
      end,
    },
    {
      "echasnovski/mini.nvim",
      event = events.UIEnter,
      branch = "stable",
      config = function()
        require("plugins.mini")
      end,
    },

    {
      "nvchad/nvim-colorizer.lua",
      ft = { "javascriptreact", "css", "html", "javascript", "typescript", "typescriptreact", "svelte", "vue" },
      event = events.BufReadPost,
      config = function()
        require("colorizer").setup({
          filetypes = {
            "javascriptreact",
            "css",
            "html",
            "javascript",
            "typescript",
            "typescriptreact",
            "svelte",
            "vue",
          },
          user_default_options = {
            tailwind = true,
          },
        })
      end,
    },

    {
      "nyngwang/NeoZoom.lua",
      cmd = {
        "NeoZoomToggle",
      },
      config = function()
        require("neo-zoom").setup({})
        require("keymaps-for-plugins").neozoom_mappings()
      end,
    },

    { "ellisonleao/glow.nvim", ft = "markdown", config = true, cmd = "Glow" },
    {
      "toppair/peek.nvim",
      ft = "markdown",
      build = "deno task --quiet build:fast",
      config = function()
        require("plugins.peek-nvim")
      end,
    },

    {
      "AckslD/messages.nvim",
      cmd = {
        "Messages",
      },
      event = events.VeryLazy,
      config = function()
        require("messages").setup()
        _G.Msg = function(...)
          require("messages.api").capture_thing(...)
        end
      end,
    },

    {
      "folke/noice.nvim",
      event = events.VeryLazy,
      dependencies = {
        "MunifTanjim/nui.nvim",
      },
      config = function()
        require("plugins.noice")
      end,
    },
  }
end

local function http_clients()
  return {
    {
      -- "nxtcoder17/http-cli",
      dir = "~/workspace/nxtcoder17/http-cli",
      build = "task build",
      cmd = {
        "Gql",
      },
      ft = "yaml",
      config = function()
        require("http-cli").setup({
          envFile = function()
            return string.format("%s/%s", vim.env.PWD, ".tools/gqlenv.yml")
          end,
        })
      end,
    },
  }
end

local function git_clients()
  return {
    {
      "sindrets/diffview.nvim",
      cmd = {
        "DiffviewOpen",
        "DiffviewClose",
        "DiffviewRefresh",
      },
    },
    {
      "lewis6991/gitsigns.nvim",
      cmd = {
        "Gitsigns",
      },
      config = function()
        require("plugins.git-signs")
      end,
    },
  }
end

local function lua_rocks()
  return {
    {
      "theHamsta/nvim_rocks",
      event = events.VeryLazy,
      build = "pipx install hererocks && hererocks . -j2.1.0-beta3 -r3.0.0 && cp nvim_rocks.lua lua",
      config = function()
        -- require("plugins.nvim_rocks").list_installed()
        vim.schedule(function()
          print("syncing luarocks")
          require("plugins.nvim_rocks").install("base64")
        end)
        -- os.execute("luarocks install base64")
        -- ---- Add here the packages you want to make sure that they are installed
        -- local nvim_rocks = require("nvim_rocks")
        -- nvim_rocks.ensure_installed("base64")
      end,
    },
  }
end

local plugins = {}

vim.list_extend(plugins, colorschemes())
vim.list_extend(plugins, fuzzy_finders())
vim.list_extend(plugins, file_managers())
vim.list_extend(plugins, navigation())
vim.list_extend(plugins, session_managers())
vim.list_extend(plugins, syntax())
vim.list_extend(plugins, lsp())
vim.list_extend(plugins, completions())
vim.list_extend(plugins, search_and_replace())
vim.list_extend(plugins, dap())
vim.list_extend(plugins, terminals())
vim.list_extend(plugins, status_and_tab_bars())
vim.list_extend(plugins, ui())
vim.list_extend(plugins, http_clients())
vim.list_extend(plugins, git_clients())
vim.list_extend(plugins, lua_rocks())

require("lazy").setup(plugins)
