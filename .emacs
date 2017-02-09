;; ===== ELPA packages    =====
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			 ("marmalade" . "https://marmalade-repo.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")))

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

;; ===== Build related config/functions ===== 
(add-hook 'c-mode-common-hook '(lambda ()
      (setq c-recognize-knr-p nil)
      (setq c-basic-offset 3)
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
(global-set-key [f6] 'goto-line)

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


(put 'erase-buffer 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
