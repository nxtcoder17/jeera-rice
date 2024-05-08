_G.R = function(pkg)
  package.loaded[pkg or "functions.utils"] = nil
  return require(pkg or "functions.utils")
end

_G.P = function(...)
  print(vim.inspect(...))
end

_G.Fn = function()
  return R("functions")
end

_G.signature = function(func)
  local info = debug.getinfo(func, "u")
  if info and info.nparams > 0 then
    local signature = funcname .. "("
    for i = 1, info.nparams do
      local paramName = debug.getlocal(func, i)
      signature = signature .. paramName
      if i < info.nparams then
        signature = signature .. ", "
      end
    end
    signature = signature .. ")"
    print(signature)
  else
    print("Function has no parameters.")
  end
end

-- _G.OffLoad = function(pkg)
--   if pkg ~= "" then
--     package.loaded[pkg] = nil
--     _G[pkg] = nil
--     print(string.format("pkg %s offload", pkg))
--   end
-- end

-- vim.opt.tabstop = 4
-- vim.opt.shiftwidth = 4
-- vim.opt.expandtab = true

--
vim.api.nvim_set_keymap("i", "<Tab>", [[pumvisible() ? "\<C-n>" : v:lua.smart_tab()]], { expr = true, noremap = true })

function _G.smart_tab()
  local col = vim.fn.col(".") - 1
  if vim.fn.getline("."):sub(1, col):match("^%s*$") then
    return "\t"
  else
    return string.rep(" ", vim.o.shiftwidth)
  end
end

-- require("functions.cmd")
