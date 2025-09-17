-- [source](https://nanotipsforvim.prose.sh/using-pcall-to-make-your-config-more-stable)
_G.Require = function(module)
	local ok, mod = pcall(require, module)
	if ok then
		return mod
	end
	print("ERROR while loading module: ", module)
end

---@param pkg any
_G.R = function(pkg)
	package.loaded[pkg] = nil
	return Require(pkg)
end

---pretty print for lua datastructures
_G.P = function(...)
	vim.print(vim.inspect(...))
end

_G.NewLogger = function(name, level)
	level = level or "debug"
	return Require("plenary.log").new({
		plugin = name,
		level = level,

		outfile = require("plenary.path"):new(vim.fn.stdpath("cache"), "log", name .. ".log").filename,
	})
end

_G.bin_lookup = function(bin)
	local handle = io.popen("command -v " .. vim.fn.shellescape(bin) .. " 2>/dev/null")
	if not handle then
		return false
	end
	local result = handle:read("*a")
	handle:close()
	return result ~= ""
end

-- _G.Logger = _G.NewLogger("global-logger")

-- INFO: neovim configuration directory
vim.g.nvim_dir = vim.fn.stdpath("config")

-- INFO: directory at which vim has been started
vim.g.project_root_dir = vim.fn.getcwd()
