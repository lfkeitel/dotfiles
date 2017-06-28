(require 'multi-term)
(global-set-key (kbd "C-c s") 'multi-term)

(setq multi-term-program-switches "--login")

(evil-set-initial-state 'term-mode 'emacs)

(defun hrs/term-paste (&optional string)
  (interactive)
  (process-send-string
   (get-buffer-process (current-buffer))
   (if string string (current-kill 0))))

(add-hook 'term-mode-hook
          (lambda ()
            (goto-address-mode)
            (define-key term-raw-map (kbd "C-y") 'hrs/term-paste)
            (setq yas-dont-activate t)))
