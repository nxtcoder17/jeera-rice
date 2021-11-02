-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/nxtcoder17/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/nxtcoder17/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/nxtcoder17/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/nxtcoder17/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/nxtcoder17/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["bufdelete.nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/bufdelete.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua"
  },
  ["cmp-nvim-ultisnips"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/cmp-nvim-ultisnips"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/cmp-path"
  },
  ["cmp-spell"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/cmp-spell"
  },
  ["cmp-treesitter"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/cmp-treesitter"
  },
  ["cmp-vsnip"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/cmp-vsnip"
  },
  ["compe-tmux"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/compe-tmux"
  },
  ["crates.nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/crates.nvim"
  },
  everforest = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/everforest"
  },
  ["formatter.nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/formatter.nvim"
  },
  fzf = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/fzf"
  },
  ["fzf-lua"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/fzf-lua"
  },
  ["gitsigns.nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["gruvbox-material"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/gruvbox-material"
  },
  ["guihua.lua"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/guihua.lua"
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/impatient.nvim"
  },
  ["lsp-colors.nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/lsp-colors.nvim"
  },
  ["lsp-status.nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/lsp-status.nvim"
  },
  ["lsp_signature.nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/lsp_signature.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/lspkind-nvim"
  },
  ["lspsaga.nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/lspsaga.nvim"
  },
  ["lua-dev.nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/lua-dev.nvim"
  },
  ["lualine.nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/lualine.nvim"
  },
  ["lush.nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/lush.nvim"
  },
  ["navigator.lua"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/navigator.lua"
  },
  ["nord.nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/nord.nvim"
  },
  nordbuddy = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/nordbuddy"
  },
  ["nvim-autopairs"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/nvim-autopairs"
  },
  ["nvim-bqf"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/opt/nvim-bqf"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-compe"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/nvim-compe"
  },
  ["nvim-fzf"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/nvim-fzf"
  },
  ["nvim-hlslens"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/nvim-hlslens"
  },
  ["nvim-lsp-installer"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer"
  },
  ["nvim-lsp-ts-utils"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/nvim-lsp-ts-utils"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-treesitter-refactor"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/nvim-treesitter-refactor"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects"
  },
  ["nvim-ts-autotag"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/nvim-ts-autotag"
  },
  ["nvim-ts-context-commentstring"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/nvim-ts-context-commentstring"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  rnvimr = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/rnvimr"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim"
  },
  ["telescope-fzy-native.nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/telescope-fzy-native.nvim"
  },
  ["telescope-project.nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/telescope-project.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["trouble.nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/trouble.nvim"
  },
  ultisnips = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/ultisnips"
  },
  undotree = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/undotree"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/vim-commentary"
  },
  ["vim-dot-http"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/vim-dot-http"
  },
  ["vim-expand-region"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/vim-expand-region"
  },
  ["vim-kitty"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/vim-kitty"
  },
  ["vim-matchup"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/vim-matchup"
  },
  ["vim-polyglot"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/vim-polyglot"
  },
  ["vim-smoothie"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/vim-smoothie"
  },
  ["vim-startuptime"] = {
    commands = { "StartupTime" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/opt/vim-startuptime"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  ["vim-textobj-entire"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/vim-textobj-entire"
  },
  ["vim-textobj-function"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/vim-textobj-function"
  },
  ["vim-textobj-indent"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/vim-textobj-indent"
  },
  ["vim-textobj-line"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/vim-textobj-line"
  },
  ["vim-textobj-underscore"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/vim-textobj-underscore"
  },
  ["vim-textobj-user"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/vim-textobj-user"
  },
  ["vim-tmux-navigator"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/vim-tmux-navigator"
  },
  ["vim-visual-multi"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/vim-visual-multi"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/vim-vsnip-integ"
  },
  ["wilder.nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/wilder.nvim"
  },
  ["zenbones.nvim"] = {
    loaded = true,
    path = "/home/nxtcoder17/.local/share/nvim/site/pack/packer/start/zenbones.nvim"
  }
}

time([[Defining packer_plugins]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file StartupTime lua require("packer.load")({'vim-startuptime'}, { cmd = "StartupTime", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType qf ++once lua require("packer.load")({'nvim-bqf'}, { ft = "qf" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
