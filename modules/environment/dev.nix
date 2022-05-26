{ config, options, pkgs, pkgsLocal, lib, ... }:

let
  inherit (lib) mkIf mkOption mkEnableOption types optionals;

  cfg = config.modules.environment.code;
in {
  options.modules.environment.code = {
    enable = mkEnableOption "Code environment";

    enableRust = mkOption {
      type = with types; bool;
      default = true;
      description = "Enable Rust environment";
    };

    enableHaskell = mkOption {
      type = with types; bool;
      default = true;
      description = "Enable Haskell environment";
    };
  };

  config = mkIf cfg.enable {
    nix.extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';

    environment.systemPackages = with pkgs;
      [ alacritty direnv cmake gnumake clang clang-tools git ]
      ++ optionals cfg.enableRust [ rustc cargo rustup rls rustfmt ]
      ++ optionals cfg.enableHaskell [
        ghc
        haskell-language-server
        cabal-install
        stack
      ];

    system.user.hm = {
      programs = {
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
        
        git = {
          enable = true;
          userName = "ChrisRenfrow";
          userEmail = "chris@chrisrenfrow.me";
          # aliases = [ ];
        };
      };
    };
  };
}
