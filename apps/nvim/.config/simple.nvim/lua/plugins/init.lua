-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	{
		-- general purpose lua development utilities
		"nvim-lua/plenary.nvim",
		lazy = true,
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- lazy = true,
		event = "UIEnter",
		-- event = "Lazy",
		config = function()
			Require("plugins.fzf-lua")
			Require("plugins.fzf-lua.keymaps")
		end,
		-- cmd = {
		-- 	"Fzf",
		-- 	"FzfLua",
		-- },
		-- keys = { "sf", "cd", "f;" },
	},
	{
		"echasnovski/mini.nvim",
		-- event = "UIEnter",
		event = "BufReadPre",
		branch = "stable",
		config = function()
			require("plugins.mini")
		end,
	},

	{
		"nxtcoder17/http-cli",
		-- dir = "~/workspace/nxtcoder17/http-cli",
		build = "task build",
		cmd = {
			"Gql",
			"Http",
		},
		ft = "yaml",
		config = function()
			require("http-cli").setup({
				envFile = function()
					local v = os.getenv("HTTP_CLI_ENV")
					if v ~= "" then
						return v
					end

					local paths = {
						vim.fn.getcwd() .. "/.secrets/http-cli-env.yml",
						vim.g.project_root_dir .. "/.secrets/http-cli-env.yml",
					}

					for _, path in ipairs(paths) do
						if Require("functions.fs").exists(path) then
							return path
						end
					end
				end,
			})
		end,
	},

	{
		"kevinhwang91/rnvimr",
		cmd = {
			"RnvimrToggle",
		},
		keys = {
			{ "<M-o>", "<Cmd>RnvimrToggle<CR>", mode = "n" },
			{ "<M-o>", "<C-\\><C-n>:RnvimrToggle<CR>", mode = "t" },
		},
	},
}

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	ui = {
		border = "rounded",
	},

	spec = plugins,
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = false },
})
