local fn = vim.fn

vim.cmd[[packadd packer.nvim]]

require'packer'.startup(function()
use 'wbthomason/packer.nvim'

use 'tpope/vim-surround'
use 'tpope/vim-commentary'
use 'shaunsingh/nord.nvim'
use "mbbill/undotree"


-- LSP
use 'neovim/nvim-lspconfig'
use 'hrsh7th/nvim-compe'
use 'onsails/lspkind-nvim'
use 'kabouzeid/nvim-lspinstall'

-- Treesitter
use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

-- Telescope
use 'nvim-lua/popup.nvim'
use 'nvim-lua/plenary.nvim'
use 'nvim-telescope/telescope.nvim'
use 'nvim-telescope/telescope-fzy-native.nvim'
use 'nvim-telescope/telescope-project.nvim'

-- 
use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }



use { 'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'} }

-- Better profiling output for startup.
use {
"dstein64/vim-startuptime",
cmd = "StartupTime",
}
end)

-- Setting up Nord Colorscheme
vim.g.nord_contrast = true
vim.g.nord_borders = true
require'nord'.set()



-- Telescope

local actions = require('telescope.actions')

require'telescope'.setup{
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
  defaults = {
        vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
    },
    prompt_prefix = "λ -> ",
    selection_caret = "|> ",
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
  },
  buffers = {
    sort_lastused = true,
    theme = "ivy",
    previewer = true,
    mappings = {
      i = {
        ["<c-d>"] = actions.delete_buffer
      },
      n = {
        ["<c-d>"] = actions.delete_buffer,
      }
    }
  },
  pickers = {
    find_files = {
      theme = "ivy",
    }
  }
}

-- Extensions

-- require('telescope').load_extension('octo')
local Telescope = {}
require("telescope").load_extension "fzf"
function Telescope.nvim_config()
  require("telescope.builtin").file_browser {
    prompt_title = " NVim Config Browse",
    cwd = "~/.config/nvim/",
    layout_strategy = "horizontal",
    layout_config = { preview_width = 0.65, width = 0.75 },
  }
end

function Telescope.file_explorer()
  require("telescope.builtin").file_browser {
    prompt_title = " File Browser",
    path_display = { "shorten" },
    cwd = "~",
    layout_strategy = "horizontal",
    layout_config = { preview_width = 0.65, width = 0.75 },
  }
end

