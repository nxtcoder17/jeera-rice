local notify = Require("mini.notify")

notify.setup()

vim.notify = notify.make_notify({
	INFO = { duration = 3000 },
})
