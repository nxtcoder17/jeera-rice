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

vim.lsp.enable("gopls")

-- Linter
set_linter("go", { "golangcilint" })

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
