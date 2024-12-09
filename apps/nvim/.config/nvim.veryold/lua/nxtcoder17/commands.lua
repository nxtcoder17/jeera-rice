vim.api.nvim_create_user_command("BufDelOthers", function()
	require("close_buffers").wipe({ type = "other" })
end, { desc = "Wipe all buffers except the current focused" })

vim.api.nvim_create_user_command("BufDelNameless", function()
	require("close_buffers").wipe({ type = "nameless", glob = "*.lua" })
end, {
	desc = "Wipe all buffers matching the glob",
})
