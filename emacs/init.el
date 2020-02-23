
;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------
;; Remove the initial message 
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq initial-major-mode 'org-mode)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
       '("melpa" . "https://melpa.org/packages/") t)
;; keep the installed packages in .emacs.d
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
(package-initialize)

;; Basic Configurations of fonts
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8)
(set-frame-font "SF Mono 13")

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
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)

;; Symlinks
(setq vc-follow-symlinks t)

;; make the frame full screen
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist '(cursor-color . "white"))

;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;; more useful frame title, that show either a file or a
;; buffer name (if the buffer isn't visiting a file)
(add-to-list 'default-frame-alist '(ns-appearance . dark))
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

(use-package names
  :ensure t)

(use-package system-packages
  :ensure t
  :init
  (setq system-packages-use-sudo nil)
  (when (eq system-type 'darwin)
    (setq system-packages-package-manager 'brew)))

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

;; show lines on left side
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

;; Update packages on four days interval
(use-package auto-package-update
  :ensure t
  :bind ("C-x P" . auto-package-update-now)
  :config
  (setq auto-package-update-delete-old-versions t
        auto-package-update-interval 4)
  (auto-package-update-maybe))

(use-package server
  :ensure t
  :config
  (unless (server-running-p) (server-start)))

;; Play well with $PATH on mac 
(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns))
  :config
  (exec-path-from-shell-initialize))

;; C-x o alternative
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
  :diminish super-save-mode
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
  :hook (after-init . desktop-read)
  :config
  (desktop-save-mode t))

(use-package recentf
  :ensure t
  :custom
  (recentf-max-menu-items 100)
  (recentf-max-saved-items 100)
  :init
  (recentf-mode))

(use-package all-the-icons
  :ensure t
  :init
  (unless (member "all-the-icons" (font-family-list))
    (all-the-icons-install-fonts t)))

(use-package all-the-icons-ivy-rich
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1))

(use-package ivy-rich
  :ensure t
  :init (ivy-rich-mode 1))

;; powerline
;; Hide extra abbreviation of minor mode
(use-package diminish
  :ensure t)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;; Themes
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package dash
  :config (dash-enable-font-lock))

;; Git Related 
(use-package magit
  :defer t
  :bind (("C-x g"   . magit-status)
         ("C-x M-g" . magit-dispatch))
  :config
  (magit-add-section-hook 'magit-status-sections-hook
                          'magit-insert-modules
                          'magit-insert-stashes
                          'append))

(use-package git-gutter-fringe
  :ensure t
  :diminish git-gutter-mode
  :config (global-git-gutter-mode))

;; Project and Search 
(use-package ag
  :ensure t)

(use-package projectile
  :ensure t
  :bind ("C-c p" . projectile-command-map)
  :init
  (setq projectile-completion-system 'ivy
        projectile-git-submodule-command nil)
  :diminish projectile-mode
  :config
  (projectile-mode +1)
  (add-to-list 'projectile-project-root-files ".projectile")
  (add-to-list 'projectile-project-root-files ".git")

  ;; set different project types
  (projectile-register-project-type 'xcode
    '("*.xcodeproj")))


(use-package neotree
  :ensure t
  :bind ("C-8" . 'neotree-toggle)
  :init
  ;; slow rendering
  (setq inhibit-compacting-font-caches t)
  ;; set icons theme
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  ;; Every time when the neotree window is opened, let it find current file and jump to node
  (setq neo-smart-open t)
  ;; When running ‘projectile-switch-project’ (C-c p p), ‘neotree’ will change root automatically
  (setq projectile-switch-project-action 'neotree-projectile-action)
  ;; show hidden files
  (setq-default neo-show-hidden-files t))

;; Which next key you need to type
(use-package which-key
  :ensure t
  :config (which-key-mode))

;; Critical modes
(use-package web-mode
  :defer 2
  :after (add-node-modules-path)
  :ensure t
  :mode (("\\.html\\'" . web-mode)
         ("\\.jsx\\'" . web-mode)))

(use-package markdown-mode
  :ensure t
  :mode "\\.md\\'")

(use-package yaml-mode
  :ensure t
  :mode "\\.yaml\\'")

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
  :diminish flyspell-mode
  :config
  (setq ispell-program-name "aspell"
        ispell-extra-args '("--sug-mode=ultra" "--lang=en_US"))
  :hook (text-mode . flyspell-mode)
        (prog-mode . flyspell-prog-mode))

;;; Syntax highlighting
;; for package syntax
(use-package flycheck-package
  :ensure t
  :after flycheck)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :diminish flycheck-mode
  :config
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
  (add-to-list 'flycheck-checkers 'swift))

(use-package swift-mode
  :ensure t
  :mode "\\.swift\\'"
  :interpreter "swift"
  :config
  (setq-default swift-mode:basic-offset 2)
  :init
  (use-package company-sourcekit
    :ensure t
    :init (setq company-sourcekit-use-yasnippet t)
    :config (add-to-list 'company-backends 'company-sourcekit))
  (add-to-list 'flycheck-checkers 'swift))

;; Running programs 
(use-package quickrun
  :ensure t
  :bind
  (("C-c q" . quickrun)
   ("<f8>" . quickrun-compile-only)))

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
  (setq shell-pop-term-shell "/bin/zsh"
        shell-pop-window-position "bottom"
        shell-pop-universal-key "C-t"
        shell-pop-full-span t
        shell-pop-window-size 50
        shell-pop-shell-type (quote ("ansi-term" "*ansi-term*" (lambda nil (ansi-term shell-pop-term-shell)))))
  ;; need to do this manually or not picked up by `shell-pop'
  (shell-pop--set-shell-type 'shell-pop-shell-type shell-pop-shell-type))

(use-package multi-term
  :ensure t
  :config
  (setq multi-term-program "/bin/zsh"))

;; Auto-completion
(use-package company
  :ensure t
  :bind ("C-<tab>" . company-complete)
  :diminish
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.1)
  (setq company-show-numbers t)
  (setq company-tooltip-limit 10)
  (setq company-minimum-prefix-length 2)
  (setq company-tooltip-align-annotations t)
  ;; invert the navigation direction if the the completion popup-isearch-match
  ;; is displayed on top (happens near the bottom of windows)
  (setq company-tooltip-flip-when-above t)
  (setq company-backends (delete 'company-semantic company-backends)))

(use-package company-quickhelp
  :ensure t
  :config
  (company-quickhelp-mode))

;; Folder and navigation
(use-package dired
  :commands dired-mode
  :bind (:map dired-mode-map ("C-o" . dired-omit-mode))
  :config
  (progn
    (setq dired-dwim-target t)
    (setq-default dired-omit-mode t)
    (setq-default dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^\\.")
    (define-key dired-mode-map "i" 'dired-subtree-insert)
    (define-key dired-mode-map ";" 'dired-subtree-remove)))
(use-package dired-subtree
  :ensure t
  :commands (dired-subtree-insert))

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

;; Org mode
(defun my/org-add-ids-to-headlines-in-file ()
  "Add ID properties to all headlines in the current file which
   do not already have one."
  (interactive)
  (org-map-entries 'org-id-get-create))

(use-package org
  :ensure t
  :mode ("\\.org\\'" . org-mode)
  :bind (("C-c l" . org-store-link)
         ("C-c c" . org-capture)
         ("C-c a" . org-agenda)
         ("C-c b" . org-iswitchb)
         ("C-c C-w" . org-refile)
         ("C-c j" . org-clock-goto)
         ("C-c C-x C-o" . org-clock-out)
         )
  :config
  (progn
    ;; The GTD part of this config is heavily inspired by
    ;; https://emacs.cafe/emacs/orgmode/gtd/2017/06/30/orgmode-gtd.html
    (setq org-use-fast-todo-selection t)
    ;; TODO Keywords
    (setq org-todo-keywords
          '((sequence "☛ TODO(t)" "|" "✔ DONE(d)")
            (sequence "⚑ WAITING(w@/)" "|" "✘ CANCELLED(c@/)")))
    (setq org-enforce-todo-dependencies t)
    (setq org-agenda-files '("~/Dropbox/org/"))
    (setq org-log-done 'time)
    (setq org-capture-templates
          '(("t" "todo" entry
             (file+headline "~/Dropbox/org/inbox.org" "Tasks")
             "* ☛ TODO %?\n%U" :empty-lines 1)
            ("s" "Scheduled" entry
             (file+headline "~/Dropbox/org/inbox.org" "Tasks")
             "* ☛ TODO %? %^G \nSCHEDULED: %^t\n  %U" :empty-lines 1)
            ("d" "Deadline" entry
             (file+headline "~/Dropbox/org/inbox.org" "Tasks")
             "* ☛ TODO %? %^G \n  DEADLINE: %^t" :empty-lines 1)
            ("p" "Priority" entry
             (file+headline "~/Dropbox/org/inbox.org" "Tasks")
             "* ☛ TODO [#A] %? %^G \n  SCHEDULED: %^t")
            ("T" "Tickler (Repeated)" entry
             (file+headline "~/Dropbox/org/tickler.org" "Tickler")
             "* %i%? \n %^t")
            ("j" "Journal" entry
             (file+datetree "~/Dropbox/org/journal.org")
             "* %?\nEntered on %U\n  %i\n  %a")
            ("i" "idea" entry
             (file+datetree "~/Dropbox/org/ideas.org")
             "* %? \n %U")))
    (setq org-refile-targets '(("~/Dropbox/org/gtd.org" :maxlevel . 3)
                               ("~/Dropbox/org/someday.org" :maxlevel . 1)
                               ("~/Dropbox/org/tickler.org" :maxlevel . 2)
                               ("~/Dropbox/org/ideas.org" :maxlevel . 2)))

    (setq org-refile-use-outline-path 'file)
    (setq org-outline-path-complete-in-steps nil)
        (setq org-agenda-custom-commands
      '(("c" "Simple agenda view"
         ((tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "High-priority unfinished tasks:")))
          (agenda "")
          (alltodo ""))
         ((org-agenda-tag-filter-preset '("-SOMEDAY"))))))
    (setq org-clock-continuously t)
    (setq org-duration-format '(:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))
    (setq org-tag-alist '(("@work" . ?w) ("@personal" . ?p) ("@health" . ?h)
                          ("@travel" . ?t) ("@Resonance" . ?r) ("@life" . ?l)
                          ("@algo" . ?a)))))

(use-package org-protocol
  :after org
  :config
  (setq org-modules (quote (org-protocol)))
  (add-to-list 'org-capture-templates
               '("l" "Link" entry (file "~/Dropbox/org/inbox.org")
                 "* ☛ TODO %? |- (%:description) :BOOKMARK:\n:PROPERTIES:\n:CREATED: %U\n:Source: %:link\n:END:\n%i\n" :clock-in t :clock-resume t))
  (add-to-list 'org-capture-templates
               '("c" "Content" entry (file "~/Dropbox/org/inbox.org")
                 "* ☛ TODO %? :BOOKMARK:\n%(replace-regexp-in-string \"\n.*\" \"\" \"%i\")\n:PROPERTIES:\n:CREATED: %U\n:Source: %:link\n:END:\n%i\n" :clock-in t :clock-resume t)))

(use-package org-inlinetask
  :bind (:map org-mode-map
              ("C-c C-x t" . org-inlinetask-insert-task))
  :after (org)
  :commands (org-inlinetask-insert-task))

(use-package org-bullets
  :ensure t
  :commands (org-bullets-mode)
  :init (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package org-journal
  :ensure t
  :requires org)

;; config changes made through the customize UI will be stored here
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file))

(setq disabled-command-function nil)
