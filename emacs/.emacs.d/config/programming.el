;; Use 4 spaces for tabns
(setq-default tab-width 4)

;; Set c-mode indent
(setq-default c-basic-offset 4)

;; Treat camelCase as separate words
(global-subword-mode 1)

;; Scroll compilation output to bottom
(setq compilation-scroll-output t)

;; Always indent with spaces
(setq-default indent-tabs-mode nil)

;; Auto close bracket insertion
(electric-pair-mode 1)

(defun lfk/inhibit-electric-pair-mode (char)
  (minibufferp))

(setq electric-pair-inhibit-predicate #'lfk/inhibit-electric-pair-mode)
