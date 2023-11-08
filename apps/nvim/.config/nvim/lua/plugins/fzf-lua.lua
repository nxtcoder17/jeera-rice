local actions = require("fzf-lua.actions")

vim.api.nvim_set_hl(0, "FzfText", { fg = "#abb2bf", bg = "#282c34", bold = false })

local fzf = require("fzf-lua")
fzf.setup({
  "telescope",
  fzf_opts = {
    ["--layout"] = "reverse",
    ["--pointer"] = "👉",
  },
  file_icon_padding = " ",
  global_resume = true,
  global_resume_query = true,
  global_resume_prompt = "resume: ",

  -- global_files_prompt = "Files❯ ",

  hls = {
    border = "FzfLuaBorder",
    preview_border = "FzfLuaBorder",
    scrollborder_e = "FzfLuaBorder",
    scrollborder_f = "FzfLuaBorder",
    normal = "FzfText",
  },

  winopts = {
    preview = {
      -- layout = "vertical",
      horizontal = "right:40%",
    },
    height = 0.3, -- window height
    width = 1,  -- window width
    row = 1,    -- window row position (0=top, 1=bottom)
    col = 0.50, -- window col position (0=left, 1=right)
    border = {
      "╭",
      "─",
      "╮",
      "│",
      "╯",
      "─",
      "╰",
      "│",
    },
  },

  files = {
    prompt = "Files ❯ ",
    cwd_prompt = false,
    fzf_opts = {
      ["--no-separator"] = "",
      ["--no-scrollbar"] = "",
    },
  },

  actions = {
    buffers = {
      -- providers that inherit these actions:
      --   buffers, tabs, lines, blines
      ["default"] = actions.buf_edit,
      ["ctrl-s"] = actions.buf_split,
      ["ctrl-v"] = actions.buf_vsplit,
      ["ctrl-t"] = actions.buf_tabedit,
      ["ctrl-d"] = { actions.buf_del, actions.resume },
    },
  },
})

vim.api.nvim_set_hl(0, "FzfLuaBorder", { fg = "#282d36" })

local M = {}

M.files = function(dir)
  dir = dir or vim.loop.cwd()

  local fzf_opts = {}
  if dir ~= vim.g.nxt.project_root_dir then
    fzf_opts = {
      ["--header"] = string.format("'%s'", "📂 " .. dir:sub(#vim.g.nxt.project_root_dir + 2)),
    }
  end

  fzf.fzf_exec("rg --threads 3 --files --iglob !.git --hidden --sort path", {
    prompt = string.format("Files ❯ "),
    fzf_opts = fzf_opts,
    fn_transform = function(x)
      return fzf.make_entry.file(x, {
        file_icons = true,
        color_icons = true,
        strip_cwd_prefix = true,
      })
    end,
    cwd = dir,
    actions = {
      ["default"] = actions.file_edit,
      ["ctrl-s"] = actions.file_split,
      ["ctrl-v"] = actions.file_vsplit,
      ["ctrl-t"] = actions.file_tabedit,
      ["ctrl-q"] = actions.file_sel_to_qf,
      ["ctrl-f"] = function()
        if dir ~= vim.g.nxt.project_root_dir then
          return M.files(vim.g.nxt.project_root_dir)
        end
        return M.files()
      end,
    },
  })
end

M.only_tabs = function()
  local tab_names = {}
  local tab_name_to_win_id = {}

  for tabidx, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
    local win_id = vim.api.nvim_tabpage_get_win(tabnr)
    local tab_name = tabidx .. " [TAB] " .. require("tabby.util").get_tab_name(tabnr)
    table.insert(tab_names, tab_name)

    tab_name_to_win_id[tab_name] = win_id
  end

  fzf.fzf_exec(tab_names, {
    prompt = "Find Tabs ❯ ",
    actions = {
      -- Use fzf-lua builtin actions or your own handler
      ["default"] = function(selected, opts)
        local win_id = tab_name_to_win_id[selected[1]]
        vim.api.nvim_set_current_win(win_id)
      end,
      ["ctrl-d"] = function(selected, opts)
        vim.cmd("tabclose " .. selected[1])
      end,
    },
  })
end

M.dap_actions = function()
  local tab_names = {}
  local tab_name_to_win_id = {}

  for tabidx, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
    local win_id = vim.api.nvim_tabpage_get_win(tabnr)
    local tab_name = tabidx .. " [TAB] " .. require("tabby.util").get_tab_name(tabnr)
    table.insert(tab_names, tab_name)

    tab_name_to_win_id[tab_name] = win_id
  end

  fzf.fzf_exec(tab_names, {
    prompt = "DAP Actions ❯ ",
    actions = {
      -- Use fzf-lua builtin actions or your own handler
      ["default"] = function(selected, opts)
        local win_id = tab_name_to_win_id[selected[1]]
        vim.api.nvim_set_current_win(win_id)
      end,
      ["ctrl-d"] = function(selected, opts)
        vim.cmd("tabclose " .. selected[1])
      end,
    },
  })
end

vim.api.nvim_create_user_command("ReloadFzfLua", function()
  R("plugins.fzf-lua")
end, { nargs = 0 })

return M
