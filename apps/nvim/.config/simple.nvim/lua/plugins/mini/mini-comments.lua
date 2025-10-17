local lang_comments = {
	gotmpl = "{{- /* %s */}}",
	gowork = "// %s",
	terraform = "# %s",
	proto = "// %s",
	kdl = "// %s",
	gotexttmpl = "{{- /* %s */}}",
	gohtmltmpl = "{{- /* %s */}}",
	jsonc = "// %s",
	hyprlang = "# %s",
}

Require("mini.comment").setup({
	options = {
		custom_commentstring = function()
			local v = lang_comments[vim.bo.filetype]
			if v ~= nil then
				return v
			end
			return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
		end,
	},
	mappings = {
		comment = "s;",
		comment_visual = "s;",
		comment_line = "s;",
	},
})
