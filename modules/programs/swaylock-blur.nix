{ config, pkgs, pkgsLocal, lib, ... }:

let
  inherit (lib) mkIf mkOption mkEnableOption types;

  cfg = config.modules.programs.swaylock-blur;
in
{
  options.modules.programs.swaylock-blur = {
    enable = mkEnableOption "swaylock-blur";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgsLocal; [ swaylock-blur ];
  };
}