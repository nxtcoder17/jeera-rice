local nls = require('null-ls')

local fmt = nls.builtins.formatting
local dgn = nls.builtins.diagnostics

-- Configuring null-ls
nls.setup({
    sources = {
        fmt.trim_whitespace.with({
            filetypes = { 'text', 'sh', 'zsh', 'toml', 'make', 'conf', 'tmux' },
        }),

        -- NOTE:
        -- 1. both needs to be enabled to so prettier can apply eslint fixes
        -- 2. prettierd should come first to prevent occassional race condition
        fmt.prettierd,
        fmt.eslint_d,

        fmt.rustfmt,
        fmt.stylua,
        fmt.terraform_fmt,
        fmt.gofmt,
        -- fmt.zigfmt,
        -- fmt.shfmt,
        -- # DIAGNOSTICS #
        dgn.eslint_d,
        dgn.shellcheck,
        dgn.luacheck.with({
            extra_args = { '--globals', 'vim', '--std', 'luajit' },
        }),
    },
})
