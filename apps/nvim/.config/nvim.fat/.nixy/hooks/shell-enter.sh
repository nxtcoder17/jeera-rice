mkdir -p $HOME/.config

# echo "nixy-mode  = $NIXY_MODE"
if [ "$NIXY_MODE" = "colima" ]; then
  ln -sf /tmp/nvim $HOME/.config/
  ln -sf /tmp/fzf $HOME/.config/

  mkdir -p $HOME/.config/fish
  cp -r -s /tmp/fish/* $HOME/.config/fish/
  rm -f $HOME/.config/fish/fish_variables
fi
