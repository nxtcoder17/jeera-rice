---@module 'blink.cmp'
---@class GoImportsSource : blink.cmp.Source
---@field items blink.cmp.CompletionItem[]
local go_imports = {
	items = {},
}

function go_imports.new(_) end

---@param context blink.cmp.Context
function go_imports.get_completions(context, callback)
	callback({
		is_incomplete_forward = false,
		is_incomplete_backward = false,
		items = self.items,
	})
end

return go_imports
