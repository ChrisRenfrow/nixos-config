{ config, options, pkgs, pkgsLocal, hmLib, lib, inputs, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  inherit (builtins) readFile;

  cfg = config.modules.programs.emacs;
in {

  options.modules.programs.emacs.enable = mkEnableOption "emacs";

  config = mkIf cfg.enable {

    nixpkgs.overlays = with inputs; [ (import emacs-overlay) ];

    system.user.hm.home.file = {
      ".emacs.d/early-init.el".text = readFile ./early-init.el;
      ".emacs.d/init.el".text = readFile ./init.el;
    };

    system.user.hm = {
      programs.emacs = {
        enable = true;
        package = pkgs.emacsWithPackagesFromUsePackage {
          alwaysEnsure = true;
          package = pkgs.emacsPgtkGcc;
          config = ./init.el;
        };
      };
    };

    environment = { systemPackages = with pkgs; [ ]; };
  };
}
