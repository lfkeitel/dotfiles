(add-hook 'css-mode-hook
	  (lambda()
	    (rainbow-mode)
	    (setq css-indent-offset 2)))

(add-hook 'less-mode-hook 'rainbow-mode)
