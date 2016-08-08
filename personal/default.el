(require 'prelude-lisp)
(prelude-require-packages '(yasnippet
                            idea-darkula-theme
                            magit-gitflow
                            editorconfig
                            dumb-jump
                            ag
                            powerline
                           ; tern
                           ;tern-auto-complete                         
                            ))

(load-theme 'idea-darkula t)
(editorconfig-mode 1)
(setq prelude-whitespace nil)

(add-hook 'magit-mode-hook 'turn-on-magit-gitflow)

(powerline-default-theme)
