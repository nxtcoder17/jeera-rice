local re = require("rex_pcre")
local M = {}

M.go_impl = function()
	d = vim.lsp.diagnostic.get_line_diagnostics()
	for _, v in ipairs(d) do
		if v.code == "InvalidTypeArg" then
			print(v.message)
			-- local i = re.match(v.message, "(%*?%w+) does not implement")
			-- local i = re.match(v.message, "([\\*?\\w]+) does not implement")
			local i = re.match(v.message, "([\\*\\w]+\\b) does not implement (\\b[\\*\\.\\w]+\\b)")
			print(i)
		end
	end
end

M.restore_tabs = function()
	local json = require("dkjson")
	local test = assert(io.open("/tmp/abc.txt", "r"))
	local tu = require("tabby.util")
	local s = test:read("*a")
	test:close()
	local tbl, pos, err = json.decode(s, 1, nil)
	print(vim.inspect(tbl), pos, err)
	for i, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
		-- tu.set_tab_name(tabnr, string.gsub(vim.cmd("pwd"), path, ""))
		-- local x = vim.fn.getcwd()
		-- x = re.gsub(x, ".*/", "")
		-- vim.cmd(string.format("TabRename %s", re.gsub(vim.fn.getcwd(), ".*/", "")))
		tu.set_tab_name(tabnr, re.gsub(vim.fn.getcwd(), ".*/", ""))
	end
end

M.save_tabs = function()
	local json = require("dkjson")
	local tu = require("tabby.util")
	local tbl = {}
	for i, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
		table.insert(tbl, tu.get_tab_name(tabnr))
	end
	local s = json.encode(tbl, { indent = true })
	print(s)
	local test = assert(io.open("/tmp/abc.txt", "w"))
	test:write(s)
	test:close()
end

M.x = function()
	local X = vim.fn.getcwd()
	re.gsub(X, ".*/", "")
end

return M
