local lib = Require("plugins.colorschemes.lib")

vim.g.zenwritten = {
	italic_comments = true,

	lightness = "dim",
	darken_comments = 45,

	solid_line_nr = true,
	solid_vert_split = true,
}

vim.cmd.colorscheme("zenwritten")

lib.hl("Normal", { bg = "None" })
lib.hl("NormalNC", { bg = "None" })
lib.hl("LineNr", { bg = "None" })
lib.hl("SignColumn", { bg = "None" })
