{
  description = "Modularized NixOS System Config";
  # Heavily inspired by what I found at https://github.com/barsoosayque/nixconfig/
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { 
        inherit system;
        overlays = [
          (import inputs.emacs-overlay)
        ];
      };
      localLib = import ./lib { inherit nixpkgs; inherit pkgs; };
    in {
      nixosConfigurations = localLib.flakeUtils.collectHosts ./hosts {
        inherit home-manager localLib;
        modulesPath = ./modules;
        pkgsLocal = self.packages."${system}";
      };

      nixosModules = localLib.flakeUtils.collectModules ./modules {};
    };
}
