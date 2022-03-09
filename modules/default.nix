{ config, options, pkgs, lib, hostName, ... }:

{
  config = {
    boot = {
      cleanTmpDir = true;

      kernelPackages = pkgs.linuxPackages_latest;
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    nix = {
      package = pkgs.nixUnstable;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';

      # Dispose responsibly
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
    };

    nixpkgs.config.allowUnfree = true;

    security.sudo.enable = true;

    fonts.fontconfig.enable = true;

    networking = {
      inherit hostName;
      useDHCP = false;
    };

    # Seems like a good policy?
    # users.mutableUsers = false;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
