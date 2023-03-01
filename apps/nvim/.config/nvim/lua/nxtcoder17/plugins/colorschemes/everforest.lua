vim.g.everforest_background = "hard"
vim.g.everforest_better_performance = 1
vim.g.everforest_enable_italic = 1
vim.g.everforest_transparent_background = 2

vim.g.everforest_diagnostic_virtual_text = "colored"

-- palette source: (https://user-images.githubusercontent.com/58662350/214382274-0108806d-b605-4047-af4b-c49ae06a2e8e.png)
vim.g.everforest_colors_override = {
	-- ["bg0"] = { "#202020", "234" },
	-- ["bg2"] = { "#282828", "235" },
	["red"] = { "#ab8149", "237" },
	["bg_visual"] = { "#86bfb5", 238 },
}

vim.cmd("colorscheme everforest")
