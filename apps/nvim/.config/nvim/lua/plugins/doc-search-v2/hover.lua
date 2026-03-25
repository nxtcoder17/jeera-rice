-- hover.lua — Simplified hover and goto definition

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

-- function M.show(lang)
--   local symbol_info = get_qualified_symbol()
--   if not symbol_info then
--     return
--   end
--   local cmd = build_find_cmd(lang, symbol_info)
--
--   vim.system(
--     { "sh", "-c", cmd },
--     { text = true },
--     vim.schedule_wrap(function(result)
--       if not result or result.stdout == "" then
--         return
--       end
--       local lines = vim.split(result.stdout, "\n")
--       local parts = vim.split(lines[1], "\t")
--       if #parts < 2 then
--         return
--       end
--       local file, lnum = parts[2]:match("^([^:]+):(%d+)")
--       if not (file and lnum) then
--         return
--       end
--       open_float({
--         filepath = file,
--         filetype = file:match("%.([^%.]+)$"),
--         title = parts[1],
--         target_line = tonumber(lnum),
--       })
--     end)
--   )
-- end

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

  local fzf = require("fzf-lua")

  fzf.fzf_exec(lang.get_search_command(search_query), {
    prompt = "Search > ",
    query = search_query,
    formatter = false,
    multiprocess = false,
    no_esc = true,
    regex = true,
    rg_glob = true,
    fzf_opts = {
      ["--delimiter"] = " ≈",
      ["--with-nth"] = "2..",
    },
    previewer = "builtin",
    actions = {
      ["default"] = function(selected)
        vim.print(vim.inspect(selected))
        vim.print(selected[1])
        local delimiter_pos = string.find(selected[1], " ≈", 1, true)
        if delimiter_pos then
          local path = string.sub(selected[1], 1, delimiter_pos - 1)
          vim.cmd("edit " .. path)
          vim.cmd("normal! zz")
        end
      end,
      ["ctrl-f"] = function(selected)
        vim.print(vim.inspect(selected))
        M.show(lang, lang.build_query("function", fzf.get_last_query()))
      end,
      ["ctrl-r"] = function(selected)
        M.show(lang, lang.build_query("function_call", fzf.get_last_query()))
      end
    },
  })

  -- fzf.live_grep({
  --   prompt = "Search > ",
  --   -- search = search_query,
  --   cmd = lang.get_search_command(search_query),
  --   -- debug = true,
  --   actions = {
  --     ["default"] = function(selected)
  --       local true_path = fzf.path.entry_to_file(selected[1])
  --       local p = import("engine").parse_selection(true_path)
  --       if p then
  --         vim.cmd("edit " .. vim.fn.fnameescape(p.file))
  --         vim.cmd(":" .. p.line)
  --         vim.cmd("normal! zz")
  --       end
  --     end,
  --     ["ctrl-f"] = function(selected)
  --       vim.print(vim.inspect(selected))
  --       M.show(lang, lang.build_query("function", fzf.get_last_query()))
  --     end,
  --     ["ctrl-r"] = function(selected)
  --       M.show(lang, lang.build_query("function_call", fzf.get_last_query()))
  --     end
  --   },
  -- })
end

-- function M.show(lang, search_query)
--   local search_result = lang.get_search_dirs()
--   local dirs, pretty_path = search_result[1], search_result[2]
--   search_query = search_query or vim.fn.expand("<cword>")
--
--   local fzf = require("fzf-lua")
--
--   fzf.live_grep({
--     prompt = "Search > ",
--     cmd = lang.get_search_command(),
--   })
--
--
--   fzf.live_grep({
--     prompt = "Search > ",
--     -- search = search_query,
--     -- search_paths = dirs,
--     cmd = string.format([[
--       rg --column --line-number --no-heading --color=always --smart-case -t go -e '%s' %s | sed 's/'
--     ]], search_query, dirs),
--     -- rg_glob = true,
--     -- rg_opts = "--column --line-number --no-heading --color=always --smart-case -e",
--     formatter = false, -- REQUIRED to stop internal formatting
--     -- multiline = true,
--     -- formatter = {"path.filename_first", 2},
--     -- multiprocess = false,
--     -- fn_transform = function(entry)
--     --   local file, line_num, col, rest = entry:match("^([^:]+):(%d+):(%d+):%s*(.*)$")
--     --   if file then
--     --     local display = string.format(
--     --       "%s:%s:%s: %s",
--     --       pretty_path(file),
--     --       line_num,
--     --       col,
--     --       rest
--     --     )
--     --     -- Embed original as field 1, display as field 2
--     --     return entry .. "≈" ..  display
--     --     -- return FzfLua.make_entry.file(entry, { file_icons = true, color_icons = true }) .. "\0" .. display
--     --   end
--     --   return entry
--     -- end,
--     -- fzf_opts = {
--     --   ["--delimiter"] = "≈",
--     --   ["--with-nth"] = "2..",
--     -- },
--     actions = {
--       ["default"] = function(selected)
--         local true_path = fzf.path.entry_to_file(selected[1])
--         local p = import("engine").parse_selection(true_path)
--         if p then
--           vim.cmd("edit " .. vim.fn.fnameescape(p.file))
--           vim.cmd(":" .. p.line)
--           vim.cmd("normal! zz")
--         end
--       end,
--       ["ctrl-f"] = function(selected)
--         vim.print(vim.inspect(selected))
--         M.show(lang, lang.build_query("function", fzf.get_last_query()))
--       end,
--       ["ctrl-r"] = function(selected)
--         M.show(lang, lang.build_query("function_call", fzf.get_last_query()))
--       end
--     },
--   })
-- end

return M
