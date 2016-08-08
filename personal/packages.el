;;; packages.el --- Summary personal package dependencies

;;; Commentary:

;; all packages I needs are listed here
;; Prelude takes over the installing

;;; Code:
; (require 'prelude-lisp)
; (prelude-require-packages '(
;                             jsdoc
;                             flycheck-clojure
;                             clj-refactor
;                             cljr-helm
;                             clojure-cheatsheet
;                             clojars
;                             clojure-snippets
;                             yasnippet
;                             idea-darkula-theme
;                             magit-gitflow
;                             ))


(autoload 'glsl-mode "glsl-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.glsl\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.vert\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.frag\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.geom\\'" . glsl-mode))

;;; packages.el ends here
