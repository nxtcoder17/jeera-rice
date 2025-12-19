local fzf = require("fzf-lua")

-- =============================================================================
-- Language Providers
-- Each provider implements:
--   categories()      -> { {name, icon, handler}, ... }
--   filetype          -> string
-- =============================================================================

local providers = {}

-- =============================================================================
-- Go Provider (using rg/fd for source jumping)
-- =============================================================================
providers.go = {
  filetype = "go",

  categories = function()
    return {
      { name = "Packages", icon = "󰏗", handler = providers.go.packages },
      { name = "Functions", icon = "", handler = providers.go.functions },
      { name = "Types", icon = "", handler = providers.go.types },
      { name = "Constants", icon = "", handler = providers.go.constants },
    }
  end,

  -- Helper: get package directory path
  get_pkg_dir = function(pkg, is_mod)
    if is_mod then
      local cache = vim.fn.systemlist("go env GOMODCACHE")[1] or ""
      return cache .. "/" .. pkg
    else
      local dir = vim.fn.systemlist("go list -f '{{.Dir}}' " .. pkg .. " 2>/dev/null")[1]
      return dir or ""
    end
  end,

  -- Get all packages (workspace + GOMODCACHE)
  packages = function()
    local items = {}

    -- Workspace packages (go list with directory)
    local workspace = vim.fn.systemlist("go list -f '{{.ImportPath}}:::{{.Dir}}' ./... 2>/dev/null")
    for _, line in ipairs(workspace) do
      if line ~= "" then
        local pkg, dir = line:match("^(.+):::(.+)$")
        if pkg and dir then
          table.insert(items, "[ws] " .. pkg .. "\t" .. dir)
        end
      end
    end

    -- GOMODCACHE packages
    local cache = vim.fn.systemlist("go env GOMODCACHE")[1] or ""
    if cache ~= "" then
      local cmd = string.format("fd -t d -d 4 '@v' '%s' 2>/dev/null | head -200", cache)
      local cached = vim.fn.systemlist(cmd)
      for _, path in ipairs(cached) do
        local pkg = path:gsub(cache .. "/", "")
        if pkg ~= "" then
          table.insert(items, "[mod] " .. pkg .. "\t" .. path)
        end
      end
    end

    fzf.fzf_exec(items, {
      prompt = "Packages ❯ ",
      previewer = false,
      fzf_opts = {
        ["--delimiter"] = "\t",
        ["--with-nth"] = "1",
        ["--preview"] = "tree -C -L 2 {2} 2>/dev/null || ls -la {2} 2>/dev/null",
      },
      actions = {
        ["default"] = function(selected)
          if not selected or #selected == 0 then return end
          local parts = vim.split(selected[1], "\t")
          local pkg_display = parts[1]:gsub("^%[[^%]]+%] ", "")
          local pkg_dir = parts[2]
          providers.go.package_symbols(pkg_display, pkg_dir)
        end,
        ["ctrl-y"] = function(selected)
          if not selected or #selected == 0 then return end
          local pkg = selected[1]:gsub("^%[[^%]]+%] ", ""):match("^[^\t]+")
          vim.fn.setreg("+", pkg)
          vim.notify("Yanked: " .. pkg)
        end,
      },
    })
  end,

  -- Show all symbols within a package (using rg)
  package_symbols = function(pkg, pkg_dir)
    local cmd = string.format(
      "cd '%s' && rg -n --no-heading '^(func |type |const |var )' --glob '*.go' --glob '!*_test.go' . 2>/dev/null | sed 's|^\\./||'",
      pkg_dir
    )

    fzf.fzf_exec(cmd, {
      prompt = pkg .. " ❯ ",
      previewer = false,
      fzf_opts = {
        ["--delimiter"] = ":",
        ["--nth"] = "3..",
        ["--preview"] = string.format(
          "bat --style=numbers --color=always --highlight-line {2} --line-range {2}: '%s/'{1} 2>/dev/null || cat -n '%s/'{1} | tail -n +{2} | head -30",
          pkg_dir, pkg_dir
        ),
        ["--preview-window"] = "right:30%",
        ["--header"] = "ctrl-f: funcs | ctrl-t: types | ctrl-c: consts | ctrl-g: all",
      },
      actions = {
        ["default"] = function(selected)
          if not selected or #selected == 0 then return end
          local file, line = selected[1]:match("^([^:]+):(%d+):")
          if file and line then
            local full_path = pkg_dir .. "/" .. file
            vim.cmd("edit " .. full_path)
            vim.cmd(":" .. line)
            vim.cmd("normal! zz")
          end
        end,
        ["ctrl-y"] = function(selected)
          if not selected or #selected == 0 then return end
          local content = selected[1]:match("^[^:]+:%d+:(.+)$")
          if content then
            vim.fn.setreg("+", content)
            vim.notify("Copied: " .. content)
          end
        end,
        ["ctrl-f"] = function() providers.go.functions(pkg_dir, pkg) end,
        ["ctrl-t"] = function() providers.go.types(pkg_dir, pkg) end,
        ["ctrl-c"] = function() providers.go.constants(pkg_dir, pkg) end,
        ["ctrl-g"] = function() providers.go.package_symbols(pkg, pkg_dir) end,
      },
    })
  end,

  -- Search functions (optionally within a specific directory)
  functions = function(dir, prompt)
    local base_dir = dir or "."
    local cmd = string.format(
      "cd '%s' && rg -n --no-heading '^func ' --glob '*.go' --glob '!*_test.go' . 2>/dev/null | sed 's|^\\./||'",
      base_dir
    )
    fzf.fzf_exec(cmd, {
      prompt = (prompt or "Functions") .. " ❯ ",
      previewer = false,
      fzf_opts = {
        ["--delimiter"] = ":",
        ["--nth"] = "3..",
        ["--preview"] = string.format(
          "bat --style=numbers --color=always --highlight-line {2} --line-range {2}: '%s/'{1} 2>/dev/null || cat -n '%s/'{1} | tail -n +{2} | head -30",
          base_dir, base_dir
        ),
        ["--preview-window"] = "right:30%",
        ["--header"] = dir and "ctrl-f: funcs | ctrl-t: types | ctrl-c: consts | ctrl-g: all" or nil,
      },
      actions = {
        ["default"] = function(selected)
          if not selected or #selected == 0 then return end
          local file, line = selected[1]:match("^([^:]+):(%d+):")
          if file and line then
            local full_path = dir and (base_dir .. "/" .. file) or file
            vim.cmd("edit " .. full_path)
            vim.cmd(":" .. line)
            vim.cmd("normal! zz")
          end
        end,
        ["ctrl-f"] = dir and function() providers.go.functions(dir, prompt) end or nil,
        ["ctrl-t"] = dir and function() providers.go.types(dir, prompt) end or nil,
        ["ctrl-c"] = dir and function() providers.go.constants(dir, prompt) end or nil,
        ["ctrl-g"] = dir and function() providers.go.package_symbols(prompt, dir) end or nil,
      },
    })
  end,

  -- Search types (optionally within a specific directory)
  types = function(dir, prompt)
    local base_dir = dir or "."
    local cmd = string.format(
      "cd '%s' && rg -n --no-heading '^type ' --glob '*.go' --glob '!*_test.go' . 2>/dev/null | sed 's|^\\./||'",
      base_dir
    )
    fzf.fzf_exec(cmd, {
      prompt = (prompt or "Types") .. " ❯ ",
      previewer = false,
      fzf_opts = {
        ["--delimiter"] = ":",
        ["--nth"] = "3..",
        ["--preview"] = string.format(
          "bat --style=numbers --color=always --highlight-line {2} --line-range {2}: '%s/'{1} 2>/dev/null || cat -n '%s/'{1} | tail -n +{2} | head -30",
          base_dir, base_dir
        ),
        ["--preview-window"] = "right:60%",
        ["--header"] = dir and "ctrl-f: funcs | ctrl-t: types | ctrl-c: consts | ctrl-g: all" or nil,
      },
      actions = {
        ["default"] = function(selected)
          if not selected or #selected == 0 then return end
          local file, line = selected[1]:match("^([^:]+):(%d+):")
          if file and line then
            local full_path = dir and (base_dir .. "/" .. file) or file
            vim.cmd("edit " .. full_path)
            vim.cmd(":" .. line)
            vim.cmd("normal! zz")
          end
        end,
        ["ctrl-f"] = dir and function() providers.go.functions(dir, prompt) end or nil,
        ["ctrl-t"] = dir and function() providers.go.types(dir, prompt) end or nil,
        ["ctrl-c"] = dir and function() providers.go.constants(dir, prompt) end or nil,
        ["ctrl-g"] = dir and function() providers.go.package_symbols(prompt, dir) end or nil,
      },
    })
  end,

  -- Search constants/vars (optionally within a specific directory)
  constants = function(dir, prompt)
    local base_dir = dir or "."
    local cmd = string.format(
      "cd '%s' && rg -n --no-heading '^(const |var )' --glob '*.go' --glob '!*_test.go' . 2>/dev/null | sed 's|^\\./||'",
      base_dir
    )
    fzf.fzf_exec(cmd, {
      prompt = (prompt or "Constants") .. " ❯ ",
      previewer = false,
      fzf_opts = {
        ["--delimiter"] = ":",
        ["--nth"] = "3..",
        ["--preview"] = string.format(
          "bat --style=numbers --color=always --highlight-line {2} --line-range {2}: '%s/'{1} 2>/dev/null || cat -n '%s/'{1} | tail -n +{2} | head -30",
          base_dir, base_dir
        ),
        ["--preview-window"] = "right:60%",
        ["--header"] = dir and "ctrl-f: funcs | ctrl-t: types | ctrl-c: consts | ctrl-g: all" or nil,
      },
      actions = {
        ["default"] = function(selected)
          if not selected or #selected == 0 then return end
          local file, line = selected[1]:match("^([^:]+):(%d+):")
          if file and line then
            local full_path = dir and (base_dir .. "/" .. file) or file
            vim.cmd("edit " .. full_path)
            vim.cmd(":" .. line)
            vim.cmd("normal! zz")
          end
        end,
        ["ctrl-f"] = dir and function() providers.go.functions(dir, prompt) end or nil,
        ["ctrl-t"] = dir and function() providers.go.types(dir, prompt) end or nil,
        ["ctrl-c"] = dir and function() providers.go.constants(dir, prompt) end or nil,
        ["ctrl-g"] = dir and function() providers.go.package_symbols(prompt, dir) end or nil,
      },
    })
  end,
}

-- =============================================================================
-- Lua Provider
-- =============================================================================
providers.lua = {
  filetype = "lua",

  categories = function()
    return {
      { name = "Modules", icon = "󰏗", handler = providers.lua.modules },
      { name = "Vim API", icon = "", handler = providers.lua.vim_api },
      { name = "Stdlib", icon = "󰢱", handler = providers.lua.stdlib },
    }
  end,

  modules = function()
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
            providers.lua.module_symbols(selected[1])
          end
        end,
      },
    })
  end,

  module_symbols = function(mod_name)
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
  end,

  vim_api = function()
    local modules = { "vim.api", "vim.fn", "vim.lsp", "vim.treesitter", "vim.diagnostic", "vim.keymap", "vim.fs", "vim.ui", "vim.iter", "vim.loader" }
    fzf.fzf_exec(modules, {
      prompt = "Vim API ❯ ",
      actions = {
        ["default"] = function(selected)
          if selected and #selected > 0 then
            providers.lua.vim_module_symbols(selected[1])
          end
        end,
      },
    })
  end,

  vim_module_symbols = function(mod_path)
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
  end,

  stdlib = function()
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
  end,
}

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

-- Make it available to providers
_G.show_doc_float = show_doc_float

-- =============================================================================
-- Filetype -> Provider mapping
-- =============================================================================
local filetype_map = {
  go = "go",
  lua = "lua",
}

local function doc_search_for_provider(provider)
  local cats = provider.categories()
  local items = {}
  local handler_map = {}

  for _, cat in ipairs(cats) do
    local display = cat.icon .. "  " .. cat.name
    table.insert(items, display)
    handler_map[display] = cat.handler
  end

  fzf.fzf_exec(items, {
    prompt = "DocSearch ❯ ",
    actions = {
      ["default"] = function(selected)
        if selected and #selected > 0 then
          local handler = handler_map[selected[1]]
          if handler then handler() end
        end
      end,
    },
  })
end


-- =============================================================================
-- Main Entry Point
-- =============================================================================
local function doc_search()
  local ft = vim.bo.filetype
  local provider_key = filetype_map[ft]
  local provider = provider_key and providers[provider_key]

  if not provider then
    -- Show language picker
    local choices = {}
    for key, prov in pairs(providers) do
      table.insert(choices, key)
    end
    fzf.fzf_exec(choices, {
      prompt = "Language ❯ ",
      actions = {
        ["default"] = function(selected)
          if selected and #selected > 0 and providers[selected[1]] then
            doc_search_for_provider(providers[selected[1]])
          end
        end,
      },
    })
    return
  end

  doc_search_for_provider(provider)
end

return doc_search
