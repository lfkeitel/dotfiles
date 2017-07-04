;; Move windows with shift + arrow key
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; Block collapse
(global-set-key (kbd "C-=") #'toggle-hiding)
(add-hook 'prog-mode-hook #'hs-minor-mode)

;; Buffer keymaps because I was using them naturally
(global-set-key (kbd "C-c b") #'switch-to-buffer)
(global-set-key (kbd "C-c C-b") #'list-buffers)
(global-set-key (kbd "C-c k") #'lfk/kill-current-buffer)

;; Custom utility keymaps
(global-set-key (kbd "C-x k") #'lfk/kill-current-buffer)

;; Reload the main init file
(global-set-key (kbd "C-c C-i")
		(lambda ()
		  (interactive)
		  (load-user-file "init.el")))

;; Set keymap for terminal
(global-set-key (kbd "C-S-t") #'ansi-term)

;; Set keymap for new empty buffer
(global-set-key (kbd "<f3>") #'lfk/new-empty-buffer)

;; Add #' in elisp code
(define-key emacs-lisp-mode-map "#" #'lfk/sharp)

;; Bind window resize functions
(global-set-key (kbd "S-M-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-M-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-M-<down>") 'shrink-window)
(global-set-key (kbd "S-M-<up>") 'enlarge-window)

;; Surround text with something
(global-set-key (kbd "C-\"") 'lfk/surround)
