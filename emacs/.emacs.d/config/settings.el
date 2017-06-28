;; Enable and format line numbers
(setq linum-format "%4d \u2502 ")
(global-linum-mode t)

;; Set frame title
(setq frame-title-format '((:eval (projectile-project-name))))

;; Enable pretty lambdas
(global-prettify-symbols-mode t)

;; Highlight current line
(when window-system
  (global-hl-line-mode))

;; Scroll only as far as the point
(setq scroll-conservatively 100)

;; Neotree integration with Projectile
(setq projectile-switch-project-action 'neotree-projectile-action)

;; Faster than default scp
(setq tramp-default-method "ssh")

;; Set correct ssh sock
(setenv "SSH_AUTH_SOCK" (concat (getenv "HOME") "/.gnupg/S.gpg-agent.ssh"))
