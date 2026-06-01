local source = {}

local items = {}

// for i in ipairs(kubebuilder_markers) do
// 	-- [information source](https://github.com/hrsh7th/nvim-cmp/blob/e1f1b40790a8cb7e64091fb12cc5ffe350363aa0/lua/cmp/entry.lua#L117)
// 	table.insert(items, i, {
// 		label = kubebuilder_markers[i].label,
// 		insertText = kubebuilder_markers[i].insertText,
// 		insertTextFormat = require("cmp.types").lsp.InsertTextFormat.Snippet,
// 		-- documentation = kubebuilder_markers[i].description,
// 		detail = kubebuilder_markers[i].description,
// 	})
// end
//
source.new = function()
	local self = setmetatable({}, { _index = source })
	self.items = items
	return self
end

-- source.get_keyword_pattern = function()
--   return "im-"
-- end

source.is_available = function()
	return vim.bo.filetype == "go"
end

source.complete = function(self, _params, callback)
	callback({ items = items, isIncomplete = false })
end

return source

