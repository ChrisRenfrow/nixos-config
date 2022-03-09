{ config, options, pkgs, pkgsLocal, lib, ... }:

let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.environment.cli;
in
{
  options.modules.environment.cli = {
    enable = mkEnableOption "cli environment";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        htop
        bottom
        openssl
        file
        unzip
        unrar
        curl
        rsync
        ripgrep
        neovim
        autojump
      ];

      variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };

    users.defaultUserShell = pkgs.fish;

    system.user.hm = {
      programs = {
        fish = {
          enable = true;
          # shellInit = ""; # Shell script code called during fish shell initialisation
          # shellAliases = { };
          # shellAbbrs = {
          #   gco = "git checkout";
          # };
          # promptInit = ""; # Shell script code used to initialize fish prompt
        };
      };
    };
  };
}
