local lib = Require("plugins.completions.blink.sources.lib")

local common_pkg_imports = {
	-- k8s.io types
	'corev1 "k8s.io/api/core/v1"',
	'appsv1 "k8s.io/api/apps/v1"',
	'metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"',
	'batchv1 "k8s.io/api/batch/v1"',
	'storagev1 "k8s.io/api/storage/v1"',
	'networkingv1 "k8s.io/api/networking/v1"',
	'autoscalingv2 "k8s.io/api/autoscaling/v2"',
	'rbacv1 "k8s.io/api/rbac/v1"',

	-- k8s.io utils
	'yamlutil "k8s.io/apimachinery/pkg/util/yaml"',
	'apiextensionsv1 "k8s.io/apiextensions-apiserver/pkg/apis/apiextensions/v1"',
	"k8s.io/kubernetes/pkg/util/taints",

	-- apimachinery
	'apiErrors "k8s.io/apimachinery/pkg/api/errors"',
	'apiLabels "k8s.io/apimachinery/pkg/labels"',
	'apiTypes "k8s.io/apimachinery/pkg/types"',
	'apiMeta "k8s.io/apimachinery/pkg/api/meta"',

	-- sigs.k8s.io
	'"sigs.k8s.io/yaml"',
	'ctrl "sigs.k8s.io/controller-runtime"',
	'controllerutil "sigs.k8s.io/controller-runtime/pkg/controller/controllerutil"',
	'"sigs.k8s.io/controller-runtime/pkg/client"',
	'"sigs.k8s.io/controller-runtime/pkg/handler"',
	'"sigs.k8s.io/controller-runtime/pkg/source"',
	'"sigs.k8s.io/controller-runtime/pkg/reconcile"',
	'"sigs.k8s.io/controller-runtime/pkg/controller"',

	-- client-go
	'"k8s.io/client-go/rest"',
	'clientgoscheme "k8s.io/client-go/kubernetes/scheme"',
}

local kubebuilder_markers = {
	{
		label = "kubebuilder:marker validation enum",
		insertText = "// +kubebuilder:validation:Enum=${0:item1;item2;item3}",
		description = [[
      [Source](https://book.kubebuilder.io/reference/markers.html#markers-for-configcode-generation)
      // +kubebuilder:validation:Enum=Wallace;Gromit;Chicken
    ]],
	},
	{
		label = "kubebuilder:marker Maximum Validation",
		insertText = "// +kubebuilder:validation:Maximum=${0:17}",
		description = [[
      [Source](https://book.kubebuilder.io/reference/markers.html#markers-for-configcode-generation)
      // +kubebuilder:validation:Maximum=17
    ]],
	},
	{
		label = "kubebuilder:marker Minimum Validation",
		insertText = "// +kubebuilder:validation:Minimum=${0:0}",
		description = [[ **On Field**
      // +kubebuilder:validation:Mimimum=0
      [Source](https://book.kubebuilder.io/reference/markers.html#markers-for-configcode-generation)
    ]],
	},
	{
		label = "kubebuilder:marker MinLength validation",
		insertText = "// +kubebuilder:validation:MinLength=${0:1}",
		description = [[ On Field
    specifies the minimum length for this string.
    ]],
	},
	{
		label = "kubebuilder:printcolumn:JSONPath",
		insertText = '// +kubebuilder:printcolumn:JSONPath="${1:.metadata.name}",name=${2:ColumnName},type=${3:string}',
		description = [[ On Field
      specifies the printcolumn for a jsonpath field
    ]],
	},
}

---@module 'blink.cmp'
---@class GoImportsSource: blink.cmp.Source
---@field completion_items blink.cmp.CompletionItem[]
local go_imports = {}

function go_imports.new(opts)
	local self = setmetatable({}, { __index = go_imports })
	self.opts = opts

	local items = {}

	for i in ipairs(common_pkg_imports) do
		table.insert(items, i, lib.make_completion_item_module(common_pkg_imports[i]))
	end

	for i in ipairs(kubebuilder_markers) do
		-- table.insert(items, i, lib.make_completion_item_snippet(table.unpack(kubebuilder_markers[i])))
		table.insert(items, i, {
			label = kubebuilder_markers[i].label,
			insertText = kubebuilder_markers[i].insertText,
			insertTextFormat = require("blink.cmp.types").CompletionItemKind.Snippet,
			-- documentation = kubebuilder_markers[i].description,
			detail = kubebuilder_markers[i].description,
		})
	end

	self.completion_items = items

	return self
end

function go_imports:enabled()
	return vim.bo.filetype == "go"
end

---@param ctx blink.cmp.Context
function go_imports:get_completions(ctx, callback)
	callback({
		is_incomplete_forward = false,
		is_incomplete_backward = false,
		items = self.completion_items,
	})

	return function() end
end

return go_imports
