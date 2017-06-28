(setenv "GOPATH" "/home/lfkeitel/go")
(add-to-list 'exec-path "/home/lfkeitel/go/bin")

(use-package go-mode
  :ensure t
  :mode "\\.go\\'")

(use-package go-autocomplete
  :ensure t)

(defun set-go-mode-stuff ()
  (setq gofmt-command "goimports")

  (add-hook 'before-save-hook 'gofmt-before-save)

  (if (not (string-match "go" compile-command))
	  (set (make-local-variable 'compile-command)
		   "go build -v && go test -v && go vet"))

  (local-set-key (kbd "M-]") 'godef-jump-other-window)
  (local-set-key (kbd "M-,") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark))

(add-hook 'go-mode-hook 'set-go-mode-stuff)
