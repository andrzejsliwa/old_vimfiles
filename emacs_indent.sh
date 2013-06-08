#!/usr/bin/env bash
emacs --batch --eval "
(progn (find-file \"$1\")
    (if (string-equal \"darwin\" (symbol-name system-type))
        (setq erlang-root-dir (car (file-expand-wildcards \"/usr/local/Cellar/erlang*/R*\")))
        (setq erlang-root-dir \"/usr/lib/erlang/\"))
    (setq load-path (cons (car (file-expand-wildcards (concat erlang-root-dir \"/lib/erlang/lib/tools-*/emacs\"))) load-path))
    (require 'erlang-start)

    (add-hook 'erlang-mode-hook
              (lambda ()
                (setq-default indent-tabs-mode nil)
                (setq-default tab-width 4)))

    (add-to-list 'auto-mode-alist '(\"rebar.config$\" . erlang-mode))
    (add-to-list 'auto-mode-alist '(\"sys.config$\"   . erlang-mode))
    (add-to-list 'auto-mode-alist '(\"app.config$\"   . erlang-mode))
    (add-to-list 'auto-mode-alist '(\"Emakefile$\"    . erlang-mode))
    (add-to-list 'auto-mode-alist '(\"\\.rel$\"       . erlang-mode))
    (add-to-list 'auto-mode-alist '(\"\\.app$\"       . erlang-mode))
    (add-to-list 'auto-mode-alist '(\"\\.appSrc$\"    . erlang-mode))
    (add-to-list 'auto-mode-alist '(\"\\.app.src$\"   . erlang-mode))
    (add-to-list 'auto-mode-alist '(\"\\.escript$\"   . erlang-mode))
    (add-to-list 'auto-mode-alist '(\"\\.[heyx]rl$\"  . erlang-mode))
    (erlang-mode)
    (untabify (point-min) (point-max))
    (delete-trailing-whitespace)
    (save-buffer)
    (message \"Formating file $1...\")
    (erlang-indent-current-buffer)
    (save-buffer)
    (save-buffers-kill-emacs))" > /dev/null 2>&1




