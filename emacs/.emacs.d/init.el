;(package-initialize)

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

(add-to-list 'load-path (expand-file-name "lisp" user-init-dir))

(load-config-file "package.el")
(load-config-file "sensible-defaults.el")
(load-config-file "custom.el")
(load-config-file "packages.el")
(load-config-file "misc-functions.el")
(load-config-file "projects.el")
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
(load-config-file "search.el")
(load-config-file "windows.el")

(put 'erase-buffer 'disabled nil)

;; Load a system specific, private elisp scripts
(when (file-exists-p (expand-file-name "private" user-init-dir))
    (lfk/load-directory (expand-file-name "private" user-init-dir)))
