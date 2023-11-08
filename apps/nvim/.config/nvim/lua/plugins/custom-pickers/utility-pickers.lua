local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local themes = require("telescope.themes")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local utils = require("telescope.utils")

local Utils = require("functions.utils")

local M = {}

M.pick = function()
  local items = {
    { key = "base64 encode", value = Utils.base64_encode, desc = "encode selection to base64" },
    { key = "base64 decode", value = Utils.base64_decode, desc = "decode selection to string" },
  }

  local ivyCustomLayoutConfig = {
    bottom_pane = {
      height = 17,
    },
  }

  local m = {}
  for _, item in ipairs(items) do
    table.insert(m, {
      ordinal = item.key,
      display = item.key,
      value = item.value,
    })
  end

  pickers
      .new(
        themes.get_ivy({
          layout_config = ivyCustomLayoutConfig,
        }),
        {
          results_title = "Utility pickers",
          prompt_title = "Hub for utility pickers",
          finder = finders.new_table({
            results = m,
            entry_maker = function(x)
              return x
            end,
          }),
          sorter = sorters.get_fzy_sorter({}),
          attach_mappings = function(prompt_bufnr, map)
            return actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              selection.value()
            end)
          end,
        }
      )
      :find()
end

return M
