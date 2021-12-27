local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")
local telescope_actions = require("telescope.actions")
local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")

-- Custom Find Command
local findCmd
if vim.fn.executable("fd") then
  findCmd = { "fd", "-t", "f", "-H", "-E", ".git", "--strip-cwd-prefix" }
elseif vim.fn.executable("rg") then
  findCmd = { "rg", "--files", "--iglob", "!.git", "--hidden" }
end

-- Don't preview the binaries
local previewers = require("telescope.previewers")
local Job = require("plenary.job")

local previewMaker = function(filepath, bufnr, opts)
  filepath = vim.fn.expand(filepath)
  Job
    :new({
      command = "file",
      args = { "--mime-type", "-b", filepath },
      on_exit = function(j)
        local mime_type = vim.split(j:result()[1], "/")[1]
        if mime_type == "text" then
          previewers.buffer_previewer_maker(filepath, bufnr, opts)
        else
          -- maybe we want to write something to the buffer here
          vim.schedule(function()
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
          end)
        end
      end,
    })
    :sync()
end

telescope.setup({
  defaults = {
    previewer = previewMaker,
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
  pickers = {
    find_files = {
      theme = "ivy",
      find_command = findCmd,
      prompt_title = "  Looking for files",
    },
    lsp_references = {
      theme = "cursor",
      prompt_title = "  Looking for references",
    },
    lsp_definitions = {
      theme = "ivy",
    },
    grep_string = {
      theme = "ivy",
    },
    buffers = {
      theme = "ivy",
      mappings = {
        n = {
          ["<C-d>"] = actions.delete_buffer,
        },
        i = {
          ["<C-d>"] = actions.delete_buffer,
        },
      },
    },
  },
})

require("telescope").load_extension("fzf")

local M = {}

M.grep = function()
  telescope_builtin.grep_string({
    prompt_title = " Grep word",
    search = vim.fn.input("   Grep for word> ", vim.fn.expand("<cword>")),
    use_regex = true,
  })
  -- local jobopts = {
  -- entry_maker = function(entry)
  --   local _,_, filename, lnum, col, text = string.find(entry, "([^:]+):(%d+):(%d+):(.*)")

  --   local table = {
  --     ordinal = text,
  --     display = text,
  --   }

  --   return table
  -- end,
  -- }
  -- local rg = {"rg", "--line-number", "--column", "",  vim.fn.getcwd(0)}
  -- return pickers.new({
  --     finder = finders.new_oneshot_job(rg),
  --     sorter = sorters.get_generic_fuzzy_sorter(),
  --   }):find()
end

M.nvim_config = function()
  require("telescope.builtin").find_files({
    prompt_title = "  Nvim Config",
    cwd = "~/me/jeera-rice",
    layout_strategy = "horizontal",
    layout_config = { preview_width = 0.65, width = 0.75 },
    theme='ivy'
  })
end

M.jeera_rice = function()
  M.find_files({
    prompt_title = "  Jeera Rice",
    cwd = "~/me/jeera-rice",
    theme='ivy',
  });
end

M.file_explorer = function()
  require("telescope.builtin").file_browser({
    prompt_title = " File Browser",
    path_display = { "shorten" },
    cwd = "~",
    layout_strategy = "horizontal",
    layout_config = { preview_width = 0.65, width = 0.75 },
  })
end

M.list_sessions = function()
  require("session-lens").search_session()
end

-- WIP: do not use
M.debugger = function(opts)
  local results = {
    "Launch",
    "ToggleBreakpoint",
    "StepOver",
    "StepInto",
    "StepOut",
    "Restart",
    "Reset",
  }
  pickers.new(opts, {
    prompt_title = "vimspector debugger",
    finder = finders.new_table(results),
    sorter = require("telescope.sorters").get_generic_fuzzy_sorter({}),
    attach_mappings = function(_, map)
      -- Map "<cr>" in insert mode to the function, actions.set_command_line
      map("i", "<cr>", actions.set_command_line)
      return true
    end,
  }):find()
end

-- Docker Images
M.dockerImages = function()
  pickers.new({
    theme = "ivy",
    results_title = "Docker Images",
    finder = finders.new_oneshot_job({"docker", "images"}),
    sorter = sorters.get_fuzzy_file(),
    mappings = {
      n = {
        ["<C-d>"] = function(args) print(args) end,
      },
      i = {
        ["<C-d>"] = function(args) print(args) end,
      },
    },
  }):find()
end

return M
