
;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------
(setq inhibit-startup-message t)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)
;; keep the installed packages in .emacs.d
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
(package-initialize)

;; Configurations
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(setq user-full-name "Rahul Ranjan"
      user-mail-address "rahul@rudrakos.com")

;; Always load newest byte code
(setq load-prefer-newer t)

;; mode line settings
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;; more useful frame title, that show either a file or a
;; buffer name (if the buffer isn't visiting a file)
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;; Keep modes indentation
(setq-default indent-tabs-mode nil)   ;; don't use tabs to indent

;; smart tab behavior - indent or complete
(setq tab-always-indent 'complete)

;; Keep the garbage collection in check
(setq gc-cons-threshold 20000000)

;; Newline at end of file
(setq require-final-newline t)

;; Wrap lines at 80 characters
(setq-default fill-column 80)

;; No blink cursor
(blink-cursor-mode -1)

;; delete the selection with a keypress
(delete-selection-mode t)

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(defconst rahul-savefile-dir (expand-file-name "savefile" user-emacs-directory))

;; create the savefile dir if it doesn't exist
(unless (file-exists-p rahul-savefile-dir)
  (make-directory rahul-savefile-dir))

;; revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)

;; Bootstrap `use-package`
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-verbose t)

;; Packages

;;; built-in
(use-package paren
  :config
  (show-paren-mode +1))

(use-package elec-pair
  :config
  (electric-pair-mode +1))

(use-package nlinum
  :ensure t
  :init (setq nlinum-format "%d  ")
  :config
  (global-nlinum-mode))

;; highlight the current line
(use-package hl-line
  :config
  (global-hl-line-mode +1))

;; saveplace remembers your location in a file when saving files
(use-package saveplace
  :config
  (setq save-place-file (expand-file-name "saveplace" rahul-savefile-dir))
  ;; activate it for all buffers
  (setq-default save-place t))

(use-package auto-package-update
  :ensure t
  :bind ("C-x P" . auto-package-update-now)
  :config
  (setq auto-package-update-delete-old-versions t))

(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns))
  :config
  (setq exec-path-from-shell-arguments '("-l"))
  (exec-path-from-shell-initialize))

;; Helps you to try a package without installing it
(use-package try
  :ensure t)

;;; third-party packages
(use-package afternoon-theme
  :ensure t
  :config
  (load-theme 'afternoon t))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

(use-package ag
  :ensure t)

(use-package projectile
  :ensure t
  :init
  (setq projectile-completion-system 'ivy)
  :config
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (projectile-mode +1))

;; Which next key you need to type
(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package yaml-mode
  :ensure t)

(use-package json-mode
  :ensure t
  :mode (("\\.json\\'" . json-mode)
         ("\\.tmpl\\'" . json-mode)
         ("\\.eslintrc\\'" . json-mode))
  :config (setq-default js-indent-level 2))

(use-package json-reformat
  :ensure t
  :after json-mode
  :bind (("C-c r" . json-reformat-region)))

;; Autocompletion
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  (add-to-list 'flycheck-checkers 'swift))

(use-package swift-mode
  :ensure t
  :mode "\\.swift\\'")

(use-package company-sourcekit
  :ensure t
  :init (setq company-sourcekit-use-yasnippet t)
  :config (add-to-list 'company-backends 'company-sourcekit))

(use-package quickrun
  :defer t
  :bind
  (("C-c C-c" . quickrun)))

;; config changes made through the customize UI will be stored here
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file))
