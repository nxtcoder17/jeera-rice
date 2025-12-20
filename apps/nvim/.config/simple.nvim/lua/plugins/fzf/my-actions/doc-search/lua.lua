local fzf = require("fzf-lua")

local M = {}

-- =============================================================================
-- Helper: Show doc in floating window
-- =============================================================================
local function show_doc_float(title, lines, ft)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("filetype", ft, { buf = buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.min(#lines + 2, math.floor(vim.o.lines * 0.8))
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " " .. title .. " ",
    title_pos = "center",
  })

  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf })
  vim.keymap.set("n", "<esc>", "<cmd>close<cr>", { buffer = buf })
end

-- =============================================================================
-- Search Lua modules in runtime path
-- =============================================================================
function M.modules()
  local items = {}
  local seen = {}

  local rtp = vim.api.nvim_list_runtime_paths()
  for _, path in ipairs(rtp) do
    local lua_path = path .. "/lua"
    if vim.fn.isdirectory(lua_path) == 1 then
      local cmd = string.format("fd -t f -e lua -d 2 . '%s' 2>/dev/null", lua_path)
      local files = vim.fn.systemlist(cmd)
      for _, file in ipairs(files) do
        local mod = file:gsub(lua_path .. "/", ""):gsub("%.lua$", ""):gsub("/", ".")
        if mod ~= "" and not seen[mod] then
          seen[mod] = true
          table.insert(items, mod)
        end
      end
    end
  end

  fzf.fzf_exec(items, {
    prompt = "Modules ❯ ",
    actions = {
      ["default"] = function(selected)
        if selected and #selected > 0 then
          M.module_symbols(selected[1])
        end
      end,
    },
  })
end

-- =============================================================================
-- Show symbols within a module
-- =============================================================================
function M.module_symbols(mod_name)
  local ok, mod = pcall(require, mod_name)
  if not ok or type(mod) ~= "table" then
    vim.notify("Cannot load module: " .. mod_name, vim.log.levels.WARN)
    return
  end

  local items = {}
  for key, val in pairs(mod) do
    if type(key) == "string" and not key:match("^_") then
      table.insert(items, string.format("[%s] %s", type(val), key))
    end
  end

  fzf.fzf_exec(items, {
    prompt = mod_name .. " ❯ ",
    preview = function(selected)
      if not selected or #selected == 0 then return {} end
      local name = selected[1]:match("%] (.+)$")
      local val = mod[name]
      if type(val) == "function" then
        local info = debug.getinfo(val, "S")
        if info and info.source:sub(1, 1) == "@" then
          local filepath = info.source:sub(2)
          local start_line = info.linedefined or 1
          local end_line = info.lastlinedefined or start_line + 20
          local lines = vim.fn.readfile(filepath)
          local result = { "-- " .. filepath .. ":" .. start_line, "" }
          for i = math.max(1, start_line - 5), math.min(#lines, end_line) do
            table.insert(result, lines[i])
          end
          return result
        end
      end
      return { vim.inspect(val):sub(1, 1000) }
    end,
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then return end
        local name = selected[1]:match("%] (.+)$")
        local val = mod[name]
        if type(val) == "function" then
          local info = debug.getinfo(val, "S")
          if info and info.source:sub(1, 1) == "@" then
            vim.cmd("edit " .. info.source:sub(2))
            vim.cmd(":" .. (info.linedefined or 1))
            return
          end
        end
        show_doc_float(mod_name .. "." .. name, { vim.inspect(val) }, "lua")
      end,
    },
  })
end

-- =============================================================================
-- Browse Vim API modules
-- =============================================================================
function M.vim_api()
  local modules = { "vim.api", "vim.fn", "vim.lsp", "vim.treesitter", "vim.diagnostic", "vim.keymap", "vim.fs", "vim.ui", "vim.iter", "vim.loader" }
  fzf.fzf_exec(modules, {
    prompt = "Vim API ❯ ",
    actions = {
      ["default"] = function(selected)
        if selected and #selected > 0 then
          M.vim_module_symbols(selected[1])
        end
      end,
    },
  })
end

-- =============================================================================
-- Show symbols within a Vim module
-- =============================================================================
function M.vim_module_symbols(mod_path)
  local parts = vim.split(mod_path, ".", { plain = true })
  local mod = vim.tbl_get(_G, unpack(parts))
  if not mod or type(mod) ~= "table" then return end

  local items = {}
  for key, val in pairs(mod) do
    if type(key) == "string" and not key:match("^_") then
      table.insert(items, string.format("[%s] %s", type(val), key))
    end
  end

  fzf.fzf_exec(items, {
    prompt = mod_path .. " ❯ ",
    preview = function(selected)
      if not selected or #selected == 0 then return {} end
      local name = selected[1]:match("%] (.+)$")
      local help_topic = mod_path == "vim.fn" and name or (mod_path .. "." .. name):gsub("vim%.", "")
      return vim.fn.systemlist("nvim --headless -c 'try | help " .. help_topic .. " | catch | endtry' -c '%print' -c 'q!' 2>/dev/null")
    end,
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then return end
        local name = selected[1]:match("%] (.+)$")
        vim.cmd("help " .. name)
      end,
    },
  })
end

-- =============================================================================
-- Browse Lua standard library
-- =============================================================================
function M.stdlib()
  local libs = { "string", "table", "math", "io", "os", "coroutine", "debug", "package", "utf8" }
  fzf.fzf_exec(libs, {
    prompt = "Stdlib ❯ ",
    actions = {
      ["default"] = function(selected)
        if selected and #selected > 0 then
          local lib = _G[selected[1]]
          if type(lib) == "table" then
            local items = {}
            for k, v in pairs(lib) do
              table.insert(items, string.format("[%s] %s", type(v), k))
            end
            fzf.fzf_exec(items, {
              prompt = selected[1] .. " ❯ ",
              actions = {
                ["default"] = function(sel)
                  if sel and #sel > 0 then
                    local name = sel[1]:match("%] (.+)$")
                    show_doc_float(selected[1] .. "." .. name, { "-- C function: " .. selected[1] .. "." .. name }, "lua")
                  end
                end,
              },
            })
          end
        end
      end,
    },
  })
end

return M
