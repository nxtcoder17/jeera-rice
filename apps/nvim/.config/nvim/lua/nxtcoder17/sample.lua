-- local trim = require("nxtcoder17.utils.strings")
--
-- local x = "/home/nxtcoder17/.config/hello"
-- local y = "/home/nxtcoder17/.config"
--
-- local z = x:gsub(y, "")
-- print(z)

-- local p = "jeera-rice/apps/nvim/.config/nvim/lua/nxtcoder17/autocmds.lua"
-- local root_dir = "jeera-rice/apps/nvim/.config/nvim"

local p = "jeera-rice-apps"
local root_dir = "jeera-rice"

-- local p = "/home/nxtcoder17/.config/hello"
-- local root_dir = "/home/nxtcoder17/.config"

-- local x = p:gsub("%f[%a]" .. root_dir .. "%f[%A]", "")
local x = vim.fn.substitute(p, root_dir, "", "g")
-- local x = p:gsub(root_dir, "")
print(x)
