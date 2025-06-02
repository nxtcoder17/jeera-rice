-- [Copied from wincent's repository](https://github.com/wincent/wincent/blob/fee810b2be44c0ff399e5058250f989c67068008/aspects/nvim/files/.config/nvim/lua/wincent/foldtext.lua)

local middot = "·"
local raquo = "»"
local small_l = "ℓ"

-- Override default `foldtext()`, which produces something like:
--   +---  2 lines: source $HOME/.config/nvim/pack/bundle/opt/vim-pathogen/autoload/pathogen.vim--------------------------------
--
-- Instead returning:
--   »··[2ℓ]··: source $HOME/.config/nvim/pack/bundle/opt/vim-pathogen/autoload/pathogen.vim···································
--
function _G.foldtext()
	local line_count = vim.v.foldend - vim.v.foldstart + 1
	local lines = "[" .. line_count .. small_l .. "]"
	local first = vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, true)[1]
	local tabs = first:match("^%s*"):gsub(" +", ""):len()
	local spaces = first:match("^%s*"):gsub("\t", ""):len()
	local indent = spaces + tabs * vim.bo.tabstop
	local stripped = first:match("^%s*(.-)$")
	local prefix = raquo .. middot .. middot .. lines
	local suffix = ": "

	-- Can't usefully use string.len() on UTF-8.
	local prefix_len = tostring(line_count):len() + 6

	local dash_count = math.max(indent - prefix_len - string.len(suffix), 0)
	local dashes = string.rep(middot, dash_count)
	return prefix .. dashes .. suffix .. stripped
end

local logger = NewLogger("folds")

function MyFoldExpr(ln)
	local indent = vim.fn.indent(ln) / vim.opt.shiftwidth:get()

	-- local indent_t = vim.b.custom_fold_indent_level or 1
	local line = vim.fn.getline(ln)

	if line:match("^%s*$") then
		return "=" -- No folding for empty lines
	end

	-- logger.debug(string.format("line: %s, indent: %d", line, indent))

	if vim.b.custom_fold_indent_level ~= nil then
		local ct = vim.b.custom_fold_indent_level

		if indent < ct then
			return "0"
		elseif indent == ct then
			return string.format("%d", indent + 1)
		elseif indent > ct then
			return string.format("%d", ct - indent + 1)
		end
	end

	-- return "-1"
	return string.format("%d", indent)
end

-- start unfolded
vim.opt.foldlevelstart = 99 -- start buffer with all folds open
vim.opt.foldmethod = "indent"

-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "v:lua.MyFoldExpr(v:lnum)"

vim.opt.foldnestmax = 10
vim.opt.foldminlines = 1 -- Allow closing even 1-line folds.

vim.opt.foldtext = "v:lua.foldtext()"
