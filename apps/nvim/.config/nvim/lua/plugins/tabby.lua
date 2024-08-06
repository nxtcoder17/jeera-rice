local colors = require("colors")

local function dark_theme()
  -- vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#000000", bg = "#698e91", bold = true })
  -- vim.api.nvim_set_hl(0, "TabLine", { fg = "#9da2a3", bg = "#4c6669", bold = false })

  local hl_bg = "#325158"
  local hl_fg = "#789cbf"
  local hl_selected_bg = "#68a0ad"
  local hl_selected_fg = "#053942"

  -- vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#a3b3b5", bg = "#283638", bold = false })
  -- vim.api.nvim_set_hl(0, "TabLine", { fg = "#a3b3b5", bg = "#0b2f33", bold = false })

  vim.api.nvim_set_hl(0, "TabLineSel", { fg = hl_selected_fg, bg = hl_selected_bg, bold = false })
  vim.api.nvim_set_hl(0, "TabLine", { fg = hl_fg, bg = hl_bg, bold = false })
end

local function light_theme()
  local hl_bg = "#bfe0e2"
  local hl_fg = "#356169"
  local hl_selected_bg = "#2e788c"
  local hl_selected_fg = "#daf1f3"

  -- vim.api.nvim_set_hl(0, "TabLineSel", {
  --   bg = colors.palette["bermuda-gray"]["200"],
  --   fg = colors.gel_pen_variants["blue-black"],
  --   bold = true,
  -- })
  --
  -- vim.api.nvim_set_hl(0, "TabLine", {
  --   fg = colors.gel_pen_variants["blue-black"],
  --   bg = colors.palette["bermuda-gray"]["50"],
  --   blend = 100,
  -- })

  vim.api.nvim_set_hl(0, "TabLineSel", {
    bg = hl_selected_bg,
    fg = hl_selected_fg,
    bold = true,
  })

  vim.api.nvim_set_hl(0, "TabLine", {
    fg = hl_fg,
    bg = hl_bg,
    blend = 100,
  })
end

if vim.o.background == "light" then
  light_theme()
else
  dark_theme()
end

-- require("tabby").setup()

local theme = {
  fill = "TabLineFill",
  -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
  head = "TabLine",
  current_tab = "TabLineSel",
  tab = "TabLine",
  win = "TabLine",
  tail = "TabLine",
}

require("tabby").setup({
  line = function(line)
    return {
      {
        -- { "  ", hl = theme.head },
        line.sep(" ", theme.head, theme.fill),
      },
      line.tabs().foreach(function(tab)
        local hl = tab.is_current() and theme.current_tab or theme.tab
        return {
          -- line.sep("", hl, theme.fill),
          -- line.sep("", hl, theme.fill),
          line.sep(" ", hl, theme.fill),
          -- tab.is_current() and "" or "󰆣",
          -- tab.number(),
          " " .. tab.name(),
          -- tab.close_btn(""),
          -- line.sep("", hl, theme.fill),
          line.sep("", hl, theme.fill),
          hl = hl,
          -- margin = " ",
        }
      end),
      line.spacer(),
      -- line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
      --   return {
      --     line.sep("", theme.win, theme.fill),
      --     win.is_current() and "" or "",
      --     win.buf_name(),
      --     line.sep("", theme.win, theme.fill),
      --     hl = theme.win,
      --     margin = " ",
      --   }
      -- end),
      -- {
      --   line.sep("", theme.tail, theme.fill),
      --   { "  ", hl = theme.tail },
      -- },
      hl = theme.fill,
    }
  end,
  -- option = {}, -- setup modules' option,
})
