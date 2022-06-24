{
  description = "Modularized NixOS System Config";
  # Heavily inspired by what I found at https://github.com/barsoosayque/nixconfig/
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    emacs-overlay.url = "github:nix-community/emacs-overlay/master";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      localLib = import ./lib {
        inherit nixpkgs;
        inherit pkgs;
      };
    in {
      nixosConfigurations = localLib.flakeUtils.collectHosts ./hosts {
        inherit home-manager localLib inputs;
        modulesPath = ./modules;
        pkgsLocal = self.packages."${system}";
      };

      nixosModules =
        localLib.flakeUtils.collectModules ./modules { inherit pkgs; };

      packages."${system}" =
        localLib.flakeUtils.collectPackages ./packages { inherit pkgs; };

      devShell."${system}" = import ./shell.nix { inherit pkgs; };
    };
}
