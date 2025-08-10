local global = vim.api.nvim_create_augroup("autocmds", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
	group = global,
	callback = function()
		vim.cmd("set ft=terminal")
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = global,
	callback = function()
		vim.hl.on_yank({ higroup = "IncSearch", priority = 250, timeout = 200 })
	end,
})

vim.api.nvim_create_autocmd("BufRead", {
	group = global,
	pattern = "*",
	callback = function()
		vim.cmd(
			[[if &ft !~# 'commit\|rebase\|query\|Terminal\|toggleterm\|terminal\|TelescopePrompt\|TelescopeResult' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif"]]
		)
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	group = global,
	pattern = { os.getenv("HOME") .. "/.Xresources" },
	callback = function()
		os.execute(string.format("xrdb -merge %s", os.getenv("HOME") .. "/.Xresources"))
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = global,
	pattern = { "env", ".env" },
	callback = function()
		-- vim.diagnostic.disable(vim.fn.expand("<abuf>"))
		vim.diagnostic.enable(false)
	end,
})

-- vim.api.nvim_create_autocmd({ "BufNewFile" }, {
-- 	group = global,
-- 	callback = function()
-- 		vim.cmd(string.format("-1r %s/skeletons/%s.nix", vim.fn.stdpath("config"), vim.b.filetype))
-- 	end,
-- })

vim.api.nvim_create_autocmd({ "LspAttach" }, {
	group = global,
	pattern = "*",
	callback = function()
		--INFO: https://github.com/quangnguyen30192/cmp-nvim-tags/blob/main/README.md#troubleshooting
		vim.bo.tagfunc = nil
	end,
})

local function file_exists(name)
	local f = io.open(name, "r")
	return f ~= nil and io.close(f)
end

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	group = global,
	pattern = "*",
	callback = function()
		coroutine.wrap(function()
			local co = coroutine.running()
			if file_exists(string.format("%s/tags", vim.g.project_root_dir)) then
				require("plenary.job")
					:new({
						command = "bash",
						args = {
							"-c",
							"fd -t file --ignore-vcs --exclude tags -c never > /tmp/list.txt && ctags -L /tmp/list.txt",
						},
						cwd = vim.g.project_root_dir,
						-- on_exit = function(j, return_val)
						--   -- vim.print(j:result())
						--   -- print(return_val)
						--   for _, v in ipairs(j:result()) do
						--     print(v)
						--   end
						-- end,
					})
					:sync()
			end
			coroutine.yield()
		end)()
	end,
})

-- vim.api.nvim_create_autocmd({ "InsertEnter" }, {
-- 	group = global,
-- 	pattern = "*",
-- 	callback = function()
-- 		if vim.fn.exists(":TSBufDisable") > 0 then
-- 			vim.cmd("TSBufDisable highlight")
-- 		end
-- 	end,
-- })
--
-- vim.api.nvim_create_autocmd({ "InsertLeave" }, {
-- 	group = global,
-- 	pattern = "*",
-- 	callback = function()
-- 		if vim.b.no_ts_highlight == true then
-- 			return
-- 		end
-- 		if vim.fn.exists(":TSBufEnable") > 0 then
-- 			vim.cmd("TSBufEnable highlight")
-- 		end
-- 	end,
-- })

vim.api.nvim_create_autocmd("BufReadPost", {
	group = global,
	desc = "Go to the last location when opening a buffer",
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.cmd('normal! g`"zz')
		end
	end,
})
