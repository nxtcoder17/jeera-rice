local _, b64 = pcall(require, "base64")

local nutil_fns = require("functions.neovim-utils")

local logger = nutil_fns.new_logger("functions.strings")

local M = {}

M.trim = function(s)
  return s:gsub("^%s*(.-)%s*$", "%1")
end

-- **camel_case**, does transformation from
--   - `sample-word` to `sampleWord`
--   - `SampleWord` to `sampleWord`
M.camel_case = function(str)
  local camelCased = ""
  local wasSeparator = false
  for i = 1, #str do
    local char = str:sub(i, i)
    if not char:match("%a") then
      wasSeparator = true
    else
      camelCased = camelCased .. (wasSeparator and char:upper() or char)
      wasSeparator = false
    end
  end
  return camelCased
end

-- **snake_case**, does transformation from
-- - `sample-word` to `sample_word`
-- - `SampleWord` to `sample_word`
M.snake_case = function(str, opts)
  opts = opts or { all_lowercase = true, all_uppercase = false }
  local snakeCased = str:sub(1, 1)
  local prevChar = str:sub(1, 1)
  for i = 2, #str - 1 do
    local char = str:sub(i, i)
    local nextChar = str:sub(i + 1, i + 1)

    if not char:match("%u") and nextChar:match("%u") then
      snakeCased = snakeCased .. char .. "_"
    else
      snakeCased = snakeCased .. char
    end
  end

  snakeCased = snakeCased .. str:sub(#str, #str)

  if opts.all_uppercase then
    return string.upper(snakeCased)
  end
  return string.lower(snakeCased)
end

M.snake_case_all_lowercase = function(str)
  return M.snake_case(str, { all_lowercase = true })
end

M.snake_case_all_uppercase = function(str)
  return M.snake_case(str, { all_uppercase = true })
end

M.base64_decode = function(text)
  text = text or nutil_fns.get_selection()
  logger.debug("[base64_decode] decoding input: ", text)
  local v = b64.decode(text)
  logger.debug("[base64_decode] decoded output:", v)

  if os.execute("command -v xclip") == 0 then
    os.execute(string.format("echo -n %s | xclip -sel clip", v))
  end
  return v
end

M.base64_encode = function(text)
  text = text or nutil_fns.get_selection()
  logger.debug("[base64_encode] encoding input: ", text)
  local v = b64.encode(text)
  logger.debug("[base64_encode] encoded output: ", v)
  if os.execute("command -v xclip") == 0 then
    os.execute(string.format("echo -n %s | xclip -sel clip", v))
  end
  return v
end

return M
