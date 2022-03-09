{ config, options, pkgs, pkgsLocal, lib, hmLib, ... }:

let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.services.mullvad;
in
{
  options.modules.services.mullvad = {
    enable = mkEnableOption "mullvad";
  };

  config = mkIf cfg.enable {
    services.mullvad-vpn.enable = true;

    environment = {
      systemPackages = with pkgs; [
        mullvad-vpn
      ];
    };
  };
}
