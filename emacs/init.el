
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

;; Basic Configurations of fonts
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8)
(set-frame-font "Inconsolata 14")

(setq user-full-name "Rahul Ranjan"
      user-mail-address "rahul@rudrakos.com")

;; nice scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; disable the annoying bell ring
(setq ring-bell-function 'ignore)

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

;; replace buffer-menu with ibuffer
(global-set-key (kbd "C-x C-b") #'ibuffer)

;; align code in a pretty way
(global-set-key (kbd "C-x \\") #'align-regexp)

;; Keep modes indentation
(setq-default indent-tabs-mode nil)   ;; don't use tabs to indent
(setq-default c-basic-offset 2)
(setq-default tab-width 2)
(setq-default c-basic-indent 2)

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

(use-package term
  :config
  (setq default-process-coding-system '(utf-8-unix . utf-8-unix)))

(use-package nlinum
  :ensure t
  :init (setq nlinum-format " %d  ")
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

(use-package server
  :ensure t
  :config
  (unless (server-running-p) (server-start)))

(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns))
  :config
  (exec-path-from-shell-initialize))

(use-package windmove
  :config
  ;; use shift + arrow keys to switch between visible buffers
  (windmove-default-keybindings))

;; Helps you to try a package without installing it
(use-package try
  :ensure t)

;;; third-party packages
(use-package super-save
  :ensure t
  :config
  ;; add integration with ace-window
  (add-to-list 'super-save-triggers 'ace-window)
(super-save-mode +1))

;; Desktop mode
(use-package desktop
  :ensure t
  :custom
  (desktop-restore-eager   1   "Restore only the first buffer right away")
  (desktop-lazy-idle-delay 1   "Restore the rest of the buffers 1 seconds later")
  (desktop-lazy-verbose    nil "Be silent about lazily opening buffers")
  :bind
  ("C-c d" . desktop-clear)
  :config
  (desktop-save-mode))

(use-package recentf
  :ensure t
  :custom
  (recentf-max-menu-items 100)
  (recentf-max-saved-items 100)
  :init
  (recentf-mode))

(use-package all-the-icons
  :ensure t
  :defer 3)

;; powerline
(use-package diminish
  :ensure t)

(use-package powerline
  :ensure t
  :config
  (setq powerline-arrow-shape 'curve
        powerline-display-buffer-size nil
        powerline-display-mule-info nil)
  (powerline-center-theme)
  (remove-hook 'focus-out-hook 'powerline-unset-selected-window)
  (setq powerline-height 20))

(use-package dracula-theme
  :ensure t
  :config
  (load-theme 'dracula t))

(use-package dash
  :config (dash-enable-font-lock))

;; The awesomeness
(use-package magit
  :defer t
  :bind (("C-x g"   . magit-status)
         ("C-x M-g" . magit-dispatch))
  :config
  (magit-add-section-hook 'magit-status-sections-hook
                          'magit-insert-modules
                          'magit-insert-stashes
                          'append))
;; Files and Folders
(use-package ag
  :ensure t)

(use-package projectile
  :ensure t
  :bind ("C-c p" . projectile-command-map)
  :init
  (setq projectile-completion-system 'ivy
        projectile-git-submodule-command nil)

  :config
  (projectile-mode +1)
  (add-to-list 'projectile-project-root-files ".projectile")
  (add-to-list 'projectile-project-root-files ".git")

  ;; set different project types
  (projectile-register-project-type 'xcode
    '("*.xcodeproj")))
 
;; Which next key you need to type
(use-package which-key
  :ensure t
  :config (which-key-mode))

;; Critical modes
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

;; Spelling check
(use-package flyspell
  :ensure t
  :config
  (setq ispell-program-name "aspell"
        ispell-extra-args '("--sug-mode=ultra" "--lang=en_US"))
  :hook (text-mode . flyspell-mode)
        (prog-mode . flyspell-prog-mode))

;; Syntax highlighting
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
  (add-to-list 'flycheck-checkers 'swift))

(use-package swift-mode
  :ensure t
  :mode "\\.swift\\'"
  :interpreter "swift"
  :config
  (setq-default swift-mode:basic-offset 2))

(use-package markdown-mode
  :ensure t)

(use-package company-quickhelp
  :ensure t
  :config
  (company-quickhelp-mode))

(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode))

;; Running programs 
(use-package quickrun
  :ensure t
  :bind
  (("C-c C-q" . quickrun)
   ("<f8>" . quickrun-compile-only)))

(use-package leetcode
  :if (file-directory-p "~/.emacs.d/leetcode/")
  :ensure t
  :load-path "~/.emacs.d/leetcode/"
  :config
  (setq leetcode-account "coyo8")
  (setq leetcode-password "vBG3762TECmDQo")
  (setq leetcode-prefer-language "swift"))

(use-package multi-term
  :ensure t
  :config
  (setq multi-term-program "/bin/zsh"))

;; Unicode
(use-package unicode-fonts
  :ensure t
  :demand t
  :config
  (unicode-fonts-setup))

(use-package shell-pop
  :ensure t
  :bind (("C-t" . shell-pop))
  :config
  (setq shell-pop-shell-type (quote ("ansi-term" "*ansi-term*" (lambda nil (ansi-term shell-pop-term-shell)))))
  (setq shell-pop-term-shell "/bin/zsh")
  (setq shell-pop-universal-key "C-t")
  ;; need to do this manually or not picked up by `shell-pop'
  (shell-pop--set-shell-type 'shell-pop-shell-type shell-pop-shell-type))

;; Autocompletion
(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0.1)
  (setq company-show-numbers t)
  (setq company-tooltip-limit 10)
  (setq company-minimum-prefix-length 2)
  (setq company-tooltip-align-annotations t)
  ;; invert the navigation direction if the the completion popup-isearch-match
  ;; is displayed on top (happens near the bottom of windows)
  (setq company-tooltip-flip-when-above t)
  (global-company-mode))

;; (use-package company-sourcekit
;;   :ensure t
;;   :config
;;   (add-to-list 'company-backends 'company-sourcekit))

;; Search and find enhancements
(use-package ivy
  :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (global-set-key (kbd "C-c C-r") 'ivy-resume))

(use-package swiper
  :ensure t
  :config
  (global-set-key "\C-s" 'swiper))

(use-package counsel
  :ensure t
  :config
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "C-c a") 'counsel-ag)
  (global-set-key (kbd "C-x l") 'counsel-locate)
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history))

(use-package counsel-projectile
  :ensure t
  :after counsel
  :bind ("C-x C-p" . counsel-projectile-switch-project)
  :config
  (counsel-projectile-mode))


;; Format code
(use-package format-all
  :ensure t)
  

;; config changes made through the customize UI will be stored here
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file))

