(use-package powerline
  :ensure t)

(use-package powerline-evil
  :ensure t
  :config
  (powerline-evil-center-color-theme))

(use-package ample-theme
  :init (progn (load-theme 'ample t t)
               (load-theme 'ample-flat t t)
               (load-theme 'ample-light t t)
               (enable-theme 'ample))
  :defer t
  :ensure t)
