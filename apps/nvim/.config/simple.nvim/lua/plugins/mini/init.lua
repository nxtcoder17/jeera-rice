package.path = package.path .. ';' .. debug.getinfo(1, "S").source:match("@?(.*/)") .. '?.lua'

Require("mini.pairs").setup({})

Require("mini.surround").setup({
	mappings = {
		add = "ys",
		delete = "ds",
		replace = "cs",
		find = "", -- Find surrounding (to the right)
		find_left = "", -- Find surrounding (to the left)
		highlight = "", -- Highlight surrounding
		update_n_lines = "", -- Update `n_lines`
	},
})

Require("mini.align").setup({})

Require("mini.git").setup()
Require("mini.sessions").setup()

Require("mini-comments")
Require("mini-notify")
Require("mini-patterns")
Require("mini-statusline")
