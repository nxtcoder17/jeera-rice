local M = {}

--- Look up definition for word under cursor using fzf tags
function M.lookup_definition()
	local fzf = require("fzf-lua")

	-- Get the word under cursor (normal mode)
	local word = vim.fn.expand("<cword>")

	if word == "" then
		vim.notify("No word under cursor", vim.log.levels.WARN)
		return
	end

	-- Open fzf tags picker with ivy-style configuration
	fzf.tags({
		query = word,
		prompt = "Definition❯ ",
		winopts = {
			height = 0.35, -- ivy mode: small height
			width = 1, -- ivy mode: full width
			row = 1, -- ivy mode: bottom-aligned
			preview = {
				layout = "horizontal",
				horizontal = "right:50%",
			},
		},
		-- Default action (Enter) jumps to tag location
		-- fzf-lua handles this automatically
		previewer = "builtin",
	})
end

return M
