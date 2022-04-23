{ config, options, pkgs, pkgsLocal, hmLib, lib, inputs, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  inherit (builtins) readFile;

  cfg = config.modules.programs.emacs;
in {

  options.modules.programs.emacs.enable = mkEnableOption "emacs";

  config = mkIf cfg.enable {

    nixpkgs.overlays = with inputs; [ (import emacs-overlay) ];

    system.user.hm.home.file = {
      ".emacs.d/early-init.el".text = readFile ./early-init.el;
      ".emacs.d/init.el".text = readFile ./init.el;
    };

    system.user.hm = {
      programs.emacs = {
        enable = true;
        package = pkgs.emacsWithPackagesFromUsePackage {
          alwaysEnsure = true;
          package = pkgs.emacsPgtkGcc;
          config = ./init.el;
          extraEmacsPackages = epkgs: with epkgs; [ nix-mode ];
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
      ];
    };
  };
}
