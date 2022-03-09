{ config, options, pkgs, pkgsLocal, lib, hmLib, ... }:

let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.programs.yubioath;
in
{
  options.modules.programs.yubioath = {
    enable = mkEnableOption "yubioath";
  };

  config = mkIf cfg.enable {
    services.pcscd.enable = true;

    environment = {
      systemPackages = with pkgs; [
        yubioath-desktop
      ];
    };
  };
}