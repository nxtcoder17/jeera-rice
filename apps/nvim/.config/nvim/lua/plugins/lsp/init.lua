-- local min_severity = vim.diagnostic.severity.WARN
local min_severity = vim.diagnostic.severity.HINT

vim.diagnostic.config({
	underline = {
		severity = {
			min = min_severity,
			max = vim.diagnostic.severity.ERROR,
		},
	},
	-- virtual_text = {
	--   -- prefix = "☠ ",
	--   prefix = " ● ",
	--   severity = vim.diagnostic.severity.ERROR,
	--   only_current_line = true,
	-- },
	virtual_text = false,
	signs = {
		severity = {
			min = min_severity,
			max = vim.diagnostic.severity.ERROR,
		},
	},
	float = {
		source = "always",
		focusable = false,
		border = "single",
	},
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	-- delay update diagnostics
	update_in_insert = false,
})

local function on_attach(client, bufnr)
	local opts = { silent = true, buffer = bufnr, remap = false }

	-- if client.supports_method("textDocument/inlayHint") then
	--   vim.lsp.inlay_hint.enable(bufnr, true)
	-- end

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
		title = "",
	})

	if client ~= nil and client.server_capabilities ~= nil then
		-- client.server_capabilities.semanticTokensProvider = nil
		client.server_capabilities.semanticTokensProvider = false -- turn off semantic tokens
	end
	-- client.server_capabilities.semanticTokensProvider = nil

	-- vim.api.nvim_create_autocmd("CursorHold", {
	--   buffer = bufnr,
	--   callback = function()
	--     local float_opts = {
	--       focusable = false,
	--       close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
	--       border = "rounded",
	--       source = "always",
	--       prefix = " ",
	--       scope = "cursor",
	--     }
	--     vim.diagnostic.open_float(nil, float_opts)
	--   end,
	-- })

	vim.keymap.set("n", "sn", function()
		local severity = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severity.ERROR }
		local ft = vim.bo.filetype
		if ft == "typescript" or ft == "typescript.tsx" or ft == "typescriptreact" then
			severity.min = vim.diagnostic.severity.HINT
		end
		vim.diagnostic.goto_next({ severity = severity })
	end, opts)

	vim.keymap.set("n", "sp", function()
		local severity = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severity.ERROR }
		local ft = vim.bo.filetype
		if ft == "typescript" or ft == "typescript.tsx" or ft == "typescriptreact" then
			severity.min = vim.diagnostic.severity.HINT
		end
		vim.diagnostic.goto_prev({ severity = severity })
	end, opts)

	vim.keymap.set("n", "se", vim.diagnostic.open_float, opts)

	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set({ "n", "v" }, "<M-CR>", vim.lsp.buf.code_action, opts)
	-- vim.keymap.set("n", "f;", function()
	--   vim.lsp.buf.format({ async = false })
	-- end, opts)

	-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gr", "<Cmd>Fzf lsp_references<CR>", opts)
	-- vim.keymap.set("n", "gr", function()
	-- 	require("telescope.builtin").lsp_references({ include_current_line = false, show_line = false })
	-- end, opts)
	vim.keymap.set("n", "gd", "<Cmd>Fzf lsp_definitions jump_to_single_result=true<CR>", opts)
	vim.keymap.set("n", "gD", "<Cmd>Fzf lsp_typedefs<CR>", opts)
	vim.keymap.set("n", "gi", "<Cmd>Fzf lsp_implementations<CR>", opts)
	vim.keymap.set("n", "sr", vim.lsp.buf.rename, opts)
end

-- LSP signs default
local signs = { Error = "🔥", Warn = "🗯️", Hint = "⚡", Info = "»" }

for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- table.insert(vim.opt.runtimepath, vim.fn.stdpath("data") .. "/mason/bin")
vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.stdpath("data") .. "/mason/bin"

local function wrapper(...)
	local has_coq, coq = pcall(require, "coq")
	if has_coq then
		return coq.lsp_ensure_capabilities(...)
	end

	local has_cmp, cmp = pcall(require, "cmp")
	if has_cmp then
		return vim.tbl_deep_extend(
			"force",
			...,
			-- { capabilities = cmp.update_capabilities(vim.lsp.protocol.make_client_capabilities()) }
			{ capabilities = require("cmp_nvim_lsp").default_capabilities() }
		)
	end

	return ...
end

Require("plugins.lsp.languages.go").setup_lsp(on_attach, wrapper)
Require("plugins.lsp.languages.lua").setup_lsp(on_attach, wrapper)
Require("plugins.lsp.languages.typescript").setup_lsp(on_attach, wrapper)
Require("plugins.lsp.languages.deno").setup_lsp(on_attach, wrapper)
Require("plugins.lsp.languages.nix").setup_lsp(on_attach, wrapper)
Require("plugins.lsp.languages.python").setup_lsp(on_attach, wrapper)
Require("plugins.lsp.languages.docker").setup_lsp(on_attach, wrapper)
Require("plugins.lsp.languages.css").setup_lsp(on_attach, wrapper)
Require("plugins.lsp.languages.tailwindcss").setup_lsp(on_attach, wrapper)
Require("plugins.lsp.languages.terraform").setup_lsp(on_attach, wrapper)
Require("plugins.lsp.languages.bash").setup_lsp(on_attach, wrapper)
Require("plugins.lsp.languages.graphql").setup_lsp(on_attach, wrapper)
Require("plugins.lsp.languages.html").setup_lsp(on_attach, wrapper)
Require("plugins.lsp.languages.protobuf").setup_lsp(on_attach, wrapper)
Require("plugins.lsp.languages.htmx").setup_lsp(on_attach, wrapper)
Require("plugins.lsp.languages.sql").setup_lsp(on_attach, wrapper)

Require("plugins.lsp.linter-and-formatter").setup_lsp(on_attach, wrapper)
