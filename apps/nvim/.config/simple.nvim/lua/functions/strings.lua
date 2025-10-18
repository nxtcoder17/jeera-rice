-- local Tests = R("functions.tests")

local M = {}

-- local test = Tests.setup_tests(logger).test
-- local tests = {}

M.trim = function(s)
	return s:gsub("^%s*(.-)%s*$", "%1")
end

-- **camel_case**, does transformation from
--   - `sample-word` to `sampleWord`
--   - `SampleWord` to `sampleWord`
M.camel_case = function(str)
	local camelCased = ""
	local wasSeparator = false
	for i = 1, #str do
		local char = str:sub(i, i)
		if not char:match("%a") then
			wasSeparator = true
		else
			camelCased = camelCased .. (wasSeparator and char:upper() or char)
			wasSeparator = false
		end
	end
	return camelCased
end

local is_uppercase = function(s)
	return s:match("%u") ~= nil
end

local ends_with = function(s, suffix)
	return s:sub(#s - #suffix + 1, #s - #suffix + 1) == suffix
end

-- **snake_case**, does transformation from
-- - `sample-word` to `sample_word`
-- - `SampleWord` to `sample_word`
M.snake_case = function(str, opts)
	opts = opts or { all_lowercase = true, all_uppercase = false }
	local snakeCased = str:sub(1, 1)
	for i = 2, #str - 1 do
		local char = str:sub(i, i)
		local next_char = str:sub(i + 1, i + 1)

		if not is_uppercase(char) and is_uppercase(next_char) then
			snakeCased = snakeCased .. char .. "_"
		elseif is_uppercase(char) and not is_uppercase(next_char) and not ends_with(snakeCased, "_") then
			snakeCased = snakeCased .. "_" .. char
		else
			snakeCased = snakeCased .. char
		end
	end

	snakeCased = snakeCased .. str:sub(#str, #str)

	if opts.all_uppercase then
		return string.upper(snakeCased)
	end
	return string.lower(snakeCased)
end

-- tests.snake_case = function()
--   -- test(M.snake_case("sample-word"), "sample_word")
--   test(M.snake_case("AWSAccount"), "awsa_ccount")
--   test(M.snake_case("AWSACCount"), "awsac_count")
--   test(M.snake_case("AWSCloudformationTrustedARN"), "aws_cloudformation_trusted_arn")
-- end

M.snake_case_all_lowercase = function(str)
	return M.snake_case(str, { all_lowercase = true })
end

M.snake_case_all_uppercase = function(str)
	return M.snake_case(str, { all_uppercase = true })
end

-- M.tests = tests

return M
