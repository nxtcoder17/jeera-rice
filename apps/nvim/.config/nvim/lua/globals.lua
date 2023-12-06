-- vim.g.nxt is a global table that contains all the global variables, written by me
-- it is just a precaution to not pollute the global namespace
vim.g.nxt = {
  home = os.getenv("HOME"),
  project_root_dir = vim.fn.getcwd(), -- this is tab local directory
  nvim_dir = vim.fn.stdpath("config"),
  colors_ns_id = vim.api.nvim_create_namespace("colors"),
}

vim.api.nvim_set_hl_ns(vim.g.nxt.colors_ns_id)

vim.g.nxt_fns = {
  relative_from_project_root = function(dir)
    return dir:sub(#vim.g.nxt.project_root_dir + 2)
  end,

  is_light_theme = function()
    return vim.o.background == "light"
  end,
}

if vim.g.nxt_fns.is_light_theme() then
  vim.g.nxt_colors = {}
else
  vim.g.nxt_colors = {}
end
