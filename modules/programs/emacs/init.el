(defvar package-quickstart t)

(eval-when-compile
  (require 'use-package))

(eval-and-compile
  (setq package-enable-at-startup nil)
  (setq use-package-ensure-function 'ignore)
  (setq package-archives nil))

(setq name "Chris Renfrow"
      email "dev@chrisrenfrow.me")

(defvar cr/default-font-size 100
  "Default font-size for fixed pitch (monospaced)")
(defvar cr/default-variable-font-size 100
  "Default font-size for variable pitch")

(defvar cr/projects-base-directory "~/projects/code"
  "The location I keep my code projects, mostly used by =projectile=")

(setq-default tab-width 2)

(use-package no-littering
  :ensure t
  :init
  (setq user-emacs-directory "~/.cache/emacs")
  :config
  ;; Move auto-save files
  (setq auto-save-file-name-transforms
    `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  ;; Move custom into it's own file
  (setq custom-file (no-littering-expand-etc-file-name "custom.el")))

;; Fixed pitch
(set-face-attribute 'default nil :font "Iosevka" :height cr/default-font-size)
;; Variable pitch
(set-face-attribute 'variable-pitch nil :font "Iosevka Aile" :height cr/default-variable-font-size :weight 'regular)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil)
  :config
  (evil-mode 1)
  ;; Use visual line motions outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :ensure t
  :after evil
  :config
  (evil-collection-init))

(use-package general
  :ensure t
  :after evil
  :config
  (general-create-definer cr/leader-key
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC"))

(cr/leader-key
  "t" '(:ignore t :which-key "toggles")
  "tt" '(counsel-load-theme :which-key "load new theme"))

(use-package hydra
  :ensure t)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("d" (text-scale-adjust 0) "default" :exit t)
  ("f" nil "finished" :exit t))

(cr/leader-key
  "ts" '(hydra-text-scale/body :which-key "scale text"))

(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package doom-themes
  :ensure t
  :init (load-theme 'doom-solarized-light t))

(use-package all-the-icons
  :ensure t)

(use-package doom-modeline
  :ensure t
  :after (all-the-icons)
  :hook (after-init . doom-modeline-mode)
  :custom ((doom-modeline-height 15)
           (doom-modeline-lsp t)
           (doom-modeline-github nil)
           (doom-modeline-minor-modes t)
           (doom-modeline-buffer-file-name-style 'truncate-except-project)))

(use-package minions
  :ensure t
  :config (minions-mode 1))

(use-package which-key
  :ensure t
  :config
  (setq which-key-idle-delay 1)
  (which-key-mode))

(use-package ivy
  :ensure t
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search))
  :config
  (setq ivy-initial-inputs-alist nil)
  (ivy-mode 1))

(use-package ivy-rich
  :ensure t
  :after ivy
  :init
  (ivy-rich-mode 1))

(use-package ivy-prescient
  :ensure t
  :after counsel
  :config
  (prescient-persist-mode 1) ; Persist prescient sorting across sessions
  (ivy-prescient-mode 1))

(use-package flx
  :ensure t
  :init
  (setq ivy-flx-limit 1000))

(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (counsel-mode 1))

(defun cr/org-font-setup ()
    ;; Set faces for heading levels
    (dolist (face '((org-level-1 . 1.2)
                    (org-level-2 . 1.1)
                    (org-level-3 . 1.05)
                    (org-level-4 . 1.0)
                    (org-level-5 . 1.1)
                    (org-level-6 . 1.1)
                    (org-level-7 . 1.1)
                    (org-level-8 . 1.1)))
      (set-face-attribute (car face) nil :font "Iosevka Etoile" :weight 'light :height (cdr face)))

    ;; Ensure that anything that should be fixed-pitch in Org files appears that way
    (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-table nil                 :inherit 'fixed-pitch)
    (set-face-attribute 'org-formula nil               :inherit 'fixed-pitch)
    (set-face-attribute 'org-code nil                  :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-table nil                 :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-verbatim nil              :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-special-keyword nil       :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-meta-line nil             :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-checkbox nil              :inherit 'fixed-pitch)
    (set-face-attribute 'line-number nil               :inherit 'fixed-pitch)
    (set-face-attribute 'line-number-current-line nil  :inherit 'fixed-pitch))

(defun cr/org-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil))

(use-package org
  :ensure t
  :commands (org-capture org-agenda)
  :hook (org-mode . cr/org-setup)
  :config
  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-ellipsis "▿"
        org-fontify-quote-and-verse-blocks t
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 2
        org-hide-block-startup nil
        org-src-preserve-indentation nil
        org-hide-emphasis-markers t
        org-cycle-separator-lines 2
        org-startup-folded 'content)
  (cr/org-font-setup))

(cr/leader-key
  "o" '(:ignore t :which-key "org")
  "oi" '(:ignore t :which-key "insert")
  "oil" '(org-insert-link :whick-key "insert link")
  "oa" '(org-agenda :which-key "status")
  "ot" '(org-todo-list :which-key "todos")
  "oc" '(org-capture t :which-key "capture")
  "ox" '(org-export-dispatch t :which-key "export"))

(use-package org-superstar
  :ensure t
  :after org
  :hook (org-mode . org-superstar-mode)
  :config
  (setq org-hide-leading-stars t
        org-superstar-leading-bullet ?\s
        org-indent-mode-turns-on-hiding-stars nil
        org-superstar-remove-leading-stars t
        org-superstar-cycle-headline-bullets nil ; changes cycling behavior
        org-superstar-headline-bullets-list '("⁙" "⁘" "⁖" "⁚" "‧")))

(use-package markdown-mode
  :ensure t
  :mode "\\.md\\'"
  :config
  (setq markdown-command "markdown")

  (defun cr/set-markdown-header-font-sizes ()
    (dolist (face '((markdown-header-face-1 . 1.5)
        (markdown-header-face-2 . 1.2)
        (markdown-header-face-3 . 1.1)
        (markdown-header-face-4 . 1.0)
        (markdown-header-face-5 . 1.0)))
      (set-face-attribute (car face) nil :weight 'normal :height (cdr face))))

  (defun cr/markdown-mode-hook ()
    (cr/set-markdown-header-font-sizes))
  (add-hook 'markdown-mode-hook 'cr/markdown-mode-hook))

(defun cr/doc-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :ensure t
  :hook ((org-mode . cr/doc-mode-visual-fill)
         (markdown-mode . cr/doc-mode-visual-fill)))

(use-package toc-org
  :ensure t
  :hook ((org-mode . toc-org-mode)
         (markdown-mode . toc-org-mode))
  :bind ("C-c C-o" . toc-org-markdown-follow-thing-at-point))

(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)))
  (push '("conf-unix" . conf-unix) org-src-lang-modes))

(with-eval-after-load 'org
  ;; Required as of Org 9.2 to use easy-templates
  (require 'org-tempo)

  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("nix" . "src nix"))
  (add-to-list 'org-structure-template-alist '("clang" . "src c"))
  (add-to-list 'org-structure-template-alist '("rs" . "src rust"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (add-to-list 'org-structure-template-alist '("hs" . "src haskell"))
  (add-to-list 'org-structure-template-alist '("yaml" . "src yaml"))
  (add-to-list 'org-structure-template-alist '("json" . "src json")))

(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t
        cr/daily-note-filename "%<%Y-%m-%d>.org"
        cr/daily-note-header "#+title: %<%Y-%m-%d %a>\n\n[[roam:%<%Y-%B>]]\n\n")
  :custom
  (org-roam-directory "~/documents/notes/roam/")
  (org-roam-dailies-directory (concat org-roam-directory "journal/"))
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(("d" "default" plain "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                         "#+title: ${title}\n")
      :unnarrowed t)))
  (org-roam-dailies-capture-templates
   `(("d" "default" entry
      "* %?"
      :if-new (file+head ,cr/daily-note-filename
                         ,cr/daily-note-header))
     ("t" "task" entry
      "* TODO %?\n\t%U\n\t%a\n\t%i"
      :if-new (file+head+olp ,cr/daily-note-filename
                             ,cr/daily-note-header
                             ("Tasks"))
      :empty-lines 1)
     ("l" "log entry" entry
      "* %<%H:%M> - %?"
      :if-new (file+head+olp ,cr/daily-note-filename
                             ,cr/daily-note-header
                             ("Log")))
     ("j" "journal" entry
      "* %<%H:%M> - Journal\t:journal:\n\n%?\n\n"
      :if-new (file+head+olp ,cr/daily-note-filename
                             ,cr/daily-note-header
                             ("Log")))
     ("m" "meeting" entry
      "* %<%H:%M> - %^{Meeting Title}\t:meetings:\n\n%?\n\n"
      :if-new (file+head+olp ,cr/daily-note-filename
                             ,cr/daily-note-header
                             ("Log")))))
  :bind
  (("C-c n l" . org-roam-buffer-toggle)
   ("C-c n f" . org-roam-node-find)
   ("C-c n d" . org-roam-dailies-find-date)
   ("C-c n c" . org-roam-dailies-capture-today)
   ("C-c n C r" . org-roam-dailies-capture-tomorrow)
   ("C-c n t" . org-roam-dailies-goto-today)
   ("C-c n y" . org-roam-dailies-goto-yesterday)
   ("C-c n r" . org-roam-dailies-goto-tomorrow)
   ("C-c n g" . org-roam-graph)
   :map org-mode-map
   (("C-c n i" . org-roam-node-insert)
   ;("C-c n I" . org-roam-insert-immediate)
    ))
  :config
  (org-roam-db-autosync-mode))

(use-package org-drill
  :ensure t
  :config
  (setq org-roam-db-node-include-function
        (lambda () (not (member "drill" (org-get-tags))))))

(cr/leader-key
  "od" '(:ignore t :which-key "org-drill")
  "odd" '(org-drill :which-key "drill")
  "odr" '(org-drill-resume :which-key "resume"))

(use-package org-pomodoro
  :ensure t
  :after org
  :config
  (setq org-pomodoro-manual-break t
        org-pomodoro-keep-killed-time t
        org-pomodoro-start-sound "~/.emacs.d/sounds/focus_bell.wav"
        org-pomodoro-short-break-sound "~/.emacs.d/sounds/three_beeps.wav"
        org-pomodoro-long-break-sound "~/.emacs.d/sounds/three_beeps.wav"
        org-pomodoro-finished-sound "~/.emacs.d/sounds/meditation_bell.wav"))

(cr/leader-key
 "op" '(org-pomodoro :which-key "pomodoro"))

(use-package treemacs
  :ensure t
  :config
  (treemacs-filewatch-mode 1)
  (treemacs-follow-mode 1)
  (treemacs-project-follow-mode 1)
  (treemacs-git-mode 'deferred)
  (treemacs-indent-guide-mode 1))

(use-package treemacs-icons-dired
  :ensure t
  :hook (dired-mode . treemacs-icons-dired-enable-once))

(use-package treemacs-all-the-icons
  :ensure t
  :after (treemacs all-the-icons)
  :config (treemacs-load-theme "all-the-icons"))

(use-package treemacs-evil
  :ensure t
  :after (treemacs evil))

(use-package treemacs-projectile
  :ensure t
  :after (treemacs projectile))

(use-package treemacs-magit
  :ensure t
  :after (treemacs magit))

(use-package treemacs-perspective
  :ensure t
  :after (treemacs persp-mode)
  :config (treemacs-set-scope-type 'Perspectives))

(use-package lsp-mode
  :ensure t
  :hook (prog-mode . lsp)
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :custom
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :ensure t
  :after lsp)

(use-package lsp-ivy
  :ensure t
  :after lsp)

(use-package flycheck
  :ensure t)

(use-package rustic
  :ensure t
  :mode "\\.rs\\'"
  :after lsp-mode
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status))
  :custom
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-rust-analyzer-server-display-inlay-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (lsp-rust-analyzer-display-chaining-hints t)
  (lsp-rust-analyzer-display-closure-return-type-hints t)
  (lsp-rust-analyzer-display-parameter-hints t)
  (lsp-rust-analyzer-display-reborrow-hints t)
  :config
  (setq rustic-format-on-save t))

(use-package haskell-mode
  :ensure t
  :mode "\\.hs\\'"
  :init (setq haskell-program-name "ghci"))

(use-package python-mode
  :ensure t
  :mode  "\\.py\\'")

(use-package magit
  :ensure t
  :commands magit-status)

(use-package company
    :ensure t
    :after lsp-mode
    :hook (lsp-mode . company-mode)
    :bind
    (:map company-active-map
          ("<tab>" . company-complete-selection))
    (:map lsp-mode-map
          ("<tab>" . company-indent-or-complete-common))
    :custom
    (company-minimum-prefix-length 1)
    (company-idle-delay 0.0))

  (use-package company-box
    :ensure t
    :hook (company-mode . company-box-mode))

(defun cr/switch-project-action ()
  "Switch to a perspective named after the project, start `magit-status'."
  (persp-switch (projectile-project-name))
  (magit-status))

(use-package projectile
  :ensure t
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/projects/code")
    (setq projectile-project-search-path '("~/projects/code")))
  (setq projectile-switch-project-action #'cr/switch-project-action))

(cr/leader-key
  "p" '(:ignore t :which-key "projectile")
  "pa" '(projectile-add-known-project :which-key "make project known to projectile")
  "pp" '(projectile-switch-project :which-key "switch to project")
  "pf" '(projectile-find-file :which-key "find file in current project"))

(use-package counsel-projectile
  ;; Extremely slow for some reason, disabling for now
  :disabled
  :ensure t
  :after projectile
  :config (counsel-projectile-mode))

(use-package perspective
  :ensure t
  :bind (("C-M-k" . persp-switch)
         ("C-M-n" . persp-next)
         ("C-x b" . persp-counsel-switch-buffer*)
         ("C-x k" . persp-kill-buffer*))
  :custom
  (persp-mode-prefix-key (kbd "C-c M-p"))
  :init
  (persp-mode))

(use-package evil-nerd-commenter
  :ensure t
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-mode
  :ensure t
  :hook (org-mode
         emacs-lisp-mode
         web-mode
         js2-mode))

(use-package vterm
  :ensure t)
