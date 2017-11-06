;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(defvar my-favorite-package-list
  '(undo-tree
    fiplr
    mozc
    molokai-theme
    flycheck
    vimrc-mode
    company
    ycmd
    company-ycmd
    )
  "packages to be installed")

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents (package-refresh-contents))
(dolist (pkg my-favorite-package-list)
  (unless (package-installed-p pkg)
    (package-install pkg)))

(setq inhibit-startup-message t)

(require 'linum)
(global-linum-mode)
(setq line-number-display-limit-width 10000)

(when (eq system-type 'gnu/linux)
  (require 'mozc)
  (setq default-input-method "japanese-mozc"))

(setq desktop-globals-to-save '(extended-command-history))
(desktop-save-mode 1)

(require 'molokai-theme)
(load-theme 'molokai t)

(global-set-key "\C-h" 'delete-backward-char)
(setq scroll-conservatively 1)
(setq scroll-margin 5)
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

(require 'vimrc-mode)

(require 'company)
(global-company-mode +1)
(global-set-key (kbd "C-M-i") 'company-complete)
;; C-n, C-pで補完候補を次/前の候補を選択
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-search-map (kbd "C-n") 'company-select-next)
(define-key company-search-map (kbd "C-p") 'company-select-previous)
;; C-sで絞り込む
(define-key company-active-map (kbd "C-s") 'company-filter-candidates)
;; TABで候補を設定
(define-key company-active-map (kbd "C-i") 'company-complete-selection)
;; 各種メジャーモードでも C-M-iで company-modeの補完を使う
(define-key emacs-lisp-mode-map (kbd "C-M-i") 'company-complete)

;; ycmd
(require 'ycmd)
(add-hook 'after-init-hook #'global-ycmd-mode)
(set-variable 'ycmd-server-command `("python" ,(file-truename "~/.ycmd/ycmd")))
(require 'company-ycmd)
(company-ycmd-setup)

;; eww設定
(defvar eww-disable-colorize t)
(defun shr-colorize-region--disable (orig start end fg &optional bg &rest _)
  (unless eww-disable-colorize
    (funcall orig start end fg)))
(advice-add 'shr-colorize-region :around 'shr-colorize-region--disable)
(advice-add 'eww-colorize-region :around 'shr-colorize-region--disable)
(defun eww-disable-color ()
  "eww で文字色を反映させない"
  (interactive)
  (setq-local eww-disable-colorize t)
  (eww-reload))
(defun eww-enable-color ()
  "eww で文字色を反映させる"
  (interactive)
  (setq-local eww-disable-colorize nil)
  (eww-reload))

(setq eww-search-prefix "http://www.google.co.jp/search?q=")

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Ricty Diminished" :foundry "PfEd" :slant normal :weight normal :height 113 :width normal)))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (company-ycmd ycmd company vimrc-mode flycheck molokai-theme mozc fiplr undo-tree))))
