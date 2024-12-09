{
  description = "your dev environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          # hardeningDisable = [ "all" ];

          buildInputs = with pkgs; [
            # cli tools
            curl
            jq
            yq
            go-task

            # source version control
            git
            pre-commit

            # programming tools
            go_1_21

            nodejs-slim
            nodePackages.npm
            nodePackages.pnpm

            # build tools
            podman
            upx
          ];

          shellHook = ''
            echo "using nix flake"
          '';
        };
      }
    );
}

