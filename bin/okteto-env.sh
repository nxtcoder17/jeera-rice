#! /usr/bin/env sh

OKTETO_KUBE_CONFIG="$HOME/.kube/okteto-kube.config"
DEFAULT_KUBE_CONFIG="$HOME/.kube/config"

command=$1

case $command in 
  status)
    if [ "$OKTETO_KUBE_CONFIG" == "$KUBECONFIG" ]; then
      echo "OKTETO Configuration is up"
    else 
      echo "NORMAL K8s configuration is up"
    fi
    ;;
  activate) 
    export KUBECONFIG="$OKTETO_KUBE_CONFIG"
    echo $KUBECONFIG
    echo "Okteto Configuration is up"
    ;;
  deactivate) 
    export KUBECONFIG="$DEFAULT_KUBE_CONFIG"
    echo "Normal Configuration is up"
    exit
    ;;
esac
