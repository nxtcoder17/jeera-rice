home = os.getenv("HOME")
xdgDataHome = os.getenv("XDG_DATA_HOME")

localBinDir = home .. "/.local/bin"

jeeraRiceBin = os.getenv("HOME") .. "/me/jeera-rice/bin"

local xdgToPath = {
  xdgDataHome       .. "/node/bin",          -- npm/pnpm global packages
  xdgDataHome       .. "/go/bin",            -- go global packages
  home              .. '/.local/bin',        -- local bin
  home              .. "/me/jeera-rice/bin", -- jeera-rice bin
}

local stdlib = require('posix.stdlib')
print(table.concat(xdgToPath, ":"))
stdlib.setenv("PATH", table.concat(xdgToPath, ":"))
