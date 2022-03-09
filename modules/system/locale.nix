{ config, pkgs, pkgsLocal, lib, ... }:

let
  inherit (lib) mkOption types;
  inherit (builtins) attrNames;

  cfg = config.system.locale;

  locations = {
    San_Francisco = {
      latitude = 37.773972;
      longitude = -122.431297;
      timeZone = "America/Los_Angeles";
    };
  };
in
{
  options.system.locale = {
    locationName = mkOption {
      type = with types; enum (attrNames locations);
      description = "Location name of host";
    };

    location = mkOption {
      type = with types; attrs;
      readOnly = true;
      description = "Read-only paramerts of host location";
    };
  };

  config =
    let
      location = locations."${cfg.locationName}";
    in
      {
        system.locale.location = location;
        time.timeZone = location.timeZone;
      };
}
