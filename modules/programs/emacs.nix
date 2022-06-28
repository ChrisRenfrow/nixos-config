{ config, options, pkgs, pkgsLocal, hmLib, lib, inputs, ... }:

let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.programs.emacs;
  emacsPkg = pkgs.emacsPgtkNativeComp;
  emacsWithPackages = (pkgs.emacsPackagesFor emacsPkg).emacsWithPackages;
in {

  options.modules.programs.emacs.enable = mkEnableOption "emacs";

  config = mkIf cfg.enable {
    nixpkgs.overlays = with inputs; [ (import emacs-overlay) ];

    environment.sessionVariables = { LSP_USE_PLIST = "true"; };

    system.user.hm = {
      programs.emacs = {
        enable = true;
        package = (emacsWithPackages (epkgs: with epkgs; [ nix-mode vterm ]));
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
        rnix-lsp
        nixfmt
        ## rust-mode/rustic
        cargo
        rustfmt
        rust-analyzer
        rls
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
        evince # PDF-viewer
        ## Misc
        python39
        pandoc
        imagemagick
      ];
    };
  };
}
