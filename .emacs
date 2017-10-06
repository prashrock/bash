;; ===== ELPA packages    =====
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			 ("melpa stable" . "https://stable.melpa.org/packages/")))
;; 			 ("marmalade" . "https://marmalade-repo.org/packages/")
;; M-x package-install smartparens
;; M-x package-install flycheck

;; ===== Useful keys =====
;; Support inserting timestamps
(defun insert-timestamp ()
  "timestamp insertion function."
  (interactive)
  (insert (format-time-string "%Y%m%d-%H%M%S: ")))
(global-set-key (kbd "M-t") 'insert-timestamp)
;; Use Alt key as meta
(setq x-alt-keysym 'meta)
;; Switch to visible bell instead of audio bell
(setq-default visible-bell t)
(setq-default bell-inhibit-time 10)
;; See trailing whitespace
(setq-default show-trailing-whitespace t)
;; automatic highlighting of opening/closing paren
(show-paren-mode t)
(setq show-paren-style 'mixed)
;; enable smartparens
(require 'smartparens-config)
(show-smartparens-global-mode +1)
(smartparens-global-mode 1)
;; misc
(global-auto-revert-mode t)

;; ===== Enable max colors !! =====
(setq font-lock-maximum-decoration t)

;; ===== Enable Linum-Mode and add space after the number  =====
(global-linum-mode t)
(setq linum-format "%d ")

;; ====== Clang format a selected region ======
;; https://llvm.org/svn/llvm-project/cfe/trunk/tools/clang-format/clang-format.el
;; (load "/usr/local/share/clang/clang-format.el")
(global-set-key [C-M-tab] 'clang-format-region)

;; ===== Multiple-cursors =====
(require 'cl-lib)
;;(require 'multiple-cursors)
(global-set-key (kbd "C-c m c") 'mc/edit-lines)
(global-set-key (kbd "C-c m s") 'mc/mark-sort-regions)
;; Note: Use M-x list-packages, to get the list and use M-x package-install followed by multiple-cursors to install this package

;; ===== Cscope ===== 
(require 'xcscope)
(cscope-setup)
(setq load-path (cons "~/.emacs.d/lisp" load-path))
(load-library "p4")
(show-paren-mode t)
;;(setq show-paren-style 'expression)
;;(setq show-paren-style 'nil)
(which-function-mode 1)
(setq tags-revert-without-query t)  ;;re-visit tags if it changes on disk

;; ===== Enable Semantic Mode =====
(require 'cc-mode)
(require 'semantic)
(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
(semantic-add-system-include "/usr/include/linux/kernel")
(semantic-mode 1)
;; C/C++ (from https://truongtx.me/2013/03/10/emacs-setting-up-perfect-environment-for-cc-programming)
(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)


;; ===== Build related config/functions ===== 
(add-hook 'c-mode-common-hook '(lambda ()
      (setq c-recognize-knr-p nil)
      (setq c-basic-offset 2)
      (setq js-indent-level 2)
      (setq indent-tabs-mode nil)
      (c-set-offset 'arglist-intro '+)
      (local-set-key (kbd "RET") 'newline-and-indent)
    ))

(defun release-build ()
  (interactive)
  (compile "cd $DEVDIR; make -sC something"))

(defun clean-build ()
  (interactive)
  (compile 
     "echo 'Doing a full-clean:';
      cd $DEVDIR;                           make clean;       make veryclean; 
      cd $DEVDIR/something;                 make clean;       make veryclean;"
   ))

(defun etags-build (dir-name)
  "Create etags file."
  (interactive "DDirectory: ")
  (compile
     (format
        "find -L %s                                                                         \
        '(' -type d -name .svn -or -type f -name cscope.files -or -name TAGS ')' -prune     \
        -or -type f '(' -name '*.c' -or -name '*.cpp' -or -name '*.h' ')' -print0            \
        | xargs -r0 readlink -f | tee cscope.files | etags -o %s/TAGS -" 
      dir-name dir-name) ) 
  (shell-command (format "cd %s; cscope -b -q -k"  dir-name))
  (let ((tag-file (concat dir-name "TAGS"))) (visit-tags-table tag-file))
  (let ((semanticdb-create-ebrowse-database dir-name)))
  (let ((semanticdb-project-roots           dir-name))) 
)

;;(shell-command (format "cd %s; cscope -b -q -k"  dir-name))

;;(setq path-to-ctags (concat dir-name "TAGS"))
;;(setq tags-table-list (concat dir-name "TAGS"))

;; ===== Set the highlight current line minor mode ===== 
;;(global-hl-line-mode 1)

;; ===== Eenable max colors !! ===== 
(setq font-lock-maximum-decoration t)

;; ===== Enable Linum-Mode and add space after the number  ===== 
;;(global-linum-mode t)
(setq linum-format "%d ")

;; ===== Enable SR-Speedbar for use in Terminal ===== 
;;(require 'sr-speedbar)

;; ========== Line by line scrolling ========== 
(setq scroll-step 1)

;; ===== Set standard indent to 3 rather that 4 ====
(setq standard-indent 3)

;; ========== Support Wheel Mouse Scrolling ==========
(mouse-wheel-mode t)

;; ========== Place Backup Files in Specific Directory ==========
;; Enable backup files.
(setq make-backup-files t)
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 20   ; how many of the newest versions to keep
  kept-old-versions 5    ; and how many of the old
)

;; ========== Enable Line and Column Numbering ==========
(line-number-mode 1)
(column-number-mode 1)
;; Enable highlighting of selected regions
(transient-mark-mode 1)
;; Function definitions
(defun indent-all ()
     "Indent entire buffer."
     (interactive)
     (indent-region (point-min) (point-max) nil))
;; Python Mode for .pillar file
(setq auto-mode-alist (append '(("\\.pillar$" . python-mode))
                               auto-mode-alist))
;; Lisp mode for anything that ends in .emacs
(setq auto-mode-alist (append '(("\\.emacs$" . lisp-mode))
                               auto-mode-alist))
;; Colorings
(set-foreground-color "#dbdbdb")
(set-background-color "#000000")
(custom-set-faces
 '(font-lock-comment-face ((t (:foreground "cyan"))))
)

;; ========== Don't use GNU style indenting for braces ====
;;(setq c-default-style "linux"
;;      c-basic-offset 3)


;; ========== Backspace to work on terminal  ====
(global-set-key [(control h)] 'delete-backward-char)

;; ========== RET auto-indent  ====
;;(add-hook 'c-mode-common-hook '(lambda ()
;;      (local-set-key (kbd "RET") 'newline-and-indent)))

;; ========== Use tabs instead of spaces ====
;;(setq-default c-basic-offset 4
;;              tab-width 4
;;              indent-tabs-mode t)
;;(setq-default c-basic-offset 3
;;              tab-width 3
;;              indent-tabs-mode nil)
;; from http://stackoverflow.com/questions/69934/set-4-space-indent-in-emacs-in-text-mode
;;(setq-default indent-tabs-mode nil)
;;(setq-default tab-width 3)
;;(setq indent-line-function 'insert-tab)

;; ===== Set Tags For my use-case ===== 
;;(setq tags-table-list '("~/KPA/CPP/bld/TAGS"))

;; ===== Use F3 to auto-complete after a TAGS is loaded ===== 
(global-set-key [f3] 'complete-tag)

;; ===== Use F4 and F5 to Find all usage of a tag after TAGS is loaded ===== 
(global-set-key [f4] 'tags-search)
(global-set-key [f5] "\C-u\M-,")

;; ===== Use F6 to Goto Line Number ===== 
(global-set-key "\M-g"  'goto-line)
(global-set-key "\C-q"  'undo)

;; ===== Use F7 and F8 to Find Definition of a tag after TAGS is loaded ===== 
(global-set-key [f7] 'find-tag)
(global-set-key [f8] "\C-u\M-.")

;; ===== Use F12 to get line numbers ===== 
(global-set-key [f12] 'linum-mode)

;; ===== Use Arrow keeys to move between frames ===== 
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <left>") 'windmove-left)
;; Set ctrl-arrow keys to move words/pages
(global-set-key "\M-[C" 'forward-word)
(global-set-key "\M-[D" 'backward-word)
(global-set-key "\M-[B" 'scroll-up)
(global-set-key "\M-[A" 'scroll-down)
(global-set-key "\M-[5C" 'forward-word)
(global-set-key "\M-[5D" 'backward-word)


(put 'erase-buffer 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;;ARC LINT as you type
(require 'flycheck)
(flycheck-define-checker arc-lint
   "Arc lint"
   :command ("arc" "lint"
             "--output" "compiler"
             source)
   :standard-input nil
   :error-patterns ((error line-start (file-name) ":" line ":" (message)))
   ;; TODO: you should adjust modes here to suit
   :modes (c++-mode))
 (add-to-list 'flycheck-checkers 'arc-lint)
;; make flycheck visible in the terminal
(set-face-attribute 'flycheck-info nil :foreground "yellow" :background "red")
(set-face-attribute 'flycheck-warning nil :foreground "yellow" :background "red")
(set-face-attribute 'flycheck-error nil :foreground "yellow" :background "red")
