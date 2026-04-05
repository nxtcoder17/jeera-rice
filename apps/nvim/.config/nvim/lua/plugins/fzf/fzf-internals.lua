-- **DO NOT EDIT**

-- Copied over from fzf-lua codebase, cause i was not able to replicate live_grep like functionalities
-- in my custom live picker
-- [SOURCE](lua/fzf-lua/providers/grep.lua:12)


local core = require("fzf-lua.core")
local utils = require("fzf-lua.utils")
local config = require("fzf-lua.config")
local make_entry = require("fzf-lua.make_entry")

local get_grep_cmd = make_entry.get_grep_cmd

local M = {}

---@param opts fzf-lua.config.Grep|{}?
---@return thread?, string?, table?
M.grep = function(opts)
  ---@type fzf-lua.config.Grep
  opts = config.normalize_opts(opts, "grep")
  if not opts then
    return
  end

  -- we need this for `actions.grep_lgrep`
  opts.__ACT_TO = opts.__ACT_TO or M.live_grep_dynamic

  -- regex as alias to search+no_esc
  if opts.regex then
    opts.search = opts.regex
    opts.no_esc = true
    opts.regex = nil
  end

  if not opts.search and not opts.raw_cmd then
    -- resume implies no input prompt
    if opts.resume then
      opts.search = ""
    else
      -- if user did not provide a search term prompt for one
      local search = utils.input(opts.input_prompt)
      -- empty string is not falsy in lua, abort if the user cancels the input
      if search then
        opts.search = search
        -- save the search query for `resume=true`
        opts.__call_opts.search = search
      else
        return
      end
    end
  end

  if
    (utils.has(opts, "fzf") or utils.has(opts, "sk", { 1, 8, 1 }))
    and not opts.prompt
    and opts.search
    and #opts.search > 0
  then
    opts.prompt = utils.ansi_from_hl(opts.hls.live_prompt, opts.search) .. " > "
  end

  -- get the grep command before saving the last search
  -- in case the search string is overwritten by 'rg_glob'
  opts.cmd = get_grep_cmd(opts, opts.search, opts.no_esc)
  if not opts.cmd then
    return
  end

  -- query was already parsed for globs inside 'get_grep_cmd'
  -- no need for our external headless instance to parse again
  opts.rg_glob = false

  -- search query in header line
  if type(opts._headers) == "table" then
    table.insert(opts._headers, "search")
  end
  opts = core.set_title_flags(opts, { "cmd" })
  opts = core.set_fzf_field_index(opts)
  return core.fzf_exec(opts.cmd, opts)
end

M.grep_lgrep = function(_, opts)
  opts.__ACT_TO({
    resume = true,
    -- different lookup key for grep|lgrep_curbuf
    __resume_key = opts.__resume_key,
    rg_glob = opts.rg_glob or opts.__call_opts.rg_glob,
    -- globs always require command processing with 'multiprocess'
    multiprocess = opts.multiprcess and (opts.rg_glob or opts.__call_opts.rg_glob) and 1,
    -- when used with tags pass the resolved ctags_file from tags-option as
    -- `tagfiles()` might not return the correct file called from the float (#700)
    ctags_file = opts.ctags_file,
  })
end


local function normalize_live_grep_opts(opts)
  ---@type fzf-lua.config.Grep
  opts = config.normalize_opts(opts, "grep")
  if not opts then
    return
  end

  -- regex as alias to search+no_esc
  if opts.regex then
    opts.search = opts.regex
    opts.no_esc = true
    opts.regex = nil
  end

  -- auto disable treesitter as it collides with cmd regex highlighting
  -- ignore if forced with `_treesitter = true` (#2511)
  if opts._treesitter == 1 then
    opts = utils.map_set(opts, "winopts.treesitter", false)
  end

  -- we need this for `actions.grep_lgrep`
  opts.__ACT_TO = opts.__ACT_TO or M.grep

  -- used by `actions.toggle_ignore', normalize_opts sets `__call_fn`
  -- to the calling function  which will resolve to this fn), we need
  -- to deref one level up to get to `live_grep_{mt|st}`
  opts.__call_fn = utils.__FNCREF2__()

  -- NOTE: no longer used since we hl the query with `FzfLuaLivePrompt`
  -- prepend prompt with "*" to indicate "live" query
  -- opts.prompt = type(opts.prompt) == "string" and opts.prompt or "> "
  -- if opts.live_ast_prefix ~= false then
  --   opts.prompt = opts.prompt:match("^%*") and opts.prompt or ("*" .. opts.prompt)
  -- end

  -- when using live_grep there is no "query", the prompt input
  -- is a regex expression and should be saved as last "search"
  -- this callback overrides setting "query" with "search"
  opts.__resume_set = function(what, val, o)
    if what == "query" then
      config.resume_set("search", val, { __resume_key = o.__resume_key })
      config.resume_set("no_esc", true, { __resume_key = o.__resume_key })
      utils.map_set(config, "__resume_data.last_query", val)
      -- also store query for `fzf_resume` (#963)
      utils.map_set(config, "__resume_data.opts.query", val)
      -- store in opts for convenience in action callbacks
      o.last_query = val
    else
      config.resume_set(what, val, { __resume_key = o.__resume_key })
    end
  end
  -- we also override the getter for the quickfix list name
  opts.__resume_get = function(what, o)
    return config.resume_get(
      what == "query" and "search" or what,
      { __resume_key = o.__resume_key }
    )
  end

  -- when using an empty string grep (as in 'grep_project') or
  -- when switching from grep to live_grep using 'ctrl-g' users
  -- may find it confusing why is the last typed query not
  -- considered the last search so we find out if that's the
  -- case and use the last typed prompt as the grep string
  if not opts.search or #opts.search == 0 and (opts.query and #opts.query > 0) then
    -- fuzzy match query needs to be regex escaped
    opts.no_esc = nil
    opts.search = opts.query
    -- also replace in `__call_opts` for `resume=true`
    opts.__call_opts.query = nil
    opts.__call_opts.no_esc = nil
    opts.__call_opts.search = opts.query
  end

  -- interactive interface uses 'query' parameter
  opts.query = opts.search or ""
  if opts.search and #opts.search > 0 then
    -- escape unless the user requested not to
    if not opts.no_esc then
      opts.query = utils.rg_escape(opts.search)
    end
  end

  return opts
end

M.normalize_live_grep_opts = normalize_live_grep_opts

M.live_grep_dynamic = function(opts)
  ---@type fzf-lua.config.Grep
  opts = normalize_live_grep_opts(opts)
  if not opts then
    return
  end

  opts.__ACT_TO = function(_options)
    local new_opts = vim.tbl_deep_extend("force", opts.grep_rg_options, _options or {})
    -- new_opts.fzf_opts = {
    --   ["--delimiter"] = " ≈",
    -- };
    return M.grep(new_opts)
  end

  -- search query in header line
  opts = core.set_title_flags(opts, { "cmd", "live" })
  opts = core.set_fzf_field_index(opts)
  core.fzf_live(opts.command_fn, opts)
end

return M
