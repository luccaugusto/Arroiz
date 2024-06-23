(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)
(visual-line-mode)
(adaptive-wrap-prefix-mode)

(ac-config-default)

(setq
   backup-by-copying t      ; don't clobber symlinks
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

(setq backup-directory-alist
          `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
          `((".*" ,temporary-file-directory t)))

;;; c-mode
(setq-default c-basic-offset 4
	      c-default-style '((java-mode . "java")
                                (awk-mode . "awk")
                                (other . "bsd")))

(add-hook 'c-mode-hook (lambda ()
                         (interactive)
			 (c-toggle-comment-style -1)))

(global-unset-key "\C-o")
(global-unset-key "\M-o")
(defun insert-line-below ()
  "Insert an empty line below the current line."
  (interactive)
  (save-excursion
    (end-of-line)
    (open-line 1)
    (next-line)
    (indent-according-to-mode)))

(defun insert-line-above ()
  "Insert an empty line above the current line."
  (interactive)
  (save-excursion
    (end-of-line 0)
    (open-line 1)
    (indent-according-to-mode)))


(define-key global-map "\C-o" 'insert-line-below)
(define-key global-map "\M-o" 'insert-line-above)

;;; Font size
(set-face-attribute 'default nil :height 170)

;;(set-frame-parameter (selected-frame) 'alpha '(<active> . <inactive>))
;;(set-frame-parameter (selected-frame) 'alpha <both>)
(set-frame-parameter (selected-frame) 'alpha '(95 . 80))

;;; Whitespace mode
(setq custom-tab-width 4)

(setq-default python-indent-offset custom-tab-width)
(setq-default evil-shift-width custom-tab-width)
(defun rc/set-up-whitespace-handling ()
  (interactive)
  (whitespace-mode 0)
  (add-to-list 'write-file-functions 'delete-trailing-whitespace))

(setq whitespace-style '(face tabs tab-mark trailing))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(whitespace-tab ((t (:foreground "#636363")))))
(setq whitespace-display-mappings
  '((tab-mark 9 [124 9] [92 9]))) ; 124 is the ascii ID for '\|'
(global-whitespace-mode) ; Enable whitespace mode everywhere
; END TABS CONFIG

(add-hook 'tuareg-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'c++-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'c-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'emacs-lisp-mode 'rc/set-up-whitespace-handling)
(add-hook 'java-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'lua-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'rust-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'scala-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'markdown-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'haskell-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'python-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'erlang-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'asm-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'nasm-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'go-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'nim-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'yaml-mode-hook 'rc/set-up-whitespace-handling)

;;; display-line-numbers-mode
(when (version<= "26.0.50" emacs-version)
  (global-display-line-numbers-mode))

;;; multiple cursors
;;(rc/require 'multiple-cursors)

;;(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
;;(global-set-key (kbd "C->")         'mc/mark-next-like-this)
;;(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
;;(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
;;(global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
;;(global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)o

;;; Packages that don't require configuration
;;(rc/require
;; 'scala-mode
;; 'd-mode
;; 'yaml-mode
;; 'glsl-mode
;; 'tuareg
;; 'lua-mode
;; 'less-css-mode
;; 'graphviz-dot-mode
;; 'clojure-mode
;; 'cmake-mode
;; 'rust-mode
;; 'csharp-mode
;; 'nim-mode
;; 'jinja2-mode
;; 'markdown-mode
;; 'purescript-mode
;; 'nix-mode
;; 'dockerfile-mode
;; 'love-minor-mode
;; 'toml-mode
;; 'nginx-mode
;; 'kotlin-mode
;; 'go-mode
;; 'php-mode
;; 'racket-mode
;; 'qml-mode
;; 'ag
;; 'hindent
;; 'elpy
;; 'typescript-mode
;; 'rfc-mode
;; 'sml-mode
;; )


(add-to-list 'exec-path "/usr/local/bin")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(custom-enabled-themes '(misterioso))
 '(display-line-numbers-type 'relative)
 '(package-selected-packages '(adaptive-wrap magit auto-complete php-mode evil)))
