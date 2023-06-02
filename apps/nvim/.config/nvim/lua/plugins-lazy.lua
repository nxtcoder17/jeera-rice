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
  UIEnter = "UIEnter",
  InsertEnter = "InsertEnter",
}

local function colorschemes()
  return {
    {
      "rebelot/kanagawa.nvim",
      -- disabled = true,
      -- lazy = false,
      init = function()
        require("plugins.kanagawa")
        vim.cmd("colorscheme kanagawa")
      end,
    },
    {
      "catppuccin/nvim",
      as = "catppuccin",
      disabled = true,
      events = events.BufRead,
      config = function()
        -- require("plugins.catppuccin")
        -- vim.cmd("colorscheme catppuccin")
      end,
    },
    {
      "towolf/vim-helm",
      ft = { "gotmpl", "gotexttmpl", "yaml" },
    },
  }
end

local function fuzzy_finders()
  return {
    {
      "nvim-telescope/telescope.nvim",
      event = events.UIEnter,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended

        -- "edolphin-ydf/goimpl.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        { "gbrlsnchs/telescope-lsp-handlers.nvim" },
        { "debugloop/telescope-undo.nvim" },
        { "nvim-telescope/telescope-ui-select.nvim" },
        { "natecraddock/telescope-zf-native.nvim" },
        -- {
        -- 	"nvim-telescope/telescope-smart-history.nvim",
        -- 	requires = {
        -- 		"kkharji/sqlite.lua",
        -- 	},
        -- },
      },
      config = function()
        require("plugins.telescope")
        require("keymaps-for-plugins").telescope_keymaps()
      end,
    },

    {
      {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = {
          "nvim-tree/nvim-web-devicons",
        },
        config = function()
          require("plugins.fzf-lua")
        end,
      },
    },
  }
end

local function file_managers()
  return {
    {
      "kevinhwang91/rnvimr",
      event = events.UIEnter,
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
      "tiagovla/scope.nvim",
      event = events.UIEnter,
      config = function()
        require("scope").setup()
      end,
    },
    { "chaoren/vim-wordmotion", event = events.BufRead },

    -- {
    --   "chrisgrieser/nvim-spider",
    --   event = events.BufRead,
    --   config = function()
    --     require("keymaps-for-plugins").spider_keymaps()
    --   end,
    -- },

    {
      "stevearc/aerial.nvim",
      event = events.BufRead,
      after = "nvim-treesitter",
      config = function()
        require("plugins.aerial")
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
      event = events.BufRead,
      config = function()
        require("plugins.treesitter")
      end,
      dependencies = {
        { "nvim-treesitter/nvim-treesitter-refactor" },
        { "nvim-treesitter/nvim-treesitter-textobjects" },
        {
          "JoosepAlviste/nvim-ts-context-commentstring",
        },
        { "p00f/nvim-ts-rainbow" },
        { "nvim-treesitter/playground" },
      },
    },

    {
      "nvim-treesitter/nvim-treesitter-context",
      event = events.BufRead,
      dependencies = { "nvim-treesitter" },
      config = function()
        require("treesitter-context").setup()
      end,
    },
    {
      "kevinhwang91/nvim-ufo",
      event = events.BufRead,
      requires = "kevinhwang91/promise-async",
      config = function()
        require("plugins.nvim-ufo")
      end,
    },

    {
      "ziontee113/syntax-tree-surfer",
      dependencies = {
        "nvim-treesitter",
      },
      event = events.BufRead,
      config = function()
        local sts = require("syntax-tree-surfer")

        local opts = { noremap = true, silent = true }

        vim.keymap.set("n", "<M-v>", function() -- only jump to variable_declarations
          -- sts.targeted_jump({ "variable_declaration" })
          sts.filtered_jump({ "variable_declaration" }, true)
        end, opts)

        vim.keymap.set("n", "<M-f>", function() -- only jump to functions
          sts.targeted_jump({ "function", "arrrow_function", "function_definition" })
          --> In this example, the Lua language schema uses "function",
          --  when the Python language uses "function_definition"
          --  we include both, so this keymap will work on both languages
        end, opts)

        vim.keymap.set("n", "<A-m>", function()
          sts.filtered_jump("default", true) --> true means jump forward
        end, opts)
      end,
    },
    { "fladson/vim-kitty", ft = "kitty" },
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
    },
    {
      "neovim/nvim-lspconfig",
      event = events.BufRead,
      config = function()
        require("plugins.lspconfig")
      end,
      dependencies = {
        "folke/neodev.nvim",
        "williamboman/mason-lspconfig.nvim",
        {
          "j-hui/fidget.nvim",
          config = function()
            require("fidget").setup({ window = { blend = 0 } })
          end,
        },
        "b0o/schemastore.nvim",
        "folke/lsp-colors.nvim",
        {
          "jose-elias-alvarez/null-ls.nvim",
          config = function()
            require("plugins.null-ls")
          end,
        },
      },
    },
    {
      "ray-x/go.nvim",
      event = events.BufRead,
      config = function()
        require("go").setup()
      end,
      dependencies = {
        "ray-x/guihua.lua",
      },
      ft = "go",
    },
    {
      "folke/trouble.nvim",
      event = events.BufRead,
      -- cond = function()
      --   local x = vim.lsp.get_active_clients()
      --   return #x > 0
      -- end,
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
      config = function()
        require("plugins.nvim-cmp")
      end,
      dependencies = {
        { "hrsh7th/cmp-nvim-lsp" },
        {
          "L3MON4D3/LuaSnip",
          config = function()
            require("plugins.luasnip")
            require("keymaps-for-plugins").luasnip_keymaps()
          end,
        },
        {
          "dcampos/cmp-emmet-vim",
          event = events.BufRead,
          ft = { "html", "javascriptreact", "typescriptreact" },
          dependencies = {
            "mattn/emmet-vim",
          },
        },
        { "hrsh7th/cmp-nvim-lua",               ft = "lua" },
        { "onsails/lspkind.nvim" },
        { "saadparwaiz1/cmp_luasnip" },
        { "hrsh7th/cmp-nvim-lsp-signature-help" },
        { "andersevenrud/cmp-tmux" },
        -- {
        --   "tzachar/cmp-tabnine",
        --   run = "./install.sh",
        --   config = function()
        --     require("nxtcoder17.plugins.cmp.tabnine")
        --   end,
        -- },
        { "hrsh7th/cmp-cmdline" },
        { "hrsh7th/cmp-buffer" },
        { "lukas-reineke/cmp-rg" },
        {
          "zbirenbaum/copilot.lua",
          event = events.BufRead,
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
                  -- keymap = {
                  --   accept = "<C-CR>",
                  --   accept_word = false,
                  --   accept_line = false,
                  --   -- next = "<M-]>",
                  --   -- prev = "<M-[>",
                  --   -- dismiss = "<C-]>",
                  --   next = "<C-n>",
                  --   prev = "<C-p>",
                  --   dismiss = "<C-c>",
                  -- },
                },
              })
            end, 100)
          end,
        },
        -- {
        --   "zbirenbaum/copilot-cmp",
        --   after = { "copilot.lua" },
        --   config = function()
        --     require("copilot_cmp").setup()
        --   end,
        -- },
      },
    },
    -- {
    --   "jcdickinson/codeium.nvim",
    --   event = events.BufRead,
    --   dependencies = {
    --     "nvim-cmp",
    --     "MunifTanjim/nui.nvim",
    --   },
    --   commit = "bb3ede8de30efe01b976eda8342ae4d40a5ee91f",
    --   config = function()
    --     require("codeium").setup({})
    --   end,
    -- },
    -- {
    --   "github/copilot.vim",
    --   event = events.BufRead,
    --   config = function()
    --     require("keymaps-for-plugins").copilot_mappings()
    --   end,
    -- },
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
    { "mg979/vim-visual-multi", event = events.BufRead },
  }
end

local function dap()
  return {
    {
      "mfussenegger/nvim-dap",
      event = events.BufRead,
      config = function()
        require("plugins.dap")
      end,
      dependencies = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        { "jbyuki/one-small-step-for-vimkind", module = "osv" },
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
      event = events.BufRead,
      version = "*",
      config = function()
        require("plugins.toggleterm")
        require("keymaps-for-plugins").toggleterm_keymaps()
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

local function misc()
  return {
    {
      "luukvbaal/stabilize.nvim",
      event = events.BufRead,
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
      event = events.UIEnter,
      config = function()
        require("colorizer").setup({
          user_default_options = {
            tailwind = true,
          },
        })
      end,
    },
    {
      "nyngwang/NeoZoom.lua",
      event = events.BufEnter,
      config = function()
        require("neo-zoom").setup({})
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
    -- {
    --   "subnut/nvim-ghost.nvim",
    --   -- ft = "markdown",
    --   event = events.BufEnter,
    --   config = function()
    --     vim.g.nvim_ghost_server_port = 4001
    --     vim.cmd([[
    --       augroup nvim_ghost_user_autocommands
    --         " au User www.reddit.com,www.stackoverflow.com setfiletype markdown
    --         " au User www.reddit.com,www.github.com setfiletype markdown
    --         au User *.github.com setfiletype markdown
    --       augroup END
    --     ]])
    --   end,
    -- },
  }
end

local function http_clients()
  return {
    {
      dir = "~/workspace/nxtcoder17/github/http-cli",
      event = events.BufRead,
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
      event = events.BufEnter,
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
vim.list_extend(plugins, misc())
vim.list_extend(plugins, http_clients())
vim.list_extend(plugins, git_clients())

require("lazy").setup(plugins)
