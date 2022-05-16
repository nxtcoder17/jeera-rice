local home = os.getenv("HOME")
local xdgDataHome = os.getenv("XDG_DATA_HOME")

local xdgToPath = {
	xdgDataHome .. "/node/bin", -- npm/pnpm global packages
	xdgDataHome .. "/go/bin", -- go global packages
	home .. "/.local/bin", -- local bin
	home .. "/me/jeera-rice/bin", -- jeera-rice bin
	home .. "/.local/tars.uz/go-1.18/bin",
}

-- local stdlib = require('posix.stdlib')
print(table.concat(xdgToPath, ":"))
-- stdlib.setenv("PATH", table.concat(xdgToPath, ":"))
