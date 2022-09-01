;;; init.el --- Brian's Emacs configuration
;;
;; Copyright (c) Brian Wang
;;
;; Author: Brian Wang <vimfunny@qq.com>
;; URL: https://github.com/vimfun/emacs.d

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This is my personal Emacs configuration.

;;; Code:

(require 'package)
(setq package-archives '(("cn-gnu-elpa"     . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("cn-nongnu-elpa"  . "http://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("cn-melpa"        . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
                         ("cn-melpa-stable" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/stable-melpa/")
                         ("cn-org"          . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")))
;; keep the installed packages in .emacs.d
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
(package-initialize)
;; update the package metadata is the local cache is missing
(unless package-archive-contents
  (package-refresh-contents))

(setq user-full-name "Brian Wang"
      user-mail-address "vimfunny@qq.com")

;; Always load newest byte code
(setq load-prefer-newer t)

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

;; quit Emacs directly even if there are running processes
(setq confirm-kill-processes nil)

(defconst bozhidar-savefile-dir (expand-file-name "savefile" user-emacs-directory))

;; create the savefile dir if it doesn't exist
(unless (file-exists-p bozhidar-savefile-dir)
  (make-directory bozhidar-savefile-dir))

;; the toolbar is just a waste of valuable screen estate
;; in a tty tool-bar-mode does not properly auto-load, and is
;; already disabled anyway
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))

;; the blinking cursor is nothing, but an annoyance
(blink-cursor-mode -1)

;; disable the annoying bell ring
(setq ring-bell-function 'ignore)

;; disable startup screen
(setq inhibit-startup-screen t)

;; nice scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode t))

;; let's pick a nice font
(cond
 ((find-font (font-spec :name "Cascadia Code"))
  (set-frame-font "Cascadia Code-14"))
 ((find-font (font-spec :name "Menlo"))
  (set-frame-font "Menlo-14"))
 ((find-font (font-spec :name "DejaVu Sans Mono"))
  (set-frame-font "DejaVu Sans Mono-14"))
 ((find-font (font-spec :name "Inconsolata"))
  (set-frame-font "Inconsolata-14")))

;; mode line settings
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;; maximize the initial frame automatically
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; more useful frame title, that show either a file or a
;; buffer name (if the buffer isn't visiting a file)
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;; Emacs modes typically provide a standard means to change the
;; indentation width -- eg. c-basic-offset: use that to adjust your
;; personal indentation width, while maintaining the style (and
;; meaning) of any files you load.
(setq-default indent-tabs-mode nil)   ;; don't use tabs to indent
(setq-default tab-width 8)            ;; but maintain correct appearance

;; Newline at end of file
(setq require-final-newline t)

;; Wrap lines at 80 characters
(setq-default fill-column 80)

;; delete the selection with a keypress
(delete-selection-mode t)

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; hippie expand is dabbrev expand on steroids
(setq hippie-expand-try-functions-list '(try-expand-dabbrev
                                         try-expand-dabbrev-all-buffers
                                         try-expand-dabbrev-from-kill
                                         try-complete-file-name-partially
                                         try-complete-file-name
                                         try-expand-all-abbrevs
                                         try-expand-list
                                         try-expand-line
                                         try-complete-lisp-symbol-partially
                                         try-complete-lisp-symbol))

;; use hippie-expand instead of dabbrev
(global-set-key (kbd "M-/") #'hippie-expand)
(global-set-key (kbd "s-/") #'hippie-expand)

;; replace buffer-menu with ibuffer
(global-set-key (kbd "C-x C-b") #'ibuffer)

;; Start proced in a similar manner to dired
(global-set-key (kbd "C-x p") #'proced)

;; align code in a pretty way
(global-set-key (kbd "C-x \\") #'align-regexp)

(define-key 'help-command (kbd "C-i") #'info-display-manual)

;; misc useful keybindings
(global-set-key (kbd "s-<") #'beginning-of-buffer)
(global-set-key (kbd "s->") #'end-of-buffer)
(global-set-key (kbd "s-q") #'fill-paragraph)
(global-set-key (kbd "s-x") #'execute-extended-command)
(global-set-key (kbd "C-s") 'swiper)

;; smart tab behavior - indent or complete
(setq tab-always-indent 'complete)

;; enable some commands that are disabled by default
(put 'erase-buffer 'disabled nil)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-verbose t)
(setq use-package-always-ensure t)

;;; built-in packages
(use-package paren
  :config
  (show-paren-mode +1))

(use-package elec-pair
  :config
  (electric-pair-mode +1))

(use-package calendar
  :config
  ;; weeks in Bulgaria start on Monday
  (setq calendar-week-start-day 1))

;; highlight the current line
(use-package hl-line
  :config
  (global-hl-line-mode 0))

(use-package org
  :config
  (setq org-startup-indented t))

(setq display-line-numbers 'visual)

(use-package abbrev
  :ensure nil
  :config
  (setq save-abbrevs 'silently)
  (setq-default abbrev-mode t))

(use-package uniquify
  :ensure nil
  :config
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-separator "/")
  ;; rename after killing uniquified
  (setq uniquify-after-kill-buffer-p t)
  ;; don't muck with special buffers
  (setq uniquify-ignore-buffers-re "^\\*"))

;; saveplace remembers your location in a file when saving files
(use-package saveplace
  :config
  (setq save-place-file (expand-file-name "saveplace" bozhidar-savefile-dir))
  ;; activate it for all buffers
  (setq-default save-place t))

(use-package savehist
  :config
  (setq savehist-additional-variables
        ;; search entries
        '(search-ring regexp-search-ring)
        ;; save every minute
        savehist-autosave-interval 60
        ;; keep the home clean
        savehist-file (expand-file-name "savehist" bozhidar-savefile-dir))
  (savehist-mode +1))

(use-package desktop
  :config
  (desktop-save-mode +1))

(use-package recentf
  :config
  (setq recentf-save-file (expand-file-name "recentf" bozhidar-savefile-dir)
        recentf-max-saved-items 500
        recentf-max-menu-items 15
        ;; disable recentf-cleanup on Emacs start, because it can cause
        ;; problems with remote files
        recentf-auto-cleanup 'never)
  (recentf-mode +1))

(use-package windmove
  :config
  ;; use shift + arrow keys to switch between visible buffers
  (windmove-default-keybindings))

(use-package dired
  :ensure nil
  :config
  ;; dired - reuse current buffer by pressing 'a'
  (put 'dired-find-alternate-file 'disabled nil)

  ;; always delete and copy recursively
  (setq dired-recursive-deletes 'always)
  (setq dired-recursive-copies 'always)

  ;; if there is a dired buffer displayed in the next window, use its
  ;; current subdir, instead of the current subdir of this dired buffer
  (setq dired-dwim-target t)

  ;; enable some really cool extensions like C-x C-j(dired-jump)
  (require 'dired-x))

(use-package ranger)

(use-package whitespace
  :init
  ; (dolist (hook '(prog-mode-hook text-mode-hook)) (add-hook hook #'whitespace-mode))
  (add-hook 'before-save-hook #'whitespace-cleanup)
  :config
  (setq whitespace-line-column 80) ;; limit line length
  (setq whitespace-style '(face tabs empty trailing lines-tail)))

(use-package lisp-mode
  :ensure nil
  :config
  (defun bozhidar-visit-ielm ()
    "Switch to default `ielm' buffer.
Start `ielm' if it's not already running."
    (interactive)
    (crux-start-or-switch-to 'ielm "*ielm*"))

  (add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)
  (define-key emacs-lisp-mode-map (kbd "C-c C-z") #'bozhidar-visit-ielm)
  (define-key emacs-lisp-mode-map (kbd "C-c C-c") #'eval-defun)
  (define-key emacs-lisp-mode-map (kbd "C-c C-b") #'eval-buffer))

(use-package ielm
  :config
  (add-hook 'ielm-mode-hook #'rainbow-delimiters-mode))

;;; third-party packages
(use-package zenburn-theme)
(use-package afternoon-theme)
(use-package leuven-theme)
(use-package moe-theme)

(load-theme 'wheatgrass)

(use-package jq-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.jq$" . jq-mode)))

(use-package diminish
  :config
  (diminish 'abbrev-mode)
  (diminish 'flyspell-mode)
  (diminish 'flyspell-prog-mode)
  (diminish 'eldoc-mode))

(use-package avy
  :bind (("s-." . avy-goto-word-or-subword-1)
         ("s-," . avy-goto-char)
         ("C-c ." . avy-goto-word-or-subword-1)
         ("C-c ," . avy-goto-char)
         ("M-g f" . avy-goto-line)
         ("M-g w" . avy-goto-word-or-subword-1))
  :config
  (setq avy-background t))

(use-package magit
  :bind (("C-x g" . magit-status)))

(use-package git-timemachine
  :bind (("s-g" . git-timemachine)))

(use-package ag)

(use-package projectile
  :init
  (setq projectile-project-search-path (seq-filter #'file-exists-p
                                                   '("~/workspace/" "~/spt/" "~/.emacs.d/")))
  :config
  ;; I typically use this keymap prefix on macOS
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  ;; On Linux, however, I usually go with another one
  (define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map)
  (global-set-key (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package elisp-slime-nav
  :config
  (dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
    (add-hook hook #'elisp-slime-nav-mode))
  (diminish 'elisp-slime-nav-mode))

(use-package paredit
  :config
  (add-hook 'emacs-lisp-mode-hook #'paredit-mode)
  ;; enable in the *scratch* buffer
  (add-hook 'lisp-interaction-mode-hook #'paredit-mode)
  (add-hook 'ielm-mode-hook #'paredit-mode)
  (add-hook 'lisp-mode-hook #'paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'paredit-mode)
  (diminish 'paredit-mode "()"))

(use-package anzu
  :diminish t
  :bind (("M-%" . anzu-query-replace)
         ("C-M-%" . anzu-query-replace-regexp))
  :config
  (global-anzu-mode +1))

(use-package easy-kill
  :config
  (global-set-key [remap kill-ring-save] 'easy-kill))

(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

(use-package move-text
  :bind
  (([(meta shift up)] . move-text-up)
   ([(meta shift down)] . move-text-down)))

(use-package rainbow-delimiters)

(use-package rainbow-mode
  :config
  (add-hook 'prog-mode-hook (lambda ()
                              (rainbow-mode)))
  (diminish 'rainbow-mode))

(setq evil-want-keybinding nil)

(use-package hideshow
  :hook (prog-mode . hs-minor-mode)
  :after evil
  :config
  (diminish 'hs-minor-mode))

(use-package evil
  :bind (("C-z" . evil-local-mode))
  :config
  (add-hook 'text-mode-hook (lambda ()
                              (evil-local-mode)
                              (setq truncate-lines t)
                              (setq display-line-numbers 'visual)
                              (setq evil-symbol-word-search t)))
  (add-hook 'prog-mode-hook (lambda ()
                              (evil-local-mode)
                              (setq truncate-lines t)
                              (setq display-line-numbers 'visual)
                              (setq evil-symbol-word-search t))))

(use-package evil-surround
  :after evil
  :config
  (add-hook 'evil-mode-hook #'turn-on-evil-surround-mode))

(use-package evil-collection
  :custom (evil-collection-setup-minibuffer t)
  :init (evil-collection-init))

(use-package clojure-mode
  :config
  ;; teach clojure-mode about some macros that I use on projects like
  ;; nREPL and Orchard
  (define-clojure-indent
    (returning 1)
    (testing-dynamic 1)
    (testing-print 1))

  (add-hook 'clojure-mode-hook #'paredit-mode)
  (add-hook 'clojure-mode-hook #'subword-mode)
  (add-hook 'clojure-mode-hook #'rainbow-delimiters-mode))

(use-package inf-clojure
  :config
  (add-hook 'inf-clojure-mode-hook #'paredit-mode)
  (add-hook 'inf-clojure-mode-hook #'rainbow-delimiters-mode))

(use-package cider
  :config
  (setq nrepl-log-messages t)
  (add-hook 'cider-repl-mode-hook #'paredit-mode)
  (add-hook 'cider-repl-mode-hook #'company-mode)
  (add-hook 'cider-mode-hook #'company-mode)
  (add-hook 'cider-repl-mode-hook #'cider-company-enable-fuzzy-completion)
  (add-hook 'cider-mode-hook #'cider-company-enable-fuzzy-completion)
  (add-hook 'cider-repl-mode-hook #'rainbow-delimiters-mode))

(use-package restclient)
(use-package ob-restclient)
(use-package typescript-mode) ;; For javascript and typescript
(use-package ob-deno)         ;; For javascript and typescript
(use-package ob-graphql)
(use-package ob-elixir)
(use-package ob-go)
(use-package ob-prolog)
(use-package ob-rust)

(use-package counsel-jq)

(use-package org-superstar
  :config
  (setq org-startup-indented t)
  (add-hook 'org-mode-hook (lambda () (org-superstar-mode t))))

(use-package org-super-agenda)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((deno       . t)
   (clojure    . t)
   (elixir     . t)
   (gnuplot    . t)
   (go         . t)
   (java       . t)
   (plantuml   . t)
   (prolog     . t)
   (python     . t)
   (restclient . t)
   (rust       . t)
   (shell      . t)))

(add-to-list 'org-src-lang-modes '("deno" . typescript))

(setq org-confirm-babel-evaluate nil)
(setq org-babel-clojure-backend 'cider)

; (use-package color
;   :config
;   (set-face-attribute 'org-block nil
;                       :background (color-darken-name
;                                    (face-attribute 'default :background) 2)))
;
(use-package flycheck-joker)

(use-package elixir-mode
  :config
  (add-hook 'elixir-mode #'subword-mode))

(use-package eglot)

;; utop configuration
(use-package utop
  :config
  (add-hook 'tuareg-mode-hook #'utop-minor-mode))

;;;; Markup languages support

(use-package web-mode
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.hbs\\'" . web-mode)))

(use-package markdown-mode
  :mode (("\\.md\\'" . gfm-mode)
         ("\\.markdown\\'" . gfm-mode))
  :config
  (setq markdown-fontify-code-blocks-natively t)
  :preface
  (defun jekyll-insert-image-url ()
    (interactive)
    (let* ((files (directory-files "../assets/images"))
           (selected-file (completing-read "Select image: " files nil t)))
      (insert (format "![%s](/assets/images/%s)" selected-file selected-file))))

  (defun jekyll-insert-post-url ()
    (interactive)
    (let* ((project-root (projectile-project-root))
           (posts-dir (expand-file-name "_posts" project-root))
           (default-directory posts-dir))
      (let* ((files (remove "." (mapcar #'file-name-sans-extension (directory-files "."))))
             (selected-file (completing-read "Select article: " files nil t)))
        (insert (format "{%% post_url %s %%}" selected-file))))))

(use-package adoc-mode
  :mode "\\.adoc\\'")

(use-package yaml-mode)

(use-package cask-mode)

(use-package selectrum
  :config
  (selectrum-mode +1))

(use-package selectrum-prescient
  :config
  (selectrum-prescient-mode +1)
  (prescient-persist-mode +1))

(use-package consult
  :bind (
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ("<help> a" . consult-apropos)            ;; orig. apropos-command
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flycheck)
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings (search-map)
         ("M-s f" . consult-find)
         ("M-s F" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)))

(use-package company
  :config
  (setq company-idle-delay 0.5)
  (setq company-show-numbers t)
  (setq company-tooltip-limit 10)
  (setq company-minimum-prefix-length 2)
  (setq company-tooltip-align-annotations t)
  ;; invert the navigation direction if the the completion popup-isearch-match
  ;; is displayed on top (happens near the bottom of windows)
  (setq company-tooltip-flip-when-above t)
  (global-company-mode)
  (diminish 'company-mode))

(use-package hl-todo
  :config
  (setq hl-todo-highlight-punctuation ":")
  (global-hl-todo-mode))

(use-package zop-to-char
  :bind (("M-z" . zop-up-to-char)
         ("M-Z" . zop-to-char)))

;; TODO: can be removed in favor of consult
(use-package imenu-anywhere
  :bind (("C-c i" . imenu-anywhere)
         ("s-i" . imenu-anywhere)))

;; (use-package flyspell
;;   :config
;;   (when (eq system-type 'windows-nt)
;;     (add-to-list 'exec-path "C:/Program Files (x86)/Aspell/bin/"))
;;   (setq ispell-program-name "aspell"    ; use aspell instead of ispell
;;         ispell-extra-args '("--sug-mode=ultra"))
;;   (add-hook 'text-mode-hook #'flyspell-mode)
;;   (add-hook 'prog-mode-hook #'flyspell-prog-mode))
(use-package gnuplot)
(use-package gnuplot-mode)
(use-package plantuml-mode
  :config
  (setq plantuml-jar-path     (expand-file-name "~/.m2/jars/plantuml-1.2022.6.jar"))
  (setq org-plantuml-jar-path (expand-file-name "~/.m2/jars/plantuml-1.2022.6.jar"))
  )

(use-package flycheck
  :diminish t
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package flycheck-eldev
  :diminish t)

(use-package super-save
  :config
  ;; add integration with ace-window
  (add-to-list 'super-save-triggers 'ace-window)
  (super-save-mode +1)
  (diminish 'super-save-mode))

(use-package crux
  :bind (("C-c o" . crux-open-with)
         ("M-o" . crux-smart-open-line)
         ("C-c n" . crux-cleanup-buffer-or-region)
         ("C-c f" . crux-recentf-find-file)
         ("C-M-z" . crux-indent-defun)
         ("C-c u" . crux-view-url)
         ("C-c e" . crux-eval-and-replace)
         ("C-c w" . crux-swap-windows)
         ("C-c D" . crux-delete-file-and-buffer)
         ("C-c r" . crux-rename-buffer-and-file)
         ("C-c t" . crux-visit-term-buffer)
         ("C-c k" . crux-kill-other-buffers)
         ("C-c TAB" . crux-indent-rigidly-and-copy-to-clipboard)
         ("C-c I" . crux-find-user-init-file)
         ("C-c S" . crux-find-shell-init-file)
         ("s-r" . crux-recentf-find-file)
         ("s-j" . crux-top-join-line)
         ("C-^" . crux-top-join-line)
         ("s-k" . crux-kill-whole-line)
         ("C-<backspace>" . crux-kill-line-backwards)
         ("s-o" . crux-smart-open-line-above)
         ([remap move-beginning-of-line] . crux-move-beginning-of-line)
         ([(shift return)] . crux-smart-open-line)
         ([(control shift return)] . crux-smart-open-line-above)
         ([remap kill-whole-line] . crux-kill-whole-line)
         ("C-c s" . crux-ispell-word-then-abbrev)))

(use-package diff-hl
  :config
  (global-diff-hl-mode +1)
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

(use-package which-key
  :config
  (which-key-mode +1)
  (diminish 'which-key-mode))

(use-package undo-tree
  :config
  ;; autosave the undo-tree history
  (setq undo-tree-history-directory-alist
        `((".*" . ,temporary-file-directory)))
  (setq undo-tree-auto-save-history t)
  (global-undo-tree-mode +1)
  (diminish 'undo-tree-mode))

(use-package ace-window
  :config
  (global-set-key (kbd "s-w") 'ace-window)
  (global-set-key [remap other-window] 'ace-window))

;; FIXME: Figure out why the vterm module stopped compiling properly
;; (use-package vterm
;;   :config
;;   (setq vterm-shell "/bin/bash")
;;   ;; macOS
;;   (global-set-key (kbd "s-v") 'vterm)
;;   ;; Linux
;;   (global-set-key (kbd "C-c v") 'vterm))

;; super useful for demos
(use-package keycast)

(use-package gif-screencast
  :config
  ;; To shut up the shutter sound of `screencapture' (see `gif-screencast-command').
  (setq gif-screencast-args '("-x"))
  ;; Optional: Used to crop the capture to the Emacs frame.
  (setq gif-screencast-cropping-program "mogrify")
  ;; Optional: Required to crop captured images.
  (setq gif-screencast-capture-format "ppm"))

;; temporarily highlight changes from yanking, etc
(use-package volatile-highlights
  :config
  (volatile-highlights-mode +1)
  (diminish 'volatile-highlights-mode))

;; term
(use-package vterm)
(use-package multi-vterm)

;; Java
(use-package yasnippet :config (yas-global-mode))
; (use-package lsp-mode :hook ((lsp-mode . lsp-enable-which-key-integration))
;   :config (setq lsp-completion-enable-additional-text-edit nil))
; (use-package hydra)
; (use-package lsp-ui)
; (use-package lsp-java :config (add-hook 'java-mode-hook 'lsp))
; (use-package dap-mode :after lsp-mode :config (dap-auto-configure-mode))
; (use-package dap-java :ensure nil)
; (use-package helm-lsp)
; (use-package helm :config (helm-mode))
; (use-package lsp-treemacs)

;;; init.el ends here
