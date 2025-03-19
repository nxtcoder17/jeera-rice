local treesitter_buf = vim.api.nvim_create_augroup("autocmds", {
	clear = true,
})

-- vim.api.nvim_create_autocmd("BufReadPre", {
-- 	group = treesitter_buf,
-- 	callback = function()
-- 		vim.cmd("TSDisable highlight")
-- 	end,
-- })

-- vim.api.nvim_create_autocmd("BufWinEnter", {
-- 	group = treesitter_buf,
-- 	callback = function()
-- 		vim.defer_fn(function()
-- 			-- vim.cmd("TSEnable highlight")
-- 		end, 1000) -- Adjust delay if needed (100ms is usually fine)
-- 	end,
-- })
