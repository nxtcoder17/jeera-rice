{
  description = "nixy project development workspace";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils/11707dc2f618dd54ca8739b309ec4fc024de578b";
    nixpkgs_default.url = "github:nixos/nixpkgs/050e09e091117c3d7328c7b2b7b577492c43c134";
  };

  outputs = {
      self, flake-utils,nixpkgs_default,
    }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs_default {
          inherit system;
          config.allowUnfree = true;
        };

        pkgs_default = import nixpkgs_default {
          inherit system;
          config.allowUnfree = true;
        };

        packages = [
          pkgs_default.bash
          pkgs_default.bash-completion
        ] ++ (pkgs.lib.optionals pkgs.stdenv.isLinux [ pkgs.glibcLocales ]);

        libraries = pkgs.lib.makeLibraryPath [
        ];
        
        # Custom URL packages
        urlPackages = [

          (pkgs.writeShellScriptBin "patch-dynamic-loader" ''
            set -euo pipefail

            if [ $# -ne 1 ]; then
              echo "Usage: patch-dynamic-loader <binary>"
              exit 1
            fi

            BIN="$1"

            patchelf \
              --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
              "$BIN"
          '')
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          # hardeningDisable = [ "all" ];

          buildInputs = packages ++ urlPackages;

          shellHook = ''
            ${
              if pkgs.stdenv.isLinux
              then ''export LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive''
              else ''''
            }

            source ${pkgs_default.bash-completion}/etc/profile.d/bash_completion.sh

            if [ -z "$LANG" ]; then
              # INFO: if LANG env var unset, set it to en_US.UTF-8
              export LANG="en_US.UTF-8"
            fi

            # INFO: this ensures, we always have /usr/bin/env
            [ ! -e /usr/bin ] && [ -e "${pkgs.coreutils}/bin" ] && ln -sf ${pkgs.coreutils}/bin /usr/bin
            [ ! -e /usr/share ] && [ -e "${pkgs.coreutils}/share" ] && ln -sf ${pkgs.coreutils}/share /usr/share
            [ ! -e /usr/libexec ] && [ -e "${pkgs.coreutils}/libexec" ] && ln -sf ${pkgs.coreutils}/libexec /usr/libexec
            [ ! -e /usr/lib ] && [ -e "${pkgs.coreutils}/lib" ] && ln -sf ${pkgs.coreutils}/lib /usr/lib

            # INFO: it seems like many tools have hardcoded value for /bin/sh, so we need to make sure that /bin/sh exists
            if [ ! -e "/bin/sh" ]; then
              mkdir -p /bin
              ln -sf $(which bash) /bin/sh
            fi

            if [ -n "${libraries}" ]; then
              export LD_LIBRARY_PATH="${libraries}:$LD_LIBRARY_PATH"
            fi

            if [ -e shell-enter.sh ]; then
              source "shell-enter.sh"
            fi

            if [ -n "$NIXY_BUILD_SCRIPT" ] && [ -e "$NIXY_BUILD_SCRIPT" ]; then
              source "$NIXY_BUILD_SCRIPT"
            fi

            cd /home/nxtcoder17/.config/nvim
          '';
        };

      }
    );
}