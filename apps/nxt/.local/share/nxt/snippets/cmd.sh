#! /usr/bin/env bash

set -o nounset
set -o pipefail
set -o errexit

cmd=$1
shift 1;

case $cmd in 
  install)
    ;;
  uninstall)
    ;;

  *)
    echo "only install|uninstall supported"
    ;;
esac
