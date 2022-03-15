{ config, options, pkgs, pkgsLocal, lib, hostName, hmLib, localLib, ... }:

let
  inherit (lib)
    mkOption
    mkAliasDefinitions
    types;
    # hasPrefix
    # removePrefix;
  # inherit (builtins)
    # filter
    # attrValues
    # concatStringsSep;

  cfg = config.system.user;
in
{
  options.system.user = {
    name = mkOption {
      type = with types; str;
      description = "Main user name";
    };

    uid = mkOption {
      type = with types; int;
      readOnly = true;
      description = "Main user UID";
    };

    extraConfig = mkOption {
      type = with types; attrs;
      default = { };
      description = "Extra configs for current user (nixos user configs)";
    };

    hm = mkOption {
      type = with types; attrs;
      default = { };
      description = "Home-manager configs for current user";
    };

    home = mkOption {
      type = with types; str;
      readOnly = true;
      description = "Absolute path to the user's home directory";
    };
  };

  config = rec {
    users.users."${cfg.name}" = mkAliasDefinitions options.system.user.extraConfig;
    home-manager.users."${cfg.name}" = mkAliasDefinitions options.system.user.hm;

    system.user = {
      uid = 1000;
      home = "/home/${cfg.name}";

      extraConfig = {
        home = mkAliasDefinitions options.system.user.home;
        uid = mkAliasDefinitions options.system.user.uid;
        extraGroups = [ "wheel" "video" ];
        isNormalUser = true;
      };

      hm = {
        xdg = {
          enable = true;
          userDirs = {
            enable = true;
            desktop = "/dev/null";
            publicShare = "/dev/null";
            templates = "/dev/null";
            documents = "${cfg.home}/documents";
            download = "${cfg.home}/downloads";
            music = "${cfg.home}/music";
            pictures = "${cfg.home}/pictures";
            videos = "${cfg.home}/videos";
          };
        };
      };
    };
  };
}
