local M = {}

local filetypes = {
  lua = {
    mason = { "stylua", "selene" },
    -- linters = { "luacheck", "selene" },
    linters = { "selene" },
    formatters = { "stylua" },
  },
  go = {
    mason = { "golangci-lint", "crlfmt" },
    linters = { "golangcilint" },
    formatters = { "golangci-lint", "crlfmt" },
  },
  javascript = {
    mason = { "eslint_d", "biome" },
    linters = { "eslint_d", "biome" },
    formatters = { "eslint_d", "biome" },
  },
  python = {
    mason = { "black", "mypy" },
    linters = { "mypy" },
    formatters = { "black" },
  },
}

local fn = Require("functions")
if not fn then
  vim.notify("functions module not found", vim.log.levels.ERROR)
end

function filetypes:linters(ft)
  local config = self[ft]
  if not config then
    return {}
  end
  return config.linters
end

function filetypes:formatters(ft)
  local config = self[ft]
  if not config then
    return {}
  end
  return config.formatters
end

function filetypes:mason_packages(ft)
  local config = self[ft]
  if not config then
    return {}
  end
  return config.mason
end

M.linter = function()
  require("lint").linters_by_ft = {
    lua = filetypes:linters("lua"),
    markdown = filetypes:linters("markdown"),
    go = filetypes:linters("go"),
    python = filetypes:linters("python"),
  }

  -- [source](https://github.com/mfussenegger/nvim-lint)
  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
      -- try_lint without arguments runs the linters defined in `linters_by_ft`
      -- for the current filetype
      require("lint").try_lint()
    end,
  })
end

M.formatter = function()
  require("conform").setup({
    formatters_by_ft = {
      lua = Require("functions").join_tables(filetypes:formatters("lua"), { stop_after_first = true }),
      python = filetypes:formatters("python"),
      javascript = Require("functions").join_tables(filetypes:formatters("javascript"), { stop_after_first = true }),
      -- go = Require("functions").join_tables(filetypes:formatters("go"), { stop_after_first = true}),
      go = filetypes:formatters("go"),
    },

    formatters = {
      ["eslint_d"] = {
        cwd = require("conform.util").root_file({ ".eslintrc", ".eslintrc.json" }),
      },

      ["biome"] = {
        cwd = require("conform.util").root_file({ ".biome.json", ".biome.jsonc" }),
      },

      --  golang
      ["golangci-lint"] = {
        cwd = require("conform.util").root_file({
          ".golangci.yml",
          ".golangci.yaml",
          ".golangci.toml",
          ".golangci.json",
        }),
      },
    },
  })
end

local augroup = vim.api.nvim_create_augroup("linter-and-formatter", { clear = true })

vim.api.nvim_create_autocmd({ "Filetype" }, {
  group = augroup,
  -- pattern = "*",
  callback = function()
    for _, pkg in ipairs(filetypes:mason_packages(vim.bo.filetype)) do
      if not Require("mason-registry").is_installed(pkg) then
        vim.cmd("MasonInstall " .. pkg)
      end
    end
  end,
})

return M
