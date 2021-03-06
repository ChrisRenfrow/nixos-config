{ config, pkgs, pkgsLocal, ... }:

{
  imports = [ ];

  boot = {
    # Fix freezing issues on Dell XPS 9550
    kernelParams = [ "acpi_rev_override=1" ];
    # Add the ability to create a virtual webcam via OBS or similar software
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=10 card_label="OBS Cam" exclusive_caps=1
    '';
    # Fix SDR dongle not being seen by software
    # https://old.reddit.com/r/RTLSDR/wiki/blacklist_dvb_usb_rtl28xxu
    # or https://groups.google.com/forum/#!topic/ultra-cheap-sdr/6_sSON94Azo
    blacklistedKernelModules = [ "dvd_usb_rtl28xxu" ];
  };

  ## TODO: Make bluetooth support into an optional module
  hardware.enableAllFirmware = true;

  # hardware.pulseaudio = {
  #   enable = true;
  #   package = pkgs.pulseaudioFull.override { jackaudioSupport = true; };
  #   extraConfig = ''
  #     load-module module-switch-on-connect
  #   '';
  # };

  hardware = {
    opengl = {
      enable = true;
      setLdLibraryPath = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Disable = "Headset";
        MultiProfile = "multiple";
      };
    };
  };

  services.blueman.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="0d28", ATTR{idProduct}=="0204", MODE:="666"
  '';

  environment = { systemPackages = with pkgs; [ firefox syncplay ]; };

  # make whatis, apropos, and man -k work again
  documentation.man.generateCaches = true;

  fonts.fonts = with pkgs; [
    (iosevka-bin.override { variant = "aile"; })
    (iosevka-bin.override { variant = "etoile"; })
    iosevka-bin
    noto-fonts
    noto-fonts-emoji
  ];

  networking = {
    firewall.enable = true;
    networkmanager = {
      enable = true;
      wifi = {
        powersave = false;
        scanRandMacAddress = false;
      };
    };
    wireguard.enable = true;
  };

  system = {
    user.name = "crenfrow";
    locale.locationName = "San Francisco";
    stateVersion =
      "22.05"; # https://nixos.org/manual/nixos/stable/options.html#opt-system.stateVersion
  };

  nix.settings.trusted-users = [ "crenfrow" ];

  services = {
    printing = {
      enable = true;
      drivers = with pkgs; [ hplip ];
    };
    avahi = {
      enable = true;
      nssmdns = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
      # wireplumber.enable = true;
    };
  };

  modules = {
    environment = {
      code.enable = true;
      cli.enable = true;
    };

    programs = {
      firefox.enable = true;
      emacs.enable = true;
      yubioath.enable = true;
      swaylock-blur.enable = true;
      zoom.enable = true;
      imv.enable = true;
      cook-cli.enable = true;
    };

    services = {
      redshift.enable = true;
      mullvad.enable = true;
    };

    wayland = {
      gtk.enable = true;
      sway.enable = true;
    };
  };
}
