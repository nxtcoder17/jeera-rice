local function jump_next()
	return require("snippy").can_jump(1) and "<Plug>(snippy-next)" or ""
end

local function jump_prev()
	return require("snippy").can_jump(-1) and "<Plug>(snippy-previous)" or ""
end

local function expand_or_advance()
	return require("snippy").can_expand() and "<Plug>(snippy-expand)" or jump_next()
end

vim.keymap.set("i", "<C-k>", expand_or_advance, { expr = true, remap = true })
vim.keymap.set("s", "<C-k>", jump_next, { expr = true, remap = true })
vim.keymap.set({ "i", "s" }, "<C-j>", jump_prev, { expr = true, remap = true })
