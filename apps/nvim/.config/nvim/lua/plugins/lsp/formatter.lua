local M = {}

M.setup_mason = function()
	local mr = require("mason-registry")

	local requirements = {
		"stylua",

		"black",

		"prettierd",
		"djlint",

		"alejandra",
	}

	for _, item in ipairs(requirements) do
		if not mr.is_installed(item) then
			vim.cmd("MasonInstall " .. item)
		end
	end
end

M.setup_formatters = function()
	Require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "black" },
			-- javascript = { "prettierd", stop_after_first = true },
			-- javascriptreact = { "prettierd", stop_after_first = true },
			html = { "prettierd" },
			gohtmltmpl = { "djlint" },
			nix = { "alejandra" },
		},

		formatters = {
			djlint = {
				prepend_args = {
					"--indent",
					2,
					"--max-attribute-length",
					3,
					"--line-break-after-multiline-tag",
				},
			},
		},
	})

	vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
end

return M
