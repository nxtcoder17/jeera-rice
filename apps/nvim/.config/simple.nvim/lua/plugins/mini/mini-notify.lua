-- source :h mini.notify
local win_config = function()
  local has_statusline = vim.o.laststatus > 0
  local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
  return { anchor = 'SE', col = vim.o.columns, row = vim.o.lines - pad }
end

Require("mini.notify").setup({
	window = {
		config = win_config,
		winblend = 100,
	},
})

vim.notify = Require("mini.notify").make_notify({
	INFO = { duration = 2000 },
	ERROR = { duration = 2000 },
	WARN = { duration = 2000 },
})

