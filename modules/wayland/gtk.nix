{ config, options, pkgs, pkgsLocal, lib, modulesLib, ... }:

let
  inherit (lib) mkIf mkEnableOption makeBinPath;
  cfg = config.modules.wayland.gtk;
in {
  options.modules.wayland.gtk.enable = mkEnableOption "gtk";

  config = mkIf cfg.enable {
    programs.sway.wrapperFeatures.gtk = true;

    system.user.hm.gtk = {
      enable = true;
      iconTheme.package = pkgs.gruvbox-dark-icons-gtk;
      iconTheme.name = "gruvbox-dark";
      theme.package = pkgs.gruvbox-dark-gtk;
      theme.name = "gruvbox-dark";
    };
  };
}
