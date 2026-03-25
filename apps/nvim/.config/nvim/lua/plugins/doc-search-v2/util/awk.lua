-- util/awk.lua — Shared AWK script builders (Simplified)

local M = {}

-- Temp file cache: written once per session, cleaned on VimLeave
local awk_files = {}

local cleanup_registered = false
local function ensure_cleanup()
  if cleanup_registered then return end
  cleanup_registered = true
  vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
      for _, path in pairs(awk_files) do os.remove(path) end
    end,
  })
end

-- Write awk script to temp file, return path. Cached per name.
function M.to_file(name, content)
  if awk_files[name] then return awk_files[name] end
  ensure_cleanup()
  local path = vim.fn.tempname() .. "_docsearch_" .. name .. ".awk"
  local f = io.open(path, "w")
  if not f then return nil end
  f:write(content); f:close()
  awk_files[name] = path
  return path
end

local function go_base()
  return [[
{
  file = $1; linenum = $2; content = $0
  sub(/^[^:]+:[^:]+:/, "", content); gsub(/ *\{.*$/, "", content)
  symbol = content; gsub(/^(func|type|const|var) +/, "", symbol)
  if (match(symbol, /^\([^)]+\) +/)) {
    recv = substr(symbol, RSTART, RLENGTH); method = substr(symbol, RSTART + RLENGTH)
    gsub(/^\(|\) *$/, "", recv); gsub(/^[^ ]+ +/, "", recv)
    symbol = recv "{}." method
  }
  gsub(/[ \t([].*$/, "", symbol)
]]
end

function M.go_simplified(modname, dirs)
  local case_blocks = {}
  for _, d in ipairs(dirs) do
    local label = d.prefix or ""
    if d.sublabel then label = label .. "(" .. d.sublabel .. ") " end
    local path_pattern = d.path:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "\\%1")
    table.insert(case_blocks, string.format(
      [[  if (file ~ /^%s/) {
    rel = file; sub(/^%s\/?/, "", rel); dir = rel; gsub(/\/[^\/]+$/, "", dir)
    if (dir == rel) dir = ""
    prefix = "%s"; pkg = (dir == "" ? "%s" : "%s/" dir)
  }]], path_pattern, path_pattern, label,
      (d.label == "workspace" and modname or (d.label == "stdlib" and "" or d.sublabel or "")),
      (d.label == "workspace" and modname or (d.label == "stdlib" and "" or d.sublabel or ""))
    ))
  end
  return go_base() .. table.concat(case_blocks, " else ") .. [[
  if (pkg != "") printf "%s%s.%s\t%s:%s\n", prefix, pkg, symbol, file, linenum
  else printf "%s%s\t%s:%s\n", prefix, symbol, file, linenum
}]]
end

function M.node_simplified(pkgname, dirs)
  return [[
{
  file = $1; linenum = $2; content = $0
  sub(/^[^:]+:[^:]+:/, "", content); gsub(/[{;].*$/, "", content); gsub(/\s*$/, "", content)
  symbol = content
  gsub(/^export\s+(default\s+)?/, "", symbol); gsub(/^declare\s+/, "", symbol); gsub(/^async\s+/, "", symbol)
  if (match(symbol, /^(function|class|interface|type|enum|namespace|const|let|var)\s+/)) {
    gsub(/^(function|class|interface|type|enum|namespace|const|let|var)\s+/, "", symbol)
    gsub(/\s*[:=\(\<].*$/, "", symbol); gsub(/\s+/, "", symbol)
    if (symbol != "") printf "%s\t%s:%s\n", symbol, file, linenum
  }
}]]
end

return M
