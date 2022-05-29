NAMESPACE=$1

USERNAME=kl-user
CONTEXT_NAME=kl-context

mkdir $NAMESPACE
pushd $NAMESPACE

# current-context
currentCtx=$(kubectl config view -o jsonpath='{.current-context}')

clusterName=$(kubectl config view -o json | jq -r ".contexts[] | select(.name == \"$currentCtx\")| .context.cluster")

clusterUrl=$(kubectl config view -o json | jq -r ".clusters[] | select(.name == \"$currentCtx\") | .cluster.server")

echo $currentCtx $clusterUrl $clusterName

# kubectl config current-context set namespace $NAMESPACE
kubectl create sa $USERNAME --namespace $NAMESPACE
secret=$(kubectl get sa $USERNAME -n $NAMESPACE -o json | jq -r .secrets[].name)

# Get ca.crt from secret 
kubectl get secret $secret -n $NAMESPACE -o json | jq -r '.data["ca.crt"]' | base64 -d > ca.crt
# Get service account token from secret
user_token=$(kubectl get secret $secret -n $NAMESPACE -o json | jq -r '.data["token"]' | base64 -d)

echo USER_TOKEN: $user_token

# creating role for this user
cat > $USERNAME-role.yml <<EOF
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: $USERNAME-role
  namespace: $NAMESPACE
rules:
  - apiGroups:
      - ""
      - extensions
      - apps
    resources:
      - "*"
    verbs:
      - "*"
  - apiGroups:
      - batch
    resources:
      - jobs
      - cronjobs
    verbs:
      - "*"
EOF
kubectl apply -f $USERNAME-role.yml

# Create the yaml to bind the cluster admin role to user1
cat > $USERNAME-role-binding.yml <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: $USERNAME-role-binding
  namespace: $NAMESPACE
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role 
  name: $USERNAME-role
subjects:
  - kind: ServiceAccount
    name: $USERNAME
    namespace: $NAMESPACE
EOF
# Apply the policy to user1
kubectl apply -f $USERNAME-role-binding.yml

# ############ using
kubectl config set-cluster $clusterName  --embed-certs=true --server=$clusterUrl --certificate-authority=./ca.crt

# Set user credentials 
kubectl config set-credentials $USERNAME --token=$user_token

# Define the combination of user1 user with the EKS cluster
kubectl config set-context $CONTEXT_NAME --cluster=$clusterName --user=$USERNAME --namespace=$NAMESPACE
kubectl config use-context $CONTEXT_NAME

kubectl config view --raw --minify=true 
echo "saving account kubeconfig to $USERNAME-$NAMESPACE-kubeconfig.yml"
kubectl config view --raw --minify=true > $USERNAME-$NAMESPACE-kubeconfig.yml
kubectl config use-context $currentCtx

echo "cleaning up existing kubeconfigs for sanity reasons ..."
kubectl config delete-context $CONTEXT_NAME > /dev/null

echo "DONE 🚀"
