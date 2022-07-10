#! /usr/bin/env bash

USERNAME=$1
shift 1;
NAMESPACES=( "$@" )

primaryNamespace=${NAMESPACES[0]}

username=$USERNAME
contextName=kl-context

KUBECTL=${KUBECTL:-kubectl}

# current-context
currentCtx=$($KUBECTL config view -o jsonpath='{.current-context}')
clusterName=$($KUBECTL config view -o json | jq -r ".contexts[] | select(.name == \"$currentCtx\")| .context.cluster")
clusterUrl=$($KUBECTL config view -o json | jq -r ".clusters[] | select(.name == \"$currentCtx\") | .cluster.server")

contextName="$currentCtx-user"

dir="$PWD/$username"
manifestsDir="$dir/manifests"
[ -d "$manifestsDir" ] || mkdir -p "$manifestsDir"
pushd "$dir" || (echo "pushd failed, exiting ..." && exit 1)
echo "$primaryNamespace" > PRIMARY_NAMESPACE
pushd "$manifestsDir" || (echo "pushd failed, exiting ..." && exit 1)

# kubectl config current-context set namespace $NAMESPACE
cat > svc-account.sh <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: $username
  namespace: $primaryNamespace
EOF

$KUBECTL apply -f svc-account.sh
popd

secret=$($KUBECTL get sa "$username" -n "$primaryNamespace" -o json | jq -r .secrets[].name)

# Get ca.crt from secret
$KUBECTL get secret "$secret" -n "$primaryNamespace" -o json | jq -r '.data["ca.crt"]' | base64 -d > ./ca.crt

# Get service account token from secret
user_token=$($KUBECTL get secret "$secret" -n "$primaryNamespace" -o json | jq -r '.data["token"]' | base64 -d)

pushd $manifestsDir

## for primary namespace, all actions allowed
cat > primary-$primaryNamespace-role.yml <<EOF
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
kubectl apply -f primary-$primaryNamespace-role.yml

# creating role for secondary namespaces
cat > cluster-role.yml <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: $username-cluster-role
rules:
  - apiGroups:
      - ""
      - apps
      - batch
    resources:
      - jobs
      - deployments
      - services
      - clusterroles
    verbs:
      - get
      - list
      - watch
  - apiGroups:
      - ""
    resources:
      - namespaces
    verbs:
      - get
      - list
EOF
kubectl apply -f cluster-role.yml

cat > cluster-rb.yml <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: $username-cluster-rb
subjects:
  - kind: ServiceAccount
    name: $username
    namespace: $primaryNamespace
roleRef:
  kind: ClusterRole
  name: $username-cluster-role
  apiGroup: "rbac.authorization.k8s.io"
EOF
$KUBECTL apply -f cluster-rb.yml

# for ns in "${NAMESPACES[@]:1}"
# do
#   # apply role bindings in secondary namespace
#   name=cluster-rb-ns-$ns.yml
# cat > $name <<EOF
# apiVersion: rbac.authorization.k8s.io/v1
# kind: RoleBinding
# metadata:
#   name: $username-cluster-rb
#   namespace: $ns
# roleRef:
#   apiGroup: rbac.authorization.k8s.io
#   kind: ClusterRole
#   name: $username-cluster-role
# subjects:
#   - kind: ServiceAccount
#     name: $username
#     namespace: $primaryNamespace
# EOF

# $KUBECTL apply -f $name
# done

popd

# ############ using
kubectl config set-cluster "$clusterName"  --embed-certs=true --server="$clusterUrl" --certificate-authority=./ca.crt

# Set user credentials
kubectl config set-credentials "$username" --token="$user_token"

# Define the combination of user1 user with the EKS cluster
kubectl config set-context $contextName --cluster="$clusterName" --user="$username" --namespace="$primaryNamespace"
kubectl config use-context $contextName

#kubectl config view --raw --minify=true
echo "saving account kubeconfig to $username-kubeconfig.yml"
kubectl config view --raw --minify=true > kubeconfig.yml
kubectl config use-context "$currentCtx"

echo "cleaning up existing kubeconfig for sanity reasons ..."
kubectl config delete-context $contextName > /dev/null

echo "DONE 🚀"
