;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(setq package-list
      '(undo-tree
        mozc
        molokai-theme
        atom-dark-theme
        flycheck
        flycheck-irony
        vimrc-mode
        company
        company-jedi
        company-irony
        helm
        restart-emacs
        magit
        mew
        yasnippet
        yasnippet-snippets
        omnisharp
        ))

(require 'package)
;; list the repositories containing them
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
;; activate all the packages (in particular autoloads)
(package-initialize)
;; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))
;; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))
(setq inhibit-startup-message t)

(setq-default indent-tabs-mode nil)

(require 'undo-tree)
(global-undo-tree-mode)

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

(require 'helm-config)
(helm-mode 1)
(define-key global-map (kbd "M-x")     'helm-M-x)
(define-key global-map (kbd "C-x C-f") 'helm-find-files)
(define-key global-map (kbd "C-x C-r") 'helm-recentf)
(define-key global-map (kbd "M-y")     'helm-show-kill-ring)
(define-key global-map (kbd "C-c i")   'helm-imenu)
(define-key global-map (kbd "C-x b")   'helm-buffers-list)
(define-key helm-map (kbd "C-h") 'delete-backward-char)
(define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)
(define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
(define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)

;; Disable helm in some functions
(add-to-list 'helm-completing-read-handlers-alist '(find-alternate-file . nil))

;; (1) helm-buffers-list のバッファ名の領域を広くとる
(setq helm-buffer-details-flag nil)

;; Emulate `kill-line' in helm minibuffer
(setq helm-delete-minibuffer-contents-from-point t)
(defadvice helm-delete-minibuffer-contents (before emulate-kill-line activate)
  "Emulate `kill-line' in helm minibuffer"
  (kill-new (buffer-substring (point) (field-end))))

(defadvice helm-ff-kill-or-find-buffer-fname (around execute-only-if-file-exist activate)
  "Execute command only if CANDIDATE exists"
  (when (file-exists-p candidate)
    ad-do-it))
(setq helm-ff-fuzzy-matching nil)
(defadvice helm-ff--transform-pattern-for-completion (around my-transform activate)
  "Transform the pattern to reflect my intention"
  (let* ((pattern (ad-get-arg 0))
	 (input-pattern (file-name-nondirectory pattern))
	 (dirname (file-name-directory pattern)))
    (setq input-pattern (replace-regexp-in-string "\\." "\\\\." input-pattern))
    (setq ad-return-value
	  (concat dirname
		  (if (string-match "^\\^" input-pattern)
		      ;; '^' is a pattern for basename
		      ;; and not required because the directory name is prepended
		      (substring input-pattern 1)
		    (concat ".*" input-pattern))))))

(defun helm-buffers-list-pattern-transformer (pattern)
  (if (equal pattern "")
      pattern
    (let* ((first-char (substring pattern 0 1))
	   (pattern (cond ((equal first-char "*")
			   (concat " " pattern))
			  ((equal first-char "=")
			   (concat "*" (substring pattern 1)))
			  (t
			   pattern))))
      ;; Escape some characters
      (setq pattern (replace-regexp-in-string "\\." "\\\\." pattern))
      (setq pattern (replace-regexp-in-string "\\*" "\\\\*" pattern))
      pattern)))


(unless helm-source-buffers-list
  (setq helm-source-buffers-list
	(helm-make-source "Buffers" 'helm-source-buffers)))
(add-to-list 'helm-source-buffers-list
	     '(pattern-transformer helm-buffers-list-pattern-transformer))

(require 'vimrc-mode)

(require 'company)
;; 常にcompanyを有効化
(global-company-mode +1)
;; ctrl+alt+iで強制補完
(global-set-key (kbd "C-M-i") 'company-complete)
;; 待たずに補完開始
(setq company-idle-delay 0)
;; 1文字打ったら補完開始
(setq company-minimum-prefix-length 1)
;; バックエンドのサーバーに補完候補を問い合わせるタイムアウト時間(sec)
(setq company-async-timeout 10)
;; ctrl+n/pで補完候補を次/前の候補を選択
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-search-map (kbd "C-n") 'company-select-next)
(define-key company-search-map (kbd "C-p") 'company-select-previous)
;; TABで候補を決定
(define-key company-active-map (kbd "C-i") 'company-complete-selection)

(set-face-attribute 'company-tooltip nil
                    :foreground "black" :background "lightgrey")
(set-face-attribute 'company-tooltip-common nil
                    :foreground "black" :background "lightgrey")
(set-face-attribute 'company-tooltip-common-selection nil
                    :foreground "white" :background "steelblue")
(set-face-attribute 'company-tooltip-selection nil
                    :foreground "black" :background "steelblue")
(set-face-attribute 'company-preview-common nil
                    :background nil :foreground "lightgrey" :underline t)
(set-face-attribute 'company-scrollbar-fg nil
                    :background "lightgrey")
(set-face-attribute 'company-scrollbar-bg nil
                    :background "gray40")

(eval-after-load
    'company
  '(add-to-list 'company-backends 'company-omnisharp))

(add-hook 'csharp-mode-hook #'company-mode)

(require 'jedi-core)
(setq jedi:complete-on-dot t)
(setq jedi:use-shortcuts t)
(add-hook 'python-mode-hook 'jedi:setup)
(add-to-list 'company-backends 'company-jedi)

(require 'irony)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
(add-to-list 'company-backends 'company-irony) ; backend追加

(require 'omnisharp)
(add-hook 'csharp-mode-hook 'omnisharp-mode)

(eval-after-load "yasnippet"
  '(progn
     ;; companyと競合するのでyasnippetのフィールド移動は "C-i" のみにする
     (define-key yas-keymap (kbd "<tab>") nil)
     (yas-global-mode 1)))

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
 '(default ((t (:family "Cica" :foundry "TMNM" :slant normal :weight normal :height 120 :width normal)))))
 
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))
