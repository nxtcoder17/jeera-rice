-- local sorters = require("telescope.sorters")
-- local conf = require("telescope.config").values

-- TODO: make this prompt use fzf filters
vim.api.nvim_create_user_command("Todo", function(opts)
	print(vim.inspect(opts))
	Require("fzf-lua").grep({ search = "TODO|HACK|NOTE|FIXME", no_esc = true })
end, {
	nargs = "*",
	complete = function(_arglead, _cmdline, _cursorpos)
		return { "TODO", "HACK", "NOTE", "FIXME" }
	end,
})

vim.api.nvim_create_user_command("InlayHintsToggle", function()
	vim.g.inlay_hints_enabled = not vim.g.inlay_hints_enabled
	print("Inlay hints " .. (vim.g.inlay_hints_enabled and "enabled" or "disabled"))
end, { nargs = 0 })

vim.api.nvim_create_user_command("Dragon", function(opts)
	vim.cmd("!dragon -x %")
end, { nargs = 0 })

vim.api.nvim_create_user_command("DeleteNameless", function()
	return Require("functions").delete_nameless()
end, { nargs = 0 })

vim.api.nvim_create_user_command("SignColumn", function(params)
	vim.opt.signcolumn = string.format("yes:%s", params.fargs[1])
	vim.cmd("e!")
end, { nargs = 1 })

-- creating scratch files
vim.api.nvim_create_user_command("Scratch", function()
	vim.cmd("vne | setlocal buftype=nofile | setlocal bufhidden=hide | setlocal noswapfile")
end, {})
