-- cache.lua — Lazy, mtime-invalidated cache for syscall results
--
-- Nothing runs at require-time. All values computed on first access.
-- Cache is busted when the underlying file (go.mod, package.json) changes.

local M = {}

-- Internal store: { [key] = { value = ..., mtime = ..., watch_file = ... } }
local store = {}

-- Short-TTL store for rg+awk results: { [key] = { value = ..., expires = ... } }
local ttl_store = {}
local TTL_SECONDS = 30

-- Get file mtime (returns 0 if file doesn't exist)
local function get_mtime(filepath)
  if not filepath then return 0 end
  local stat = vim.uv.fs_stat(filepath)
  return stat and stat.mtime.sec or 0
end

-- Cached syscall: runs `fn()` once, caches result.
-- If `watch_file` is provided, re-runs when file mtime changes.
-- If `watch_file` is nil, caches forever (session-level).
function M.get(key, fn, watch_file)
  local entry = store[key]

  if entry then
    if not watch_file then
      return entry.value
    end
    local current_mtime = get_mtime(watch_file)
    if current_mtime == entry.mtime then
      return entry.value
    end
  end

  local value = fn()
  store[key] = {
    value = value,
    mtime = watch_file and get_mtime(watch_file) or 0,
  }
  return value
end

-- Short-TTL cache for expensive but frequently re-run operations
-- (e.g., rg+awk output when switching symbol types)
function M.get_ttl(key, fn)
  local entry = ttl_store[key]
  local now = vim.uv.now() / 1000 -- ms to seconds

  if entry and now < entry.expires then
    return entry.value
  end

  local value = fn()
  ttl_store[key] = {
    value = value,
    expires = now + TTL_SECONDS,
  }
  return value
end

-- Bust all caches (useful for manual refresh)
function M.clear()
  store = {}
  ttl_store = {}
end

-- Bust a specific key
function M.invalidate(key)
  store[key] = nil
  ttl_store[key] = nil
end

return M
