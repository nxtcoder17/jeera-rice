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

Require("plugins.mini.mini-git")
Require("plugins.mini.mini-comments")
Require("plugins.mini.mini-hipatterns")
Require("plugins.mini.mini-statusline")
Require("plugins.mini.mini-sessions")
