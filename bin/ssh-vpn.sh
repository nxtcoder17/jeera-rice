#!/usr/bin/env bash

namespace=$1

kubectl run kuttle --image=nxtcoder17/alpine.python3:nonroot --restart=Never -- sh -c 'exec tail -f /dev/null'
sshuttle --dns -r kuttle -e kuttle 0.0.0.0/0

