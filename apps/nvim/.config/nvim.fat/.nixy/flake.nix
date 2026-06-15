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
          pkgs_default.bat
          pkgs_default.bc
          pkgs_default.bun
          pkgs_default.coreutils-full
          pkgs_default.curl
          pkgs_default.dust
          pkgs_default.eza
          pkgs_default.fd
          pkgs_default.fzf
          pkgs_default.gh
          pkgs_default.git
          pkgs_default.git-filter-repo
          pkgs_default.go
          pkgs_default.google-chrome
          pkgs_default.jq
          pkgs_default.less
          pkgs_default.ncurses
          pkgs_default.nerdctl
          pkgs_default.nodejs
          pkgs_default.podman
          pkgs_default.ripgrep
          pkgs_default.unixtools.whereis
          pkgs_default.unzip
          pkgs_default.which
          pkgs_default.wl-clipboard
          pkgs_default.xdg-utils
          pkgs_default.yq
          pkgs_default.zed-editor
        ] ++ (pkgs.lib.optionals pkgs.stdenv.isLinux [ pkgs.glibcLocales ]);

        libraries = pkgs.lib.makeLibraryPath [
        ];
        
        # Custom URL packages
        urlPackages = [
          (pkgs.stdenv.mkDerivation rec {
            name = "nvim";
            pname = "nvim";
            src = pkgs.fetchurl {
              url = "https://github.com/neovim/neovim/releases/download/v0.12.2/nvim-linux-x86_64.tar.gz";
              sha256 = "sha256-Mc+FlFy2ANls32n4i8aL7IFKy/9QhjxVRq3vOhvO8mA=";
            };
            nativeBuildInputs = with pkgs; [
              unzip p7zip unrar xz gzip bzip2 zstd lzip
              patchelf autoPatchelfHook
            ];
            unpackPhase = ''
              echo ">> Detecting archive type for $src"
              mime=$(file -b --mime-type "$src")
              echo ">> Got: $mime"

              try_tar() {
                if tar tf "$src" >/dev/null 2>&1; then
                  echo ">> Extracting tar archive"
                  tar xf "$src"
                  ls -al .
                  return 0
                fi
                return 1
              }

              case "$mime" in
                application/gzip|application/x-gzip|application/x-xz|application/x-bzip2|application/x-zstd)
                  if ! try_tar; then
                    echo ">> Not a tarball, using decompressor directly"
                    case "$mime" in
                      application/gzip|application/x-gzip) gunzip -k "$src" ;;
                      application/x-bzip2) bunzip2 -k "$src" ;;
                      application/x-xz) xz -d -k "$src" ;;
                      application/x-zstd) unzstd -k "$src" ;;
                    esac
                  fi
                  ;;
                application/x-tar|application/x-gtar)
                  tar xf "$src"
                  ;;
                application/zip)
                  unzip "$src"
                  ;;
                application/x-7z-compressed)
                  7z x "$src"
                  ;;
                application/x-rar)
                  unrar x "$src"
                  ;;
                application/x-executable)
                  # INFO: renaming the script as per the tool name, as it is a one off binary
                  cp "$src" ./$name
                  chmod +x $name
                  echo 'cp $name $out/bin' > .copy-binary
                  ;;
                *)
                  echo "!! Unknown archive type: $mime"
                  echo "Falling back to copying..."
                  cp -r "$src" .
                  ;;
              esac
            '';
            installPhase = ''
              mkdir -p $out/bin

              if [ -f ".copy-binary" ]; then
                source .copy-binary
                return
              fi

              # ["nvim-linux-x86_64/bin"]
              cp -rL * $out
              ln -sf $out/nvim-linux-x86_64/bin/* $out/bin

              echo "[##] printing contents of $out now"
              ls -al $out
            '';
          })
          (pkgs.stdenv.mkDerivation rec {
            name = "treesitter-cli";
            pname = "treesitter-cli";
            src = pkgs.fetchurl {
              url = "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.8/tree-sitter-cli-linux-x86.zip";
              sha256 = "sha256-JQllY+jgEgbmoDbHW4lFkievcBvrPMzDcCo/94UEAHs=";
            };
            nativeBuildInputs = with pkgs; [
              unzip p7zip unrar xz gzip bzip2 zstd lzip
              patchelf autoPatchelfHook
            ];
            unpackPhase = ''
              echo ">> Detecting archive type for $src"
              mime=$(file -b --mime-type "$src")
              echo ">> Got: $mime"

              try_tar() {
                if tar tf "$src" >/dev/null 2>&1; then
                  echo ">> Extracting tar archive"
                  tar xf "$src"
                  ls -al .
                  return 0
                fi
                return 1
              }

              case "$mime" in
                application/gzip|application/x-gzip|application/x-xz|application/x-bzip2|application/x-zstd)
                  if ! try_tar; then
                    echo ">> Not a tarball, using decompressor directly"
                    case "$mime" in
                      application/gzip|application/x-gzip) gunzip -k "$src" ;;
                      application/x-bzip2) bunzip2 -k "$src" ;;
                      application/x-xz) xz -d -k "$src" ;;
                      application/x-zstd) unzstd -k "$src" ;;
                    esac
                  fi
                  ;;
                application/x-tar|application/x-gtar)
                  tar xf "$src"
                  ;;
                application/zip)
                  unzip "$src"
                  ;;
                application/x-7z-compressed)
                  7z x "$src"
                  ;;
                application/x-rar)
                  unrar x "$src"
                  ;;
                application/x-executable)
                  # INFO: renaming the script as per the tool name, as it is a one off binary
                  cp "$src" ./$name
                  chmod +x $name
                  echo 'cp $name $out/bin' > .copy-binary
                  ;;
                *)
                  echo "!! Unknown archive type: $mime"
                  echo "Falling back to copying..."
                  cp -r "$src" .
                  ;;
              esac
            '';
            installPhase = ''
              mkdir -p $out/bin

              if [ -f ".copy-binary" ]; then
                source .copy-binary
                return
              fi

              # ["."]
              cp -rL * $out
              ln -sf $out/./* $out/bin

              echo "[##] printing contents of $out now"
              ls -al $out
            '';
          })

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
            export BROWSER="google-chrome-stable"
            export CONTAINER_HOST="unix:///run/user/1000/podman/podman.sock"
            export DISPLAY=":0"
            export DOCKER_HOST="/run/user/1000/podman/podman.sock"
            export IS_DEMO="1"
            export SSH_AUTH_SOCK="/home/nxtcoder17/.ssh/agent.sock"
            export WAYLAND_DISPLAY="wayland-1"
            export XDG_BACKEND="wayland"
            export XDG_RUNTIME_DIR="/run/user/1000"

            if [ -e shell-enter.sh ]; then
              source "shell-enter.sh"
            fi

            if [ -n "$NIXY_BUILD_SCRIPT" ] && [ -e "$NIXY_BUILD_SCRIPT" ]; then
              source "$NIXY_BUILD_SCRIPT"
            fi

            cd /home/nxtcoder17/workspace/nxtcoder17/jeera-rice/apps/nvim/.config/nvim.fat
          '';
        };

      }
    );
}