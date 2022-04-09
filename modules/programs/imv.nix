{ config, options, pkgs, lib, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.generators) toINI;

  cfg = config.modules.programs.imv;
  settings = {
    binds = {
      "<Shift+X>" = ''exec rm "$imv_current_file"; close'';
      "<Shift+R>" = "rotate by 90";
    };
  };
in {
  options.modules.programs.imv.enable = mkEnableOption "imv";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ imv ];

    system.user.hm = {
      xdg.configFile."imv/config".text = toINI { } settings;
    };
  };
}
