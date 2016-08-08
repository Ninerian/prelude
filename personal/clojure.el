;;; clojure.el --- settings for the clojure mode

;;; Commentary:

;; All settings for the clojure mode are listed here


;;; Code:
(require 'prelude-lisp)
(require 'cider)
(prelude-require-packages '(
                            flycheck-clojure
                            flycheck-pos-tip
                            clj-refactor
                            cljr-helm
                            clojure-cheatsheet
                            clojars
                            clojure-snippets
                            ))

(eval-after-load 'flycheck
  '(flycheck-clojure-setup))

(eval-after-load 'flycheck
  '(setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages))

(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'after-init-hook #'flycheck-pos-tip-mode)

(defun my-clojure-mode-hook ()
  (clj-refactor-mode 1)
  (yas-minor-mode 1) ; for adding require/use/import statements
  ;; This choice of keybinding leaves cider-macroexpand-1 unbound
  (cljr-add-keybindings-with-prefix "C-c C-m"))

(add-hook 'clojure-mode-hook #'my-clojure-mode-hook)

(global-set-key (kbd "TAB") #'company-indent-or-complete-common)


(setq cider-cljs-lein-repl "(do (use 'figwheel-sidecar.repl-api) (start-figwheel!) (cljs-repl))")
;;(provide 'key)
;;; clojure.el ends here
