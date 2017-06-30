(defconst user-init-dir
  (cond ((boundp 'user-emacs-directory)
	 user-emacs-directory)
	((boundp 'user-init-directory)
	 user-init-directory)
	(t "~/.emacs.d")))

(defun load-config-file (file)
  (interactive "fConfig: ")
  "Load a file in current user's configuration directory"
  (load-file (expand-file-name file (expand-file-name "config" user-init-dir))))

(defun load-user-file (file)
  (interactive "fELisp File: ")
  "Load a lisp 'module' from the user's emacs directory"
  (load-file (expand-file-name file user-init-dir)))

(add-to-list 'load-path (concat user-init-dir "lisp"))

(load-config-file "package.el")

; https://github.com/hrs/sensible-defaults.el
(require 'sensible-defaults)
(sensible-defaults/use-all-settings)
(sensible-defaults/use-all-keybindings)
(sensible-defaults/backup-to-temp-directory)

(load-config-file "custom.el")
(load-config-file "packages.el")
(load-config-file "projects.el")
(load-config-file "misc-functions.el")
(load-config-file "org.el")
(load-config-file "magit.el")
(load-config-file "dashboard.el")
(load-config-file "modes.el")
(load-config-file "cursors.el")
(load-config-file "markdown.el")
(load-config-file "keys.el")
(load-config-file "settings.el")
(load-config-file "theme.el")
(load-config-file "font.el")
(load-config-file "programming.el")
(load-config-file "css-less.el")
(load-config-file "golang.el")
(load-config-file "docker.el")
(load-config-file "terminal.el")
(load-config-file "dandelion.el")

(require 'buffer-move)
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)
