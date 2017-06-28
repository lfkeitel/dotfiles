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
