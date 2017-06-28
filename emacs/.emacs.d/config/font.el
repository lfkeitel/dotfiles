(setq lfk/default-font "Inconsolata")
(setq lfk/default-font-size 12)
(setq lfk/current-font-size lfk/default-font-size)

(setq lfk/font-change-increment 1.1)

(defun lfk/font-code ()
  "Return a string representing the current font (like \"Inconsolata-14\")."
  (concat lfk/default-font "-" (number-to-string lfk/current-font-size)))

(defun lfk/set-font-size ()
  "Set the font to `lfk/default-font' at `lfk/current-font-size'.
Set that for the current frame, and also make it the default for
other, future frames."
  (let ((font-code (lfk/font-code)))
    (add-to-list 'default-frame-alist (cons 'font font-code))
    (set-frame-font font-code)))

(defun lfk/reset-font-size ()
  "Change font size back to `lfk/default-font-size'."
  (interactive)
  (setq lfk/current-font-size lfk/default-font-size)
  (lfk/set-font-size))

(defun lfk/increase-font-size ()
  "Increase current font size by a factor of `lfk/font-change-increment'."
  (interactive)
  (setq lfk/current-font-size
        (ceiling (* lfk/current-font-size lfk/font-change-increment)))
  (lfk/set-font-size))

(defun lfk/decrease-font-size ()
  "Decrease current font size by a factor of `lfk/font-change-increment', down to a minimum size of 1."
  (interactive)
  (setq lfk/current-font-size
        (max 1
             (floor (/ lfk/current-font-size lfk/font-change-increment))))
  (lfk/set-font-size))

(define-key global-map (kbd "C-)") 'lfk/reset-font-size)
(define-key global-map (kbd "C-+") 'lfk/increase-font-size)
(define-key global-map (kbd "C--") 'lfk/decrease-font-size)

(lfk/reset-font-size)
