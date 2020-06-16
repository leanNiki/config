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

;;; Emacs Config
(setq inhibit-startup-screen t 	        ; inhibit useless and old-school startup screen
      kept-new-versions 6
      kept-old-versions 2
      version-control t 		; use version control

      delete-old-versions -1 	        ; delete excess backup versions silently
      BACKUP-by-copying-when-linked t
      backup-directory-alist `(("." . "~/.config/emacs/saves"))  ; which directory to put backups file
      vc-follow-symlinks t 		; don't ask for confirmation when opening symlinked file
      ring-bell-function 'ignore 	; silent bell when you make a mistake
      coding-system-for-read 'utf-8 	; use utf-8 by default
      coding-system-for-write 'utf-8 
      sentence-end-double-space nil	; sentence SHOULD end with only a point.
      default-fill-column 80		; toggle wrapping text at the 80th character
      initial-scratch-message "")       ; print a default message in the empty scratch buffer opened at startup


(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;;; Package Config
;; exwm (window manager)
(use-package exwm 
  :init
  (progn
    (require 'exwm-config)
    (require 'exwm-systemtray)
    (exwm-systemtray-enable)
    (require 'exwm-randr)
    ;; Make class name the buffer name
    (add-hook 'exwm-update-class-hook
	 (lambda ()
	   (exwm-workspace-rename-buffer exwm-class-name)))
    (setq exwm-workspace-number 2 ;; how many initial ws
	  ;; exwm-workspace-minibuffer-position 'top
	  exwm-workspace-show-all-buffers t ;; show buffers from all workspaces
	  exwm-layout-show-all-buffers t
	  exwm-systemtray-background-color "#f7ca88"
	  exwm-systemtray-height 14
	  exwm-randr-workspace-output-plist '(0 "eDP-1-1")) ;; RandR setup

    ;; -- Keybindings --
    (exwm-input-set-key (kbd "s-R") #'exwm-reset)
    ;; switch workspace interactive
    (exwm-input-set-key (kbd "s-w") 
		   (lambda ()
		     (interactive)
		     (exwm-workspace-switch-create 0)))
    (exwm-input-set-key (kbd "s-e") 
		   (lambda ()
		     (interactive)
		     (exwm-workspace-switch-create 1)))
    ;; 's-<0-9>': Switch to certain workspace
    (dotimes (i 10)
      (exwm-input-set-key (kbd (format "s-%d" i))
			  `(lambda ()
			     (interactive)
			     (exwm-workspace-switch-create ,i))))
    ;; 's-p': Launch application
    (exwm-input-set-key (kbd "s-r")
		   (lambda (command)
		     (interactive (list (read-shell-command "> ")))
		     (start-process-shell-command command nil command)))
    ;; close
    (exwm-input-set-key (kbd "s-c") #'kill-this-buffer)
    (exwm-input-set-key (kbd "s-C") #'delete-window)
    (exwm-input-set-key (kbd "s-x") #'exwm-workspace-delete)
    (exwm-input-set-key (kbd "s-m") #'exwm-workspace-move-window)
    (exwm-input-set-key (kbd "s-n") #'next-buffer)
    (exwm-input-set-key (kbd "s-p") #'previous-buffer)
    (exwm-input-set-key (kbd "s-b") #'helm-mini)
    (exwm-input-set-key (kbd "s-SPC") #'exwm-layout-toggle-fullscreen)
    (exwm-input-set-key (kbd "s-t") #'exwm-floating-toggle-floating)
    (exwm-input-set-key (kbd "s-f") #'find-file)
    ;; navigation
    (exwm-input-set-key (kbd "s-h") #'windmove-left)
    (exwm-input-set-key (kbd "s-j") #'windmove-down)
    (exwm-input-set-key (kbd "s-k") #'windmove-up)
    (exwm-input-set-key (kbd "s-l") #'windmove-right)

    (exwm-input-set-key (kbd "s-H") #'exwm-layout-shrink-window-horizontally)
    (exwm-input-set-key (kbd "s-J") #'exwm-layout-shrink-window)
    (exwm-input-set-key (kbd "s-K") #'exwm-layout-enlarge-window)
    (exwm-input-set-key (kbd "s-L") #'exwm-layout-enlarge-window-horizontally)

    (exwm-input-set-key (kbd "s-a") #'split-window-right)
    (exwm-input-set-key (kbd "s-s") #'split-window-below)

    ;;(exwm-randr-enable)
    ;;(exwm-enable)
    ))


;; emacs-mini-modeline
(use-package mini-modeline
  :config

  (defun my-read-lines (file reader indices)
    (with-temp-buffer
      (insert-file-contents file)
      (goto-char 1)
      (mapcar (lambda (index)
		(save-excursion
                  (when (search-forward-regexp (concat "^" index "\\(.*\\)$") nil t)
                    (if reader
			(funcall reader (match-string 1))
                      (match-string 1)))))
              indices)))

  (defvar my-last-cpu-ticks nil)

  (defun my-cpu-monitor () ""
	 (number-to-string
	  (cl-destructuring-bind (cpu)
	      (my-read-lines
	       "/proc/stat" (lambda (str) (mapcar 'read (split-string str nil t))) '("cpu"))
	    (let ((total (apply '+ cpu)) (idle (nth 3 cpu)))
	      (prog1 (when my-last-cpu-ticks
		       (let ((total-diff (- total (car my-last-cpu-ticks)))
			     (idle-diff (- idle (cdr my-last-cpu-ticks))))
			 (unless (zerop total-diff)
			   (/ (* (- total-diff idle-diff) 100) total-diff))))
		(setq my-last-cpu-ticks (cons total idle)))))))

  (defun my-memory-monitor () ""
	 (number-to-string
	  (cl-destructuring-bind (memtotal memavailable memfree buffers cached)
              (my-read-lines
               "/proc/meminfo" (lambda (str) (and str (read str)))
               '("MemTotal:" "MemAvailable:" "MemFree:" "Buffers:" "Cached:"))
	    (if memavailable
		(/ (* (- memtotal memavailable) 100) memtotal)
              (/ (* (- memtotal (+ memfree buffers cached)) 100) memtotal)))))

  (defvar my-last-network-rx nil)

  (defun my-network-rx-monitor () ""
	 (number-to-string
	 (with-temp-buffer
	   (insert-file-contents "/proc/net/dev")
	   (goto-char 1)
	   (let ((rx 0))
	     (while (search-forward-regexp "^[\s\t]*\\(.*\\):" nil t)
	       (unless (string= (match-string 1) "lo")
		 (setq rx (+ rx (read (current-buffer))))))
	     (prog1 (when my-last-network-rx
		      (/ (- rx my-last-network-rx) 1000))
	       (setq my-last-network-rx rx))))))

  (defvar my-last-network-tx nil)
  (defun my-network-tx-monitor () ""
	 (number-to-string
	 (with-temp-buffer
	   (insert-file-contents "/proc/net/dev")
           (goto-char 1)
           (let ((tx 0))
             (while (search-forward-regexp "^[\s\t]*\\(.*\\):" nil t)
               (unless (string= (match-string 1) "lo")
                 (forward-word 8)
                 (setq tx (+ tx (read (current-buffer))))))
             (prog1 (when my-last-network-tx
                      (/ (- tx my-last-network-tx) 1000))
               (setq my-last-network-tx tx))))))

  (defun my-cpu-mon () ""
	 (string-trim (shell-command-to-string
	  "top -bn1 | grep \"Cpu(s)\" | sed \"s/.*, *\([0-9.]*\)%* id.*/\1/\" | awk '{print 100 - $1}'")))
  (my-cpu-mon)

  (setq mini-modeline-r-format '("%e"
				 evil-mode-line-tag
				 vc-mode
				 mode-line-mule-info
				 mode-line-client
				 mode-line-modified
				 mode-line-remote
				 mode-line-frame-identification
				 mode-line-position
				 mode-line-buffer-identification
				 " "
				 (-5 :eval mode-name)
				 "                   "
				 ;;mode-line-modes
				 (:eval
				  (propertize
				   (concat " " (number-to-string exwm-workspace-current-index) " ")
				   'face '(:weight bold)))
				 " NET: "
				 (-5 :eval (my-network-tx-monitor))
				 " | "
				 (-5 :eval (my-network-rx-monitor))
				 "  CPU: "
				 (-3 :eval (my-cpu-monitor))
				 "%%  MEM: "
				 (:eval (my-memory-monitor))
				 "%%  BAT"
				 battery-mode-line-string
				 "  "
				 (:propertize display-time-string face (:weight bold))
				 )
	mini-modeline-face-attr '(:background "#f7ca88" :weight normal :box (:line-width 2 :color "#f7ca88")))


  (setq display-time-format "%a %d %b %T"
	display-time-interval 5
	display-time-default-load-average nil
	mini-modeline-update-interval 0.5
	resize-mini-windows t)

  (display-time-mode t)
  (display-battery-mode t)
  (mini-modeline-mode t))
  

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
  (defun term-zsh ()
    (interactive)
    (term "/bin/zsh"))
  (general-define-key
   :states 'normal
   :keymaps 'override
   :prefix "SPC"
   "a" 'org-cycle-agenda-files
   "b" 'helm-mini
   "c" 'org-capture
   "e" (lambda() (interactive) (find-file user-init-file))
   "f f" 'helm-find-files
   "f l" 'helm-locate
   "g" 'magit
   "k" 'kill-this-buffer
   "m" 'mingus-browse
   "r" 'ranger
   "<RET>" (lambda() (interactive) (term "/bin/zsh"))
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
   "w a" 'evil-window-vsplit
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
  (setq helm-completion-in-region-fuzzy-match t
	helm-mode-fuzzy-match t)
  (general-define-key
   :keymaps 'helm-map
    "C-j" 'helm-next-line
    "C-k" 'helm-previous-line
    "C-l" 'helm-maybe-exit-minibuffer)

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
  (setq org-agenda-files '("~/doc/org/gtd.org")
	org-default-notes-file "~/doc/org/gtd.org"
	initial-buffer-choice org-default-notes-file
	))
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
;; (use-package telephone-line
;;   :config
;;   (telephone-line-defsegment* tel-date-segment ()
;;     (format-time-string "%H:%m:%S %Y-%m-%d"))
;;   (setq telephone-line-lhs
;; 	'((evil   . (telephone-line-evil-tag-segment))
;; 	  (accent . (telephone-line-vc-segment
;; 		     telephone-line-erc-modified-channels-segment
;; 		     telephone-line-process-segment))
;; 	  (nil    . (telephone-line-minor-mode-segment
;; 		     telephone-line-buffer-segment))))
;;   (setq telephone-line-rhs
;; 	'((nil    . (telephone-line-misc-info-segment))
;; 	  (accent . (telephone-line-major-mode-segment))
;; 	  (evil   . (telephone-line-airline-position-segment
;; 		     tel-date-segment))))
;;   (telephone-line-mode 1))

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


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#383838" "#dca3a3" "#5f7f5f" "#e0cf9f" "#7cb8bb" "#dc8cc3" "#7cb8bb" "#dcdccc"])
 '(custom-enabled-themes '(me))
 '(custom-safe-themes
   '("3c95ec2229d582d745688f3e28cc550d2e560d83a0c92cdce06fa417466cb649" "a3a514b761438f9a7834c23f4371b08b247615f43d50d0ee8fb60151b027bfdd" "ebe3e7cda1b82838640b0e70f002117da9fa3883d411ea8298b2a5839a2d43f1" "3c8e907afd71c11d24e8010ffbb61e4cdc71d72411c189cfbaf158d8d336ceb7" "24a024bb7ca2a0568e2e648457d345795b7c112ebd65ba8ab26c3a4dfb00d3f1" "8539162e4aa676677cf7d7fe802ec6281f573af6706094892060531799043e69" "c5dd73ccfcd509f3967bc677f131634937cede7225080d851ccbd7110deeeda7" "51e842e1167bac1dba63562d507525c38d52121660cdf7c392f84afc0b5433f9" "3114f391ecadd345689503761455cb98f3fe3baa30bddfdcf94aed39571c55d2" "c63ca9936fd7fcf05fd31466d02f6bd19c199202e654bf519a7154e1ed649e25" "701042f8e3ab6941c8903f95f623f358dcf04703d3dfae848517156ad8378ea0" "81c9aeff03174b0872cf92a609280cafa37f9f5b8c224fefa418b86646878f0f" "da70288cd6b38811c17efa9571a91f010d73c1651b0ddcf041ee38d24b3ffa1b" "ff35abdef447be406c718bf7b13287edf6fc4884be542b9ed3e0daf62a15a7a5" "f6733cae5aebd5c3afdf7b2382aaf18c643fd0648d2bbc1bf15d83fc1f253887" "4eb98ad23a98e0e44c1cb00e3ed22d34112874790b64dff31242ad2bd8b063ee" "7d3ac9ad78e434c4b28c4955ec736cc8bec4c2331cf3e89372d663c1b7ce6171" "ca1f1b2274dc4f52524bf778ea522a5dda0110d0d515aa1f664de8351fe6ca28" "bc4c89a7b91cfbd3e28b2a8e9e6750079a985237b960384f158515d32c7f0490" "2132cc703bafa08e25609ccb722693c0bf6b44da1d926137c4c31082369f1f9a" "adebeda801ac024c4d54eed10b1276d3aa1b561aaed8a82bc17400830222c4cc" default))
 '(display-battery-mode t)
 '(display-time-mode t)
 '(helm-completion-style 'emacs)
 '(mini-modeline-mode t)
 '(package-selected-packages
   '(mini-modeline which-key use-package tide telephone-line symon ranger rainbow-mode prettier-js posframe mingus hydra helm general exwm evil-org evil-magit evil-collection company)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
