;;; Emacs Config
;;; Packages
(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(package-initialize)

(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

;;; Package Config
;; company
(use-package company)

;; evil
(use-package evil
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode t))

;; evil-collection
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; general (SPACE)
(use-package general
  :config
  (general-define-key
   :states 'normal
   :keymaps 'override
   :prefix "SPC"
   "a" 'org-agenda
   "b" 'helm-buffers-list
   "c" 'org-capture
   "f f" 'helm-find-files
   "f l" 'helm-locate
   "g" 'magit
   "k" 'kill-this-buffer
;   "m" 'emms-smart-browse
   "m" 'mingus-browse
   "r" 'ranger
   "t" 'term
   "<SPC>" 'helm-M-x
   "w w" 'hydra-window/body
   "w h" 'evil-window-left
   "w j" 'evil-window-down
   "w k" 'evil-window-up
   "w l" 'evil-window-right
   "w H" 'evil-window-move-far-left
   "w J" 'evil-window-move-very-bottom
   "w K" 'evil-window-move-very-top
   "w L" 'evil-window-move-far-right
   "w n" 'evil-window-next
   "w s" 'evil-window-split
   "w v" 'evil-window-vsplit
   "w c" 'evil-window-delete
   "w =" 'balance-windows
   "w <" 'evil-window-increase-width
   "w >" 'evil-window-decrease-width
   "w +" 'evil-window-decrease-height
   "w -" 'evil-window-decrease-height
   ))

;; helm
(use-package helm
  :config
  (setq helm-completion-in-region-fuzzy-match t)
  (setq helm-mode-fuzzy-match t)
  (helm-mode t))

;; hideshow
(use-package hideshow
  :config
  (add-hook 'emacs-lisp-mode-hook 'hs-minor-mode))

;; hydra
(use-package hydra
  :config
  (defhydra hydra-window (:color red)
    "
Windows
"
    ("h" evil-window-left "focus left")
    ("j" evil-window-down "focus down")
    ("k" evil-window-up "focus up")
    ("l" evil-window-right "focus right")
    ("H" evil-window-move-far-left "move left")
    ("J" evil-window-move-very-bottom "move down")
    ("K" evil-window-move-very-top "move up")
    ("L" evil-window-move-far-right "move right")
    ("n" evil-window-next "next")
    ("s" evil-window-split "hsplit")
    ("v" evil-window-vsplit "vsplit")
    ("c" evil-window-delete "close")
    ("=" balance-windows "balance")
    ("<" evil-window-increase-width "increase width")
    (">" evil-window-decrease-width "decrease width")
    ("+" evil-window-increase-height "increase height")
    ("-" evil-window-decrease-height "decrease height")))

;; magit
(use-package magit)
(use-package evil-magit
  :after (evil magit))

;; mingus
(require 'mingus-stays-home)
(use-package mingus
  :ensure t
  :config
  (general-define-key
   :states 'normal
   :keymaps 'mingus-browse-map
    "a" 'mingus-insert
    "A" 'mingus-load-all
    "h" 'mingus-open-parent
    "l" 'mingus-down-dir-or-play-song
    "L" 'mingus-load-playlist
    "n" 'mingus-next
    "P" 'mingus-prev
    "p" 'mingus-toggle
    "r" 'mingus-repeat
    "s" 'mingus-stop
    "z" 'mingus-random
    "+" 'mingus-vol-up
    "-" 'mingus-vol-down
    "1" (lambda() (interactive) (mingus))
    "2" (lambda() (interactive) (mingus-browse))
    "3" 'mingus-help
    "4" 'mingus-dired-file
  )
  (general-define-key
   :states 'normal
   :keymaps 'mingus-playlist-map
    "A" 'mingus-load-all
    "d" 'mingus-del
    "D" 'mingus-del-marked
    "l" 'mingus-play
    "L" 'mingus-load-playlist
    "n" 'mingus-next
    "P" 'mingus-prev
    "p" 'mingus-toggle
    "r" 'mingus-repeat
    "s" 'mingus-stop
    "z" 'mingus-random
    "+" 'mingus-vol-up
    "-" 'mingus-vol-down
    "1" (lambda() (interactive) (mingus))
    "2" (lambda() (interactive) (mingus-browse))
    "3" 'mingus-help
    "4" 'mingus-dired-file
  )
  (general-define-key
   :states 'normal
   :keymaps 'mingus-help-map
    "1" (lambda() (interactive) (mingus))
    "2" (lambda() (interactive) (mingus-browse))
    "3" 'mingus-help
    "4" 'mingus-dired-file
  )
)

;; org-mode
(use-package org
  :config
  (setq org-agenda-files '("~/doc/org/gtd.org")))
(use-package evil-org
  :after (evil org))

;; prettier
(use-package prettier-js
  :hook typescript-mode-hook)

;; rainbow-mode
(use-package rainbow-mode
  :config
  (rainbow-mode t))

;;; ranger
;; See [[https://github.com/ralesi/ranger.el#configuration][Github]]
;; Keybindings
;; D         | delete                  
;; dd        | cut                     
;; t         | toggle mark             
;; TAB       | mark, move to next      
;; zh OR C-h | toggle hidden files     
;; zi        | toggle literal preview  
;; zf        | toggle fullscreen image 
;; ;+        | mkdir                   
;; ;=        | diff current file + ask 
;; C-C C-e   | Start WDired Mode       
;; C-c C-c   | finish WDired Mode      
;; C-c C-k   | abort WDired Mode       
(use-package ranger
  :config
  (ranger-override-dired-mode t) ;; use ranger as default browser

  ;;; Kill buffers as soon as you move to another entry. 
  ;; Alternatively use `ranger-cleanup-on-disable t` to kill buffers
  ;; when ranger session is disabled/closed
  (setq ranger-cleanup-eagerly t))

;; telephone-line
(use-package telephone-line
  :config
  (telephone-line-defsegment* tel-date-segment ()
    (format-time-string "%H:%m:%S %Y-%m-%d"))
  (setq telephone-line-lhs
	'((evil   . (telephone-line-evil-tag-segment))
	  (accent . (telephone-line-vc-segment
		     telephone-line-erc-modified-channels-segment
		     telephone-line-process-segment))
	  (nil    . (telephone-line-minor-mode-segment
		     telephone-line-buffer-segment))))
  (setq telephone-line-rhs
	'((nil    . (telephone-line-misc-info-segment))
	  (accent . (telephone-line-major-mode-segment))
	  (evil   . (telephone-line-airline-position-segment
		     tel-date-segment))))
  (telephone-line-mode 1))

;; tide
(use-package tide
  :preface
  (defun setup-tide-mode ()
     (interactive)
     (tide-setup)
     (flycheck-mode +1)
     (setq flycheck-check-syntax-automatically '(save mode-enabled))
     (eldoc-mode +1)
     (tide-hl-identifier-mode +1)
     ;; company is an optional dependency. You have to
     ;; install it separately via package-install
     ;; `M-x package-install [ret] company`
     (company-mode +1))
   :after (typescript-mode company flycheck)
   :hook ((typescript-mode . setup-tide-mode)
	  (before-save . tide-format-before-save))
   :config

   ;; aligns annotation to the right hand side
   (setq company-tooltip-align-annotations t)
   ;; formats the buffer before saving
   ;(add-hook 'before-save-hook 'tide-format-before-save)
   ;(add-hook 'typescript-mode-hook #'setup-tide-mode)

   (general-define-key
    :states 'normal
    :keymaps 'tide-mode-map
    "C-b" 'tide-references
    "C-M-b" 'tide-jump-to-definition
    "C-," 'tide-jump-back
    "M-C-r" 'tide-rename-symbol
    "M-e" 'tide-project-errors)
   (general-define-key
    :states 'insert
    :keymaps 'tide-mode-map
    "C-b" 'tide-references
    "C-M-b" 'tide-jump-to-definition
    "C-," 'tide-jump-back
    "M-C-r" 'tide-rename-symbol
    "M-e" 'tide-project-errors
    "M-<RET>" 'tide-fix)
   (general-define-key
    :states 'normal
    :keymaps 'tide-references-mode-map
    "<RET>" 'tide-goto-reference
    "i" 'tide-goto-reference
    "n" 'tide-find-next-reference
    "C-j" 'tide-find-next-reference
    "p" 'tide-find-previous-reference
    "C-k" 'tide-find-previous-reference
    "q" 'quit-window)
   (general-define-key
    :states 'normal
    :keymaps 'tide-project-errors-mode-map
    "<RET>" 'tide-goto-error
    "i" 'tide-goto-error
    "n" 'tide-find-next-error
    "C-j" 'tide-find-next-error
    "p" 'tide-find-previous-error
    "C-k" 'tide-find-previous-error
    "q" 'quit-window))

(use-package typescript-mode
  :mode "\\.ts\\'")
   
  

;; which-key
(use-package which-key
  :config
  (which-key-mode t))

;;; Emacs Config
(setq inhibit-startup-screen t 	        ; inhibit useless and old-school startup screen
      kept-new-versions 6
      kept-old-versions 2
      version-control t 		; use version control
      delete-old-versions -1 	        ; delete excess backup versions silently
      BACKUP-by-copying-when-linked t
      backup-directory-alist `(("." . "~/.emacs.d/saves"))  ; which directory to put backups file
      vc-follow-symlinks t 		; don't ask for confirmation when opening symlinked file
      ring-bell-function 'ignore 	; silent bell when you make a mistake
      coding-system-for-read 'utf-8 	; use utf-8 by default
      coding-system-for-write 'utf-8 
      sentence-end-double-space nil	; sentence SHOULD end with only a point.
      default-fill-column 80		; toggle wrapping text at the 80th character
      initial-scratch-message "")       ; print a default message in the empty scratch buffer opened at startup

(tool-bar-mode -1)
(menu-bar-mode t)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (hydra company tide evil-org mingus evil-magit magit general evil-collection emms helm rainbow-mode which-key telephone-line use-package evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
