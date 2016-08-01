;;; js.el --- settings for the js mode

;;; Commentary:

;; All settings for the js mode are listed here


;;; Code:
;; js2 refactor
(require 'prelude-lisp)
(prelude-require-packages '(js-doc js2-refactor))

(add-hook 'js2-mode-hook #'js2-refactor-mode)
(js2r-add-keybindings-with-modifier "C-s-")

;; js doc
(setq js-doc-mail-address "daniel.grosse@diginetmedia.de"
      js-doc-author (format "Daniel Grosse <%s>" js-doc-mail-address)
      js-doc-url "diginetmedia.de"
      js-doc-license "copyright 2016")

(add-hook 'js2-mode-hook
          #'(lambda ()
              (define-key js2-mode-map (kbd "s-i") 'js-doc-insert-function-doc)
              (define-key js2-mode-map "@" 'js-doc-insert-tag)))

    ;(define-key map (kbd "s-m f") 'magit-log-buffer-file)

;;(provide 'key)
;;; js.el ends here
