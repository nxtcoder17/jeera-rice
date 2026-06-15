local M = {}

local is_upper = Require("functions.strings").is_upper
local is_lower = Require("functions.strings").is_lower
local is_digit = Require("functions.strings").is_digit
local is_alnum = Require("functions.strings").is_alnum
local is_space = Require("functions.strings").is_space

local function is_separator(char)
  return char == "_" or char == "-"
end

local function is_boundary(prev, char, next)
  local prevIsDigit = is_digit(prev)

  if prevIsDigit ~= is_digit(char) then
    return true
  end

  if (is_lower(prev) or is_digit(prev)) and is_upper(char) then
    return true
  end

  return is_upper(prev) and is_upper(char) and next ~= "" and is_lower(next)
end

local function add_identifier_segments(segments, line, start_col, end_col)
  local segment_start = start_col

  for col = start_col + 1, end_col do
    local prev = line:sub(col - 1, col - 1)
    local char = line:sub(col, col)
    local next = line:sub(col + 1, col + 1)

    if is_boundary(prev, char, next) then
      table.insert(segments, { start_col = segment_start, end_col = col - 1 })
      segment_start = col
    end
  end

  table.insert(segments, { start_col = segment_start, end_col = end_col })
end

local function line_segments(line)
  local segments = {}
  local col = 1

  while col <= #line do
    local char = line:sub(col, col)

    if is_space(char) or is_separator(char) then
      col = col + 1
    elseif is_alnum(char) then
      local start_col = col

      while col <= #line and is_alnum(line:sub(col, col)) do
        col = col + 1
      end

      add_identifier_segments(segments, line, start_col, col - 1)
    else
      table.insert(segments, { start_col = col, end_col = col })
      col = col + 1
    end
  end

  return segments
end

local function get_line(lnum)
  return vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or ""
end

local function cursor_position()
  local pos = vim.api.nvim_win_get_cursor(0)
  return pos[1], pos[2] + 1
end

local function set_cursor(lnum, col)
  vim.api.nvim_win_set_cursor(0, { lnum, math.max(col - 1, 0) })
end

local function segment_at(lnum, col)
  for _, segment in ipairs(line_segments(get_line(lnum))) do
    if segment.start_col <= col and col <= segment.end_col then
      return segment
    end
  end
end

local function next_segment_position(lnum, col)
  local line_count = vim.api.nvim_buf_line_count(0)

  for current_lnum = lnum, line_count do
    local min_col = current_lnum == lnum and col or 0

    for _, segment in ipairs(line_segments(get_line(current_lnum))) do
      if segment.start_col > min_col then
        return current_lnum, segment.start_col
      end
    end
  end
end

local function previous_segment_position(lnum, col)
  for current_lnum = lnum, 1, -1 do
    local max_col = current_lnum == lnum and col or math.huge
    local target

    for _, segment in ipairs(line_segments(get_line(current_lnum))) do
      if segment.start_col < max_col then
        target = segment
      else
        break
      end
    end

    if target then
      return current_lnum, target.start_col
    end
  end
end

local function select_range(lnum, start_col, end_col)
  set_cursor(lnum, start_col)
  vim.cmd("normal! v")
  set_cursor(lnum, end_col)
end

local function text_object(inner)
  local lnum, col = cursor_position()
  local segment = segment_at(lnum, col)

  if not segment then
    return
  end

  local start_col = segment.start_col
  local end_col = segment.end_col

  if not inner then
    local line = get_line(lnum)

    while
      end_col < #line
      and (is_space(line:sub(end_col + 1, end_col + 1)) or is_separator(line:sub(end_col + 1, end_col + 1)))
    do
      end_col = end_col + 1
    end

    while end_col == segment.end_col and start_col > 1 do
      local char = line:sub(start_col - 1, start_col - 1)

      if not is_space(char) and not is_separator(char) then
        break
      end

      start_col = start_col - 1
    end
  end

  select_range(lnum, start_col, end_col)
end

function M.forward(count)
  local lnum, col = cursor_position()

  for _ = 1, count or vim.v.count1 do
    local next_lnum, next_col = next_segment_position(lnum, col)

    if not next_lnum then
      return
    end

    lnum, col = next_lnum, next_col
  end

  set_cursor(lnum, col)
end

function M.backward(count)
  local lnum, col = cursor_position()

  for _ = 1, count or vim.v.count1 do
    local prev_lnum, prev_col = previous_segment_position(lnum, col)

    if not prev_lnum then
      return
    end

    lnum, col = prev_lnum, prev_col
  end

  set_cursor(lnum, col)
end

function M.inner_word()
  text_object(true)
end

function M.a_word()
  text_object(false)
end

function M.change_word()
  local lnum, col = cursor_position()
  local segment = segment_at(lnum, col)

  if not segment then
    return
  end

  vim.api.nvim_buf_set_text(0, lnum - 1, col - 1, lnum - 1, segment.end_col, {})
  set_cursor(lnum, col)
  vim.cmd("startinsert")
end

function M.setup()
  vim.keymap.set({ "n", "x", "o" }, "w", function()
    M.forward(vim.v.count1)
  end, { silent = true, desc = "next camelCase word" })

  vim.keymap.set({ "n", "x", "o" }, "b", function()
    M.backward(vim.v.count1)
  end, { silent = true, desc = "previous camelCase word" })

  vim.keymap.set({ "x", "o" }, "iw", M.inner_word, { silent = true, desc = "inner camelCase word" })
  vim.keymap.set({ "x", "o" }, "aw", M.a_word, { silent = true, desc = "a camelCase word" })
  vim.keymap.set("n", "cw", M.change_word, { silent = true, desc = "change camelCase word" })
end

return M
