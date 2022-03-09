{ config, options, pkgs, pkgsLocal, lib, ... }:

let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    optionals;
  inherit (pkgs.vscode-utils)
    extensionsFromVscodeMarketplace;

  cfg = config.modules.environment.code;
  vscode-package = pkgs.vscodium;
in
{
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

    environment.systemPackages = with pkgs; [
      alacritty
      direnv
      cmake
      gnumake
      clang
      clang-tools
      git
      vscode-package
    ] ++ optionals cfg.enableRust [
      rustc
      cargo
      rustup
      rls
      rustfmt
    ] ++ optionals cfg.enableHaskell [
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

        vscode = {
          enable = true;
          package = vscode-package;
          extensions = with pkgs.vscode-extensions; [
            # Nix community-supported extensions
            bbenoist.nix
          ] ++ extensionsFromVscodeMarketplace [
            # VSCode marketplace extensions
            # {
            #   name = "vscode-direnv";
            #   publisher = "cab404";
            #   version = "1.0.0";
            #   sha256 = "fa72c7f93f6fe93402a8a670e873cdfd97af43ae45566d92028d95f5179c3376";
            # }
          ] ++ optionals cfg.enableRust [
            # Rust extensions
          ] ++ optionals cfg.enableHaskell [
            # Haskell extensions
          ];
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
