(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(eval-when-compile
  (require 'use-package))

(unless package-archive-contents
	(package-refresh-contents))
(unless (package-installed-p 'use-package)
	(package-install 'use-package))

(setq-default use-package-always-defer t
              use-package-always-ensure t)

(setq name "Chris Renfrow"
      email "mail@chrisrenfrow.me")

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(global-set-key (kbd "C-M-u") 'universal-argument)

(setq backup-directory-alist
          `(("." . ,(concat user-emacs-directory "backups"))))

(use-package diminish)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package counsel
  :demand t
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)) ;; Don't start search with `^'

(use-package flx ;; Improves sorting for fuzzy-matched results
  :after ivy
  :defer t
  :init
  (setq ivy-flx-limit 10000))

(use-package prescient
  :after counsel
  :config
  (prescient-persist-mode 1))

(use-package ivy-prescient
	:after prescient
	:config
	(ivy-prescient-mode 1))

(use-package general
  :ensure t
  :config
  (general-evil-setup t)

  (general-create-definer cr/leader
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC"))

(cr/leader
	"r" '(ivy-resume :which-key "ivy resume")
	"f" '(:ignore t :which-key "files")
	"ff" '(counsel-find-file :which-key "open file")
	"C-f" 'counsel-find-file
	"fr" '(counsel-recentf :which-key "recent files")
	"fR" '(revert-buffer :which-key "revert file")
	"fj" '(counsel-file-jump :which-key "jump to file"))

;; (use-package vertico
;; 	:bind (:map vertico-map
;; 		    ("C-j" . vertico-next)
;; 		    ("C-k" . vertico-previous)
;; 		    ("C-f" . vertico-exit))
;; 	:custom
;; 	(vertico-cycle t)
;; 	:init
;; 	(vertico-mode))

(use-package minions
  :hook (doom-modeline-mode . minions-mode))

(use-package doom-modeline
  ;; :after eshell
  :hook (after-init . doom-modeline-init)
  :custom-face
  (mode-line ((t (:height 0.95))))
  (mode-line-inactive ((t (:height 0.95))))
  :custom
  (doom-modeline-height 15)
  (doom-modeline-bar-width 6)
  (doom-modeline-lsp t)
  (doom-modeline-github nil)
  (doom-modeline-minor-modes t)
  (doom-modeline-persp-name nil)
  (doom-modeline-buffer-file-name-style 'truncate-except-project))

(use-package doom-themes
  :config
  (load-theme 'doom-one t)
	(doom-themes-visual-bell-config)
	(doom-themes-treemacs-config)
	(doom-themes-org-config))

(global-display-line-numbers-mode t)

(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq-default doc-view-resolution 300)

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package undo-tree
  :init
  (global-undo-tree-mode)
	:config
	(setq undo-tree-history-directory-alist
				`(("." . ,(concat user-emacs-directory "undo-tree")))))

(defun cr/no-arrow-keys ()
  "Print a friendly reminder that arrow keys have been disabled."
  (interactive)
  (message (nth (random 5)
		'("Hey, stop that."
		  "Just a reminder: `j' is down, `k' is up."
		  "Arrow keys bad."
		  "`j' and `k', that's the way."
		  "It looks like you're using your arrow keys.\nWould you like help?\n- Use hjkl instead of arrow keys\n- Continue pressing arrow keys to no effect"))))

(use-package evil
	:demand t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-tree)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal)
  ;; Disable arrow keys in normal and visual modes
  (define-key evil-normal-state-map (kbd "<left>") 'cr/no-arrow-keys)
  (define-key evil-normal-state-map (kbd "<right>") 'cr/no-arrow-keys)
  (define-key evil-normal-state-map (kbd "<down>") 'cr/no-arrow-keys)
  (define-key evil-normal-state-map (kbd "<up>") 'cr/no-arrow-keys)
  (evil-global-set-key 'motion (kbd "<left>") 'cr/no-arrow-keys)
  (evil-global-set-key 'motion (kbd "<right>") 'cr/no-arrow-keys)
  (evil-global-set-key 'motion (kbd "<down>") 'cr/no-arrow-keys)
  (evil-global-set-key 'motion (kbd "<up>") 'cr/no-arrow-keys))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package ws-butler
  :hook ((text-mode . ws-butler-mode)
	 (prog-mode . ws-butler-mode)))

;; UI Toggles

(cr/leader
  "t" '(:ignore t :which-key "toggles")
  "tS" 'whitespace-mode
  "tt" '(counsel-load-theme :which-key "choose-theme"))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
	("d" (text-scale-adjust 0) "default" :exit t)
  ("f" nil "finished" :exit t))

(cr/leader
  "ts" '(hydra-text-scale/body :which-key "scale text"))

;; Common file bindings

(cr/leader
  "f" '(:ignore t :which-key "file bindings")
  "fn" '(:ignore t :which-key "notes")
	"fnd" '(lambda () (interactive) (find-file (expand-file-name "~/Notes/org/drill") "org-drill directory"))
  "fd" '(:ignore t :which-key "dotfiles")
  "fdi" '(lambda () (interactive) (find-file (expand-file-name "~/.emacs.d/init.el") "init.el")))

(use-package perspective
  :demand t
  :bind (("C-M-k" . persp-switch)
	 ("C-M-n" . persp-next)
	 ("C-x k" . persp-kill-buffer*))
  :custom
  (persp-initial-frame-name "main")
  :config
  (unless (equal persp-mode t)
    (persp-mode)))

(use-package super-save
  :diminish super-save-mode
  :config
  (super-save-mode +1)
  (setq super-save-auto-save-when-idle t)
	(setq auto-save-default nil))

(setq global-auto-revert-non-file-buffers t)
(global-auto-revert-mode 1)

(setq display-time-world-list
      '(("Etc/UTC" "UTC")
				("America/Los_Angeles" "Los Angeles")
				("America/New_York" "New York")
				("Asia/Hanoi" "Hanoi")
				("Europe/London" "London")
				("Asia/Hong_Kong" "Hong Kong")))
(setq display-time-world-time-format "%a, %d %b %I:%M %p %Z")

(defun cr/switch-project-action ()
  "Switch to a perspective with the project name and start `magit-status'.  Thanks to David Wilson for the inspo: [[https://github.com/daviwil/dotfiles/blob/8c3c2ec283408f459524816f2b8786d9a2c106c1/Emacs.org#initial-setup][github]]."
  (persp-switch (projectile-project-name))
  (magit-status))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :demand t
  :bind
  ("C-M-p" . projectile-find-file)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Projects/Code")
    (setq projectile-project-search-path '("~/Projects/Code")))
  (setq projectile-switch-project-action #'cr/switch-project-action))

(use-package counsel-projectile
  :disabled
  :config (counsel-projectile-mode))

(use-package treemacs
	:defer t
	:config
	;; If HiDPI, double icon size (default is 22px)
	;; TODO: This merely changes the size of the icons, does nothing if
	;; the icons aren't already the correct resolution...
	;; (treemacs-resize-icons 44)

	(treemacs-follow-mode t)
	(treemacs-filewatch-mode t)
	(treemacs-fringe-indicator-mode 'always)

	(use-package treemacs-evil
		:after (treemacs evil))

	(use-package treemacs-projectile
		:after (treemacs projectile))

	(use-package treemacs-icons-dired
		:after (treemacs dired)
		:config (treemacs-icons-dired-mode))

	(use-package treemacs-magit
		:after (treemacs magit))

	(use-package treemacs-perspective
		:after (treemacs perspective)
		:config (treemacs-set-scope-type 'Perspectives)))

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(cr/leader
  "pf" 'projectile-find-file
  "ps" 'projectile-switch-project
  "pF" 'consult-ripgrep
  "pp" 'projectile-find-file
  "pc" 'projectile-compile-project
  "pd" 'projectile-dired)

(defun cr/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil)
  (diminish org-indent-mode))

(use-package org
  :hook (org-mode . cr/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"
				org-hide-emphasis-markers t
				org-src-fontify-natively t
				org-fontify-quote-and-verse-blocks t
				org-src-tab-acts-natively t
				org-edit-src-content-indentation 2
				org-hide-block-on-startup nil
				org-src-preserve-indentation nil
				org-startup-folded 'content
				org-cycle-seperator-lines 2)

  (setq org-modules
				'(org-crypt
					org-habit
					org-bookmark
					org-eshell))

  (setq org-refile-targets '((nil :maxlevel . 1)
														 (org-agenda-files :maxlevel . 1)))

  (setq org-outline-path-complete-in-steps nil
				org-refile-use-outline-path t)

  (evil-define-key '(normal insert visual) org-mode-map (kbd "C-j") 'org-next-visible-heading)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "C-k") 'org-previous-visible-heading)

  (evil-define-key '(normal insert visual) org-mode-map (kbd "M-j") 'org-metadown)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "M-k") 'org-metaup)

	(setq org-directory "~/Notes/org")

	;; Disable inherited tags specifically for `project'
	(add-to-list 'org-tags-exclude-from-inheritance "project")

	;; https://d12frosted.io/posts/2021-01-16-task-management-with-roam-vol5.html
	(defun cr/org-roam-project-files ()
		"Return a list of note files containing Project tag."
		(seq-filter
		 #'identity
		 (seq-map
			#'car
			(org-roam-db-query
			 [:select [nodes:file]
				:from tags
				:left-join nodes
				:on (= tags:node-id nodes:id)
				:where (like tags:tag (quote "%\"project\"%"))]))))

	(defun cr/update-org-agenda-files ()
		(interactive)
		(setq org-agenda-files (cr/org-roam-project-files)))

	(with-eval-after-load 'org-roam
		(cr/update-org-agenda-files))

	(defun cr/org-path (path)
		(expand-file-name path org-directory))

	(setq org-default-notes-file (cr/org-path "Inbox.org"))

	;; Todo Keywords/States
	;; - TODO - Should be done.
	;; - NEXT - Should be done next.
	;; - BACK - Back-logged. Should be done someday.
	;; - WAIT - To be done once external conditions are met.
	;; - DONE - Self-explanatory.
	(setq org-todo-keywords
				'((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
					(sequence "|" "WAIT(w)" "BACK(b)")))

	(setq org-todo-keyword-faces
				'(("NEXT" . (:foreground "orange red" :weight bold))
					("WAIT" . (:foreground "HotPink2" :weight bold))
					("BACK" . (:foreground "MediumPurple3" :weight bold))))

	;; Tags
	;; - batch - Low-effort and easy to batch with other low-effort tasks.
	;; - followup - Task is awaiting follow-up and should be prioritized.
	(setq org-tag-alist
				'((:startgroup)
					;; Put mutually exclusive tags here.
					(:endgroup)
					("@home" . ?H)
					("@work" . ?W)
					("batch" . ?b)
					("followup" . ?f)))

	;; Agendas
	(setq org-agenda-window-setup 'current-window
				org-agenda-span 'day
				org-agenda-start-with-log-mode t
				;; Make done tasks show up in the agenda log
				org-log-done 'time
				org-log-into-drawer t)
	(setq org-columns-default-format "%20CATEGORY(Category) %65ITEM(Task) %TODO %6Effort(Estim){:} %6CLOCKSUM(Clock) %TAGS")

	(setq org-agenda-custom-commands
				`(("d" "Dashboard"
					 ((agenda "" ((org-deadline-warning-days 7)))
						(tags-todo "+PRIORITY=\"A\""
											 ((org-agenda-overriding-header "High Priority")))
						(tags-todo "+followup"
											 ((org-agenda-overriding-header "Needs Follow Up")))
						(todo "NEXT"
									((org-agenda-overriding-header "Next Tasks")
									 (org-agenda-max-todos nil)))
						(todo "TODO"
									((org-agenda-overriding-header "Unprocessed Inbox Tasks")
									 (org-agenda-files '(,(cr/org-path "Inbox.org")))
									 (org-agenda-text-search-extra-files nil)))))

					("n" "Next Tasks"
					 ((agenda "" ((org-deadline-warning-days 7)))
						(todo "NEXT"
									((org-agenda-overriding-header "Next Tasks")))))

					("e" tags-todo "+TODO=\"NEXT\"+Effort<=15&+Effort>0"
					 ((org-agenda-overriding-header "Low Effort Tasks")
						(org-agenda-max-todos 20)
						(org-agenda-files org-agenda-files)))))

	;; If I decide to mimic David Wilson's clock-in workflow
	;; https://github.com/daviwil/dotfiles/blob/master/Workflow.org#clocking
	;; (add-hook 'org-timer-set-hook #'org-clock-in)

	;; (defun cr/on-org-capture ()
	;; 	;; Don't show the confirmation header text
	;; 	(setq header-line-format nil)

	;; 	;; Control how some buffers are handled
	;; 	(let ((template (org-capture-get :key t)))
	;; 		(pcase template
	;; 			("jj" (delete-other-windows)))))

	;; (add-hook 'org-capture-mode-hook 'cr/on-org-capture)

	(setq org-capture-templates
				`(("t" "Tasks")
					("tt" "Task" entry (file ,(cr/org-path "Inbox.org"))
					 "* TODO %?\n\t%U\n\t%a\t%i" :empty-lines 1)
					("ts" "Clocked Entry Subtask" entry (clock)
					 "* TODO %?\n\t%U\n\t%a\t%i" :empty-lines 1)
					("j" "Journal Entries")
					("je" "General Entry" entry
					 (file+olp+datetree ,(cr/org-path "Journal.org"))
					 "\n* %<%I:%M %p> - %^{Title} \n\n%?\n\n"
					 :tree-type week
					 :clock-in :clock-resume
					 :empty-lines 1)
					("jt" "Task Entry" entry
					 (file+olp+datetree ,(cr/org-path "Journal.org"))
					 "\n* %<%I:%M %p> - Task Notes: %a\n\n%?\n\n"
					 :tree-type week
					 :clock-in :clock-resume
					 :empty-lines 1)
					("jj" "Journal" entry
					 (file+olp+datetree ,(cr/org-path "Journal.org"))
					 "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
					 :tree-type week
					 :clock-in :clock-resume
					 :empty-lines 1)))

  (use-package org-superstar
    :after org
    :hook (org-mode . org-superstar-mode)
    :custom
    (org-superstar-remove-leading-stars t)
    (org-superstar-headline-bullets-list '("◉" "○" "●" "○" "●" "○" "●")))

  (set-face-attribute 'org-document-title nil :font "Iosevka Aile" :weight 'bold :height 1.3)
  (dolist (face '((org-level-1 . 1.2)
		  (org-level-2 . 1.1)
		  (org-level-3 . 1.05)
		  (org-level-4 . 1.0)
		  (org-level-5 . 1.1)
		  (org-level-6 . 1.1)
		  (org-level-7 . 1.1)
		  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Iosevka Aile" :weight 'medium :height (cdr face)))

  (require 'org-indent)

  ;; Ensure that anything that should be fixed-putch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
  (set-face-attribute 'org-code nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     ;; (ledger . t)
		 (js . t)
		 (haskell . t)))

  (push '("conf-unix" . conf-unix) org-src-lang-modes)

  (require 'org-tempo)

  (add-to-list 'org-structure-template-alist '("sh" . "src sh"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("sc" . "src scheme"))
  (add-to-list 'org-structure-template-alist '("ts" . "src typescript"))
	(add-to-list 'org-structure-template-alist '("js" . "src javascript"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (add-to-list 'org-structure-template-alist '("rs" . "src rust"))
  (add-to-list 'org-structure-template-alist '("yaml" . "src yaml"))
  (add-to-list 'org-structure-template-alist '("json" . "src json"))
  (add-to-list 'org-structure-template-alist '("nix" . "src nix"))
	(add-to-list 'org-structure-template-alist '("hs" . "src haskell"))

  (use-package org-pomodoro
    :after org
    :config
		(setq org-pomodoro-manual-break t
					org-pomodoro-keep-killed-time t
					org-pomodoro-start-sound "~/.emacs.d/sounds/focus_bell.wav"
					org-pomodoro-short-break-sound "~/.emacs.d/sounds/three_beeps.wav"
					org-pomodoro-long-break-sound "~/.emacs.d/sounds/three_beeps.wav"
					org-pomodoro-finished-sound "~/.emacs.d/sounds/meditation_bell.wav"))

	(cr/leader
      "op" '(org-pomodoro :which-key "pomodoro"))

  (use-package evil-org
    :after org
    :hook ((org-mode . evil-org-mode)
	   (evil-org-mode . (lambda ()
			      (evil-org-set-key-theme
			       '(navigation todo insert textobjects additional)))))
    :config
		;; TODO: This doesn't seem to be working on agenda
		;; first-launch. Consistently reproducible.
    (require 'evil-org-agenda)
    (evil-org-agenda-set-keys)))

(cr/leader
  "o" '(:ignore t :which-key "org mode")
  "oi" '(:ignore t :which-key "insert")
  "oil" '(org-insert-link :which-key "insert link")

  "on" '(org-toggle-narrow-to-subtree :which-key "toggle-narrow")

  "oa" '(org-agenda :which-key "status")
  "ot" '(org-todo-list :which-key "todos")
  "oc" '(org-capture t :which-key "capture")
  "ox" '(org-export-dispatch t :which-key "export"))

(use-package org-roam
	:demand t
	:init
	(setq org-roam-v2-ack t)
	(setq cr/daily-note-filename "%<%Y-%m-%d>.org"
				cr/daily-note-header "#+title: %<%Y-%m-%d %a>\n\n[[roam:%<%Y-%B>]]\n\n")
	:custom
	(org-roam-directory "~/Notes/org-roam/")
	(org-roam-dailies-directory "~/Notes/org-roam/journal/")
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
			"* %<%I:%M %p> - %?"
			:if-new (file+head+olp ,cr/daily-note-filename
														 ,cr/daily-note-header
														 ("Log")))
		 ("j" "journal" entry
			"* %<I:%M %p> - Journal\t:journal:\n\n%?\n\n"
			:if-new (file+head+olp ,cr/daily-note-filename
														 ,cr/daily-note-header
														 ("Log")))
		 ("m" "meeting" entry
			"* %<%I:%M %p> - %^{Meeting Title}\t:meetings:\n\n%?\n\n"
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

(use-package deft
	:commands (deft)
	:config (setq deft-directory "~/Notes/org-roam"
								deft-recursive t
								deft-extensions '("md" "org")))

(use-package org-drill
	:defer t
	:config
	;; Exclude :drill: items from `org-roam'.
	(setq org-roam-db-node-include-function
				(defun cr/org-roam-include ()
					(not (member "drill" (org-get-tags))))))

(cr/leader
	"od" '(:ignore t :which-key "drill")
	"odd" '(org-drill :which-key "drill")
	"odc" '(org-drill-cram :which-key "cram")
	"odr" '(org-drill-resume :which-key "resume"))

(use-package org-appear
	:hook (org-mode . org-appear-mode))

(defun cr/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands lsp
  :bind (:map lsp-mode-map
	      ("TAB" . completion-at-point))
  :custom (lsp-headerline-breadcrumb-enable nil))

(cr/leader
  "l" '(:ignore t :which-key "lsp")
  "ld" 'xref-find-definitions
  "lr" 'xref-find-references
  "ln" 'lsp-ui-find-next-reference
  "lp" 'lsp-ui-find-prev-reference
  "ls" 'counsel-imenu
  "le" 'lsp-ui-flycheck-list
  "lS" 'lsp-ui-sideline-mode
  "lX" 'lsp-execute-code-action)

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-sideline-enable t
	lsp-ui-sideline-show-hover nil
	lsp-ui-doc-position 'bottom)
  (lsp-ui-doc-show))

;; Typescript & JavaScript

(use-package typescript-mode
  :mode "\\.ts\\'"
  :config
  (setq typescript-indent-level 2))

(defun cr/js-set-indentation ()
  (setq js-indent-level 2
	evil-shift-width js-indent-level)
  (setq-default tab-width 2))

(use-package js2-mode
  :mode "\\.jsx?\\'"
  :config
  ;; Probably should add some logic here for compatibility on non-NixOS systems
  (add-to-list 'magic-mode-alist '("#!/run/current-system/sw/bin/env node" . js2-mode))
  ;; Don't use built-in syntax checking
  (setq js2-mode-show-strict-warnings nil)
  ;; Setup proper indentation in JavaScript and JSON files
  (add-hook 'js2-mode-hook #'cr/set-js-indentation)
  (add-hook 'json-mode-hook #'cr/set-js-indentation))

(use-package prettier-js
  :hook ((js2-mode . prettier-js-mode)
	 (typescript-mode . prettier-js-mode))
  :config
  (setq prettier-js-show-errors nil))

;; C/C++
(use-package ggtags
	:hook ('c-mode-common-hook . (lambda ()
																 (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
																	 (ggtags-mode 1 ))))
	:bind (:map ggtags-mode-map
							("C-c g s" . 'ggtags-find-other-symbol)
							("C-c g h" . 'ggtags-view-tag-history)
							("C-c g r" . 'ggtags-find-reference)
							("C-c g f" . 'ggtags-find-file)
							("C-c g c" . 'ggtags-create-tags)
							("C-c g u" . 'ggtags-update-tags)
							("M-,"     . 'pop-tag-mark)))

;; Rust

(use-package rust-mode
  :mode "\\.rs\\'"
  :init (setq rust-format-on-save t))

(use-package haskell-mode
	:mode "\\.hs\\'"
	:init (setq haskell-program-name "ghci"))

;; Emacs Lisp

(add-hook 'emacs-lisp-mode-hook #'flycheck-mode)

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . helpful-function)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-command] . helpful-command)
  ([remap describe-key] . helpful-key))

(cr/leader
  "e" '(:ignore t :which-key "eval")
  "eb" '(eval-buffer :which-key "eval buffer"))

(cr/leader
  :keymaps '(visual)
  "er" '(eval-region :which-key "eval region"))

;; Markdown

(use-package markdown-mode
  :mode "\\.md\\'"
  :config
  (setq markdown-command "marked")

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

;; HTML

(use-package web-mode
  :mode "(\\.\\(html?\\|ejs\\|tsx\\|jsx\\)\\'"
  :config
  (setq-default web-mode-code-indent-offset 2
		web-mode-markup-indent-offset 2
		web-mode-attribute-indent-offset 2))

;; YAML

(use-package yaml-mode
  :mode "\\.ya?ml\\'")

(use-package flycheck
  :defer t
  :hook (lsp-mode . flycheck-mode))

(use-package smartparens
  :hook (prog-mode . smartparens-mode))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-mode
  :defer t
  :hook (org-mode
	 emacs-lisp-mode
	 web-mode
	 typescript-mode
	 js2-mode))

;; Writing

(use-package writegood-mode)

(cr/leader
  "tw" '(:ignore t :which-key "writegood")
  "two" '(writegood-mode :which-key "turn-on writegood-mode")
  "twr" '(writegood-reading-ease :which-key "reading ease")
  "twg" '(writegood-grade-level :which-key "grade level"))

(use-package darkroom
	:demand t
  :config
  (setq darkroom-text-scale-increase 0))

(defun cr/toggle-tentative-focus-mode ()
  "Toggle darkroom-tentative-mode and show/hide line-numbers based on darkroom-tentative-mode state."
  (interactive)
  (if darkroom-tentative-mode
			(progn
				(display-line-numbers-mode 1)
				(darkroom-tentative-mode -1))
    (progn
			(display-line-numbers-mode -1)
			(darkroom-tentative-mode 1))))

(defun cr/toggle-focus-mode ()
  "Toggle darkroom-mode and show/hide line-numbers based on darkroom-mode state."
  (interactive)
  (if darkroom-mode
			(progn
				(display-line-numbers-mode 1)
				(darkroom-mode -1))
		(progn
			(display-line-numbers-mode -1)
			(darkroom-mode 1))))

(cr/leader
	"tf" '(:ignore t :which-key "focus-mode")
  "tft" '(cr/toggle-tentative-focus-mode :which-key "tentative focus-mode")
	"tff" '(cr/toggle-focus-mode :which-key "focus-mode"))

(use-package auctex
	:defer t
	:config
	(setq TeX-auto-save t
				TeX-parse-self t
				TeX-engine "xetex")
	(setq-default TeX-master nil))
