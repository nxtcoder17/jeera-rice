#! /usr/bin/env sh

NAMESPACE=$1
CLUSTER=$2

ACCOUNT="$NAMESPACE-acc"

mkdir $NAMESPACE

cd $NAMESPACE

echo $PWD

echo "Generating Private RSA key ..."
openssl genrsa -out $ACCOUNT.key 2048

echo "Generating Certificate Signing Request (CSR) ..."
openssl req -new -key $ACCOUNT.key -out $ACCOUNT.csr -subj "/CN=$NAMESPACE/O=$ACCOUNT"

cat > $ACCOUNT-kube-csr.yml <<EOF
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: $ACCOUNT
spec:
  request: $(cat $ACCOUNT.csr  | base64 | tr -d "\n")
  signerName: kubernetes.io/kube-apiserver-client
  usages:
    - client auth
EOF

kubectl apply -f $ACCOUNT-kube-csr.yml

kubectl certificate approve $ACCOUNT

echo 'Generting Cluster Certificate (CRT) ...'
kubectl get csr/$ACCOUNT -o json | jq '.status.certificate' -r | base64 -d > $ACCOUNT.crt

echo 'Creating Role ...'

cat > $ACCOUNT-role.yml <<EOF
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: $NAMESPACE
  name: $ACCOUNT-role
rules:
  - apiGroups:
      - extensions
      - apps
      - ""
    resources:
      - deployments
      - pods
      - namespaces
      - configmaps
      - services
    verbs:
      - get
      - list
      - watch
      - create
      - update
      - patch 
      - delete
EOF
kubectl apply -f $ACCOUNT-role.yml

echo 'Creating RoleBindings ...'
cat > $ACCOUNT-rolebinding.yml <<EOF
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: $ACCOUNT-rolebinding
  namespace: $NAMESPACE
subjects:
  - kind: User
    name: $ACCOUNT
    apiGroup: ''
roleRef:
  kind: Role
  name: $ACCOUNT-role
  apiGroup: ''
EOF
kubectl apply -f $ACCOUNT-rolebinding.yml

echo 'Generating Access Credentials ...'
kubectl config set-credentials $ACCOUNT --client-key=$ACCOUNT.key --client-certificate=$ACCOUNT.crt --embed-certs=true

echo "Generating context ..."
kubectl config set-context $ACCOUNT --cluster=$CLUSTER --user=$ACCOUNT


echo "[WARNING] To Delete this context [delete]: \`kubectl config delete-context $currentCtx\`"
echo "To Use this context [use]: \`kubectl config use-context $ACCOUNT\` "
currentCtx=$(kubectl config current-context)
kubectl config use-context $ACCOUNT

echo "saving account kubeconfig to $ACCOUNT-kubeconfig.yml"
kubectl config view --raw --minify=true > $ACCOUNT-kubeconfig.yml
kubectl config use-context $currentCtx

echo "cleaning up existing kubeconfigs for sanity reasons ..."
kubectl config delete-context $ACCOUNT > /dev/null

echo "DONE 🚀"
