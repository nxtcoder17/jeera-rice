-- Install packer
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
  vim.cmd([[packadd packer.nvim]])
end

local events = {
  BufEnter = "BufEnter",
  BufRead = "BufRead",
  UIEnter = "UIEnter",
}

require("packer").startup(function()
  use({ "wbthomason/packer.nvim" })
  use_rocks("base64")
  use_rocks("lrexlib-pcre")
  --
  use({
    "neovim/nvim-lspconfig",
    event = events.BufRead,
    config = function()
      require("nxtcoder17.plugins.lspconfig")
    end,
    requires = {
      "folke/neodev.nvim",
      {
        "williamboman/mason.nvim",
        config = function()
          require("mason").setup()
        end,
      },
      "williamboman/mason-lspconfig.nvim",
      -- Useful status updates for LSP
      {
        "j-hui/fidget.nvim",
        event = events.UIEnter,
        config = function()
          require("fidget").setup({ window = { blend = 0 } })
        end,
      },
      "b0o/schemastore.nvim",
      "folke/lsp-colors.nvim",
      {
        "jose-elias-alvarez/null-ls.nvim",
        event = events.BufRead,
        config = function()
          require("nxtcoder17.plugins.null-ls")
        end,
      },
    },
  })

  use({
    "echasnovski/mini.nvim",
    event = events.UIEnter,
    branch = "stable",
    config = function()
      require("nxtcoder17.plugins.mini")
    end,
  })

  use({
    "windwp/nvim-spectre",
    event = events.BufRead,
    config = function()
      require("nxtcoder17.plugins.nvim-spectre")
    end,
  })

  -- use({
  --   "gabrielpoca/replacer.nvim",
  -- })

  use({
    "ibhagwan/fzf-lua",
    event = events.UIEnter,
    config = function()
      require("nxtcoder17.plugins.fzf-lua")
    end,
  })

  use({
    "nvim-telescope/telescope.nvim",
    event = events.UIEnter,
    requires = {
      "nvim-lua/plenary.nvim",
      -- "edolphin-ydf/goimpl.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
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
      require("nxtcoder17.plugins.telescope")
    end,
  })

  use({
    "~/workspace/nxtcoder17/github/http-cli",
    event = events.BufRead,
    ft = "yaml",
    config = function()
      require("http-cli").setup({
        envFile = function()
          return string.format("%s/%s", vim.env.PWD, ".tools/gqlenv.yml")
        end,
      })
    end,
  })

  use({
    "kevinhwang91/rnvimr",
    event = events.UIEnter,
    config = function()
      require("nxtcoder17.plugins.rnvimr")
    end,
  })
  use({ "alexghergh/nvim-tmux-navigation", event = events.UIEnter })
  use({ "mg979/vim-visual-multi", event = events.BufRead })
  use({ "kazhala/close-buffers.nvim", event = events.BufRead })

  use({
    "brenoprata10/nvim-highlight-colors",
    event = events.BufRead,
    config = function()
      require("nvim-highlight-colors").setup({
        render = "background",
        enable_tailwind = "true",
      })
    end,
  })

  use({
    "luukvbaal/stabilize.nvim",
    event = events.BufReadPost,
    config = function()
      require("stabilize").setup()
    end,
  })

  -- completions
  use({
    "hrsh7th/nvim-cmp",
    --event = events.BufRead,
    config = function()
      require("nxtcoder17.plugins.nvim-cmp")
    end,
    requires = {
      { "hrsh7th/cmp-nvim-lsp" },
      {
        "L3MON4D3/LuaSnip",
        config = function()
          require("nxtcoder17.plugins.luasnip")
        end,
      },
      {
        "dcampos/cmp-emmet-vim",
        event = events.BufRead,
        ft = { "html", "javascriptreact", "typescriptreact" },
        requires = {
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
      -- {
      --   "zbirenbaum/copilot.lua",
      --   event = "VimEnter",
      --   config = function()
      --     vim.defer_fn(function()
      --       require("copilot").setup()
      --     end, 100)
      --   end,
      -- },
    },
  })

  use({ "tzachar/cmp-fuzzy-buffer", requires = { "hrsh7th/nvim-cmp", "tzachar/fuzzy.nvim" } })

  use({ "fladson/vim-kitty", ft = "kitty", event = events.BufRead })

  -- colorschemes
  use({
    "rebelot/kanagawa.nvim",
    events = events.BufRead,
    config = function()
      require("nxtcoder17.plugins.kanagawa")
    end,
  })

  use({
    "sainnhe/everforest",
    disabled = true,
    events = events.BufRead,
    config = function()
      -- require("nxtcoder17.plugins.colorschemes.everforest")
    end,
  })

  use({
    "olimorris/onedarkpro.nvim",
    events = events.BufRead,
    disabled = true,
    config = function()
      require("nxtcoder17.plugins.colorschemes.onedarkpro")
    end,
  })

  use({
    "sainnhe/gruvbox-material",
    disabled = true,
    events = events.BufRead,
    config = function()
      -- require("nxtcoder17.plugins.gruvbox-material")
    end,
  })

  use({
    "folke/tokyonight.nvim",
    disabled = true,
    events = events.BufRead,
    config = function()
      -- require("nxtcoder17.plugins.tokyonight")
    end,
  })

  use({
    "catppuccin/nvim",
    as = "catppuccin",
    disabled = true,
    events = events.BufRead,
    config = function()
      require("nxtcoder17.plugins.catppuccin")
    end,
  })

  -- treesitter
  use({
    "nvim-treesitter/nvim-treesitter-context",
    after = { "nvim-treesitter" },
    config = function()
      require("treesitter-context").setup()
    end,
  })
  use({
    "nvim-treesitter/nvim-treesitter",
    event = events.BufRead,
    config = function()
      require("nxtcoder17.plugins.treesitter")
    end,
    requires = {
      { "nvim-treesitter/nvim-treesitter-refactor",    after = "nvim-treesitter" },
      { "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" },
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        after = "nvim-treesitter",
      },
      { "p00f/nvim-ts-rainbow",       event = "BufReadPre",     after = "nvim-treesitter" },
      { "nvim-treesitter/playground", after = "nvim-treesitter" },
    },
  })

  use({
    "ziontee113/syntax-tree-surfer",
    after = "nvim-treesitter",
    events = events.BufRead,
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
  })

  use({
    "mfussenegger/nvim-dap",
    events = events.BufRead,
    config = function()
      require("nxtcoder17.plugins.dap")
    end,
    requires = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      { "jbyuki/one-small-step-for-vimkind", module = "osv" },
    },
  })

  -- golang
  use({
    "ray-x/go.nvim",
    events = events.BufRead,
    config = function()
      require("go").setup()
    end,
    requires = {
      "ray-x/guihua.lua",
    },
    ft = "go",
  })

  --[[ use({
		"klen/nvim-test",
		events = events.BufRead,
		config = function()
			require("nvim-test").setup()
		end,
	}) --]]
  -- git
  use({ "sindrets/diffview.nvim", event = events.BufRead })

  -- use({
  --   "luukvbaal/statuscol.nvim",
  --   config = function()
  --     require("statuscol").setup()
  --   end,
  -- })
  --
  -- folding
  use({
    "kevinhwang91/nvim-ufo",
    event = events.BufRead,
    requires = "kevinhwang91/promise-async",
    config = function()
      require("nxtcoder17.plugins.nvim-ufo")
    end,
  })

  -- term
  use({
    "chomosuke/term-edit.nvim",
    cond = function()
      return vim.fn.mode() == "t" or vim.filetype == "toggleterm"
    end,
    tag = "v1.*",
    config = function()
      require("term-edit").setup({
        prompt_end = "😎 ",
      })
    end,
  })

  use({
    "akinsho/toggleterm.nvim",
    events = events.BufRead,
    tag = "*",
    config = function()
      require("toggleterm").setup()
    end,
  })

  use({
    "jcdickinson/codeium.nvim",
    events = events.BufRead,
    after = "nvim-cmp",
    requires = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("codeium").setup({})
    end,
  })

  use({
    "nvim-neo-tree/neo-tree.nvim",
    events = events.UIEnter,
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
  })

  use({
    "nanozuki/tabby.nvim",
    events = events.UIEnter,
    config = function()
      require("tabby").setup()
    end,
  })

  -- session manager
  use({
    "jedrzejboczar/possession.nvim",
    event = events.UIEnter,
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("nxtcoder17.plugins.possession")
    end,
  })

  -- navigation
  use({
    "stevearc/aerial.nvim",
    event = events.BufRead,
    after = "nvim-treesitter",
    config = function()
      require("nxtcoder17.plugins.aerial")
    end,
  })

  -- markdown
  use({
    "ellisonleao/glow.nvim",
    event = events.BufRead,
    ft = "markdown",
    config = function()
      require("glow").setup()
    end,
  })

  use({
    "tiagovla/scope.nvim",
    events = events.UIEnter,
    config = function()
      require("scope").setup()
    end,
  })

  use({
    "folke/trouble.nvim",
    event = events.BufRead,
    cond = function()
      local x = vim.lsp.get_active_clients()
      return #x > 0
    end,
    config = function()
      require("trouble").setup({})
    end,
  })

  use({ "chaoren/vim-wordmotion", event = events.BufRead })

  -- chatgpt
  -- use({
  -- 	"jackMort/ChatGPT.nvim",
  -- 	config = function()
  -- 		require("chatgpt").setup()
  -- 	end,
  -- 	requires = {
  -- 		"MunifTanjim/nui.nvim",
  -- 		"nvim-lua/plenary.nvim",
  -- 		"nvim-telescope/telescope.nvim",
  -- 	},
  -- })
end)
