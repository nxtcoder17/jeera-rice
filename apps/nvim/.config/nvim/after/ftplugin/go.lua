vim.treesitter.query.set(
  "go",
  "folds",
  [[
    (method_declaration (block) @fold)
  ]]
)

notify_if_not_installed({
  "gopls",
  "gofumpt",
  "delve",
  "gotests",
  "gomodifytags",
  "impl",
  "iferr",
  "json-to-struct",
})

-- LSP
vim.lsp.config("gopls", {
  filetypes = { "go", "gomod", "gowork", "gotmpl", "gotexttmpl", "gohtmltmpl" },
  root_markers = { "go.mod" },
  single_file_support = true,
  on_attach = Require("lsp.on_attach"),
  settings = {
    gopls = {
      completeUnimported = false,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
      staticcheck = false,
      gofumpt = false,

      directoryFilters = { "-.git", "-node_modules", "-vendor", "-bin" },

      semanticTokens = false,
      hints = {
        ignoredError = true,
      },
    },
  },
})

-- vim.lsp.enable("gopls")

-- require("lint").linters.golangci_lint = {
--   cmd = "sh",
--   stdin = false,
--   args = {
--     "-c",
--     "golangci-lint run --output.json.path=stdout --output.text.path= --issues-exit-code=0 --show-stats=false",
--   },
--   stream = "stdout",
--
--   parser = function(output, bufnr)
--     local diagnostics = {}
--
--     local ok, decoded = pcall(vim.json.decode, output)
--     if not ok or not decoded then
--       return diagnostics
--     end
--
--     for _, item in ipairs(decoded.Issues or {}) do
--       local fname = vim.fn.getcwd() .. "/" .. item.Pos.Filename
--       if fname == vim.fn.expand("%:p") then
--         local severity = vim.diagnostic.severity.WARN
--
--         if item.FromLinter == "typecheck" then
--           severity = vim.diagnostic.severity.ERROR
--         end
--
--         table.insert(diagnostics, {
--           lnum = item.Pos.Line - 1,
--           col = item.Pos.Column - 1,
--           end_lnum = item.Pos.Line,
--           end_col = item.Pos.Column,
--           message = item.Text,
--           code = item.code and item.code.value or nil,
--           source = item.FromLinter,
--           severity = severity,
--         })
--       end
--
--     end
--     --
--     return diagnostics
--   end,
-- }

require("lint").linters.gopls = {
  cmd = "gopls",
  stdin = false,
  args = {
    "check",
    vim.fn.expand("%"),
  },
  stream = "stdout",

  parser = function(output, bufnr)
    local diagnostics = {}

    -- /home/nxtcoder17/workspace/nxtcoder17/fwatcher/pkg/watcher/watcher.go:71:19-30: f.ExcludeDirs undefined (type Watcher has no field or method ExcludeDirs)
    for _, line in ipairs(vim.split(output, "\n")) do
      if line == "" then
        break
      end

      local file, line_num, col_start, col_end, msg = line:match("^(.+):(%d+):(%d+)%-(%d+):%s*(.+)$")
      if file == nil or line_num == nil or col_start == nil or col_end == nil or msg == nil then
        break
      end

      table.insert(diagnostics, {
        lnum = tonumber(line_num)-1,
        col = tonumber(col_start),
        end_lnum = tonumber(line_num)-1,
        end_col = tonumber(col_end),
        message = msg,
        code = nil,
        source = "gopls",
        severity = vim.diagnostic.severity.ERROR,
      })
    end

    return diagnostics
  end,
}

-- Linter
set_linter("go", { "gopls" })

-- Formatter
set_formatter("go", { "golangci-lint" })

-- DAP
local ok, dap = pcall(require, "dap")
if not ok then
  return
end

local dap_utils = Require("plugins.dap.utils")

local logger = NewLogger("ftplugins.go.dap", "info")

dap.configurations.go = {
  {
    type = "go",
    name = "Debug",
    request = "launch",
    outputMode = "remote",
    -- program = "${fileDirname}",
    args = function()
      return load("return " .. vim.fn.input({ prompt = "Run Flags and Arguments: ", default = [[{ "--debug", }]] }))()
    end,
    program = function()
      return vim.fn.getcwd()
    end,
    envFile = {
      ".secrets/env",
    },
  },
}

dap.adapters.go = {
  type = "server",
  port = "${port}",
  executable = {
    command = "bash",
    args = {
      "-c",
      "dlv dap -l 127.0.0.1:${port} --api-version 2  --check-go-version false --allow-non-terminal-interactive 2>&1 | tee /tmp/debug.stdout",
      -- "dlv debug --accept-multiclient --headless -l 127.0.0.1:${port} --api-version 2 --allow-non-terminal-interactive 2>&1 | tee /tmp/debug.stdout",
      -- "dlv debug --continue --accept-multiclient --headless -l 127.0.0.1:${port} --api-version 2 --allow-non-terminal-interactive 2>&1 | tee /tmp/debug.stdout",
    },
  },
  options = {
    initialize_timeout_sec = 20,
  },
  -- enrich_config = utils.adapter_inject_env,
  enrich_config = function(current_config, on_new_config)
    local new_config = dap_utils.evaluate_config(current_config)
    logger.debug("new config", new_config)
    on_new_config(new_config)
  end,
}

-- vim.cmd('runtime! ftplugin/xxx.lua')
