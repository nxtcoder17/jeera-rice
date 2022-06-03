#! /usr/bin/env bash

NAMESPACES=( "$@" )

primaryNamespace=${NAMESPACES[0]}

username=kl-${primaryNamespace}-user
contextName=kl-context

[ -d "$primaryNamespace" ] || mkdir "$primaryNamespace"
pushd "$primaryNamespace" || (echo "pushd failed, exiting ..." && exit 1)

# current-context
currentCtx=$(kubectl config view -o jsonpath='{.current-context}')

clusterName=$(kubectl config view -o json | jq -r ".contexts[] | select(.name == \"$currentCtx\")| .context.cluster")

clusterUrl=$(kubectl config view -o json | jq -r ".clusters[] | select(.name == \"$currentCtx\") | .cluster.server")

#echo $currentCtx $clusterUrl $clusterName

# kubectl config current-context set namespace $NAMESPACE
kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: $username
  namespace: $primaryNamespace
EOF

secret=$(kubectl get sa "$username" -n "$primaryNamespace" -o json | jq -r .secrets[].name)

# Get ca.crt from secret
kubectl get secret "$secret" -n "$primaryNamespace" -o json | jq -r '.data["ca.crt"]' | base64 -d > ca.crt

# Get service account token from secret
user_token=$(kubectl get secret "$secret" -n "$primaryNamespace" -o json | jq -r '.data["token"]' | base64 -d)

## for primary namespace, all actions allowed
cat > "$username"-primary-role.yml <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: $username-role
  namespace: $primaryNamespace
rules:
  - apiGroups:
      - ""
      - extensions
      - apps
      - batch
    resources:
      - "*"
    verbs:
      - "*"

---

apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: $username-rb
  namespace: $primaryNamespace
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: $username-role
subjects:
  - kind: ServiceAccount
    name: $username
    namespace: $primaryNamespace
EOF
kubectl apply -f "$username"-primary-role.yml


# creating role for secondary namespaces
cat > "$username"-role.yml <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: $username-cluster-role
rules:
  - apiGroups:
      - ""
      - apps
    resources:
      - deployments
      - services
      - clusterroles
    verbs:
      - get
      - list
      - watch
EOF
kubectl apply -f "$username"-role.yml

for ns in "${NAMESPACES[@]:1}"
do
  # apply role bindings in secondary namespace
kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: $username-rb
  namespace: $ns
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: $username-role
subjects:
  - kind: ServiceAccount
    name: $username
    namespace: $primaryNamespace
EOF
done

## telepresence requirements
#kubectl apply -f - <<EOF
#kind: ClusterRole
#apiVersion: rbac.authorization.k8s.io/v1
#metadata:
#  name:  telepresence-role
#rules:
#- apiGroups:
#  - ""
#  resources: ["pods"]
#  verbs: ["get", "list", "create", "watch", "delete"]
#- apiGroups:
#  - ""
#  resources: ["services"]
#  verbs: ["update"]
#- apiGroups:
#  - ""
#  resources: ["pods/portforward"]
#  verbs: ["create"]
#
#- apiGroups:
#  - "apps"
#  resources: ["deployments", "replicasets", "statefulsets"]
#  verbs: ["get", "list", "update", "watch"]
#
#- apiGroups:
#  - "getambassador.io"
#  resources: ["hosts", "mappings"]
#  verbs: ["*"]
#
#- apiGroups:
#  - ""
#  resources: ["endpoints"]
#  verbs: ["get", "list", "watch"]
#
#---
#
#kind: Role
#apiVersion: rbac.authorization.k8s.io/v1
#metadata:
#  name:  telepresence-only-ambassador-role
#  namespace: ambassador
#rules:
#  - apiGroups:
#    - "*"
#    resources:
#    - "*"
#    verbs:
#    - "*"
#  - apiGroups:
#    - "rbac.authorization.k8s.io"
#    resources:
#      - "*"
#    verbs:
#      - list
#      - get
#      - watch
#---
#
#kind: RoleBinding
#apiVersion: rbac.authorization.k8s.io/v1
#metadata:
#  name: telepresence-only-ambassador-binding
#  namespace: ambassador
#subjects:
#  - kind: ServiceAccount
#    name: $username
#    namespace: $primaryNamespace
#roleRef:
#  kind: Role
#  name: telepresence-only-ambassador-role
#  apiGroup: rbac.authorization.k8s.io
#
#---
#
## RBAC to access ambassador namespace
#kind: RoleBinding
#apiVersion: rbac.authorization.k8s.io/v1
#metadata:
#  name: telepresence-self-binding
#  namespace: ambassador
#subjects:
#- kind: ServiceAccount
#  name: $username
#  namespace: $primaryNamespace
#roleRef:
#  kind: ClusterRole
#  name: telepresence-role
#  apiGroup: rbac.authorization.k8s.io
#
#---
#
## :TELEPRESENCE: for namespaces that have to be intercepted
#kind: RoleBinding
#apiVersion: rbac.authorization.k8s.io/v1
#metadata:
#  name: telepresence-role-binding
#  namespace: $primaryNamespace
#subjects:
#- kind: ServiceAccount
#  name: $username
#  namespace: $primaryNamespace
#roleRef:
#  kind: ClusterRole
#  name: telepresence-role
#  apiGroup: rbac.authorization.k8s.io
#
#---
#
#kind: ClusterRole
#apiVersion: rbac.authorization.k8s.io/v1
#metadata:
#  name:  telepresence-namespace-role
#rules:
#- apiGroups:
#  - ""
#  - apps
#  resources:
#    - namespaces
#    - services
#    - deployments
#  verbs: ["get", "list", "watch"]
#
#- apiGroups:
#  - "rbac.authorization.k8s.io"
#  - "admissionregistration.k8s.io"
#  resources:
#    - "*"
#  verbs:
#    - list
#    - get
#    - watch
#
#---
#
#kind: ClusterRoleBinding
#apiVersion: rbac.authorization.k8s.io/v1
#metadata:
#  name: telepresence-namespace-binding
#subjects:
#- kind: ServiceAccount
#  name: $username
#  namespace: $primaryNamespace
#roleRef:
#  kind: ClusterRole
#  name: telepresence-namespace-role
#  apiGroup: rbac.authorization.k8s.io
#EOF

# ############ using
kubectl config set-cluster "$clusterName"  --embed-certs=true --server="$clusterUrl" --certificate-authority=./ca.crt

# Set user credentials
kubectl config set-credentials "$username" --token="$user_token"

# Define the combination of user1 user with the EKS cluster
kubectl config set-context $contextName --cluster="$clusterName" --user="$username" --namespace="$primaryNamespace"
kubectl config use-context $contextName

#kubectl config view --raw --minify=true
echo "saving account kubeconfig to $username-kubeconfig.yml"
kubectl config view --raw --minify=true > "$username"-kubeconfig.yml
kubectl config use-context "$currentCtx"

echo "cleaning up existing kubeconfig for sanity reasons ..."
kubectl config delete-context $contextName > /dev/null

echo "DONE 🚀"
