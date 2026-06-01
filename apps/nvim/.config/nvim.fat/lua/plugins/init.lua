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

local function fuzzy_finders()
  return {
    {
      "ibhagwan/fzf-lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      lazy = true,
      config = function()
        require("plugins.fzf")
      end,
      init = function()
        Require("plugins.fzf.keymaps")
      end,
    },
  }
end

local function syntax()
  return {
    -- {
    -- 	"sheerun/vim-polyglot",
    -- 	event = "VeryLazy",
    -- },
    -- {
    --   "catppuccin/nvim",
    --   name = "catppuccin",
    --   priority = 1000,
    --   config = function()
    --     require("plugins.colorschemes.catppuccin")
    --   end,
    -- },
    {
      "nvim-treesitter/nvim-treesitter",
      event = "BufReadPost",
      branch = "master",
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
                -- gotmpl = "{{- /* %s */}}",
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
        require("treesitter-context").setup({
          max_lines = 1500, -- disable on large files to prevent scroll jank
        })
      end,
    },
    {
      "ziontee113/syntax-tree-surfer",
      dependencies = {
        "nvim-treesitter",
      },
      event = "BufReadPost",
      config = function()
        require("plugins.treesitter.syntax-tree-surfer")
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
  }
end

local function lsp()
  return {
    {
      "neovim/nvim-lspconfig",
      config = function()
        require("lsp.diagnostic")
      end,
      -- commit = "67f151e84daddc86cc65f5d935e592f76b9f4496",
      dependencies = {
        -- "williamboman/mason-lspconfig.nvim",
        "b0o/schemastore.nvim",
      },
    },

    {
      "mason-org/mason.nvim",
      opts = {
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      },
    },
    { -- nvim lua typings
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "luvit-meta/library", words = { "vim%.uv" } },
        },
      },
    },
    { "Bilal2453/luvit-meta", lazy = true }, -- not as dependency, since never needs to be loaded

    -- {
    -- 	"creativenull/efmls-configs-nvim",
    -- 	event = "BufRead",
    -- 	-- after = "nvim-lspconfig",
    -- 	-- dependencies = { "neovim/nvim-lspconfig" },
    -- },
    {
      "stevearc/conform.nvim",
      lazy = true,
      cmd = { "ConformInfo" },
      init = function()
        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        require("conform").formatters_by_ft = {}
      end,
    },
    {
      "mfussenegger/nvim-lint",
      lazy = true,
      init = function()
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
          callback = function()
            require("lint").try_lint()
          end,
        })

        require("lint").linters_by_ft = {}
      end,
    },

    {
      "olexsmir/gopher.nvim",
      ft = "go",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        Require("gopher").setup()
      end,
    },
    {
      "folke/trouble.nvim",
      opts = {}, -- for default options, refer to the configuration section for custom setup.
      cmd = "Trouble",
    },
  }
end

local function git_clients()
  return {
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
  }
end

local function navigation()
  return {
    {
      "alexghergh/nvim-tmux-navigation",
      keys = {
        {
          "<M-h>",
          function()
            require("nvim-tmux-navigation").NvimTmuxNavigateLeft()
          end,
          mode = "n",
        },
        {
          "<M-l>",
          function()
            require("nvim-tmux-navigation").NvimTmuxNavigateRight()
          end,
          mode = "n",
        },
        {
          "<M-j>",
          function()
            require("nvim-tmux-navigation").NvimTmuxNavigateDown()
          end,
          mode = "n",
        },
        {
          "<M-k>",
          function()
            require("nvim-tmux-navigation").NvimTmuxNavigateUp()
          end,
          mode = "n",
          desc = "Go up",
        },
      },
    },

    -- {
    -- 	"ludovicchabant/vim-gutentags",
    -- 	config = function()
    -- 		vim.g.gutentags_ctags_exclude = {
    -- 			"@.gitignore",
    -- 		}
    -- 	end,
    -- },

    {
      "mg979/vim-visual-multi",
      lazy = true,
      keys = { "<C-n>" },
    },
  }
end

local function completions()
  return {
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      event = "BufReadPost",
      build = "make install_jsregexp",
      config = function()
        Require("plugins.completions.luasnip")
      end,
    },

    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      after = "LuaSnip",
      dependencies = {
        -- { "L3MON4D3/LuaSnip" },
        { "hrsh7th/cmp-nvim-lsp-signature-help" },
        { "hrsh7th/cmp-nvim-lsp" },
        -- { "lukas-reineke/cmp-rg" },
        -- { "hrsh7th/cmp-cmdline" },
        -- { "andersevenrud/cmp-tmux" },
        { "saadparwaiz1/cmp_luasnip" },
        { "FelipeLema/cmp-async-path" },
        { "quangnguyen30192/cmp-nvim-tags" },
      },
      config = function()
        -- Require("plugins.completions.luasnip")
        Require("plugins.completions.cmp")
      end,
    },
  }
end

local function search_and_replace()
  return {
    {
      "windwp/nvim-spectre",
      lazy = true,
      cmd = {
        "Spectre",
      },
      config = true,
    },
    {
      "dyng/ctrlsf.vim",
      -- lazy = true,
    },
  }
end

local function neovim_development()
  return {
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = "luvit-meta/library", words = { "vim%.uv" } },
        },
      },
    },
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  }
end

local function mini_nvim()
  return {
    {
      "nvim-mini/mini.nvim",
      -- event = "UIEnter",
      -- event = "BufReadPre",
      branch = "stable",
      -- init = function()
      --   Require("plugins.mini.mini-base16")
      -- end,
      config = function()
        require("plugins.mini")
      end,
    },
  }
end

local function editor_ui_enhancements()
  return {
    -- {
    -- 	"luukvbaal/stabilize.nvim",
    -- 	event = "BufReadPost",
    -- 	config = function()
    -- 		require("stabilize").setup()
    -- 	end,
    -- },
    -- {
    -- 	"stevearc/dressing.nvim",
    -- 	event = "BufReadPost",
    -- 	config = function()
    -- 		require("dressing").setup({
    -- 			-- insert_only = false,
    -- 			-- start_in_insert = false,
    -- 			relative = "editor",
    -- 		})
    -- 	end,
    -- },
    {
      "nvchad/nvim-colorizer.lua",
      ft = { "javascriptreact", "css", "html", "javascript", "typescript", "typescriptreact", "svelte", "vue" },
      event = "BufReadPost",
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
            "gohtmltmpl",
            "gotexttmpl",
          },
          user_default_options = {
            tailwind = true,
            css = true,
          },
        })
      end,
    },

    {
      "nyngwang/NeoZoom.lua",
      cmd = {
        "NeoZoomToggle",
      },
      keys = {
        { "sz", "<cmd>NeoZoomToggle<CR>", mode = "n", desc = "Neozoom Toggle", silent = true, noremap = true },
      },
      config = function()
        require("neo-zoom").setup({})
      end,
    },

    { "ellisonleao/glow.nvim", ft = "markdown", config = true, cmd = "Glow" },
  }
end

local function nxtcoder17_plugins()
  return {
    {
      "nxtcoder17/http-cli",
      -- dir = "~/workspace/nxtcoder17/http-cli",
      build = "go build -ldflags='-s -w' -o ./bin/http ./",
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
    -- {
    -- 	dir = "~/workspace/nxtcoder17/minimal.nvim",
    -- 	-- lazy = true,
    -- },
  }
end

local function debugging()
  return {
    {
      "mfussenegger/nvim-dap",
      event = "BufReadPost",
      config = function()
        require("plugins.dap")
      end,
      dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        -- "theHamsta/nvim-dap-virtual-text",
        -- { "jbyuki/one-small-step-for-vimkind", module = "osv" },
      },
    },
  }
end

local function file_managers()
  return {
    {
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
    },
  }
end

local function terminals()
  return {
    -- {
    -- 	"chomosuke/term-edit.nvim",
    -- 	ft = { "toggleterm", "terminal" },
    -- 	version = "v1.*",
    -- 	config = function()
    -- 		require("term-edit").setup({
    -- 			prompt_end = "😎 ",
    -- 		})
    -- 	end,
    -- },
    -- {
    -- 	"akinsho/toggleterm.nvim",
    -- 	-- event = "UIEnter",
    -- 	keys = { "st" },
    -- 	version = "*",
    -- 	config = function()
    -- 		require("plugins.toggleterm")
    -- 	end,
    -- },
    -- {
    -- 	"samjwill/nvim-unception",
    -- 	lazy = true,
    -- 	init = function()
    -- 		vim.g.unception_open_buffer_in_new_tab = true
    -- 		vim.api.nvim_create_autocmd("User", {
    -- 			pattern = "UnceptionEditRequestReceived",
    -- 			callback = function()
    -- 				-- Toggle the terminal off.
    -- 				local ok, toggleterm = pcall(require, "toggleterm")
    -- 				if ok then
    -- 					toggleterm.toggle()
    -- 				end
    -- 			end,
    -- 		})
    -- 	end,
    -- },
  }
end

local function lua_rocks()
  return {
    {
      "vhyrro/luarocks.nvim",
      priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
      opts = {
        rocks = {
          "lpeg",
        },
      },
    },
  }
end

local function ai()
  return {
    -- {
    --   "supermaven-inc/supermaven-nvim",
    --   event = "BufReadPost",
    --   config = function()
    --     require("supermaven-nvim").setup({
    --       disable_inline_completion = true, -- disables inline completion for use with cmp
    --     })
    --   end,
    -- },
  }
end

local plugins = {}

vim.list_extend(plugins, fuzzy_finders())
vim.list_extend(plugins, syntax())
vim.list_extend(plugins, lsp())
vim.list_extend(plugins, debugging())
vim.list_extend(plugins, git_clients())
vim.list_extend(plugins, navigation())
vim.list_extend(plugins, completions())
vim.list_extend(plugins, search_and_replace())
vim.list_extend(plugins, neovim_development())
vim.list_extend(plugins, editor_ui_enhancements())
vim.list_extend(plugins, mini_nvim())
vim.list_extend(plugins, nxtcoder17_plugins())
vim.list_extend(plugins, file_managers())
vim.list_extend(plugins, terminals())
vim.list_extend(plugins, lua_rocks())
vim.list_extend(plugins, ai())

require("lazy").setup(plugins, {
  ui = {
    border = "rounded",
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
})
