{ nixpkgs, pkgs, ... }:

let
  inherit (pkgs.lib)
    mapAttrsToList
    flatten
    optionalAttrs;
  inherit (builtins)
    pathExists
    readDir
    filter
    mapAttrs
    isFunction;

  mapDir = mapper: path:
    mapAttrs
      (n: _: let p = path + "/${n}"; in mapper p)
      (optionalAttrs (pathExists path) (readDir path));

  mapAllFiles = mapper: path:
    flatten
      (
        mapAttrsToList
          (n: v: let p = path + "/${n}"; in if v == "directory" then mapAllFiles mapper p else mapper p)
          (optionalAttrs (pathExists path) (readDir path))
      );

  collectHosts = path: attrs:
    mapDir (p: mkHost p attrs) path;

  collectModules = path: attrs:
    filter (isFunction) (mapAllFiles import path);

  collectPackages = path: attrs:
    mapDir (p: import p attrs) path;

  mkHost = path: attrs@{ modulesPath, pkgsLocal, home-manager, localLib, inputs, ... }:
    let
      name = baseNameOf path;
    in
      nixpkgs.lib.nixosSystem {
        system = pkgs.system;

        modules = [
          {
            _module.args.pkgsLocal = pkgsLocal;
            _module.args.hostName = name;
            _module.args.hmLib = home-manager.lib;
            _module.args.localLib = localLib;
            _module.args.inputs = inputs;
          }
          home-manager.nixosModule
          (path + "/system.nix")
          (path + "/hardware.nix")
        ] ++ (collectModules modulesPath { });
      };
in
{
  inherit collectHosts collectModules collectPackages;
}
