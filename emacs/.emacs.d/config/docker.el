(use-package docker
  :ensure t
  :config
  (docker-global-mode))

(use-package dockerfile-mode)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))
