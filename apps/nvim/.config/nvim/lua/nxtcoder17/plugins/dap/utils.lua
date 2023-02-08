local M = {}

function M.get_arguments()
	local co = coroutine.running()
	if co then
		return coroutine.create(function()
			local args = {}
			vim.ui.input({ prompt = "Args: " }, function(input)
				args = vim.split(input or "", " ", { trimempty = true })
			end)
			coroutine.resume(co, args)
			return args
		end)
	end
	local args = {}
	vim.ui.input({ prompt = "Args: " }, function(input)
		args = vim.split(input or "", " ", { trimempty = true })
	end)
	return args
end

function M.choose_program_dir()
	local co = coroutine.running()
	if co then
		return coroutine.create(function()
			local dir = {}
			vim.ui.input({ prompt = "Dir: ", default = vim.fn.expand("%:p:h") }, function(input)
				dir = input
			end)
			coroutine.resume(co, dir)
			return dir
		end)
	end
	local dir = {}
	vim.ui.input({ prompt = "Dir: ", default = vim.fn.expand("%:p:h") }, function(input)
		dir = input
	end)
	return dir
end

return M
