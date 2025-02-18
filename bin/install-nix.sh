#! /usr/bin/env bash

set -o nounset
set -o pipefail
set -o errexit

cmd=$1
shift 1;

case $cmd in
  install-nix)
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix |
    sh -s -- install ostree --persistence=/var/lib/nix
    ;;
  uninstall-nix)

    ;;
  install-home-manager)
    ;;
  install-nixgl)
    nix-channel --add https://github.com/nix-community/nixGL/archive/main.tar.gz nixgl
    nix-channel --update
    nix-env -iA nixgl.auto.nixGLNvidia
    ;;
  *)
    echo "bad command: install|uninstall"
    ;;
esac
