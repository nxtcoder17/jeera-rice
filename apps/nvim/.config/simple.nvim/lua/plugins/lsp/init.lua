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
		text = {
			[vim.diagnostic.severity.HINT] = "⚡",
			[vim.diagnostic.severity.INFO] = "»",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.ERROR] = "🔥",
		},
		-- linehl = {
		-- 	[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
		-- 	[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
		-- 	[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
		-- 	[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
		-- },
		numhl = {
			[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
			[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
			[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
			[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
		},
	},
	-- virtual_lines = {
	-- 	min = min_severity,
	-- 	max = vim.diagnostic.severity.ERROR,
	-- },
	float = {
		source = "always",
		focusable = false,
		border = "single",
	},
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.buf.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	-- delay update diagnostics
	update_in_insert = false,
})
