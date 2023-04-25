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
cat > svc-account.yaml <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: $username
  namespace: $primaryNamespace
# secrets:
#   - name: $username-svc-acc-secret
EOF

$KUBECTL apply -f svc-account.yaml

cat > svc-account-secret.yml <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: $username-svc-acc-secret
  namespace: $primaryNamespace
  annotations:
    kubernetes.io/service-account.name: $username
type: kubernetes.io/service-account-token
EOF

$KUBECTL apply -f svc-account-secret.yml
# exit 0
popd

# secret=$($KUBECTL get sa "$username" -n "$primaryNamespace" -o json | jq -r .secrets[].name)
secret="$username-svc-acc-secret"

echo "secret found: $secret"

# Get ca.crt from secret
$KUBECTL get secret "$secret" -n "$primaryNamespace" -o json | jq -r '.data["ca.crt"]' | base64 -d > ./ca.crt

# Get service account token from secret
user_token=$($KUBECTL get secret "$secret" -n "$primaryNamespace" -o json | jq -r '.data["token"]' | base64 -d)

pushd $manifestsDir

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
  name: cluster-admin
  # name: $username-cluster-role
  apiGroup: "rbac.authorization.k8s.io"
EOF
$KUBECTL apply -f cluster-rb.yml

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
