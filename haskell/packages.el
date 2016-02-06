;;; packages.el --- haskell layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author:  <Scarlet@DESKTOP-VA2JGB1>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `haskell-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `haskell/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `haskell/pre-init-PACKAGE' and/or
;;   `haskell/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst haskell-packages
  '(haskell-mode
    ghc
    shm
    company-ghc
    hasktags
    hindent)
  "The list of Lisp packages required by the haskell layer.
Each entry is either:
1. A symbol, which is interpreted as a package to be installed, or
2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.
    The following keys are accepted:
    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil
    - :location: Specify a custom installation location.
      The following values are legal:
      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.
      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'
      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format"
)

(defun haskell/init-haskell-mode ()
  (use-package haskell-mode)
  :init
  (require 'haskell-interactive-mode)
  (require 'haskell-process)
  :config
  (turn-on-haskell-indent)
  ;; enable module templates
  (add-hook 'haskell-mode-hook 'haskell-auto-insert-module-template)

  (custom-set-variables
    '(haskell-process-suggest-remove-import-lines t)
    '(haskell-process-auto-import-loaded-modules t)
    '(haskell-process-log t)
    ;; company ghc
    '(company-ghc-show-info t)
    ;; cabal repl
    '(haskell-process-type 'cabal-repl)
    ;; autoformatting on save
    '(haskell-stylish-on-save t)
    ;; import settings
    '(haskell-process-suggest-remove-import t)
    '(haskell-process-add-cabal-autogen t))
    ;; key bindings
  (define-key haskell-mode-map [f8] 'haskell-navigate-imports)
  (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
  (define-key haskell-mode-map (kbd "C-`") 'haskell-interactive-bring)
  (define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-type)
  (define-key haskell-mode-map (kbd "C-c C-i") 'haskell-process-do-info)
  (define-key haskell-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
  (define-key haskell-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
  (define-key haskell-mode-map (kbd "C-c c") 'haskell-process-cabal)
  (define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)
  (define-key haskell-cabal-mode-map (kbd "C-`") 'haskell-interactive-bring)
  (define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
  (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
  (define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)
  ;; jump to defination using hybrid approch
  (define-key haskell-mode-map (kbd "M-.") 'haskell-mode-jump-to-def-or-tag)
  
  )

(defun haskell/init-ghc ()
  (use-package ghc)
  :config
  (autoload 'ghc-init  "ghc" nil t)
  (autoload 'ghc-debug "ghc" nil t)
  (add-hook 'haskell-mode-hook (lambda () (ghc-init)) )
  )

(defun haskell/init-shm ()
  (use-package shm))

(defun haskell/init-company-ghc ()
  (use-package company-ghc)
  :init
  (require 'company)
  (add-hook 'after-init-hook 'global-company-mode)
  (add-to-list 'company-backends 'company-ghc))

(defun haskell/init-hindent ()
  (use-package hindent))
