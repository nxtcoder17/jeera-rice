local null_ls = require("null-ls")
local api = vim.api

local no_really = {
	method = null_ls.methods.DIAGNOSTICS,
	filetypes = { "markdown", "text", "go" },
	generator = {
		fn = function(params)
			local diagnostics = {}
			-- sources have access to a params object
			-- containing info about the current file and editor state
			for i, line in ipairs(params.content) do
				local col, end_col = line:find("really")
				if col and end_col then
					-- null-ls fills in undefined positions
					-- and converts source diagnostics into the required format
					table.insert(diagnostics, {
						row = i,
						col = col,
						end_col = end_col,
						source = "no-really",
						message = "Don't use 'really!'",
						severity = 2,
					})
				end
			end
			return diagnostics
		end,
	},
}
null_ls.register(no_really)

local frozen_string_actions = {
	method = null_ls.methods.CODE_ACTION,
	filetypes = { "go" },
	generator = {
		fn = function(context)
			frozen_string_literal_comment = "# frozen_string_literal: true"
			first_line = context.content[1]

			if first_line ~= frozen_string_literal_comment then
				return {
					{
						title = "🥶Add frozen string literal comment",
						action = function()
							lines = { frozen_string_literal_comment, "", first_line }
							vim.api.nvim_buf_set_lines(context.bufnr, 0, 1, false, lines)
						end,
					},
				}
			end
		end,
	},
}

null_ls.register(frozen_string_actions)

local go_implement_interface = {
	method = null_ls.methods.CODE_ACTION,
	filetypes = { "go" },
	generator = {
		fn = function(context)
			d = vim.lsp.diagnostic.get_line_diagnostics()
			for _, v in ipairs(d) do
				if v.code == "InvalidTypeArg" then
					op = string.gsub(msg, "(.*(does not implement ))", "")
					op = string.gsub(op, "(( .missing method ).*)", "")
					print(v.message)
				end
			end
			return {
				{
					title = "Go Implement Interface",
				},
			}
		end,
	},
}

null_ls.register(go_implement_interface)

-- Configuring null-ls
null_ls.setup({
	sources = {
		-- eslint
		null_ls.builtins.diagnostics.eslint_d,
		null_ls.builtins.code_actions.eslint_d,
		null_ls.builtins.formatting.eslint_d,

		null_ls.builtins.formatting.stylua,

		-- null_ls.builtins.completion.spell,
		null_ls.builtins.code_actions.refactoring,
		-- null_ls.builtins.diagnostics.golangci_lint,

		null_ls.builtins.formatting.terraform_fmt,
	},
})

--[[ golangci-lint: (AUR) `yay golangci-lint` ]]
