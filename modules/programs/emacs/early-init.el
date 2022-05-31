(defun cr/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
    (format "%.2f seconds"
            (float-time
              (time-subtract after-init-time before-init-time)))
            gcs-done))

(add-hook 'emacs-startup-hook #'cr/display-startup-time)

;; Set default to 200mb (in bytes)
(setq gc-cons-threshold (* 200 1000 1000))

(setq comp-deferred-compilation nil)

(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)

(setq visible-bell t)
(set-fringe-mode 10)
