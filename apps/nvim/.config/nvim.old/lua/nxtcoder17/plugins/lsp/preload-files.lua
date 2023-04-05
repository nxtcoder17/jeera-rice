local M = {}

M.preload_files = function(fileName, filetype)
	vim.lsp.buf_request(0, "textDocument/didOpen", {
		textDocument = {
			uri = vim.uri_from_fname(fileName),
			languageId = filetype,
			version = 1,
			-- text = text,
			-- contentChanges = {
			-- 	{
			-- 		range = {
			-- 			start = {
			-- 				line = 0,
			-- 				character = 0,
			-- 			},
			-- 			["end"] = {
			-- 				line = #lines,
			-- 				character = #lines[#lines],
			-- 			},
			-- 		},
			-- 		text = text,
			-- 	},
			-- },
		},
	}, function(err, result, ctx, config)
		vim.pretty_print(result)
	end)
end

return M
