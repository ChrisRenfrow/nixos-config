{ config, options, pkgs, pkgsLocal, lib, inputs, ... }:

let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.programs.emacs;

  emacs-pkg = with pkgs;
    ((emacsPackagesFor emacsPgtkGcc).emacsWithPackages (epkgs: with epkgs; [ 
      ## UI
      ivy
      ivy-rich
      prescient
      ivy-prescient
      counsel
      vertico
      general
      which-key
      hydra
      evil
      evil-collection
      evil-surround
      evil-nerd-commenter
      doom-modeline
      minions
      doom-themes
      ## Utils
      super-save
      undo-tree
      diminish
      ws-butler
      flx
      ## Terms
      vterm
      ## Org mode
      org
      org-roam
      org-appear
      deft
      org-pomodoro
      org-drill
      org-superstar
      epkgs.evil-org   
      ## Project-management
      projectile 
      counsel-projectile
      perspective
      magit
      treemacs
      treemacs-evil
      treemacs-projectile
      treemacs-magit
      treemacs-perspective
      treemacs-icons-dired
      treemacs-all-the-icons
      ## LSP
      lsp-mode
      lsp-ui
      lsp-treemacs
      lsp-ivy
      helpful
      # epkgs.apheleia # Not available via melpa as of 2021-09-19 (https://github.com/melpa/melpa/pull/7699)
      nix-mode
      rust-mode
      haskell-mode
      markdown-mode
      js2-mode
      typescript-mode
      prettier
      web-mode
      yaml-mode
      i3wm-config-mode
      ## Coding Productivity
      flycheck
      smartparens
      rainbow-delimiters
      rainbow-mode
      ## Writing
      writegood-mode
      darkroom
      auctex
    ]));

in {

  options.modules.programs.emacs = {
    enable = mkEnableOption "emacs";
  };

  config = mkIf cfg.enable {

    nixpkgs.overlays = with inputs; [ (import emacs-overlay) ];

    services.emacs = {
      enable = true;
      package = emacs-pkg;
    };

    system.user.hm = {
      programs.emacs = {
        enable = true;
        package = emacs-pkg;
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
