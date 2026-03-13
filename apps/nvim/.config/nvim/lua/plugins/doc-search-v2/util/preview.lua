-- util/preview.lua — Shared preview command builders
--
-- Generates shell commands for fzf --preview.
-- All paths are properly quoted.

local M = {}

-- Standard preview: extract file:line from {2}, show with bat or cat fallback
-- prefix: optional base directory to prepend to file path
function M.build(prefix)
  if prefix then
    local p = vim.fn.shellescape(prefix)
    return string.format(
      'f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); bat --style=header,numbers --color=always --highlight-line "$l" --line-range "$l": %s/"$f" 2>/dev/null || { echo "-- %s/$f"; cat -n %s/"$f" | tail -n +"$l" | head -30; }',
      p, prefix, p
    )
  end
  return 'f=$(echo {2} | cut -d: -f1); l=$(echo {2} | cut -d: -f2); bat --style=header,numbers --color=always --highlight-line "$l" --line-range "$l": "$f" 2>/dev/null || { echo "-- $f"; cat -n "$f" | tail -n +"$l" | head -30; }'
end

-- Directory preview: show tree of directory (for package listing views)
function M.directory()
  return 'tree -C -L 2 {2} 2>/dev/null || ls -la {2} 2>/dev/null'
end

return M
