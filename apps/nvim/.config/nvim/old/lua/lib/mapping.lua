local M = {}

-- local modes = {
-- 	"n",
-- 	"v",
-- 	"c",
-- 	"i",
-- 	"x",
-- 	"t",
-- 	"s",
-- 	"r",
-- }

function mergeOpts(dest, src)
	dest = dest or {}
	src = src or {}
	for k, v in ipairs(src)
	do
		dest[k] = v
	end
	return dest
end


-- iterate over lua table modes

-- for _, m in ipairs(modes) do
-- 	M[string.format("%smap", m)] = function(key, value, opts)
-- 		vim.api.nvim_set_keymap(m, key, value, mergeOpts({silent=true}, opts))
-- 		-- vim.api.nvim_set_keymap(m, key, value, {silent=true})
-- 	end

-- 	M[string.format("%snoremap", m)] = function(key, value, opts)
-- 		vim.api.nvim_set_keymap(m, key, value, mergeOpts({noremap=true, silent=true}, opts))
-- 	end
-- end

M.nnoremap = function(key, value, opts) 
	vim.api.nvim_set_keymap('n', key, value, mergeOpts({noremap= true, silent=true}, opts))
end

M.vnoremap = function(key, value, opts) 
	vim.api.nvim_set_keymap('v', key, value, mergeOpts({noremap= true, silent=true}, opts))
end

M.tnoremap = function(key, value, opts) 
	vim.api.nvim_set_keymap('t', key, value, mergeOpts({noremap= true, silent=true}, opts))
end

M.inoremap = function(key, value, opts) 
	vim.api.nvim_set_keymap('i', key, value, mergeOpts({noremap= true, silent=true}, opts))
end

M.cnoremap = function(key, value, opts) 
	vim.api.nvim_set_keymap('c', key, value, mergeOpts({noremap= true, silent=true}, opts))
end

-- M.vnoremap = M["vnoremap"]
-- M.tnoremap = M["tnoremap"]

M.nmap = function(key, value, opts) 
	vim.api.nvim_set_keymap('n', key, value, mergeOpts({silent=true}, opts))
end
M.vmap = function(key, value, opts) 
	vim.api.nvim_set_keymap('v', key, value, mergeOpts({silent=true}, opts))
end

-- M.nmap = M["nmap"]
-- M.vmap = M["vmap"]

M.unmap = function(key, mode)
	vim.api.nvim_del_keymap(mode, key)
end

M.resetKeys = function (...) 
	for _,v in ipairs({...}) do
		M.nnoremap(v, "")
		M.vnoremap(v, "")
	end
end

return M
