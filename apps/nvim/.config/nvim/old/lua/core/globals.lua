local global = {};

global.home = os.getenv("HOME")
global.root_dir = vim.fn.getcwd()
global.nvim_dir = vim.fn.stdpath("config")
return global;

