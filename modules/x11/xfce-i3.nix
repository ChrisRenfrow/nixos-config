{ config, options, pkgs, pkgsLocal, lib, ... }:

let
  inherit (lib) mkIf mkOption mkEnableOption types;

  cfg = config.modules.x11.xfce-i3;
in
{
  options.modules.x11.xfce-i3 = {
    enable = mkEnableOption "xfce-i3";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      displayManager.defaultSession = "xfce+i3";
      windowManager.i3.enable = true;
      desktopManager.xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };
  };
}
