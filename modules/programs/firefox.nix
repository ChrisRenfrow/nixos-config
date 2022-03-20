{ pkgs, lib, config, ... }:

let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.programs.firefox;
  isWayland = config.modules.wayland.sway.enable == true;
  firefox-pkg = with pkgs; if isWayland then firefox-wayland else firefox;
in {
  options.modules.programs.firefox.enable = mkEnableOption "firefox";

  config = mkIf cfg.enable { environment.systemPackages = [ firefox-pkg ]; };
}
