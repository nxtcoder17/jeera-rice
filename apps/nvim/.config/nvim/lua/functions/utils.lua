local M = {}

local function new_logger(name, level)
	level = level or "debug"
	return require("plenary.log").new({
		plugin = name,
		level = level,
	})
end

local logger = new_logger("functions.utils")

-- author: justinmk source: https://github.com/neovim/neovim/pull/13896#issuecomment-1621702052
local function region_to_text(region)
	local text = ""
	local maxcol = vim.v.maxcol
	for line, cols in vim.spairs(region) do
		local endcol = cols[2] == maxcol and -1 or cols[2]
		local chunk = vim.api.nvim_buf_get_text(0, line, cols[1], line, endcol, {})[1]
		text = ("%s%s"):format(text, chunk)
	end
	return text
end

M.get_selection = function(opts)
	opts = opts or { debug = false }

	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true)
	local region = vim.region(0, "'<", "'>", vim.fn.visualmode(), true)
	local out = region_to_text(region)
	if opts.debug then
		print(out)
	end
	return out
end

M.new_logger = new_logger

M.base64_decode = function(text)
	text = text or M.get_selection()
	logger.debug("[base64_decode] decoding input: ", text)

	local ok, b64 = pcall(require, "base64")
	if not ok then
		logger.debug("base64 not installed")
	end

	local v = b64.decode(text)
	logger.debug("[base64_decode] decoded output:", v)

	if os.execute("command -v xclip") == 0 then
		os.execute(string.format("echo -n %s | xclip -sel clip", v))
	end
	return v
end

M.base64_encode = function(text)
	text = text or M.get_selection()
	logger.debug("[base64_encode] encoding input: ", text)

	local ok, b64 = pcall(require, "base64")
	if not ok then
		logger.debug("base64 not installed")
	end

	local v = b64.encode(text)
	logger.debug("[base64_encode] encoded output: ", v)
	if os.execute("command -v xclip") == 0 then
		os.execute(string.format("echo -n %s | xclip -sel clip", v))
	end
	return v
end

M.merge_tables = function(...)
	-- check if we have a table iterate over it, and insert it into a results table otherwise insert into a table
	local results = {}
	for _, t in ipairs({ ... }) do
		if type(t) == "table" then
			for k, v in pairs(t) do
				results[k] = v
			end
		else
			table.insert(results, t)
		end
	end

	return results
end

-- source chatgpt
M.system_call = function(cmd)
	local f = assert(io.popen(cmd, "r"))
	local s = assert(f:read("*a"))
	f:close()
	s = string.gsub(s, "^%s+", "")
	s = string.gsub(s, "%s+$", "")
	s = string.gsub(s, "[\n\r]+", "\n")
	return s
end

return M
