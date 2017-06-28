;; Move windows with shift + arrow key
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; Block collapse
(global-set-key (kbd "C-=") 'toggle-hiding)
(add-hook 'prog-mode-hook #'hs-minor-mode)

;; Buffer keymaps because I was using them naturally
(global-set-key (kbd "C-c b") 'switch-to-buffer)
(global-set-key (kbd "C-c C-b") 'list-buffers)
(global-set-key (kbd "C-c k") 'lfk/kill-current-buffer)

;; Custom utility keymaps
(global-set-key (kbd "C-x k") 'lfk/kill-current-buffer)

;; Reload the main init file
(global-set-key (kbd "C-c C-i")
		(lambda ()
		  (interactive)
		  (load-user-file "init.el")))

;; Set keymap for terminal
(global-set-key (kbd "C-S-t") 'ansi-term)
