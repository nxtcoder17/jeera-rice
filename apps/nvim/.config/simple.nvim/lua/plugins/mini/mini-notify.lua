Require("mini.notify").setup()

vim.notify = Require("mini.notify").make_notify({
	INFO = { duration = 3000 },
})

