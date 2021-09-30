local actions = require('telescope.actions')

-- require('telescope').setup{
--   defaults = {
--     vimgrep_arguments = {
--       'rg',
--       '--color=never',
--       '--line-number',
--       '--follow',
--       '--column'
--     },
--     initial_mode = 'insert',

--     winblend = 0,
--     layout_width = 0.45,

--     border = {},
--     borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
--     color_devicons = true,
--     use_less = true,
--     set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
--     -- file_previewer = require'telescope.previewers'.cat.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_cat.new`
--     file_previewer = require'telescope.previewers'.vim_buffer_cat.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_cat.new`
--     grep_previewer = require'telescope.previewers'.vimgrep.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_vimgrep.new`
--     qflist_previewer = require'telescope.previewers'.qflist.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_qflist.new`

--     prompt_prefix = "λ -> ",
--     selection_caret = "|> ",
--     -- Don't pass to normal mode with ESC, problem with telescope-project
--     -- mappings = {
--     --   i = {
--     --     ["<esc>"] = actions.close,
--     --   },
--     -- },
--   },
--   pickers = {
--     find_files = {
--       theme = "ivy",
--     },
--   },
--   extensions = {
--     fzy_native = {
--       override_generic_sorter = false,
--       override_file_sorter = true,
--     }
--   }
-- }

require'telescope'.setup{
  defaults = {
    prompt_prefix = "λ -> ",
    selection_caret = "|> ",
  },
  buffers = {
    sort_lastused = true,
    theme = "icy",
    previewer = false,
    mappings = {
      i = {
        ["<c-d>"] = actions.delete_buffer
      },
      n = {
        ["<c-d>"] = require("telescope.actions").delete_buffer,
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
require('telescope').load_extension('fzy_native')
require('telescope').load_extension('ultisnips')
-- require('telescope').load_extension('project')

local M = {};

local pickers = require'telescope.pickers';

M.nvim_config = function()
end

return M
-- ]]
