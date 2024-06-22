-- disabling builtin plugins

-- sourced from `https://nanotipsforvim.prose.sh/using-pcall-to-make-your-config-more-stable`
local function safeRequire(module)
  local ok, mod = pcall(require, module)
  if ok then
    return mod
  end
  print("error loading: ", module)
  -- vim.cmd.echo("Error loading " .. module)
end

if vim.g.vscode ~= nil then
  local opts = { noremap = true, silent = true }
  vim.cmd([[
    nnoremap s <Nop>
    nnoremap ss :w<CR>
  ]])
  -- vim.keymap.set({ "n", "v" }, "ss", ":w<CR>", opts)

  -- making splits
  vim.keymap.set("n", "si", ":vsplit<CR>", opts)
  vim.keymap.set("n", "sm", ":split<CR>", opts)

  -- only split
  vim.keymap.set("n", "sx", ":only<CR>", opts)
  vim.keymap.set("n", "s0", ":tabonly<CR>", opts)

  -- making splits
  vim.keymap.set("n", "scc", function()
    local f = vim.fn.expand("%:p")
    local from_project_root = f:sub(#vim.g.nxt.project_root_dir + 2)

    local lineNr = vim.fn.line(".")

    vim.fn.setreg("+", from_project_root .. ":" .. lineNr)
  end, { noremap = true, silent = true, desc = "Copy file path, including line number to system clipboard" })

  -- safeRequire("globals")
  -- safeRequire("settings")
  -- safeRequire("keymaps")
  return
end

vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1

vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1

vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1

vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_rplugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_shada_plugin = 1

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

safeRequire("globals")
safeRequire("settings")
safeRequire("theme")
safeRequire("autocmds")
safeRequire("keymaps")
safeRequire("plugins-lazy")
safeRequire("functions")
safeRequire("commands")

-- infinite redrawing fixes `neovim + tmux + kitty` as they run into some serious rendering issues
-- it might also be having some serious performance issues
-- local timer = vim.loop.new_timer()
-- if timer ~= nil then
--   timer:start(
--     1000,
--     500,
--     vim.schedule_wrap(function()
--       local currMode = vim.fn.mode()
--       if vim.bo.filetype ~= "" then
--         vim.cmd("redraw!")
--       end
--       if currMode == "i" then
--         vim.cmd("startinsert")
--       end
--
--       -- it is supposed to reload the file immediately if it is changed outside of neovim
--       vim.api.nvim_command("checktime")
--     end)
--   )
-- end
