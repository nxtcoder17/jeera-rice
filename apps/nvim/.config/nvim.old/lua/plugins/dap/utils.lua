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

function M.choose_dir(prompt, defaultDir, fn)
	defaultDir = defaultDir or vim.fn.expand("%:p:h")
	fn = fn or function(d)
		return d
	end

	local co = coroutine.running()
	if co then
		return coroutine.create(function()
			local dir = {}
			vim.ui.input({ prompt = prompt .. "> ", default = vim.fn.expand("%:p:h") }, function(input)
				dir = input
			end)
			coroutine.resume(co, dir)
			return fn(dir)
		end)
	end
	local dir = {}
	vim.ui.input({ prompt = "Dir: ", default = vim.fn.expand("%:p:h") }, function(input)
		dir = input
	end)
	return fn(dir)
end

M.file_exists = function(fp)
	local f = io.open(fp, "r")
	return f ~= nil and io.close(f)
end

function M.read_env_file(file, opts)
	local opts = opts or { debug = false }
	local debugMsg = "[read_env_file] "
	if opts.debug then
		print(debugMsg .. "env file requested " .. file)
	end

	local env = {}
	if not M.file_exists(file) then
		if opts.debug then
			print(debugMsg .. "skipping file " .. file)
		end
		return {}
	end

	for line in io.lines(file) do
		local l = vim.trim(line)
		if vim.startswith(l, "#") then
			if opts.debug then
				print(debugMsg .. "skipping line " .. l)
			end
			goto continue
		end
		local key, value = line:match("([^=]+)=(.+)")
		if key and value then
			-- env[key] = value
			local v = value:gsub("^[\"']", "")
			v = v:gsub("[\"']$", "")
			-- print(v)
			env[key] = v
		end
		::continue::
	end

	if opts.debug then
		print("env", vim.inspect(env))
	end
	return env
end

M.adapter_inject_env = function(config, on_config)
	local final_config = vim.deepcopy(config)
	local env = config.env or { ["ENV_SET_BY_DAP"] = "true" } -- default env, as empty {} throws error

	if config.envFile then
		for _, fPath in ipairs(config.envFile) do
			env = vim.tbl_deep_extend("force", env, M.read_env_file(fPath))
		end
	end

	-- vim.print("env", vim.inspect(env))
	-- vim.print("length", vim.inspect(#ipairs(env)))
	--
	-- local hasItems = false
	-- for _ in ipairs(config.envFile or {}) do
	--   hasItems = true
	--   break
	-- end

	final_config.env = env

	final_config.envFile = nil
	on_config(final_config)
end

function M.filtered_pick_process()
	local opts = {}
	vim.ui.input(
		{ prompt = "Search by process name (lua pattern), or hit enter to select from the process list: " },
		function(input)
			opts["filter"] = input or ""
		end
	)
	return require("dap.utils").pick_process(opts)
end

return M
