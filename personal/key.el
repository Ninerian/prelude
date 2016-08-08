;;; key.el --- Summary personal key bindings

;;; Commentary:

;; This package is used to define own keys


;;; Code:
;(global-set-key (kbd "<C-M-s>") [(super ?\ )])
(setq ns-right-alternate-modifier nil)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-likea-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-likea-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-likea-this)

(global-set-key (kbd "C-x C-c") nil)


;;(provide 'key)
;;; key.el ends here
