(use-package yaml-mode
  :ensure t
  :mode "\\.yml\\'")

(use-package php-mode
  :ensure t
  :mode "\\.php\\'")

(use-package smex
  :ensure t
  :config
  (smex-initialize))

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
