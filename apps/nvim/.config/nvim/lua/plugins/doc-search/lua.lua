local fzf = require("fzf-lua")

local M = {}

-- =============================================================================
-- Helpers
-- =============================================================================
local function get_query(opts)
  return opts and opts.__call_opts and opts.__call_opts.query or ""
end

local function get_query_at_cursor()
  local cword = vim.fn.expand("<cword>")
  return cword ~= "" and "'" .. cword or nil
end

-- =============================================================================
-- Collect all vim.api functions
-- =============================================================================
local function get_vim_api_functions()
  local items = {}
  for name, val in pairs(vim.api) do
    if type(val) == "function" and not name:match("^_") then
      table.insert(items, "vim.api." .. name .. "\t" .. name)
    end
  end
  table.sort(items)
  return items
end

-- =============================================================================
-- Collect all vim.fn functions
-- =============================================================================
local function get_vim_fn_functions()
  local items = {}
  -- Get function list from vim
  local funcs = vim.fn.getcompletion("", "function")
  for _, name in ipairs(funcs) do
    -- Filter to built-in functions (not user-defined)
    if not name:match(":") and not name:match("^<") then
      table.insert(items, "vim.fn." .. name .. "\t" .. name)
    end
  end
  return items
end

-- =============================================================================
-- Collect vim.lsp functions
-- =============================================================================
local function get_vim_lsp_functions()
  local items = {}
  local function collect(prefix, tbl)
    for name, val in pairs(tbl) do
      if type(val) == "function" and type(name) == "string" and not name:match("^_") then
        local full = prefix .. "." .. name
        table.insert(items, full .. "\t" .. "lsp-" .. name)
      elseif type(val) == "table" and type(name) == "string" and not name:match("^_") then
        collect(prefix .. "." .. name, val)
      end
    end
  end
  collect("vim.lsp", vim.lsp)
  table.sort(items)
  return items
end

-- =============================================================================
-- Collect Lua stdlib functions
-- =============================================================================
local stdlib_docs = {
  -- string functions
  ["string.byte"] = "string.byte(s [, i [, j]]) - Returns internal numeric codes",
  ["string.char"] = "string.char(...) - Returns string from numeric codes",
  ["string.dump"] = "string.dump(function) - Returns binary representation",
  ["string.find"] = "string.find(s, pattern [, init [, plain]]) - Find pattern in string",
  ["string.format"] = "string.format(formatstring, ...) - Format string (like printf)",
  ["string.gmatch"] = "string.gmatch(s, pattern) - Iterator over pattern matches",
  ["string.gsub"] = "string.gsub(s, pattern, repl [, n]) - Global substitution",
  ["string.len"] = "string.len(s) - Returns length of string",
  ["string.lower"] = "string.lower(s) - Returns lowercase string",
  ["string.match"] = "string.match(s, pattern [, init]) - Find pattern, return captures",
  ["string.rep"] = "string.rep(s, n [, sep]) - Repeat string n times",
  ["string.reverse"] = "string.reverse(s) - Reverse string",
  ["string.sub"] = "string.sub(s, i [, j]) - Substring from i to j",
  ["string.upper"] = "string.upper(s) - Returns uppercase string",
  -- table functions
  ["table.concat"] = "table.concat(list [, sep [, i [, j]]]) - Concatenate list elements",
  ["table.insert"] = "table.insert(list, [pos,] value) - Insert element into list",
  ["table.remove"] = "table.remove(list [, pos]) - Remove element from list",
  ["table.sort"] = "table.sort(list [, comp]) - Sort list in-place",
  ["table.unpack"] = "table.unpack(list [, i [, j]]) - Unpack list to multiple values",
  ["table.pack"] = "table.pack(...) - Pack arguments into table with n field",
  ["table.move"] = "table.move(a1, f, e, t [,a2]) - Move elements between tables",
  -- math functions
  ["math.abs"] = "math.abs(x) - Absolute value",
  ["math.acos"] = "math.acos(x) - Arc cosine in radians",
  ["math.asin"] = "math.asin(x) - Arc sine in radians",
  ["math.atan"] = "math.atan(y [, x]) - Arc tangent in radians",
  ["math.ceil"] = "math.ceil(x) - Round up to integer",
  ["math.cos"] = "math.cos(x) - Cosine of x (radians)",
  ["math.deg"] = "math.deg(x) - Convert radians to degrees",
  ["math.exp"] = "math.exp(x) - e^x",
  ["math.floor"] = "math.floor(x) - Round down to integer",
  ["math.fmod"] = "math.fmod(x, y) - Remainder of x/y",
  ["math.huge"] = "math.huge - Infinity value",
  ["math.log"] = "math.log(x [, base]) - Logarithm",
  ["math.max"] = "math.max(x, ...) - Maximum value",
  ["math.min"] = "math.min(x, ...) - Minimum value",
  ["math.modf"] = "math.modf(x) - Integer and fractional parts",
  ["math.pi"] = "math.pi - Value of pi",
  ["math.rad"] = "math.rad(x) - Convert degrees to radians",
  ["math.random"] = "math.random([m [, n]]) - Random number",
  ["math.randomseed"] = "math.randomseed(x) - Set random seed",
  ["math.sin"] = "math.sin(x) - Sine of x (radians)",
  ["math.sqrt"] = "math.sqrt(x) - Square root",
  ["math.tan"] = "math.tan(x) - Tangent of x (radians)",
  ["math.tointeger"] = "math.tointeger(x) - Convert to integer or nil",
  ["math.type"] = "math.type(x) - 'integer', 'float', or nil",
  ["math.ult"] = "math.ult(m, n) - Unsigned less than comparison",
  -- os functions
  ["os.clock"] = "os.clock() - CPU time used by program",
  ["os.date"] = "os.date([format [, time]]) - Format date/time",
  ["os.difftime"] = "os.difftime(t2, t1) - Difference in seconds",
  ["os.execute"] = "os.execute([command]) - Execute shell command",
  ["os.exit"] = "os.exit([code [, close]]) - Exit program",
  ["os.getenv"] = "os.getenv(varname) - Get environment variable",
  ["os.remove"] = "os.remove(filename) - Delete file",
  ["os.rename"] = "os.rename(oldname, newname) - Rename file",
  ["os.setlocale"] = "os.setlocale(locale [, category]) - Set locale",
  ["os.time"] = "os.time([table]) - Current time or from table",
  ["os.tmpname"] = "os.tmpname() - Temporary file name",
  -- io functions
  ["io.close"] = "io.close([file]) - Close file",
  ["io.flush"] = "io.flush() - Flush output buffer",
  ["io.input"] = "io.input([file]) - Set/get default input",
  ["io.lines"] = "io.lines([filename, ...]) - Iterator over lines",
  ["io.open"] = "io.open(filename [, mode]) - Open file",
  ["io.output"] = "io.output([file]) - Set/get default output",
  ["io.popen"] = "io.popen(prog [, mode]) - Open process",
  ["io.read"] = "io.read(...) - Read from input",
  ["io.tmpfile"] = "io.tmpfile() - Create temporary file",
  ["io.type"] = "io.type(obj) - Check if file handle",
  ["io.write"] = "io.write(...) - Write to output",
}

local function get_stdlib_functions()
  local items = {}
  local libs = { "string", "table", "math", "os", "io", "coroutine", "debug", "package", "utf8" }

  for _, lib_name in ipairs(libs) do
    local lib = _G[lib_name]
    if type(lib) == "table" then
      for name, val in pairs(lib) do
        if type(name) == "string" and not name:match("^_") then
          local full = lib_name .. "." .. name
          local doc = stdlib_docs[full] or full .. " [" .. type(val) .. "]"
          table.insert(items, full .. "\t" .. doc)
        end
      end
    end
  end
  table.sort(items)
  return items
end

-- =============================================================================
-- Main entry: All Lua symbols (unified search)
-- =============================================================================
function M.functions(query)
  local items = {}
  local effective_query = query or get_query_at_cursor()

  -- vim.api functions
  for _, item in ipairs(get_vim_api_functions()) do
    table.insert(items, "[api] " .. item)
  end

  -- vim.lsp functions
  for _, item in ipairs(get_vim_lsp_functions()) do
    table.insert(items, "[lsp] " .. item)
  end

  -- Lua stdlib
  for _, item in ipairs(get_stdlib_functions()) do
    table.insert(items, "[std] " .. item)
  end

  local shortcuts = "ctrl-a: api | ctrl-l: lsp | ctrl-s: stdlib | ctrl-f: vim.fn | ctrl-m: modules"

  fzf.fzf_exec(items, {
    prompt = "Lua ❯ ",
    previewer = false,
    fzf_opts = {
      ["--delimiter"] = "\t",
      ["--with-nth"] = "1",
      ["--header"] = shortcuts,
      ["--query"] = effective_query,
      ["--preview"] = "echo {2}",
      ["--preview-window"] = "up:3:wrap",
    },
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then return end
        local line = selected[1]
        local full_name = line:match("%] ([^\t]+)")
        if not full_name then return end

        -- Extract help topic based on prefix
        local help_topic = full_name:match("^vim%.api%.(.+)$")
        if help_topic then
          vim.schedule(function() vim.cmd("help " .. help_topic) end)
          return
        end

        help_topic = full_name:match("^vim%.fn%.(.+)$")
        if help_topic then
          vim.schedule(function() vim.cmd("help " .. help_topic) end)
          return
        end

        help_topic = full_name:match("^vim%.lsp%.(.+)$")
        if help_topic then
          vim.schedule(function() vim.cmd("help lsp." .. help_topic) end)
          return
        end

        -- Stdlib - show signature in notification
        if stdlib_docs[full_name] then
          vim.notify(stdlib_docs[full_name], vim.log.levels.INFO)
        else
          vim.notify("No help for: " .. full_name, vim.log.levels.INFO)
        end
      end,
      ["ctrl-y"] = function(selected)
        if not selected or #selected == 0 then return end
        local full_name = selected[1]:match("%] ([^\t]+)")
        if full_name then
          vim.fn.setreg("+", full_name)
          vim.notify("Copied: " .. full_name)
        end
      end,
      ["ctrl-a"] = function(_, opts) M.vim_api(get_query(opts)) end,
      ["ctrl-l"] = function(_, opts) M.vim_lsp(get_query(opts)) end,
      ["ctrl-s"] = function(_, opts) M.stdlib(get_query(opts)) end,
      ["ctrl-f"] = function(_, opts) M.vim_fn(get_query(opts)) end,
      ["ctrl-m"] = function(_, opts) M.modules(get_query(opts)) end,
    },
  })
end

-- =============================================================================
-- vim.api functions only
-- =============================================================================
function M.vim_api(query)
  local items = get_vim_api_functions()
  local effective_query = query or get_query_at_cursor()
  local shortcuts = "ctrl-a: all | ctrl-l: lsp | ctrl-s: stdlib | ctrl-f: vim.fn"

  fzf.fzf_exec(items, {
    prompt = "vim.api ❯ ",
    previewer = false,
    fzf_opts = {
      ["--delimiter"] = "\t",
      ["--with-nth"] = "1",
      ["--header"] = shortcuts,
      ["--query"] = effective_query,
      ["--preview"] = "echo {2}",
      ["--preview-window"] = "up:1:wrap",
    },
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then return end
        -- Extract function name from "vim.api.nvim_xxx"
        local full_name = selected[1]:match("^([^\t]+)")
        local help_topic = full_name:match("^vim%.api%.(.+)$")
        if help_topic then
          vim.schedule(function()
            vim.cmd("help " .. help_topic)
          end)
        else
          vim.notify("Could not parse: " .. selected[1], vim.log.levels.WARN)
        end
      end,
      ["ctrl-y"] = function(selected)
        if not selected or #selected == 0 then return end
        local name = selected[1]:match("^([^\t]+)")
        vim.fn.setreg("+", name)
        vim.notify("Copied: " .. name)
      end,
      ["ctrl-a"] = function(_, opts) M.functions(get_query(opts)) end,
      ["ctrl-l"] = function(_, opts) M.vim_lsp(get_query(opts)) end,
      ["ctrl-s"] = function(_, opts) M.stdlib(get_query(opts)) end,
      ["ctrl-f"] = function(_, opts) M.vim_fn(get_query(opts)) end,
    },
  })
end

-- =============================================================================
-- vim.fn functions
-- =============================================================================
function M.vim_fn(query)
  local items = get_vim_fn_functions()
  local effective_query = query or get_query_at_cursor()
  local shortcuts = "ctrl-a: all | ctrl-l: lsp | ctrl-s: stdlib | ctrl-v: vim.api"

  fzf.fzf_exec(items, {
    prompt = "vim.fn ❯ ",
    previewer = false,
    fzf_opts = {
      ["--delimiter"] = "\t",
      ["--with-nth"] = "1",
      ["--header"] = shortcuts,
      ["--query"] = effective_query,
      ["--preview"] = "echo {2}",
      ["--preview-window"] = "up:1:wrap",
    },
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then return end
        local full_name = selected[1]:match("^([^\t]+)")
        local help_topic = full_name:match("^vim%.fn%.(.+)$")
        if help_topic then
          vim.schedule(function() vim.cmd("help " .. help_topic) end)
        end
      end,
      ["ctrl-y"] = function(selected)
        if not selected or #selected == 0 then return end
        local name = selected[1]:match("^([^\t]+)")
        vim.fn.setreg("+", name)
        vim.notify("Copied: " .. name)
      end,
      ["ctrl-a"] = function(_, opts) M.functions(get_query(opts)) end,
      ["ctrl-l"] = function(_, opts) M.vim_lsp(get_query(opts)) end,
      ["ctrl-s"] = function(_, opts) M.stdlib(get_query(opts)) end,
      ["ctrl-v"] = function(_, opts) M.vim_api(get_query(opts)) end,
    },
  })
end

-- =============================================================================
-- vim.lsp functions
-- =============================================================================
function M.vim_lsp(query)
  local items = get_vim_lsp_functions()
  local effective_query = query or get_query_at_cursor()
  local shortcuts = "ctrl-a: all | ctrl-v: vim.api | ctrl-s: stdlib | ctrl-f: vim.fn"

  fzf.fzf_exec(items, {
    prompt = "vim.lsp ❯ ",
    previewer = false,
    fzf_opts = {
      ["--delimiter"] = "\t",
      ["--with-nth"] = "1",
      ["--header"] = shortcuts,
      ["--query"] = effective_query,
    },
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then return end
        local full_name = selected[1]:match("^([^\t]+)")
        local help_topic = full_name:gsub("^vim%.", "")
        vim.schedule(function() vim.cmd("help " .. help_topic) end)
      end,
      ["ctrl-y"] = function(selected)
        if not selected or #selected == 0 then return end
        local name = selected[1]:match("^([^\t]+)")
        vim.fn.setreg("+", name)
        vim.notify("Copied: " .. name)
      end,
      ["ctrl-a"] = function(_, opts) M.functions(get_query(opts)) end,
      ["ctrl-v"] = function(_, opts) M.vim_api(get_query(opts)) end,
      ["ctrl-s"] = function(_, opts) M.stdlib(get_query(opts)) end,
      ["ctrl-f"] = function(_, opts) M.vim_fn(get_query(opts)) end,
    },
  })
end

-- =============================================================================
-- Lua stdlib
-- =============================================================================
function M.stdlib(query)
  local items = get_stdlib_functions()
  local effective_query = query or get_query_at_cursor()
  local shortcuts = "ctrl-a: all | ctrl-v: vim.api | ctrl-l: lsp | ctrl-f: vim.fn"

  fzf.fzf_exec(items, {
    prompt = "Stdlib ❯ ",
    previewer = false,
    fzf_opts = {
      ["--delimiter"] = "\t",
      ["--with-nth"] = "1",
      ["--header"] = shortcuts,
      ["--query"] = effective_query,
      ["--preview"] = "echo {2}",
      ["--preview-window"] = "up:2:wrap",
    },
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then return end
        local full_name = selected[1]:match("^([^\t]+)")
        -- Show the signature/doc for stdlib
        vim.notify(stdlib_docs[full_name] or full_name, vim.log.levels.INFO)
      end,
      ["ctrl-y"] = function(selected)
        if not selected or #selected == 0 then return end
        local name = selected[1]:match("^([^\t]+)")
        vim.fn.setreg("+", name)
        vim.notify("Copied: " .. name)
      end,
      ["ctrl-a"] = function(_, opts) M.functions(get_query(opts)) end,
      ["ctrl-v"] = function(_, opts) M.vim_api(get_query(opts)) end,
      ["ctrl-l"] = function(_, opts) M.vim_lsp(get_query(opts)) end,
      ["ctrl-f"] = function(_, opts) M.vim_fn(get_query(opts)) end,
    },
  })
end

-- =============================================================================
-- Search Lua modules in runtime path
-- =============================================================================
function M.modules(query)
  local items = {}
  local seen = {}

  local rtp = vim.api.nvim_list_runtime_paths()
  for _, path in ipairs(rtp) do
    local lua_path = path .. "/lua"
    if vim.fn.isdirectory(lua_path) == 1 then
      local cmd = string.format("fd -t f -e lua -d 3 . '%s' 2>/dev/null", lua_path)
      local files = vim.fn.systemlist(cmd)
      for _, file in ipairs(files) do
        local mod = file:gsub(lua_path .. "/", ""):gsub("%.lua$", ""):gsub("/", ".")
        if mod ~= "" and not seen[mod] and not mod:match("^_") then
          seen[mod] = true
          table.insert(items, mod .. "\t" .. file)
        end
      end
    end
  end

  local effective_query = query or get_query_at_cursor()
  local shortcuts = "ctrl-a: all | ctrl-v: vim.api | ctrl-s: stdlib"

  fzf.fzf_exec(items, {
    prompt = "Modules ❯ ",
    previewer = false,
    fzf_opts = {
      ["--delimiter"] = "\t",
      ["--with-nth"] = "1",
      ["--header"] = shortcuts,
      ["--query"] = effective_query,
      ["--preview"] = "bat --style=numbers --color=always {2} 2>/dev/null || cat {2}",
      ["--preview-window"] = "right:50%",
    },
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then return end
        local file = selected[1]:match("\t(.+)$")
        if file then
          vim.schedule(function() vim.cmd("edit " .. file) end)
        end
      end,
      ["ctrl-y"] = function(selected)
        if not selected or #selected == 0 then return end
        local mod = selected[1]:match("^([^\t]+)")
        vim.fn.setreg("+", 'require("' .. mod .. '")')
        vim.notify("Copied: require(\"" .. mod .. "\")")
      end,
      ["ctrl-a"] = function(_, opts) M.functions(get_query(opts)) end,
      ["ctrl-v"] = function(_, opts) M.vim_api(get_query(opts)) end,
      ["ctrl-s"] = function(_, opts) M.stdlib(get_query(opts)) end,
    },
  })
end

return M
