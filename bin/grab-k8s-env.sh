#! /usr/bin/env bash

namespace=$1
deployment=$2

# from env
x=""

for item in $(kubectl get deploy/$deployment -n $namespace -o json | jq -r .spec.template.spec.containers[].envFrom[].secretRef.name | xargs)
do
  # kubectl get secret/$item -n $namespace -o json | jq -r -e '.data|keys|.[]' | xargs
  if [[ $item  != "null" ]]; then
    for cItem in $(kubectl get secret/$item -n $namespace -o json | jq -r -e '.data|keys|.[]' | xargs)
    do
      x+="echo $cItem=\'\"\$$cItem\"\';"
    done
  fi
done

for item in $(kubectl get deploy/$deployment -n $namespace -o json | jq -r .spec.template.spec.containers[].envFrom[].configMapRef.name | xargs)
do
  if [[ $item  != "null" ]]; then
    for cItem in $(kubectl get config/$item -n $namespace -o json | jq -r -e '.data|keys|.[]' | xargs)
    do
      x+="echo $cItem=\'\"\$$cItem\"\';"
    done
  fi
done

for item in $(kubectl get deploy/$deployment -n $namespace -o json | jq -r .spec.template.spec.containers[].env[].name | xargs)
do
  x+="echo $item=\'\"\$$item\"\';"
done

kubectl -n $namespace exec deploy/$deployment -- sh -c "$x"
