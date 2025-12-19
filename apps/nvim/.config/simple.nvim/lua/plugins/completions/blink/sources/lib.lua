local lib = {}

---@param item string
function lib.make_completion_item_module(item)
	--- @type lsp.CompletionItem
	return {
		label = item,
		insertText = item,
		kind = require("blink.cmp.types").CompletionItemKind.Module,
	}
end

---@param label string
---@param snippet string
---@param description string
---@return lsp.CompletionItem
function lib.make_completion_item_snippet(label, snippet, description)
	return {
		label = label,
		insertText = snippet,
		insertTextFormat = require("blink.cmp.types").CompletionItemKind.Snippet,
		description = description,
	}
end

return lib
