{ config, pkgs, pkgsLocal, lib, ... }:

let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.services.redshift;
  isWayland = config.modules.wayland.sway.enable == true;
  redshift-pname = if isWayland
                   then "gammastep"
                   else "redshift";
in
{
  options.modules.services.redshift = {
    enable = mkEnableOption "redshift";
  };

  config = mkIf cfg.enable {
    system.user.hm.services."${redshift-pname}" = {
      enable = true;
      package = mkIf isWayland pkgs.gammastep;
      provider = "manual";
      latitude = config.system.locale.location.latitude;
      longitude = config.system.locale.location.longitude;
    };
  };
}