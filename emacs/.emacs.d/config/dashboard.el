(use-package page-break-lines
    :ensure t)

;; Dashboard configuration
(setq dashboard-banner-logo-title "Welcome Lee")
; Set below to a image file for banner
;(setq dashboard-start-banner "")
(setq dashboard-items '((recents . 5)
			(bookmarks . 5)
			(projects . 5)
			(agenda . 5)))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))
