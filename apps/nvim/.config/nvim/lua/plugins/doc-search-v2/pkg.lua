-- Package-scoped require: derives base path from own module name via `...`
-- Usage in any file within this package:
--   local import = require("plugins.doc-search-v2.pkg")
--   local cache  = import("cache")
--   local go     = import("lang.go")
local base = (...):gsub("%.pkg$", "")
return function(mod)
  return require(base .. "." .. mod)
end
