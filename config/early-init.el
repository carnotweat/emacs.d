;; Disable package.el in favor of straight.el
;;; early-init.el --- Early Init File -*- lexical-binding: t; no-byte-compile: t -*-
;; NOTE: this file is generated from ~/org/emacs.org
;;
(setq gc-cons-threshold most-positive-fixnum)
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)
(setq inhibit-startup-echo-area-message (user-login-name))
(setq frame-inhibit-implied-resize t
      frame-resize-pixelwise t
      default-frame-alist '((ns-transparent-titlebar . t)
                            (full-screen . maximized)
                            (vertical-scroll-bar . nil)
                            (horizontal-scroll-bar . nil))
      visual-bell t
      display-time-default-load-average nil)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 10)
;;; for elpaca
(setq package-enable-at-startup nil
      package-quickstart nil)
;;; provide a shared eln cache or redirect it, TODO- manage it with nix
(defun startup-redirect-eln-cache (cache-directory)
  "Redirect the user's eln-cache directory to CACHE-DIRECTORY.
CACHE-DIRECTORY must be a single directory, a string.
This function destructively changes `native-comp-eln-load-path'
so that its first element is CACHE-DIRECTORY.  If CACHE-DIRECTORY
is not an absolute file name, it is interpreted relative
to `user-emacs-directory'.
For best results, call this function in your early-init file,
so that the rest of initialization and package loading uses
the updated value."
  ;; Remove the original eln-cache.
  (setq native-comp-eln-load-path (cdr native-comp-eln-load-path))
  ;; Add the new eln-cache.
  (push (expand-file-name (file-name-as-directory cache-directory)
                          user-emacs-directory)
        native-comp-eln-load-path))
;;(provide 'early-init)
