#!/usr/bin/env bash

# nn=$1
# IFS="/"; read -a arr <<<$nn

# namespace=${arr[0]}
# name=${arr[1]}

kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod 
metadata:
  name: ssh-vpn
spec:
  containers:
    - name: main
      image: nxtcoder17/alpine.python3:nonroot
      command:
        - sh
        - -c
        - tail -f /dev/null
  tolerations:
    - effect: NoSchedule
      key: node-role.kubernetes.io/control-plane
      operator: Exists
  nodeSelector:
    node-role.kubernetes.io/control-plane: ""
EOF

kubectl wait --for=condition=Ready pod/ssh-vpn

# kubectl run kuttle --image=nxtcoder17/alpine.python3:nonroot --restart=Never -- sh -c 'exec tail -f /dev/null'
# kubectl run ssh-vpn --image=nxtcoder17/alpine.python3:nonroot --restart=Never -- sh -c 'exec tail -f /dev/null'

# sshuttle --dns -r kuttle -e kuttle 0.0.0.0/0
# sshuttle -v --ns-hosts '*.svc.cluster.local' -r ssh-vpn -e kuttle 10.43.0.0/16 10.42.0.0/16
sshuttle --dns -r ssh-vpn -e kuttle 10.0.0.0/24

