{ config, options, pkgs, lib, ... }:

let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.programs.zoom;
in {
  options.modules.programs.zoom.enable = mkEnableOption "zoom";

  config = mkIf cfg.enable {
    nixpkgs.overlays = mkIf config.modules.wayland.sway.enable [
      (self: super: {
        zoom-us = super.zoom-us.overrideAttrs (old: {
          postFixup = old.postFixup + ''
            wrapProgram $out/bin/zoom-us --unset XDG_SESSION_TYPE
          '';
        });
      })
    ];

    environment.systemPackages = [ pkgs.zoom-us ];
  };
}
