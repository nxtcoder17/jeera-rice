#! /usr/bin/env bash

echo "$@" > /tmp/ol
podRef=$1
IFS=/; read -a items <<< $podRef

if [ ${#items} -gt 1 ]; then
  namespace=${items[0]}
  podName=${items[1]}
else
  podName=${items[0]}
fi

echo "$1" >> /tmp/ol
shift 2;
echo "$@" >> /tmp/ol

if [ $namespace != "" ]; then
  echo "exec kubectl exec -n $namespace -i $podName -- $@" >> /tmp/ol
  eval kubectl exec -n $namespace -i $podName -- "$@"
else
  echo "exec kubectl exec -i $podName -- $@" >> /tmp/ol
  eval kubectl exec -i $podName -- "$@"
fi
# exec kubectl exec -i $podName -- $@

