local hipatterns = Require("mini.hipatterns")

local function case_insensitive_pattern(s)
  return (s:gsub("%a", function(c)
    return string.format("[%s%s]", c:lower(), c:upper())
  end))
end

local function build_highlight_pattern(keyword)
  return "%f[%w]()" .. case_insensitive_pattern(keyword) .. "()%f[%s]"
end

hipatterns.setup({
  highlighters = {
    fixme = { pattern = build_highlight_pattern("FIXME:"), group = "MiniHipatternsFixme" }, -- FIXME: example
    hack = { pattern = build_highlight_pattern("HACK:"), group = "MiniHipatternsHack" }, -- HACK: example
    todo = { pattern = build_highlight_pattern("TODO:"), group = "MiniHipatternsTodo" }, -- TODO: example
    note = { pattern = build_highlight_pattern("NOTE:"), group = "MiniHipatternsTodo" }, -- NOTE: example
    info = { pattern = build_highlight_pattern("INFO:"), group = "MiniHipatternsTodo" }, -- INFO: example
    warn = { pattern = build_highlight_pattern("WARN:"), group = "MiniHipatternsFixme" }, -- WARN: example
    why = { pattern = build_highlight_pattern("why%?"), group = "MiniHipatternsWhy" }, -- WHY? example why? example
    step = { pattern = build_highlight_pattern("step"), group = "MiniHipatternsStep" }, -- WHY? example why? example
    error = { pattern = build_highlight_pattern("ERROR:"), group = "MiniHipatternsFixme" }, -- ERROR: example

    -- Highlight hex color strings (`#rrggbb`) using that color
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})

vim.cmd([[ hi! MiniHipatternsWhy guibg=#838f27 guifg=#d8f21b gui=bold ]])
vim.cmd([[ hi! MiniHipatternsStep guibg=#dea27c guifg=#1f272e gui=bold ]])

-- INFO: hello world

-- if vim.g.nxt_fns.is_light_theme() then
-- 	vim.cmd([[ hi! MiniHipatternsTodo guifg=#336699 guibg=#f5f5f5 gui=bold ]])
-- 	vim.cmd([[ hi! MiniHipatternsHack guifg=#996633 guibg=#f5f5f5 gui=bold ]])
-- 	vim.cmd([[ hi! MiniHipatternsNote guifg=#009999 guibg=#f5f5f5 gui=bold ]])
-- 	vim.cmd([[ hi! MiniHipatternsInfo guifg=#0066cc guibg=#f5f5f5 gui=bold ]])
--
-- 	vim.cmd([[ hi! MiniStatuslineDevinfo guifg=#707059 guibg=#dadbad gui=italic ]])
-- 	vim.cmd([[ hi! MiniStatuslineFileinfo guifg=#707059 guibg=#dadbad gui=italic ]])
-- else
-- 	vim.cmd([[ hi! MiniHipatternsTodo guifg=#759cbd guibg=#1f272e gui=bold ]])
-- 	vim.cmd([[ hi! MiniHipatternsHack guifg=#dea27c guibg=#1f272e gui=bold ]])
-- 	vim.cmd([[ hi! MiniHipatternsNote guifg=#4799a1 guibg=#1f272e gui=bold ]])
-- 	vim.cmd([[ hi! MiniHipatternsInfo guifg=#033580 guibg=#8dcf5f gui=bold ]])
-- 	vim.cmd([[ hi! MiniHipatternsFixme guifg=#000000 guibg=#d65e84 gui=bold ]])
-- end
