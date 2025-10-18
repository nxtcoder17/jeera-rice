local null_ls = require("null-ls")

-- local setup_mason = function()
-- 	local mr = Require("mason-registry")
--
-- 	local golang_tools = {
-- 		"gopls",
-- 		"gofumpt",
-- 		"delve",
-- 		"gotests",
-- 		"gomodifytags",
-- 		"impl",
-- 		"iferr",
-- 		"json-to-struct",
-- 	}
--
-- 	for _, item in ipairs(golang_tools) do
-- 		if not mr.is_installed(item) then
-- 			vim.cmd("MasonInstall " .. item)
-- 		end
-- 	end
-- end

Require("lspconfig").null_ls.setup()
null_ls.setup({
  sources = {
  	-- lua
    -- null_ls.builtins.formatting.stylua,
    -- null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.completion.spell,

		-- golang
		null_ls.builtins.diagnostics.staticcheck,
  },
})
