;; Macro to define a function
(define-syntax defun (name args body)
    `(setf '%name (lambda %args %body)))

;; Macro to define an alias
;; This macro creates another macro that allows any number of arguments to
;; be given allowing aliases to take more flags or commands.
(define-syntax alias (name body)
    `(define-syntax %name (&rest) `(%@body !%@rest)))

(define-syntax cmd-output (body)
    `(get-key (capc %@body) :stdout))
