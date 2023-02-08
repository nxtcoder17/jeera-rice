require("possession").setup({
	session_dir = vim.fn.stdpath("data") .. "possession",
	silent = true,
	load_silent = true,
	autosave = {
		current = true, -- or fun(name): boolean
		tmp = false, -- or fun(): boolean
		tmp_name = "tmp",
		on_load = true,
		on_quit = true,
	},
})
