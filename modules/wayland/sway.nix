{ config, options, pkgs, pkgsLocal, lib, modulesLib, ... }:

let
  inherit (lib) mkIf mkEnableOption makeBinPath;

  cfg = config.modules.wayland.sway;
in {
  options.modules.wayland.sway.enable = mkEnableOption "sway";

  config = mkIf cfg.enable {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
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
        brightnessctl
        playerctl
      ];
      # extraSessionCommands = ''
      # # https://github.com/swaywm/wlroots/blob/master/docs/env_vars.md
      # '';
    };

    environment.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      XDG_CURRENT_DESKTOP = "sway";
    };

    system.user.hm.xsession.pointerCursor = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = 24;
    };

    xdg = {
      portal = {
        enable = true;
        gtkUsePortal = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
        wlr = {
          enable = true;
          settings = {
            screencast = {
              max_fps = 30;
              chooser_type = "simple";
              chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
            };
          };
        };

      };
    };

    services = {
      # TODO: Make use of greetd and choice of greeter configurable?
      greetd = {
        enable = true;
        settings.default_session = {
          command = "${
              makeBinPath [ pkgs.greetd.tuigreet ]
            }/tuigreet --asterisks --time --cmd sway";
          user = "${config.system.user.name}";
        };
      };

      dbus.enable = true;

      pipewire = {
        enable = true;
        wireplumber.enable = true;
      };
    };

  };
}
