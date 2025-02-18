indent_with_spaces()

local current_file = vim.fn.expand("%:p")

local function build_pattern(keyword)
	return "%f[%w]()" .. keyword .. "()%f[%s]"
end

if string.find(current_file, "/.github/") then
	vim.b.minihipatterns_config = {
		highlighters = {
			gh_secrets = { pattern = build_pattern("%f[%w]%$%{%{%f[%s]"), group = "MiniHipatternsFixme" },
		},
	}
end
