;;; dandelion.el --- Dandelion in Emacs

;; Copyright (C) 2017 Lee Keitel

;; Author: Lee Keitel <lee@keitel.xyz>
;; Version: 1.0
;; Package-Requires: ((request "0.3.0"))

;;; Code:
(require 'request)
(require 'json)

(defun dandelion/show-status (&key data)
  (let ((statuses (gethash "data" data)))
    (with-current-buffer (get-buffer-create "*dandelion*")
      (erase-buffer)
      (maphash (lambda (key value)
                 (when (not (string= key "statusOptions"))
                     (insert (gethash "fullname" value) ": " (gethash "status" value) "\n"))) statuses)
      (toggle-read-only)
      (pop-to-buffer (current-buffer)))))

;;;###autoload
(defun dandelion-get-status ()
  (interactive)
  (request
   (concat dandelion-address "/api/cheesto/read")
   :params `(("apikey" . ,dandelion-api-key))
   :parser (lambda ()
             (let ((json-object-type 'hash-table))
               (json-read)))
   :error (function* (lambda (&rest args &key error-thrown &allow-other-keys)
                (message "Got error: %S" error-thrown)))
   :success (function* (lambda (&key data &allow-other-keys)
                         (dandelion/show-status
                          :data data)))))

(provide 'dandelion)
;;; dandelion.el ends here
