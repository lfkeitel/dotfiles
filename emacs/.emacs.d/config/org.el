(use-package org)

(use-package org-bullets
  :ensure t)

(add-hook 'org-mode-hook (lambda() (org-bullets-mode 1)))
(setq org-ellipsis "⤵")
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
(setq org-src-window-setup 'current-window)

(add-to-list 'org-structure-template-alist
             '("el" "#+BEGIN_SRC emacs-lisp\n?\n#+END_SRC"))

(add-hook 'org-mode-hook 'flyspell-mode)
(setq org-hide-leading-stars t)

;; Make windmove work in org-mode:
(add-hook 'org-shiftup-final-hook 'windmove-up)
(add-hook 'org-shiftleft-final-hook 'windmove-left)
(add-hook 'org-shiftdown-final-hook 'windmove-down)
(add-hook 'org-shiftright-final-hook 'windmove-right)

(setq org-directory "~/org")

(defun org-file-path (filename)
  "Return the absolute address of an org file, given its relative name."
  (concat (file-name-as-directory org-directory) filename))

(setq org-inbox-file "~/Dropbox/inbox.org")
(setq org-index-file (org-file-path "index.org"))
(setq org-archive-location
      (concat (org-file-path "archive.org") "::* From %s"))

(defun lfk/copy-tasks-from-inbox ()
  (when (file-exists-p org-inbox-file)
    (save-excursion
      (find-file org-index-file)
      (goto-char (point-max))
      (insert-file-contents org-inbox-file)
      (delete-file org-inbox-file))))

(setq org-agenda-files (list org-index-file))

(defun lfk/mark-done-and-archive ()
  "Mark the state of an org-mode item as DONE and archive it."
  (interactive)
  (org-todo 'done)
  (org-archive-subtree))

(define-key org-mode-map (kbd "C-c C-x C-s") 'lfk/mark-done-and-archive)

(setq org-log-done 'time)

(defun open-index-file ()
  "Open the master org TODO list."
  (interactive)
  (lfk/copy-tasks-from-inbox)
  (find-file org-index-file)
  (end-of-buffer))

(global-set-key (kbd "C-c i") 'open-index-file)

(setq org-html-postamble nil)

(setq org-todo-keywords
       '((sequence "TODO(t)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELED(c@)")))

;; org-capture
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-export-coding-system 'utf-8)

(setq org-templates-dir (file-name-as-directory (concat user-init-dir "org-templates")))
(defun org-template (temp)
  (concat org-templates-dir temp ".tmpl"))

(setq org-capture-templates
      `(("t" "Todo list item"
         entry
         (file+headline org-index-file "Tasks")
         "* TODO %?\n")

        ("j" "Journal entry"
         entry
         (file+datetree (org-file-path "journal.org"))
         (file (org-template "journal")))

        ("g" "Groceries"
         checkitem
         (file (org-file-path "groceries.org")))
        ))

(add-hook 'org-capture-mode-hook 'evil-insert-state)
