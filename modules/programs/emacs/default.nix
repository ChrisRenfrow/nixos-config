{ config, options, pkgs, pkgsLocal, hmLib, lib, inputs, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  inherit (builtins) readFile;

  cfg = config.modules.programs.emacs;

  warning = ''
    ;; WARNING: Do not edit this file!
    ;; This file has been generated by NixOS home-manager. Any changes made here may be overwritten!
    
  '';
in {

  options.modules.programs.emacs.enable = mkEnableOption "emacs";

  config = mkIf cfg.enable {
    nixpkgs.overlays = with inputs; [ (import emacs-overlay) ];

    system.user.hm.home.file = {
      ".emacs.d/early-init.el".text = warning + (readFile ./early-init.el);
      ".emacs.d/init.el".text = warning + (readFile ./init.el);
      ".emacs.d/emacs.org".text = warning + (readFile ./emacs.org);
    };

    system.user.hm = {
      programs.emacs = {
        enable = true;
        package = pkgs.emacsWithPackagesFromUsePackage {
          package = pkgs.emacsPgtkNativeComp;
          # Using org files seems to be broken. :/
          # alwaysTangle = true;
          # config = ./emacs.org;
          alwaysEnsure = true;
          config = ./init.el;
          extraEmacsPackages = epkgs:
            with epkgs; [
              nix-mode
            ];
        };
      };
    };

    environment = {
      systemPackages = with pkgs; [
        ## writegood-mode
        aspell
        aspellDicts.en
        aspellDicts.en-science
        aspellDicts.en-computers
        ## nix-mode
        nixfmt
        ## rust-mode
        cargo
        rustfmt
        ## haskell-mode
        ghc
        ghcid
        hlint
        cabal-install
        stack
        ## js2-mode & typescript-mode
        nodejs
        yarn
        ## auctex
        texinfo
        texlive.combined.scheme-full
        ## Misc
        python39
      ];
    };
  };
}
