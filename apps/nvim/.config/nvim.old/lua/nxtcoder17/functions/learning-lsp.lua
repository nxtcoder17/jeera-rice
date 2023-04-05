local function request(method, params, handler)
  -- validate({
  --   method = { method, 's' },
  --   handler = { handler, 'f', true },
  -- })
  return vim.lsp.buf_request(0, method, params, handler)
end

local function request_with_options(name, params, options)
  local req_handler
  if options then
    req_handler = function(err, result, ctx, config)
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      local handler = client.handlers[name] or vim.lsp.handlers[name]
      handler(err, result, ctx, vim.tbl_extend("force", config or {}, options))
    end
  end
  request(name, params, req_handler)
end

local util = require("vim.lsp.util")

local M = {}

M.ref = function()
  local params = util.make_position_params()
  params.context = {
    includeDeclaration = true,
  }

  -- req_handler = function(err, result, ctx, config)
  --   local client = vim.lsp.get_client_by_id(ctx.client_id)
  --   local handler = client.handlers[name] or vim.lsp.handlers[name]
  --   handler(err, result, ctx, vim.tbl_extend("force", config or {}, options))
  -- end

  local name = "textDocument/definition"
  -- local name = 'textDocument/implementation'
  request(name, params, function(err, result, ctx, config)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local handler = client.handlers[name] or vim.lsp.handlers[name]
    print(vim.inspect(result))
    -- handler(err, result, ctx, vim.tbl_extend("force", config or {}, options))
  end)

  -- request_with_options("textDocument/references", params, {})
end

return M

-- function M.references(context, options)
--   validate({ context = { context, 't', true } })
--   local params = util.make_position_params()
--   params.context = context or {
--     includeDeclaration = true,
--   }
--   request_with_options('textDocument/references', params, options)
-- end
