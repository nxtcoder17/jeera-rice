-- [source](https://nanotipsforvim.prose.sh/using-pcall-to-make-your-config-more-stable)
_G.Require = function(module)
	local ok, mod = pcall(require, module)
	if ok then
		return mod
	end
	print("ERROR while loading module: ", module)
end

--- reload any package
---@param pkg any
_G.Reload = function(pkg)
	package.loaded[pkg] = nil
	return Require(pkg)
end

--- pretty print for lua datastructures
_G.P = function(...)
	vim.print(vim.inspect(...))
end

-- INFO: neovim configuration directory
vim.g.nvim_dir = vim.fn.stdpath("config")

-- INFO: directory at which vim has been started
vim.g.project_root_dir = vim.fn.getcwd()
