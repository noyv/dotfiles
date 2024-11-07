;;; package --- Summary
;;; Commentary:
;;; Code:

;; -*- lexical-binding: t -*-

(setopt read-process-output-max (* 4096 4096))

(setopt custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t)

(setopt package-archives '(("gnu" . "http://mirrors.ustc.edu.cn/elpa/gnu/")
                           ("melpa" . "http://mirrors.ustc.edu.cn/elpa/melpa/")
                           ("nongnu" . "http://mirrors.ustc.edu.cn/elpa/nongnu/")))

(setopt use-package-always-ensure t)

(use-package benchmark-init
  :demand t
  :hook
  (after-init . benchmark-init/deactivate))

(use-package emacs
  :config
  (defvar treesit-language-source-alist nil)
  (setopt inhibit-startup-screen t)
  (setopt initial-scratch-message nil)
  (setopt initial-major-mode 'fundamental-mode)
  (setopt indent-tabs-mode nil)
  (setopt split-height-threshold nil)
  (setopt split-width-threshold 0)
  (fset 'yes-or-no-p'y-or-n-p)
  (setopt exec-path (append exec-path '("/usr/local/go/bin/" "~/go/bin/")))
  (setenv "PATH" (concat "/usr/local/go/bin/" ":" "~/go/bin/" ":" (getenv "PATH")))
  (prefer-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (add-to-list 'default-frame-alist '(fullscreen . maximized))
  (add-to-list 'default-frame-alist '(font . "FiraCode-12"))
  ;; (add-to-list 'default-frame-alist '(menu-bar-lines . 0))
  (add-to-list 'default-frame-alist '(tool-bar-lines . 0))
  (load-theme 'modus-operandi-tinted)
  (column-number-mode t)
  (global-hl-line-mode))

(use-package isearch
  :ensure nil
  :init
  (setopt isearch-lazy-count t)
  (setopt lazy-count-prefix-format nil)
  (setopt lazy-count-suffix-format " [%s/%s]"))

(use-package files
  :ensure nil
  :init
  (setopt make-backup-files t)
  (setopt backup-by-copying t)
  (setopt backup-directory-alist '(("." . "~/.config/emacs/backups")))
  (setopt delete-old-versions t)
  (setopt version-control t)
  (setopt create-lockfiles nil)
  (setopt delete-by-moving-to-trash t))

(use-package dired
  :ensure nil
  :init
  (setopt dired-recursive-deletes 'always))

(use-package saveplace
  :init
  (save-place-mode t))

(use-package savehist
  :init
  (savehist-mode t))

(use-package recentf
  :init
  (setopt recentf-exclude '("\\elpa"))
  (setopt recentf-max-menu-items 128)
  (setopt recentf-max-saved-items 128)
  (recentf-mode t))

(use-package buffer-name-relative
  :config
  (buffer-name-relative-mode))

(use-package elec-pair
  :hook (prog-mode . electric-pair-mode)
  :init
  (setopt electric-pair-inhibit-predicate 'electric-pair-conservative-inhibit))

(use-package popper
  :bind (("C-`"   . popper-toggle)
         ("M-`"   . popper-cycle)
         ("C-M-`" . popper-toggle-type))
  :init
  (setopt popper-reference-buffers
          '("\\*Messages\\*"
            "Output\\*$"
            "\\*Async Shell Command\\*"
            help-mode
            compilation-mode))
  (popper-mode +1)
  (popper-echo-mode +1))

(use-package avy)

(use-package general
  :config
  (general-create-definer general!
    :states 'normal
    :keymaps 'override
    :prefix "SPC"
    :non-normal-prefix "M-SPC"
    :prefix-command 'leader-prefix-command
    :prefix-map 'leader-prefix-map))

(use-package evil
  :init
  (setopt evil-symbol-word-search t)
  (setopt evil-undo-system 'undo-redo)
  (setopt evil-disable-insert-state-bindings t)
  (setopt evil-want-C-u-scroll t)
  (setopt evil-want-keybinding nil)
  (defalias #'forward-evil-word #'forward-evil-symbol)
  (evil-mode 1)
  :config
  (evil-set-initial-state 'package-menu-mode 'normal)
  (evil-define-key 'normal package-menu-mode-map (kbd "RET") 'package-menu-describe-package)
  (evil-define-key 'normal package-menu-mode-map "i" 'package-menu-mark-install)
  (evil-define-key 'normal package-menu-mode-map "U" 'package-menu-mark-upgrades)
  (evil-define-key 'normal package-menu-mode-map "d" 'package-menu-mark-delete)
  (evil-define-key 'normal package-menu-mode-map "u" 'package-menu-mark-unmark)
  (evil-define-key 'normal package-menu-mode-map "x" 'package-menu-execute)
  (evil-define-key '(normal motion) global-map "s" 'avy-goto-char-timer)
  )

(use-package vertico
  :init
  (vertico-mode)
  (keymap-set minibuffer-local-map "C-w" #'backward-kill-word))

(use-package orderless
  :init
  (setopt completion-styles '(basic partial-completion orderless))
  (setopt completion-category-overrides '((file (styles basic partial-completion)))))

(use-package consult
  :init
  (setopt xref-show-xrefs-function #'consult-xref)
  (setopt xref-show-definitions-function #'consult-xref)
  :config
  (consult-customize consult-ripgrep
                     :initial (consult--async-split-initial (thing-at-point 'symbol)))
  :general
  (general! "<SPC>" 'execute-extended-command)
  (general! "=" '(:keymap vc-prefix-map :which-key "vc"))
  (general! "p" '(:keymap project-prefix-map :which-key "project"))
  (general! "fo" 'find-file-other-window)
  (general! "fd" 'dired-jump)
  (general! "ff" 'find-file)
  (general! "fr" 'consult-buffer)
  (general! "fe" 'consult-flycheck)
  (general! "fl" 'consult-line)
  )

(use-package consult-flycheck)

(use-package company
  :hook (prog-mode . company-mode)
  :init
  (setopt company-minimum-prefix-length 2))

(use-package yasnippet
  :hook (prog-mode . yas-minor-mode))

(use-package flycheck
  :hook (prog-mode . flycheck-mode)
  :init
  (setopt flycheck-emacs-lisp-load-path 'inherit))

(use-package lsp-mode
  :commands lsp lsp-deferred
  :init
  (setopt lsp-enable-indentation nil)
  (setopt lsp-enable-symbol-highlighting nil)
  (setopt lsp-headerline-breadcrumb-enable nil)
  (setopt lsp-lens-enable nil)
  (setopt lsp-diagnostic-package :none)
  (setopt lsp-log-io nil))

(use-package go-mode
  :hook (go-mode . lsp-deferred)
  ;; :mode ("\\.go\\'" . go-ts-mode)
  :init
  (add-to-list 'treesit-language-source-alist '(gomod "https://github.com/camdencheek/tree-sitter-go-mod"))
  (add-to-list 'treesit-language-source-alist '(go "https://github.com/tree-sitter/tree-sitter-go")))

(use-package flycheck-golangci-lint
  :hook (go-mode . flycheck-golangci-lint-setup))

(use-package go-impl)

(use-package go-tag)

(use-package gotest
  :init
  (setopt go-test-args "-v -count=1"))

(use-package js
  :init
  (setopt js-indent-level 2))

(use-package typescript-ts-mode
  :hook (typescript-ts-base-mode . lsp-deferred)
  :mode (("\\.ts\\'" . typescript-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode))
  :init
  (add-to-list 'treesit-language-source-alist '(typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src"))
  (add-to-list 'treesit-language-source-alist '(tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src"))
  (setopt typescript-ts-mode-indent-offset 2))

(use-package sudo-edit
  :defer t)

(use-package blamer
  :defer t)

(use-package org
  :bind (:map org-mode-map
              ("TAB" . org-cycle))
  :init
  (setopt org-startup-folded 'showeverything)
  (setopt org-use-sub-superscripts nil)
  (setopt org-export-with-toc nil)
  (setopt org-html-head-include-default-style nil))

(provide 'init)
;;; init.el ends here
