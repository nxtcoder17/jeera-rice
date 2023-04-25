local source = {}

local common_go_imports = {
  -- k8s.io types
  'corev1 "k8s.io/api/core/v1"',
  'appsv1 "k8s.io/api/apps/v1"',
  'metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"',
  'storagev1 "k8s.io/api/storage/v1"',
  'networkingv1 "k8s.io/api/networking/v1"',
  'autoscalingv2 "k8s.io/api/autoscaling/v2"',

  -- k8s.io utils
  'yamlutil "k8s.io/apimachinery/pkg/util/yaml"',

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

local items = {}
for i in ipairs(common_go_imports) do
  table.insert(items, i, { label = common_go_imports[i] })
  -- table.insert(items, i, { label = "im-" .. common_go_imports[i] })
end

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
