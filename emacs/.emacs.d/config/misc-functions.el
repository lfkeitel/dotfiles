(defun toggle-hiding (column)
      (interactive "P")
      (if hs-minor-mode
          (if (condition-case nil
                  (hs-toggle-hiding)
                (error t))
              (hs-show-all))
        (toggle-selective-display column)))

;; Shamelessly stolen from https://github.com/hrs/dotfiles
(defun lfk/view-buffer-name ()
  "Display the filename of the current buffer"
  (interactive)
  (message (buffer-file-name)))

(defun lfk/rename-file (new-name)
  "Prompt for and rename the current buffer's file,
    kill the old buffer and open the new file."
  (interactive "FNew Name: ")
  (let ((filename (buffer-file-name)))
    (if filename
	(progn
	  (when (buffer-modified-p)
	    (save-buffer))
	  (rename-file filename new-name t)
	  (kill-buffer (current-buffer))
	  (find-file new-name)
	  (message "Renamed '%s' -> '%s'" filename new-name))
      (message "Buffer '%s' isn't backed by a file!" (buffer-name)))))

(defun lfk/kill-current-buffer ()
  "Kill the current buffer without prompting."
  (interactive)
  (kill-buffer (current-buffer)))

(defun lfk/new-empty-buffer ()
  "Create a new empty buffer.
New buffer will be named “untitled” or “untitled<2>”, “untitled<3>”, etc.

URL `http://ergoemacs.org/emacs/emacs_new_empty_buffer.html'
Version 2016-12-27"
  (interactive)
  (let ((-buf (generate-new-buffer "untitled")))
    (switch-to-buffer -buf)
    (text-mode)
    (setq buffer-offer-save t)))

(defun lfk/sharp ()
  "Insert #' unless in a string or comment."
  (interactive)
  (call-interactively #'self-insert-command)
  (let ((ppss (syntax-ppss)))
    (unless (or (elt ppss 3)
                (elt ppss 4)
                (eq (char-after) ?'))
      (insert "'"))))
