;;; js.el --- settings for the js mode

;;; Commentary:

;; All settings for the js mode are listed here


;;; Code:
;; js2 refactor
(require 'prelude-lisp)
(prelude-require-packages '(js-doc
                            js2-mode
                            js2-refactor
                            grunt
                            tern
                            company-tern
                            ;tern-auto-complete
                            flycheck
                            grunt
                            xref-js2))

(add-hook 'js2-mode-hook
          #'js2-refactor-mode 
          #'setup-js-buffer
          #'(lambda ()
              (define-key js2-mode-map (kbd "s-i") 'js-doc-insert-function-doc)
              (define-key js2-mode-map "@" 'js-doc-insert-tag)))

(defun setup-js-buffer ()
  (setq mode-name "JS")
  (company-mode 1)
  (tern-mode 1)
  ;; When the buffer is not visiting a file, eslint systematically fails
  (if buffer-file-name
      (flycheck-mode 1)
    (flycheck-mode -1))
  (js2-minor-mode 1)
  (js2-refactor-mode 1)
  ;(amd-mode 1)
  ;(widgetjs-mode 1)

  ;; add xref-js2 support
  (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)

(js2r-add-keybindings-with-modifier "C-s-")

;; tern will override js2r keybindings...
(define-key tern-mode-keymap (kbd "C-c C-r") nil)

;; ... and xref.
(define-key tern-mode-keymap (kbd "M-.") nil)
(define-key tern-mode-keymap (kbd "M-,") nil)

(js2r-add-keybindings-with-prefix "C-c C-r")

(define-key js-mode-map (kbd "M-.") nil)
(define-key js-mode-map (kbd "C-c C-j") nil)


  (setq-local compile-command "grunt")

  ;; we use tabs in JS files
  (setq tab-width 4)
  (setq indent-tabs-mode t))



;;(define-key amd-mode-map (kbd "C-c C-a") #'amd-initialize-makey-group)

;; eslint parser executable can be overridden in some projects but marked as
;; risky, so silence that.
(put 'flycheck-javascript-eslint-executable 'risky-local-variable nil)

(defun kill-tern-process ()
  "Kill the tern process if any.
The process will be restarted.  This is useful if tern becomes
unreachable."
  (interactive)
  (delete-process "Tern"))




(add-to-list 'company-backends 'company-tern)

;; paredit-like commands for JS
(define-key js-mode-map (kbd "<C-right>") #'js2r-forward-slurp)
(define-key js-mode-map (kbd "<C-left>") #'js2r-forward-barf)
(define-key js-mode-map (kbd "C-k") #'js2r-kill)
(define-key js-mode-map (kbd "M-S") #'js-smart-split)

;;; Convenience functions

(defun js-smart-split ()
  "Split the string or var declaration at point."
  (interactive)
  (let ((node (js2-node-at-point)))
    (cond ((js2-string-node-p node) (js2r-split-string))
          (t (js2r-split-var-declaration)))))

(defun mdn-search (searchString)
  "Open a browser on the MDN page for SEARCHSTRING."
  (interactive (list (read-string "Search: " (thing-at-point 'symbol))))
  (browse-url (format "https://developer.mozilla.org/en-US/search?q=%s&topic=js" searchString)))

(define-key js-mode-map (kbd "C-c m") #'mdn-search)

;;; modified version of js-proper-indentation that works with FTGP rules

;; TODO: Commit a proper fix to Emacs.
(defun js--proper-indentation (parse-status)
  "Return the proper indentation for the current line."
  (save-excursion
    (back-to-indentation)
    (cond ((nth 4 parse-status)    ; inside comment
           (js--get-c-offset 'c (nth 8 parse-status)))
          ((nth 3 parse-status) 0) ; inside string
          ((eq (char-after) ?#) 0)
          ((save-excursion (js--beginning-of-macro)) 4)
          ;; Indent array comprehension continuation lines specially.
          ((let ((bracket (nth 1 parse-status))
                 beg)
             (and bracket
                  (not (js--same-line bracket))
                  (setq beg (js--indent-in-array-comp bracket))
                  ;; At or after the first loop?
                  (>= (point) beg)
                  (js--array-comp-indentation bracket beg))))
          ((js--ctrl-statement-indentation))
          ((js--multi-line-declaration-indentation))
          ((nth 1 parse-status)
           ;; A single closing paren/bracket should be indented at the
           ;; same level as the opening statement. Same goes for
           ;; "case" and "default".
           (let ((same-indent-p (looking-at "[]})]"))
                 (switch-keyword-p (looking-at "default\\_>\\|case\\_>[^:]"))
                 (continued-expr-p (js--continued-expression-p)))
             (goto-char (nth 1 parse-status)) ; go to the opening char
             (if (looking-at "[({[]\\s-*\\(/[/*]\\|$\\)")
                 (progn ; nothing following the opening paren/bracket
                   (skip-syntax-backward " ")
                   (when (eq (char-before) ?\)) (backward-list))
                   (back-to-indentation)
                   (let* ((in-switch-p (unless same-indent-p
                                         (looking-at "\\_<switch\\_>")))
                          (same-indent-p (or same-indent-p
                                             (and switch-keyword-p
                                                  in-switch-p)))
                          (indent
                           (cond (same-indent-p
                                  (current-column))
                                 (continued-expr-p
                                  (+ (current-column) (* 2 js-indent-level)
                                     js-expr-indent-offset))
                                 (t
                                  (+ (current-column) js-indent-level
                                     (pcase (char-after (nth 1 parse-status))
                                       (?\( js-paren-indent-offset)
                                       (?\[ js-square-indent-offset)
                                       (?\{ js-curly-indent-offset)))))))
                     (if in-switch-p
                         (+ indent js-switch-indent-offset)
                       indent)))
               ;; If there is something following the opening
               ;; paren/bracket, everything else should be indented at
               ;; the same level.
               ; MODIFIED VERSION
               (if same-indent-p
                   (progn
                     (back-to-indentation)
                     (current-column))
                 (progn
                   (back-to-indentation)
                   (+ (current-column) js2-basic-offset)))
               ; COMMENTED ORIGINAL VERSION
               ;; (unless same-indent-p
               ;;   (forward-char)
               ;;   (skip-chars-forward " \t"))
               ;; (current-column)
               )))

          ((js--continued-expression-p)
           (+ js-indent-level js-expr-indent-offset))
          (t 0))))


;; js doc
(setq js-doc-mail-address "daniel.grosse@diginetmedia.de"
      js-doc-author (format "Daniel Grosse <%s>" js-doc-mail-address)
      js-doc-url "diginetmedia.de"
      js-doc-license "copyright 2016")


    ;(define-key map (kbd "s-m f") 'magit-log-buffer-file)
(provide 'js)
;;(provide 'key)
;;; js.el ends here
