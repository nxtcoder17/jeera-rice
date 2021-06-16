local actions = require('telescope.actions')


local ignoreFile = os.getenv('HOME') .. '/.ignore'

require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--line-number',
      '--follow',
      '--column'
    },
    initial_mode = 'insert',
    shorten_path = true,

    winblend = 0,
    width = 0.45,

    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.cat.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_cat.new`
    grep_previewer = require'telescope.previewers'.vimgrep.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_vimgrep.new`
    qflist_previewer = require'telescope.previewers'.qflist.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_qflist.new`

    prompt_prefix = "λ -> ",
    selection_caret = "|> ",
    -- Don't pass to normal mode with ESC, problem with telescope-project
    -- mappings = {
    --   i = {
    --     ["<esc>"] = actions.close,
    --   },
    -- },
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    }
  }
}

-- Extensions

-- require('telescope').load_extension('octo')
require('telescope').load_extension('fzy_native')
require('telescope').load_extension('ultisnips')
require('telescope').load_extension('project')

-- Implement delta as previewer for diffs

local previewers = require('telescope.previewers')
local builtin = require('telescope.builtin')
local conf = require('telescope.config')
local M = {}

local delta = previewers.new_termopen_previewer {
  get_command = function(entry)
    -- this is for status
    -- You can get the AM things in entry.status. So we are displaying file if entry.status == '??' or 'A '
    -- just do an if and return a different command
    if entry.status == '??' or 'A ' then
      return { 'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.value }
    end

    -- note we can't use pipes
    -- this command is for git_commits and git_bcommits
    return { 'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.value .. '^!' }

  end
}

M.my_git_commits = function(opts)
  opts = opts or {}
  opts.previewer = delta

  builtin.git_commits(opts)
end

M.my_git_bcommits = function(opts)
  opts = opts or {}
  opts.previewer = delta

  builtin.git_bcommits(opts)
end

M.my_git_status = function(opts)
  opts = opts or {}
  opts.previewer = delta

  builtin.git_status(opts)
end

M.my_note = function(opts)
  builtin.live_grep { prompt_title = ' Note ', cwd = '~/Note' }
end

M.project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(require'telescope.builtin'.git_files, opts)
  if not ok then require'telescope.builtin'.find_files(opts) end
end

return M

