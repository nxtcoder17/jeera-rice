#! /usr/bin/env sh

NAMESPACE=$1
CLUSTER=$2

ACCOUNT="$NAMESPACE"

mkdir $NAMESPACE

cd $NAMESPACE

echo $PWD

echo "Generating Private RSA key ..."
openssl genrsa -out $NAMESPACE.key 2048

echo "Generating Certificate Signing Request (CSR) ..."
openssl req -new -key $NAMESPACE.key -out $NAMESPACE.csr -subj "/CN=$NAMESPACE/O=$ACCOUNT"

cat > $NAMESPACE-kube-csr.yml <<EOF
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: $ACCOUNT
spec:
  request: $(cat $NAMESPACE.csr  | base64 | tr -d "\n")
  signerName: kubernetes.io/kube-apiserver-client
  usages:
    - client auth
EOF

kubectl apply -f $NAMESPACE-kube-csr.yml

kubectl certificate approve $ACCOUNT

echo 'Generting Cluster Certificate (CRT) ...'
kubectl get csr/$ACCOUNT -o json | jq '.status.certificate' -r | base64 -d > $NAMESPACE.crt

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
      - replicasets
      - pods
      - namespaces
      - configmaps
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
kubectl config set-credentials $ACCOUNT --client-key=$NAMESPACE.key --client-certificate=$NAMESPACE.crt --embed-certs=true

echo "Generating context ..."
kubectl config set-context $ACCOUNT --cluster=$CLUSTER --user=$ACCOUNT


echo "To Use this context [use]: \`kubectl config use-context $ACCOUNT\` "

