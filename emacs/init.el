;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(defvar my-favorite-package-list
  '(undo-tree
    helm
    mozc
    molokai-theme
    flycheck
    vimrc-mode
    auto-complete)
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

(require 'vimrc-mode)
;;
;; whitespace
;;

;; (require 'whitespace)
;; (setq whitespace-style '(face           ; faceで可視化
;;                          trailing       ; 行末
;;                          tabs           ;
;; 			 ;; empty       ; 先頭/末尾の空行
;;                          space-mark     ; 表示のマッピング
;;                          tab-mark
;;                          ))
;; 
;; (setq whitespace-display-mappings
;;       '((tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))

;; (global-whitespace-mode 1)
(global-set-key "\C-h" 'delete-backward-char)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("b571f92c9bfaf4a28cb64ae4b4cdbda95241cd62cf07d942be44dc8f46c491f4" default)))
 '(package-selected-packages (quote (auto-complete))))

;;(custom-set-faces
;; custom-set-faces was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
;; '(default ((t (:family "Ricty Diminished for Powerline" :foundry "PfEd" :slant normal :weight normal :height 128 :width normal)))))

(setq scroll-conservatively 1)
(setq scroll-margin 5)
;;
;; Auto Complete
;;
;; auto-complete-config の設定ファイルを読み込む。
(require 'auto-complete-config)
;; よくわからない
(ac-config-default)
;; TABキーで自動補完を有効にする
(ac-set-trigger-key "TAB")
;; auto-complete-mode を起動時に有効にする
(global-auto-complete-mode t)

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
 )
