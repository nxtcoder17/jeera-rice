#! /usr/bin/env bash

cmd=$1
shift 1;

case $cmd in 
  remove-finalizers)
    # kubectl get apps -n kl-core | tail -n+2 | awk '{print $1}' |xargs -I{} kubectl patch app/{} -n kl-core --type='json' -p='[{"op": "replace", "path": "/metadata/finalizers"}]'
    kubectl patch "$@" --type='json' -p='[{"op": "replace", "path": "/metadata/finalizers"}]'

    ;;
esac
