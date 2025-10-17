local hipatterns = Require("mini.hipatterns")
local function build_highlight_pattern(keyword)
	return "%f[%w]()" .. keyword .. "()%f[%s]"
end

hipatterns.setup({
	highlighters = {
		fixme = { pattern = build_highlight_pattern("FIXME:"), group = "MiniHipatternsFixme" }, -- FIXME: example
		hack = { pattern = build_highlight_pattern("HACK:"), group = "MiniHipatternsHack" }, -- HACK: example
		todo = { pattern = build_highlight_pattern("TODO:"), group = "MiniHipatternsTodo" }, -- TODO: example
		note = { pattern = build_highlight_pattern("NOTE:"), group = "MiniHipatternsTodo" }, -- NOTE: example
		info = { pattern = build_highlight_pattern("INFO:"), group = "MiniHipatternsTodo" }, -- INFO: example
		warn = { pattern = build_highlight_pattern("WARN:"), group = "MiniHipatternsFixme" }, -- WARN: example
		error = { pattern = build_highlight_pattern("ERROR:"), group = "MiniHipatternsFixme" }, -- ERROR: example

		-- Highlight hex color strings (`#rrggbb`) using that color
		hex_color = hipatterns.gen_highlighter.hex_color(),
	},
})

