local lualine = require("lualine")

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand("%:p:h")
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local colors = {
  blue = "#80a0ff",
  cyan = "#79dac8",
  black = "#080808",
  white = "#c6c6c6",
  red = "#ff5189",
  violet = "#d183e8",
  grey = "#303030",
}

local iconLeft = "▓▒░"
local iconRight = "░▒▓"

local tabline = {
  iconLeft = "▒░",
  iconRight = "░▒",
  iconSlimLeft = "░",
  iconSlimRight = "░"
};


lualine.setup({
  options = {
    theme = "tokyonight",
    -- section_separators = { left = "", right = "" },
    -- section_separators = { left = "", right = "" },
    -- component_separators = { left = "", right = "" },
    section_separators = { left = iconLeft, right = iconRight },
    -- component_separators = { left = "░", right = "░" },
    -- component_separators = { left = "░", right = "░" },
    -- component_separators = { left = leftIcon, right = iconRight },
    -- component_separators = { left = iconLeft, right = iconRight },
    -- component_separators = { left = "", right = "" },
    -- component_separators = { left = " ", right = " " },
    component_separators = { left = tabline.iconSlimLeft, right = tabline.iconSlimRight },
  },

  tabline = {
    lualine_a = { 
      {
        "buffers",
        icons_enabled = false,
        section_separators = { left = tabline.iconSlimLeft, right = tabline.iconSlimRight }, 
        padding=0,
        fmt = function(str) 
          local current_buffer = vim.fn.expand('%a'):match("^.*/(.*)$")
          local c = str == string.format('%s', vim.fn.tabpagenr()) 
          return str == current_buffer and string.format("%s %s %s", iconLeft, str, iconRight) or string.format(' %s ', str)
        end,
        buffers_color = {
          -- this takes Highlight Groups
          active = 'lualine_a_normal', -- color for active buffer
          inactive = 'Comment', -- color for inactive buffer
        },
      },
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      { "tabs",
        mode=1,
        icons_enabled= true,
        section_separators = { left = "", right = "" },
        padding=0,
        fmt = function(str) 
          return ""
          -- return c and string.format("%s %s", str, iconRight) or str
          -- return string.format("%s %s %s",tabline.iconLeft, vim.fn.tabpagenr(), tabline.iconRight)
        end,
      },
    },
  },

  sections = {
    lualine_a = {
      { "mode", upper = true, icon = "▓▒░", padding = 0 },
    },
    lualine_b = {},
    lualine_c = {
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = " ", warn = " ", info = " " },
        color_error = colors.red,
        color_warn = colors.yellow,
        color_info = colors.cyan,
      },
      {
        "filename",
        icons_enabled = true,
        file_status = true,
        symbols = { modified = "  ", readonly = " [-]" },
      },
    },
    lualine_x = {
      {
        "diff",
        symbols = { added = " ", modified = " 柳", removed = "  " },
        color_added = colors.green,
        color_modified = colors.orange,
        color_removed = colors.red,
        condition = conditions.hide_in_width,
      },

      { "branch", icon = "" },
    },
    lualine_y = {},
    lualine_z = {
      {
        "location",
        icons_enabled = true,
        fmt = function(str)
          return string.format("%s%s", str, "░▒▓")
        end,
        -- icon = "░▒▓",
        padding = 0,
      },
    },
  },
  inactive_sections = {
    lualine_a = { "filename" },
    lualine_b = {},
    lualine_c = { "filetype" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  extensions = {},
})
