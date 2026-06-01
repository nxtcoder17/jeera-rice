-- engine.lua — Simplified search engine

local fzf = require("fzf-lua")
local import = require("plugins.doc-search-v2.pkg")
local preview = import("util.preview")
local awk_util = import("util.awk")

local M = {}

local function parse_selection(selected)
  if not selected or #selected == 0 then
    return nil
  end
  local parts = vim.split(selected[1], "\t")
  if #parts >= 2 then
    local file, line = parts[2]:match("^([^:]+):(%d+)")
    return { file = file, line = tonumber(line), symbol = parts[1] }
  end
  return nil
end

function M.search(opts)
  local lang = opts.lang
  local query = opts.query or lang.get_query_at_cursor()
  local dirs = lang.get_search_dirs()
  local pattern = lang.patterns.all

  -- Build directory list for rg
  local dir_paths = {}
  for _, d in ipairs(dirs) do
    table.insert(dir_paths, vim.fn.shellescape(d.path))
  end

  -- Create AWK script
  local awk_content = lang.get_awk_script(dirs)
  local awk_path = awk_util.to_file("engine_search", awk_content)

  -- Construct command
  local cmd = string.format(
    "rg -n --no-heading -e %s %s 2>/dev/null | awk -F: -f %s",
    vim.fn.shellescape(pattern),
    table.concat(dir_paths, " "),
    vim.fn.shellescape(awk_path)
  )

  local fzf_opts = {
    ["--delimiter"] = "\t",
    ["--with-nth"] = "1",
    ["--nth"] = "1",
    ["--preview"] = preview.build(),
    ["--preview-window"] = "right:50%",
  }
  if query and query ~= "" then
    fzf_opts["--query"] = query
  end

  fzf.fzf_exec(cmd, {
    prompt = "Symbols > ",
    previewer = false,
    fzf_opts = fzf_opts,
    actions = {
      ["default"] = function(selected)
        local parsed = parse_selection(selected)
        if not parsed then
          return
        end
        vim.cmd("edit " .. vim.fn.fnameescape(parsed.file))
        vim.cmd(":" .. parsed.line)
        vim.cmd("normal! zz")
      end,
    },
  })
end

M.parse_selection = parse_selection
return M
