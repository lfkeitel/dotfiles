(include "macros.lisp")
(include "funcs.lisp")
(include "colors.lisp")
(include "git.lisp")

(defun git-current-branch ()
    (strip-git-current-branch (cmd-output (git symbolic-ref --quiet HEAD))))

(defun strip-git-current-branch (ref)
    (if (eq ref "")
        ""
        (string-replace ref "refs/heads/" "")))

(defun shortend-pwd ()
    (if (eq (pwd) "/")
        "/"
        (string-concat "%/" (list-last (string-split (pwd) "/")))))

;; My colorful prompt
(defun prompt ()
    (string-concat
        color_green
        (cmd-output (whoami))
        " "
        color_light_blue
        (shortend-pwd)
        " "
        color_green
        (git-current-branch)
        color_reset
        " ➤ "))

;; Cargo aliases
(alias cb (cargo build))
(alias cr (cargo run))

(define config-file (current-file))

(defun reload () (include config-file))

;; Notice that this file loaded correctly
(define lishrc :t)
(print "lishrc loaded")
