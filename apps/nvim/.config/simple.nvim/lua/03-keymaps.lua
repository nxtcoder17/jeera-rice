local function desc(text)
	return {
		silent = true,
		noremap = true,
		desc = text,
	}
end

vim.keymap.set({ "n", "v" }, "s", "<Nop>", desc("free up the `s` key"))
vim.keymap.set({ "n" }, ";", ":", desc("make ; act as : in normal mode"))

vim.keymap.set({ "n" }, "j", "gj", desc("makes j work as expected with wrapped lines"))
vim.keymap.set({ "n" }, "k", "gk", desc("makes k work as expected with wrapped lines"))

vim.keymap.set("t", "<esc>", "<C-\\><C-N>", desc("escaping in terminal mode"))
vim.keymap.set({ "n", "x" }, "cc", '"+y', desc("copy to clipboard"))

-- buffers
vim.keymap.set({ "n" }, "ss", ":w<CR>", desc("save"))
vim.keymap.set("c", "wqa", "wa! | qa!", desc("save all and exit"))
vim.keymap.set("n", "<Esc>", ":nohls<CR>", desc("resets search highlights"))

-- splits
vim.keymap.set({ "n", "v" }, "si", ":vsplit<CR>", desc("vertically split current buffer"))
vim.keymap.set({ "n", "v" }, "sm", ":split<CR>", desc("horizontally split current buffer"))

vim.keymap.set("n", "sh", "<C-w>h<CR>", desc("focus left window split"))
vim.keymap.set("n", "sl", "<C-w>l<CR>", desc("focus right window split"))
vim.keymap.set("n", "sj", "<C-w>j<CR>", desc("focus down window split"))
vim.keymap.set("n", "sk", "<C-w>k<CR>", desc("focus up window split"))

vim.keymap.set({ "n" }, "<C-M-Left>", ":vertical resize -5<CR>", desc("resizes verically by -5 units"))
vim.keymap.set({ "n" }, "<C-M-Right>", ":vertical resize +5<CR>", desc("resizes verically by +5 units"))
vim.keymap.set({ "n" }, "<C-M-Up>", ":resize -5<CR>", desc("resizes horizontally by -5 units"))
vim.keymap.set({ "n" }, "<C-M-Down>", ":resize +5<CR>", desc("resizes horizontally by +5 units"))

-- windows
vim.keymap.set("n", "sx", ":only<CR>", desc("closes all other splits in current tab"))
vim.keymap.set("n", "<BS>", function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if not vim.api.nvim_win_is_valid(win) then
			return
		end

		local config = vim.api.nvim_win_get_config(win)
		if config and config.relative ~= "" then
			pcall(function()
				vim.api.nvim_win_close(win, true)
			end)
		end
	end

	vim.cmd("nohls")
end, desc("closes all the floating windows"))

-- tabs
vim.keymap.set("n", "s0", ":tabonly<CR>", desc("closes all other tabs"))
vim.keymap.set(
	"n",
	"tn",
	":tabnew<CR>|:windo tcd " .. vim.g.project_root_dir .. "<CR>",
	desc("creates an empty, new tab")
)

vim.keymap.set(
	"n",
	"te",
	"<cmd>tabedit % |:windo tcd " .. vim.g.project_root_dir .. "<CR>",
	desc("opens current buffer in a new tab")
)

-- local shift_ascii_codes = {
-- 	["!"] = 33, -- Shift + 1
-- 	['"'] = 34, -- Shift + 2
-- 	["#"] = 35, -- Shift + 3
-- 	["$"] = 36, -- Shift + 4
-- 	["%"] = 37, -- Shift + 5
-- 	["&"] = 38, -- Shift + 6
-- 	["'"] = 39, -- Shift + 7
-- 	["("] = 40, -- Shift + 8
-- 	[")"] = 41, -- Shift + 9
-- 	["*"] = 42, -- Shift + 0
-- 	["+"] = 43, -- Shift + =
-- 	[":"] = 58, -- Shift + ;
-- 	["<"] = 60, -- Shift + ,
-- 	[">"] = 62, -- Shift + .
-- 	["?"] = 63, -- Shift + /
-- 	["@"] = 64, -- Shift + 2 (on some keyboards)
-- 	["^"] = 94, -- Shift + 6
-- 	["_"] = 95, -- Shift + -
-- 	["|"] = 124, -- Shift + \
-- 	["~"] = 126, -- Shift + `
-- }

-- INFO: this is a hack to bind `Alt + Shift + {1-5}` to corresponding tabs in the editor, just for faster tab switching
for key, value in pairs({ "!", "@", "#", "$", "%" }) do
	vim.keymap.set({ "n", "v", "i" }, "<M-" .. value .. ">", function()
		local tabnr = vim.api.nvim_list_tabpages()[key]
		local win_id = vim.api.nvim_tabpage_get_win(tabnr)
		vim.api.nvim_set_current_win(win_id)
	end, desc(string.format("binds `Alt/Meta + Shift + %d` to tab %d", key, key)))
end

vim.cmd([[ cnoreabbrev cd lua require('plugins.fzf.my-actions.choose-tab-dir')()<CR>]])
