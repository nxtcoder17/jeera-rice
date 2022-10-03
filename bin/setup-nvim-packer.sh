#! /usr/bin/env bash

install_dir="${XDG_DATA_HOME}/site/pack/packer/opt/packer.nvim"

[ -d $install_dir ] || {
  git clone --depth 1 "https://github.com/wbthomason/packer.nvim" $install_dir
}
