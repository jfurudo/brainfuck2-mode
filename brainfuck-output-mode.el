;; -*- Emacs-Lisp -*-
;; brainfuck-output-mode Version 0

(defvar brainfuck-output-mode-map (make-keymap))

(define-key brainfuck-output-mode-map "q" 'brainfuck-output-quit)

(defun brainfuck-output-mode ()
  (interactive)
  (setq major-mode 'brainfuck-output-mode)
  (setq mode-name "brainfuck-output-mode")
  (use-local-map brainfuck-output-mode-map))

(defun brainfuck-output-quit ()
  (interactive)
  (kill-buffer "*brainfuck-output*"))

(provide 'brainfuck-output-mode)

