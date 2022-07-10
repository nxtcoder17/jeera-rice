#! /usr/bin/env bash

USERNAME=$1
shift 1;
NAMESPACES=( "$@" )

primaryNamespace=${NAMESPACES[0]}

username=$USERNAME
contextName=kl-context

manifestsDir="$primaryNamespace/manifests"
[ -d "$manifestsDir" ] || mkdir -p "$manifestsDir"
pushd "$manifestsDir" || (echo "pushd failed, exiting ..." && exit 1)


# current-context
currentCtx=$(kubectl config view -o jsonpath='{.current-context}')
clusterName=$(kubectl config view -o json | jq -r ".contexts[] | select(.name == \"$currentCtx\")| .context.cluster")
clusterUrl=$(kubectl config view -o json | jq -r ".clusters[] | select(.name == \"$currentCtx\") | .cluster.server")

KUBECTL=${KUBECTL:-kubectl}

#echo $currentCtx $clusterUrl $clusterName

# kubectl config current-context set namespace $NAMESPACE
cat > svc-account.sh <<EOF
kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: $username
  namespace: $primaryNamespace
EOF
kubectl apply -f 

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
      - batch
    resources:
      - namespaces
      - jobs
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
  name: $username-cluster-rb
  namespace: $ns
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: $username-cluster-role
subjects:
  - kind: ServiceAccount
    name: $username
    namespace: $primaryNamespace
EOF
done

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
