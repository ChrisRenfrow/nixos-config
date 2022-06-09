(defun cr/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
    (format "%.2f seconds"
            (float-time
              (time-subtract after-init-time before-init-time)))
            gcs-done))

(add-hook 'emacs-startup-hook #'cr/display-startup-time)

;; Set default to 100mb (in bytes)
(setq gc-cons-threshold 100000000)

;; Increase the amount of data which Emacs reads from the process
(setq read-process-output-max (* 1024 1024)) ;; 1mb

(setq comp-deferred-compilation nil)

(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)

(setq visible-bell t)
(set-fringe-mode 10)
