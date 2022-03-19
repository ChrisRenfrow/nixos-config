{ config, pkgs, pkgsLocal, lib, ... }:

let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.programs.cook-cli;
in {
  options.modules.programs.cook-cli.enable = mkEnableOption "cook-cli";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgsLocal; [ cook-cli ];
  };
}
