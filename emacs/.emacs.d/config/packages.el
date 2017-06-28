(use-package evil
  :ensure t
  :config
  (evil-mode t))

(use-package helm
    :ensure t)
(require 'helm-config)

(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package auto-complete
  :ensure t
  :config (ac-config-default))

(use-package bookmark+
  :ensure t
  :init
  (setq bookmark-default-file (expand-file-name "bookmarks" user-init-dir)))

(use-package rainbow-mode
  :ensure t)

(use-package flycheck-mode
  :ensure t)
