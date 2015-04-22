(setq brainfuck-mode-memory-size 10)

(defun interpret-brainfuck (source)
  "Interpret brainfuck program."
  (let (p (memory (make-vector brainfuck-mode-memory-size 0)))
    (setq p 0)
    (message (number-to-string p))
    (brainfuck-mode-show p memory)))

(interpret-brainfuck "")
(message (number-to-string brainfuck-mode-memory-size))
(make-vector 10 0)

;; show pointer and memory.
(defun brainfuck-mode-show (pointer memory)
  "Show memory state."
  (let ((pointer-line "pointer: ") (memory-line "address"))
    (setq pointer-line (concat pointer-line (number-to-string pointer)))
    (let ((i 0))
      (while (< i brainfuck-mode-memory-size)
        (setq memory-line
              (concat memory-line " "
                      (number-to-string (aref memory i))))
        (setq i (+ i 1))))
    (message (concat pointer-line "\n" memory-line))))

(1+ brainfuck-mode-memory-size)
(make-vector 0 0)
