notify_if_not_installed({ "lua-language-server" })

vim.lsp.config("lua_ls", {
  on_attach = Require("lsp.on_attach"),
  root_markers = { "lua" },
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        -- library = vim.api.nvim_get_runtime_file("", true),
        library = {
          -- vim.env.VIMRUNTIME,
          -- [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          -- [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

vim.lsp.enable("lua_ls")

-- LINTER
set_linter("lua", { "selene" })

-- FORMATTER
set_formatter("lua", { "stylua" })
