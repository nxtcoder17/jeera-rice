local M = {}

local function silent_require(module)
  local ok, mod = pcall(require, module)
  if not ok then
    -- print("failed to load " .. module)
    return
  end
  return mod
end

local function load_language(ft)
  local query_dir = vim.fn.stdpath("config") .. "/lua/languages/" .. ft
  if vim.fn.isdirectory(query_dir) == 0 then
    return
  end

  local base = "languages." .. ft

  -- try init.lua first
  silent_require(base .. ".init")
  silent_require(base .. ".setings")
  silent_require(base .. ".lsp")
  silent_require(base .. ".autocmds")
  silent_require(base .. ".dap")
  silent_require(base .. ".formatter")
  silent_require(base .. ".linter")

  -- -- load ALL .lua files in the module dir (optional)
  -- local lang_dir = vim.fn.stdpath("config") .. "/lua/languages/" .. ft
  --
  -- local files = vim.fn.glob(lang_dir .. "/*.lua", false, true)
  -- for _, file in ipairs(files) do
  -- 	local name = file:match("([^/]+)%.lua$")
  -- 	if name and name ~= "init" then
  -- 		Require(base .. "." .. name)
  -- 	end
  -- end

  -- load tree-sitter queries
  M.load_ts_queries(ft)
end

--- Load tree-sitter queries from languages/<ft>/queries/*.scm
function M.load_ts_queries(ft)
  local query_dir = vim.fn.stdpath("config") .. "/lua/languages/" .. ft .. "/tree-sitter"
  if vim.fn.isdirectory(query_dir) == 0 then
    return
  end

  local files = vim.fn.glob(query_dir .. "/*.scm", false, true)
  for _, file in ipairs(files) do
    local qtype = file:match("([^/]+)%.scm$")
    local content = table.concat(vim.fn.readfile(file), "\n")
    vim.treesitter.query.set(ft, qtype, content)
  end
end

local lang_alias = {
  ["bash"] = "sh",

  -- golang filetypes
  ["gotexttmpl"] = "go",
  ["gohtmltmpl"] = "go",

  -- javascript filetypes
  ["typescript"] = "javascript",

  ["javascriptreact"] = "javascript",
  ["javascript.jsx"] = "javascript",
  ["jsx"] = "javascript",

  ["typescriptreact"] = "javascript",
  ["typescript.tsx"] = "javascript",
  ["tsx"] = "javascript",

  ["deno"] = "javascript",
}

-- Auto-load on FileType
vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    if lang_alias[ev.match] ~= nil then
      load_language(lang_alias[ev.match])
      return
    end

    load_language(ev.match)
  end,
})

return M
