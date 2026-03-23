-- hover.lua — Show ~30 lines from symbol definition in a floating window
--
-- Fast alternative to LSP hover: runs a targeted rg search for the symbol
-- under cursor, then displays the definition context in a float.

local import = require("plugins.doc-search-v2.pkg")
local preview = import("util.preview")

local M = {}


local hover_win = nil
local hover_buf = nil

-- Close any existing hover float
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

-- Open a float with the given lines, with syntax highlighting
-- opts = { filepath, filetype, title, target_line }
local function open_float(opts)
  close_hover()

  -- Read entire file
  local lines = {}
  local f = io.open(opts.filepath, "r")
  if not f then
    vim.notify("Cannot read: " .. opts.filepath, vim.log.levels.WARN)
    return
  end
  for line in f:lines() do
    table.insert(lines, line)
  end
  f:close()

  hover_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(hover_buf, 0, -1, false, lines)

  if opts.filetype then
    vim.bo[hover_buf].filetype = opts.filetype
  end
  vim.bo[hover_buf].modifiable = false
  vim.bo[hover_buf].bufhidden = "wipe"

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.7)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  hover_win = vim.api.nvim_open_win(hover_buf, true, {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    title = opts.title and (" " .. opts.title .. " ") or nil,
    title_pos = opts.title and "center" or nil,
  })

  -- Jump to target line at top of window
  if opts.target_line then
    vim.api.nvim_win_set_cursor(hover_win, { opts.target_line, 0 })
    vim.cmd("normal! zt")
  end

  local buf = hover_buf
  local filepath = opts.filepath
  vim.keymap.set("n", "q", close_hover, { buffer = buf, nowait = true })
  vim.keymap.set("n", "<Esc>", close_hover, { buffer = buf, nowait = true })
  vim.keymap.set("n", "<CR>", function()
    local cursor_line = vim.api.nvim_win_get_cursor(hover_win)[1]
    close_hover()
    vim.cmd("edit " .. vim.fn.fnameescape(filepath))
    vim.cmd(":" .. cursor_line)
    vim.cmd("normal! zz")
  end, { buffer = buf, nowait = true })

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = buf,
    once = true,
    callback = close_hover,
  })
end

-- Detect filetype from file extension
local function ft_from_ext(filepath)
  local ext = filepath:match("%.([^%.]+)$")
  local map = {
    go = "go",
    js = "javascript", jsx = "javascriptreact",
    ts = "typescript", tsx = "typescriptreact",
    mjs = "javascript", cjs = "javascript",
    lua = "lua",
  }
  return map[ext] or ext
end



-- Extract qualified symbol from cursor context (e.g., "time.Now" from `time.Now()`)
-- Returns { qualifier = "time", symbol = "Now" } or { symbol = "Now" } for bare symbols
local function get_qualified_symbol()
  local cword = vim.fn.expand("<cword>")
  if cword == "" then return nil end

  local line = vim.fn.getline(".")
  local col = vim.fn.col(".")

  -- Find where <cword> starts on the line
  local word_start = col
  while word_start > 1 and line:sub(word_start - 1, word_start - 1):match("[%w_]") do
    word_start = word_start - 1
  end

  -- Check if preceded by a dot
  if word_start > 1 and line:sub(word_start - 1, word_start - 1) == "." then
    -- Grab the word before the dot
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

-- Build search command across all scopes for a given language
-- Note: workspace scope already includes stdlib (for Go), so we skip standalone stdlib here
local function build_find_cmd(lang, symbol_info)
  local pattern = lang.patterns.all
  local cmds = {}

  -- Workspace (includes stdlib for Go)
  local ws_cmd = lang.build_cmd("workspace", pattern, {})
  if ws_cmd and ws_cmd ~= "echo ''" then
    table.insert(cmds, ws_cmd)
  end

  -- Dependencies
  local dep_cmd = lang.build_cmd("dep", pattern, {})
  if dep_cmd and dep_cmd ~= "echo ''" then
    table.insert(cmds, dep_cmd)
  end

  if #cmds == 0 then return nil end

  -- If we have a qualifier (e.g., time.Now), filter for "time.Now\t" (precise)
  -- Otherwise, filter for ".Symbol\t" (broad fallback)
  local rg_pattern
  if symbol_info.qualifier then
    rg_pattern = symbol_info.qualifier .. "." .. symbol_info.symbol .. '\t'
  else
    rg_pattern = "." .. symbol_info.symbol .. '\t'
  end

  return "{ " .. table.concat(cmds, "; ") .. '; } | rg -F "' .. rg_pattern .. '"'
end

-- Main hover function: find definition and show in float
function M.show(lang)
  if not lang then
    vim.notify("doc-search hover: no language adapter for this filetype", vim.log.levels.WARN)
    return
  end

  local symbol_info = get_qualified_symbol()
  if not symbol_info then return end

  local combined = build_find_cmd(lang, symbol_info)
  if not combined then
    vim.notify("No search commands available", vim.log.levels.WARN)
    return
  end
  local query = symbol_info.symbol

  vim.system({ "sh", "-c", combined }, { text = true }, vim.schedule_wrap(function(result)
    if not result or result.code ~= 0 or not result.stdout or result.stdout == "" then
      vim.notify("No definition found for: " .. query, vim.log.levels.INFO)
      return
    end

    -- Parse results
    local matches = {}
    for line in result.stdout:gmatch("[^\n]+") do
      local parts = vim.split(line, "\t")
      if #parts >= 2 then
        local file, lnum = parts[2]:match("^([^:]+):(%d+)")
        if file and lnum then
          table.insert(matches, {
            symbol = parts[1],
            file = file,
            line = tonumber(lnum),
          })
        end
      end
    end

    if #matches == 0 then
      vim.notify("No definition found for: " .. query, vim.log.levels.INFO)
      return
    end

    local match = matches[1]
    local filepath = match.file
    local ft = ft_from_ext(filepath)
    local title = match.symbol .. "  " .. filepath .. ":" .. match.line

    open_float({
      filepath = filepath,
      filetype = ft,
      title = title,
      target_line = match.line,
    })
  end))
end

-- Jump to definition: like hover but navigates to the file
function M.goto_definition(lang)
  if not lang then
    vim.notify("doc-search goto: no language adapter for this filetype", vim.log.levels.WARN)
    return
  end

  local symbol_info = get_qualified_symbol()
  if not symbol_info then return end

  local combined = build_find_cmd(lang, symbol_info)
  if not combined then return end
  local query = symbol_info.symbol

  vim.system({ "sh", "-c", combined }, { text = true }, vim.schedule_wrap(function(result)
    if not result or result.code ~= 0 or not result.stdout or result.stdout == "" then
      vim.notify("No definition found for: " .. query, vim.log.levels.INFO)
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
      vim.notify("No definition found for: " .. query, vim.log.levels.INFO)
      return
    end

    if #matches == 1 then
      -- Single match: jump directly
      local m = matches[1]
      vim.cmd("edit " .. vim.fn.fnameescape(m.file))
      vim.cmd(":" .. m.line)
      vim.cmd("normal! zz")
    else
      -- Multiple matches: use fzf to pick
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
            if not selected or #selected == 0 then return end
            local sel_parts = vim.split(selected[1], "\t")
            if #sel_parts >= 2 then
              local file, lnum = sel_parts[2]:match("^([^:]+):(%d+)")
              if file and lnum then
                vim.cmd("edit " .. vim.fn.fnameescape(file))
                vim.cmd(":" .. lnum)
                vim.cmd("normal! zz")
              end
            end
          end,
        },
      })
    end
  end))
end

return M
