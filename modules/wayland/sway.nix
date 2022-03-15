{ config, options, pkgs, pkgsLocal, lib, modulesLib, ... }:

let
  inherit (lib) mkIf mkEnableOption makeBinPath;

  cfg = config.modules.wayland.sway;
in
{
  options.modules.wayland.sway = {
    enable = mkEnableOption "sway";
  };

  config = mkIf cfg.enable {
    programs.sway = {
      enable = true;
      wrapperFeatures = {
        gtk = true;
      };
      # TODO: Make these configurable?
      extraPackages = with pkgs; [
        swaylock
        swayidle
        xwayland
        wl-clipboard
        autotiling
        flashfocus
        i3-ratiosplit
        wf-recorder
        kanshi
        mako
        wofi
        waybar
        jq # Used to parse swaymsg output
        slurp
        grim
      ];
      # extraSessionCommands = ''
      # # https://github.com/swaywm/wlroots/blob/master/docs/env_vars.md
      # '';
    };

    services = {
      # TODO: Make use of greetd and choice of greeter configurable?
      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${makeBinPath [pkgs.greetd.tuigreet]}/tuigreet --asterisks --time --cmd sway";
            user = "${config.system.user.name}";
          };
        };
      };
    };

  };
}
