local M = {}

local logger = NewLogger("functions.utils")

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

M.base64_decode = function(text)
	text = text or M.get_selection()
	logger.debug("[base64_decode] decoding input: ", text)

	-- local ok, b64 = pcall(require, "base64")
	-- if not ok then
	--   logger.debug("base64 not installed")
	-- end

	-- local v = b64.decode(text)
	local v = vim.base64.decode(text)
	logger.debug("[base64_decode] decoded output:", v)

	vim.fn.setreg("+", v)

	-- if os.execute("command -v xclip") == 0 then
	-- 	os.execute(string.format("echo -n '%s' | xclip -sel clip", v))
	-- end
	return v
end

M.base64_encode = function(text)
	text = text or M.get_selection()
	logger.debug("[base64_encode] encoding input: ", text)

	-- local ok, b64 = pcall(require, "base64")
	-- if not ok then
	--   logger.debug("base64 not installed")
	-- end
	--
	-- local v = b64.encode(text)
	local v = vim.base64.encode(text)
	logger.debug("[base64_encode] encoded output: ", v)

	vim.fn.setreg("+", v)

	-- if os.execute("command -v xclip") == 0 then
	-- 	os.execute(string.format("echo -n %s | xclip -sel clip", v))
	-- end
	return v
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

M.open_selection_in_new_buffer = function()
	local selection = vim.fn.getreg("*")
	vim.cmd("enew")
	vim.cmd("setlocal buftype=nofile")
	vim.cmd("setlocal bufhidden=delete")
	vim.cmd("setlocal noswapfile")
	vim.cmd("setlocal nomodifiable")
	vim.cmd("setlocal readonly")
	vim.cmd("setlocal buftype=nofile")
	vim.cmd("setlocal bufhidden=delete")
end

return M
