(setq brainfuck-mode-memory-size 10)

(defun interpret-brainfuck (source)
  "Interpret brainfuck program."
  (let ((pointer 0)
        (memory (make-vector brainfuck-mode-memory-size 0))
        (program-counter 0)
        (output-buffer (get-buffer-create "output")))
    (pop-to-buffer output-buffer)
    (let ((char (substring source program-counter (+ program-counter 1))))
      (insert char)
      (cond
       ((string= char "+")
        (aset memory program-counter (+ (aref memory program-counter) 1)))
       (t (insert "hoge"))))
;;    (message (number-to-string pointer))
    (insert (brainfuck-mode-show pointer memory))))

(string= "+" "+")

(interpret-Brainfuck "++")
(message (number-to-string brainfuck-mode-memory-size))
(make-vector 10 0)

(brainfuck-mode-show 0 (make-vector brainfuck-mode-memory-size 0))

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
    (concat pointer-line "\n" memory-line)))

(1+ brainfuck-mode-memory-size)
(make-vector 0 0)
