{ config, options, pkgs, pkgsLocal, lib, ... }:

let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.programs.emacs;

  myEmacs = with pkgs;
    ((emacsPackagesNgGen emacsPgtkGcc).emacsWithPackages (epkgs: [ 
      ## UI
      epkgs.ivy
      epkgs.ivy-rich
      epkgs.prescient
      epkgs.ivy-prescient
      epkgs.counsel
      epkgs.vertico
      epkgs.general
      epkgs.which-key
      epkgs.hydra
      epkgs.evil
      epkgs.evil-collection
      epkgs.evil-surround
      epkgs.evil-nerd-commenter
      epkgs.doom-modeline
      epkgs.minions
      epkgs.doom-themes
      ## Utils
      epkgs.super-save
      epkgs.undo-tree
      epkgs.diminish
      epkgs.ws-butler
      epkgs.flx
      ## Terms
      epkgs.vterm
      ## Org mode
      epkgs.org
      epkgs.org-roam
      epkgs.org-appear
      epkgs.deft
      epkgs.org-pomodoro
      epkgs.org-drill
      epkgs.org-superstar
      epkgs.evil-org   
      ## Project-management
      epkgs.projectile 
      epkgs.counsel-projectile
      epkgs.perspective
      epkgs.magit
      epkgs.treemacs
      epkgs.treemacs-evil
      epkgs.treemacs-projectile
      epkgs.treemacs-magit
      epkgs.treemacs-perspective
      epkgs.treemacs-icons-dired
      epkgs.treemacs-all-the-icons
      ## LSP
      epkgs.lsp-mode
      epkgs.lsp-ui
      epkgs.lsp-treemacs
      epkgs.lsp-ivy
      epkgs.helpful
      # epkgs.apheleia # Not available via melpa as of 2021-09-19 (https://github.com/melpa/melpa/pull/7699)
      epkgs.nix-mode
      epkgs.rust-mode
      epkgs.haskell-mode
      epkgs.markdown-mode
      epkgs.js2-mode
      epkgs.typescript-mode
      epkgs.prettier
      epkgs.web-mode
      epkgs.yaml-mode
      ## Coding Productivity
      epkgs.flycheck
      epkgs.smartparens
      epkgs.rainbow-delimiters
      epkgs.rainbow-mode
      ## Writing
      epkgs.writegood-mode
      epkgs.darkroom
      epkgs.auctex
    ]));

in {

  options.modules.pkgs.emacs = {
    enable = mkEnableOption "emacs";
  };

  config = mkIf cfg.enable {
    services.emacs = {
      enable = true;
      package = myEmacs;
    };

    system.user.hm = {
      programs.emacs = {
        enable = true;
        package = myEmacs;
      };
    };

    environment = {
      systemPackages = with pkgs; [
        ## writegood-mode
        pkgs.aspell
        pkgs.aspellDicts.en
        pkgs.aspellDicts.en-science
        pkgs.aspellDicts.en-computers
        ## nix-mode
        pkgs.nixfmt
        ## rust-mode
        pkgs.cargo
        pkgs.rustfmt
        ## haskell-mode
        pkgs.ghc
        pkgs.ghcid
        pkgs.hlint
        pkgs.cabal-install
        pkgs.stack
        ## js2-mode & typescript-mode
        pkgs.nodejs
        pkgs.yarn
        ## auctex
        pkgs.texinfo
        pkgs.texlive.combined.scheme-full
      ];
    };
  };
}
