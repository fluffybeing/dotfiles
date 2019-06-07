
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

;; Basic Configurations
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8-unix)
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

(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns))
  :config
  (exec-path-from-shell-initialize))

;; Helps you to try a package without installing it
(use-package try
  :ensure t)

;;; third-party packages
(use-package afternoon-theme
  :ensure t
  :config
  (load-theme 'afternoon t))

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
  :init
  (setq projectile-completion-system 'ivy)
  :config
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1))
 
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
  :interpreter "swift")

(use-package elpy
  :ensure t
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable))

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

;; AutoCompletions
(use-package ivy
  :ensure t
  :diminish (ivy-mode . "")
  :init (ivy-mode 1) ; globally at startup
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-height 20)
  (setq ivy-count-format "%d/%d "))

;; Override the basic Emacs commands
(use-package counsel
  :ensure t
  :bind* ; load when pressed
  (("M-x"     . counsel-M-x)
   ("C-s"     . swiper)
   ("C-x C-f" . counsel-find-file)
   ("C-x C-r" . counsel-recentf)  ; search for recently edited
   ("C-c g"   . counsel-git)      ; search for files in git repo
   ("C-c j"   . counsel-git-grep) ; search for regexp in git repo
   ("C-c /"   . counsel-ag)       ; Use ag for regexp
   ("C-x l"   . counsel-locate)
   ("C-x C-f" . counsel-find-file)
   ("<f1> f"  . counsel-describe-function)
   ("<f1> v"  . counsel-describe-variable)
   ("<f1> l"  . counsel-find-library)
   ("<f2> i"  . counsel-info-lookup-symbol)
   ("<f2> u"  . counsel-unicode-char)
   ("C-c C-r" . ivy-resume)))     ; Resume last Ivy-based completion

;; config changes made through the customize UI will be stored here
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file))

