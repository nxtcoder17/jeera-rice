-- hover.lua — Simplified hover and goto definition

-- [FZF-lua advanced docs](https://github.com/ibhagwan/fzf-lua/wiki/Advanced#fn_transform_cmd)

local import = require("plugins.doc-search-v2.pkg")
local preview = import("util.preview")
local awk_util = import("util.awk")

local M = {}

  local open_file = function(selected, mode)
    mode = mode or "vsplit"
    local file, line, col = string.match(selected[1], "^(.-):(%d+):(%d+)%s*≈")
    if file then
      if mode == "vsplit" then
        vim.cmd(":vsplit")
      elseif mode == "split" then
        vim.cmd(":split")
      elseif mode == "tab" then
        vim.cmd(":tabnew")
      end
      vim.cmd("edit " .. file)
      if line then
        vim.cmd(":" .. line)
      end
      vim.cmd("normal! zz")
    end
  end

function M.goto_definition(lang, search_query, search_opts)
  search_opts = search_opts or {}
  local fzf = require("fzf-lua")
  local grep_opts = {
    prompt = "Search> ",
    query = search_query,
    fzf_opts = {
      ["--select-1"] = "",
      ["--delimiter"] = " ≈",
      ["--with-nth"] = "2..",
    },

    -- no_esc = true,
    -- rg_glob = true,
    -- regex = true,
    formatter = false,
    file_icons = false,
    color_icons = false,

    actions = {
      ["default"] = function(selected)
        open_file(selected)
      end,
      ["tab"] = function(selected)
        M.goto_definition(lang, lang.build_query("function", fzf.get_last_query()), search_opts)
      end,
      ["ctrl-g"] = function(selected)
        local q = fzf.get_last_query()
        local cmd_string = lang.get_search_command(q, search_opts)

        local entries = {}

        local results = vim.system({ "sh", "-c", cmd_string }):wait()
        if results.code == 0 then
          entries = vim.split(results.stdout, "\n")
        end

        return fzf.fzf_exec(entries, {
          previewer = "builtin",
          fzf_opts = {
            ["--delimiter"] = " ≈",
            ["--with-nth"] = "2..",
          },
          actions = {
            ["default"] = function(selected)
              open_file(selected)
            end,
            ["ctrl-t"] = function(selected)
              open_file(selected, "tab")
            end,
            ["ctrl-v"] = function(selected)
              open_file(selected, "vsplit")
            end,
          },
        })
      end,
      ["ctrl-v"] = function(selected)
        open_file(selected, "vsplit")
      end,
      ["ctrl-f"] = function(selected)
        M.goto_definition(lang, lang.build_query("function", fzf.get_last_query()), search_opts)
      end,

      ["alt-f"] = function(selected)
        M.goto_definition(lang, lang.build_query("exported_function", fzf.get_last_query()), search_opts)
      end,

      ["ctrl-t"] = function(selected)
        M.goto_definition(lang, lang.build_query("type", fzf.get_last_query()), search_opts)
      end,
      ["ctrl-r"] = function(selected)
        M.goto_definition(lang, lang.build_query("function_call", fzf.get_last_query()), search_opts)
      end,
    },
  }

  return fzf.fzf_live(function(args)
    return lang.get_search_command(table.concat(args, "") or search_query, search_opts)
  end, require("fzf-lua.config").normalize_opts(grep_opts, "grep"))
end

function M.search_module(lang, search_query)
  if type(lang.get_search_dirs) ~= "function" then
    vim.notify("This language adapter does not support module search")
    return
  end

  -- if not search_query and type(lang.get_search_query) == "function" then
  --   search_query = lang.get_search_query()
  -- end

  search_query = search_query or vim.fn.expand("<cword>")

  local fzf = require("fzf-lua")
  local modules = lang.get_search_dirs()

  if not modules or #modules == 0 then
    vim.notify("No search modules found")
    return
  end

  local module_items = {}
  local module_by_item = {}
  for _, module in ipairs(modules) do
    if module.path and module.path ~= "" then
      local left = (module.prefix or "") .. (module.sublabel or module.path)
      local item = left .. " " .. module.path
      -- local item = module.path
      table.insert(module_items, item)
      module_by_item[item] = module.path
    end
  end

  return fzf.fzf_exec(module_items, {
    prompt = "Search Module> ",
    query = search_query,
    fzf_opts = {
      -- ["--delimiter"] = " ",
      ["--with-nth"] = "1,2",
    },
    actions = {
      ["default"] = function(selected)
        local item = selected and selected[1]
        local module_path = item and module_by_item[item]
        if module_path then
          M.goto_definition(lang, search_query, { search_dirs = { module_path } })
        end
      end,
    },
  })
end

-- vim.keymap.set("n", "xx", function() M.show(import("lang.go"), "Getwd") end, { noremap = true, silent = true })

-- vim.keymap.set("n", "xy", function()
--   vim.print("CAPTURE = ", vim.inspect(import("lang.go").get_ts_capture()))
-- end, { noremap = true, silent = true })

return M
