(defun list-last (list)
    (if (eq (count list) 1)
        (head list)
        (list-last (tail list))))
