-- hover.lua — Simplified hover and goto definition

-- [FZF-lua advanced docs](https://github.com/ibhagwan/fzf-lua/wiki/Advanced#fn_transform_cmd)

local import = require("plugins.doc-search-v2.pkg")
local preview = import("util.preview")
local awk_util = import("util.awk")

local M = {}

local hover_win = nil
local hover_buf = nil

local function close_hover()
  if hover_win and vim.api.nvim_win_is_valid(hover_win) then
    vim.api.nvim_win_close(hover_win, true)
  end
  if hover_buf and vim.api.nvim_buf_is_valid(hover_buf) then
    vim.api.nvim_buf_delete(hover_buf, { force = true })
  end
  hover_win = nil
  hover_buf = nil
end

local function open_float(opts)
  close_hover()
  local lines = {}
  local f = io.open(opts.filepath, "r")
  if not f then
    return
  end
  for line in f:lines() do
    table.insert(lines, line)
  end
  f:close()

  hover_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(hover_buf, 0, -1, false, lines)
  vim.bo[hover_buf].filetype = opts.filetype or "text"
  vim.bo[hover_buf].modifiable = false
  vim.bo[hover_buf].bufhidden = "wipe"

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.7)
  hover_win = vim.api.nvim_open_win(hover_buf, true, {
    relative = "editor",
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    title = opts.title and (" " .. opts.title .. " ") or nil,
    title_pos = "center",
  })

  if opts.target_line then
    vim.api.nvim_win_set_cursor(hover_win, { opts.target_line, 0 })
    vim.cmd("normal! zt")
  end

  local buf = hover_buf
  local filepath = opts.filepath
  vim.keymap.set("n", "q", close_hover, { buffer = buf })
  vim.keymap.set("n", "<Esc>", close_hover, { buffer = buf })
  vim.keymap.set("n", "<CR>", function()
    local cursor_line = vim.api.nvim_win_get_cursor(hover_win)[1]
    close_hover()
    vim.cmd("edit " .. vim.fn.fnameescape(filepath))
    vim.cmd(":" .. cursor_line)
    vim.cmd("normal! zz")
  end, { buffer = buf })
end

local function get_qualified_symbol()
  local cword = vim.fn.expand("<cword>")
  if cword == "" then
    return nil
  end
  local line = vim.fn.getline(".")
  local col = vim.fn.col(".")
  local word_start = col
  while word_start > 1 and line:sub(word_start - 1, word_start - 1):match("[%w_]") do
    word_start = word_start - 1
  end
  if word_start > 1 and line:sub(word_start - 1, word_start - 1) == "." then
    local dot_pos = word_start - 1
    local qual_end = dot_pos - 1
    local qual_start = qual_end
    while qual_start > 1 and line:sub(qual_start - 1, qual_start - 1):match("[%w_]") do
      qual_start = qual_start - 1
    end
    local qualifier = line:sub(qual_start, qual_end)
    if qualifier ~= "" then
      return { qualifier = qualifier, symbol = cword }
    end
  end
  return { symbol = cword }
end

local function build_find_cmd(lang, symbol_info)
  local dirs = lang.get_search_dirs()
  local pattern = lang.patterns.all
  local dir_paths = {}
  for _, d in ipairs(dirs) do
    table.insert(dir_paths, vim.fn.shellescape(d.path))
  end
  -- local awk_content = lang.get_awk_script(dirs)
  -- local awk_path = awk_util.to_file("hover_search", awk_content)

  local rg_filter
  if symbol_info.qualifier then
    rg_filter = symbol_info.qualifier .. "." .. symbol_info.symbol .. "\t"
  else
    rg_filter = "." .. symbol_info.symbol .. "\t"
  end

  return string.format(
    -- "rg -n --no-heading -e %s %s 2>/dev/null | awk -F: -f %s | rg -F %s",
    "rg -n --no-heading -e %s %s 2>/dev/null | rg -F %s",
    vim.fn.shellescape(pattern),
    table.concat(dir_paths, " "),
    -- vim.fn.shellescape(awk_path),
    vim.fn.shellescape(rg_filter)
  )
end

function M.goto_definition(lang)
  local symbol_info = get_qualified_symbol()
  if not symbol_info then
    return
  end
  local cmd = build_find_cmd(lang, symbol_info)
  vim.system(
    { "sh", "-c", cmd },
    { text = true },
    vim.schedule_wrap(function(result)
      if not result or result.stdout == "" then
        return
      end
      local matches = {}
      for line in result.stdout:gmatch("[^\n]+") do
        local parts = vim.split(line, "\t")
        if #parts >= 2 then
          local file, lnum = parts[2]:match("^([^:]+):(%d+)")
          if file and lnum then
            table.insert(matches, { file = file, line = tonumber(lnum), symbol = parts[1] })
          end
        end
      end
      if #matches == 0 then
        return
      end
      if #matches == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(matches[1].file))
        vim.cmd(":" .. matches[1].line)
        vim.cmd("normal! zz")
      else
        local fzf = require("fzf-lua")
        local items = {}
        for _, m in ipairs(matches) do
          table.insert(items, m.symbol .. "\t" .. m.file .. ":" .. m.line)
        end
        fzf.fzf_exec(items, {
          prompt = "Definitions > ",
          previewer = false,
          fzf_opts = {
            ["--delimiter"] = "\t",
            ["--with-nth"] = "1",
            ["--preview"] = preview.build(),
            ["--preview-window"] = "right:50%",
          },
          actions = {
            ["default"] = function(selected)
              local p = import("engine").parse_selection(selected)
              if p then
                vim.cmd("edit " .. vim.fn.fnameescape(p.file))
                vim.cmd(":" .. p.line)
                vim.cmd("normal! zz")
              end
            end,
          },
        })
      end
    end)
  )
end

function M.show(lang, search_query)
  search_query = search_query or vim.fn.expand("<cword>")

  local open_file = function(selected, mode)
    mode = mode or "vsplit"
    local file, line, col = string.match(selected[1], "^(.-):(%d+):(%d+)%s*≈")
    if file then
      if mode == "vsplit" then
        vim.cmd(":vsplit")
      elseif mode == "split" then
        vim.cmd(":split")
      elseif mode == "tab" then
        vim.cmd(":tabnew")
      end
      vim.cmd("edit " .. file)
      if line then 
        vim.cmd(":" .. line) 
      end
      vim.cmd("normal! zz")
    end
  end

  local fzf = require("fzf-lua")

  local opts =  {
    prompt = "Search> ",
    command_fn = function(args)
      return lang.get_search_command(table.concat(args, ""))
    end,

    search = search_query,
    -- query = search_query,
    no_esc = true,
    -- regex = true,
    rg_glob = true,
    formatter = false,
    file_icons = false,
    color_icons = false,

    -- fzf = {
    --   ["ctrl-g"] = "select-all+accept",
    -- },

    multiprocess = false,
    fzf_opts = {
      ["--delimiter"] = " ≈",
      ["--with-nth"] = "2..",
    },

    actions = {
      ["default"] = function(selected)
        open_file(selected)
      end,
      ["ctrl-g"] = function(selected)
        local q = fzf.get_last_query()
        local cmd_string = lang.get_search_command(q)

        local entries = {}

        local results = vim.system({ "sh", "-c", cmd_string }):wait()
        if results.code == 0 then
          entries = vim.split(results.stdout, "\n")
        end

        return fzf.fzf_exec(entries, {
          previewer = "builtin",
          fzf_opts = {
            ["--delimiter"] = " ≈",
            ["--with-nth"] = "2..",
          },
          actions = {
            ["default"] = function(selected)
              open_file(selected)
            end,
            ["ctrl-t"] = function(selected)
              open_file(selected, "tab")
            end,
            ["ctrl-v"] = function(selected)
              open_file(selected, "vsplit")
            end,
          },
        })
      end,
      ["ctrl-v"] = function(selected)
        open_file(selected, "vsplit")
      end,
      ["ctrl-f"] = function(selected)
        M.show(lang, lang.build_query("function", fzf.get_last_query()))
      end,
      ["ctrl-t"] = function(selected)
        M.show(lang, lang.build_query("type", fzf.get_last_query()))
      end,
      ["ctrl-r"] = function(selected)
        M.show(lang, lang.build_query("function_call", fzf.get_last_query()))
      end
    },
  }

  -- return fzf.fzf_live(function(args)
  --   return lang.get_search_command(table.concat(args, "") or search_query)
  -- end, opts)

  local fzf_internals = require("plugins.fzf.fzf-internals")
  return fzf_internals.live_grep_dynamic(opts)
  -- fzf_fn()
end

-- vim.keymap.set("n", "xx", function() M.show(import("lang.go"), "Getwd") end, { noremap = true, silent = true })

-- vim.keymap.set("n", "xy", function()
--   require("fzf-lua").live_grep({
--     actions = {
--       ["default"] = require("fzf-lua").actions.grep_lgrep,
--     },
--   }) 
-- end, { noremap = true, silent = true })
--
return M
