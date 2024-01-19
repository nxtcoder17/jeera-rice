{
  description = "Home Manager configuration of nxtcoder17";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:guibou/nixGL";
      # flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, nixgl, ... }:
    let
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs {
        system = system;
        overlays = [ nixgl.overlay ];
      };
      nixGL = import <nixgl> { };
      nixGLWrap = pkg:
        let
          bin = "${pkg}/bin";
          executables = builtins.attrNames (builtins.readDir bin);
        in
        pkgs.buildEnv {
          name = "nixGL-${pkg.name}";
          paths = map
            (name: pkgs.writeShellScriptBin name ''
              exec -a "$0" ${nixGL.auto.nixGLNvidia}/bin/nixGLNvidia ${bin}/${name} "$@"
            '')
            executables;
        };
        # use this as `programs.kitty.package = nixGLWrap pkgs.kitty;`
    in {
      homeConfigurations."nxtcoder17" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
