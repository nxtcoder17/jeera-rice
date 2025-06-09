{
  description = "Home Manager configuration of nxtcoder17";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs = { nixpkgs, home-manager, nixgl, ... }:
    let
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs {
        system = system;
        overlays = [ nixgl.overlay ];
      };

      # ghostty_term = ghostty.packages.${system}.ghostty;

      nixGL = import <nixgl> { };

      # does not work
      nixGLWrap = pkg:
        let
          bin = "${pkg}/bin";
          executables = builtins.attrNames (builtins.readDir bin);
        in
        pkgs.buildEnv {
          name = "nixGL-${pkg.name}";
          paths = map
            (name: pkgs.writeShellScriptBin name ''
              exec -a "$0" ${nixGL.auto.nixGLNvidia}/bin/nixGLNvidia-${nixGL.nvidiaVersion} ${bin}/${name} "$@"
            '')
            executables;
        };

      runWithNvidiaGPU = pkg:
        let
          name = "gpu-${pkg.name}";
          # pkgs = import nixpkgs {
          #   inherit system;
          #   overlays = [ nixgl.overlay ];
          # };
          # echo "${pkgs.nixgl.auto.nixGLNvidia}/bin/nixGLNvidia-${pkgs.nixgl.nvidiaVersion} ${pkg}/bin/$item" >> $out/bin/$item
        in
        pkgs.stdenv.mkDerivation
          {
            name = name;
            pname = name;
            src = pkg.name;
            unpackPhase = ":";
            installPhase = ''
              nvidia_version=$(cat /proc/driver/nvidia/version | grep NVRM | awk '{print $8}')
              mkdir -p $out/bin

              for item in `ls ${pkg}/bin`; do
                echo "#! /usr/bin/env bash" > "$out/bin/$item"
                echo "nixGLNvidia-$nvidia_version ${pkg}/bin/$item \$@" >> "$out/bin/$item"
                chmod +x $out/bin/$item
              done
            '';
          };

      withPostInstallScript = pkg: (script:
        let
          name = "post-install-${pkg.name}";
        in
        pkgs.stdenv.mkDerivation
          {
            name = name;
            pname = name;
            src = pkg.name;
            unpackPhase = ":";
            installPhase = ''
              mkdir -p $out/bin
              for item in `ls ${pkg}/bin`; do
                cp ${pkg}/bin/$item $out/bin/$item
              done

              PACKAGE=${pkg}
              ${script}
            '';
          });


      # use this as `programs.kitty.package = nixGLWrap pkgs.kitty;`
      username = "nxtcoder17";
      NvidiaVersion = "sample";
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          nvidiaVersion = NvidiaVersion;
          runWithNvidiaGPU = runWithNvidiaGPU;
          withPostInstallScript = withPostInstallScript;
        };

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home.nix
          {
            home.packages = with pkgs; [ ];
          }
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
