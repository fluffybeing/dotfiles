;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Rahul Ranjan"
  user-mail-address "rahul.rrixe@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Fira Code" :size 12)
  doom-variable-pitch-font (font-spec :family "Helvetica" :size 12))
(unless (find-font doom-font)
  (setq doom-font (font-spec :family "SF Mono" :size 12)))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)
(custom-set-faces!
  '(doom-modeline-buffer-modified :foreground "orange"))

(setq doom-fallback-buffer-name "Emacs"
  +doom-dashboard-name "Emacs")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Remove whole line
(setq kill-whole-line t)

;; word wrap
(+global-word-wrap-mode +1)

;; Disable confirm quit messages
(setq confirm-kill-emacs nil)

;; Auto-save and back up files automatically
(setq auto-save-default t
      make-backup-files t)

;; Mixed font
(add-hook! 'org-mode-hook #'mixed-pitch-mode)
(add-hook! 'org-mode-hook #'solaire-mode)
(setq mixed-pitch-variable-pitch-cursor nil)

;; Some basic configuration
(setq max-lisp-eval-depth 10000)
(setq-default
 delete-by-moving-to-trash t                      ; Delete files to trash
 tab-width 2                                      ; Set width for tabs
 uniquify-buffer-name-style 'forward              ; Uniquify buffer names
 window-combination-resize t                      ; take new window space from all other windows (not just current)
 x-stretch-cursor t)                              ; Stretch cursor to the glyph width

(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
  evil-want-fine-undo t                       ; By default while in insert all changes are one big blob. Be more granular
  auto-save-default t                         ; Nobody likes to loose work, I certainly don't
  make-backup-files t
  inhibit-compacting-font-caches t)           ; When there are lots of glyphs, keep them in memory

(delete-selection-mode 1)                         ; Replace selection when inserting text
(display-time-mode 1)                             ; Enable time in the mode-line
(display-battery-mode 1)                          ; On laptops it's nice to know how much power you have
(global-subword-mode 1)
(auto-save-visited-mode +1)                       ; Save files automatically

(setq-default history-length 1000)
(setq-default prescient-history-length 1000)

(setq-default custom-file (expand-file-name ".custom.el" doom-private-dir))
(when (file-exists-p custom-file)
  (load custom-file))

;; Start maximised (cross-platf)
(when IS-MAC
  (setq ns-use-thin-smoothing t) ; better looking font rendering
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t)) ; support macos integrated titlebar
  (add-to-list 'default-frame-alist '(ns-appearance . dark)) ; support macos dark mode
  (add-to-list 'default-frame-alist '(fullscreen . maximized)) ; full screen on start
  (setq ns-right-alternate-modifier (quote none))) ; un-hijack right alt to do symbols


;; Remove the trailing white space
(add-hook 'before-save-hook
          'delete-trailing-whitespace)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;          Projects & Coding
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; let's define some of the projectile project types
(after! projectile
  :config
  (setq projectile-project-search-path '("~/Code/"))   ; let projectile finds the projects
  (add-to-list 'projectile-project-root-files ".projectile")
  (add-to-list 'projectile-project-root-files ".git")
  (projectile-register-project-type 'xcode '("*.xcodeproj")))
(setq projectile-git-submodule-command nil)

(defun projectile-ignored-project-function (filepath)
  "Return t if FILEPATH is within any of `projectile-ignored-projects'"
  (or (mapcar (lambda (p) (s-starts-with-p p filepath)) projectile-ignored-projects)))

;; Make swift indendation to 2 spaces
(after! swift-mode
  :config
  (setenv "SOURCEKIT_TOOLCHAIN_PATH" "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain")
  (setq lsp-sourcekit-executable "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp"))



;; C-x o alternative
(use-package! windmove
  :config
  ;; use command + arrow keys to switch between visible buffers
  (windmove-default-keybindings 'super)
  (setq windmove-wrap-around t))

;; Key binding
(setq mac-command-modifier 'super)
(map! "C-s" 'swiper)
(map! "C-x g" 'magit-status)
(map! "s-t" '+vterm/toggle)

(map! "s-n" 'org-capture)
(map! "s-a" 'org-agenda)
(map! "s-i" 'org-mac-grab-link)

(after! protobuf-mode
  :mode "\\.proto$")

(after! company
  (define-key company-active-map (kbd "<return>") nil)
  (define-key company-active-map (kbd "RET") nil)
  (define-key company-active-map (kbd "C-SPC") #'company-complete-selection))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;                Writing
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(after! langtool
  :config
  (setq langtool-bin "/usr/local/bin/languagetool")
  (setq langtool-default-language "en-US")
  (setq langtool-mother-tongue "en"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;                     orgmode
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/org/"
  org-roam-directory "~/Dropbox/roam/"
  org-use-property-inheritance t              ; it's convenient to have properties inherited
  org-log-done 'time                          ; having the time a item is done sounds convininet
  org-list-allow-alphabetical t               ; have a. A. a) A) list bullets
  org-export-in-background t                  ; run export processes in external emacs process
  org-catch-invisible-edits 'smart)           ; try not to accidently do weird stuff in invisible regions
