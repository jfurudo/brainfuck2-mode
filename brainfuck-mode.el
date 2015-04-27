(setq brainfuck-mode-memory-size 10)

(defun interpret-brainfuck (source)
  "Interpret brainfuck program."
  (let ((pointer 0)
        (memory (make-vector brainfuck-mode-memory-size 0))
        (program-counter 0)
        (output-buffer (get-buffer-create "output"))
        (result ""))
    (pop-to-buffer output-buffer)
    (let ((i 0))
      (while (< program-counter (length source))
        (let ((operater (substring source program-counter (+ program-counter 1))))
          ;; (brainfuck-execlude-operater pointer memory operater)
          (cond
           ((string= operater "+")
            (aset memory pointer (+ (aref memory pointer) 1)))
           ((string= operater "-")
            (aset memory pointer (- (aref memory pointer) 1)))
           ((string= operater ">")
            (incf pointer))
           ((string= operater "<")
            (decf pointer))
           ((string= operater ".")
            (setq result (concat result (format "%c" (aref memory pointer)))))
           ((string= operater "[")
            (if (= (aref memory pointer) 0)
                (jump-to-close-bracket)))
           ((string= operater "]")
            (if (not (= (aref memory pointer) 0))
                (jump-to-open-bracket)))))
        (incf program-counter)
        (insert (number-to-string program-counter))
        (incf i)))
    (insert (brainfuck-mode-show pointer memory))))

; (brainfuck-mode-show 0 (make-vector brainfuck-mode-memory-size 0))

(defun jump-to-close-bracket ()
  (catch 'found-open-bracket
    (while (< program-counter (length source))
      (if (= ?\] (aref source program-counter))
          (throw 'found-open-bracket t)
        (incf program-counter)))))

(defun jump-to-open-bracket ()
  (catch 'found-close-bracket
    (while (> program-counter -1)
      (if (= ?\[ (aref source program-counter))
          (throw 'found-close-bracket t)
        (decf program-counter)))))

(defun brainfuck-execlude-operater (pointer memory operater)
  (cond
   ((string= operater "+")
    (aset memory pointer (+ (aref memory pointer) 1)))
   ((string= operater "-")
    (aset memory pointer (- (aref memory pointer) 1)))
   ((string= operater ">")
    (incf pointer))
   ((string= operater "<")
    (decf pointer))
   (t (insert "not inplemented"))))

(defun hoge ()
    (let ((pointer 0) (memory (make-vector brainfuck-mode-memory-size 0)))
      (brainfuck-execlude-operater pointer memory ">")))

(brainfuck-execlude-operater '0 (make-vector brainfuck-mode-memory-size 0) ">")

;; show pointer and memory.
(defun brainfuck-mode-show (pointer memory)
  "Show memory state."
  (let ((pointer-line "pointer: ") (memory-line "address: ") (result-line "result: "))
    (setq pointer-line (concat pointer-line (number-to-string pointer)))
    (let ((i 0))
      (while (< i brainfuck-mode-memory-size)
        (setq memory-line
              (concat memory-line " "
                      (number-to-string (aref memory i))))
        (setq i (+ i 1))))
    (concat pointer-line "\n" memory-line "\n" result-line result)))

(1+ brainfuck-mode-memory-size)

(interpret-brainfuck "++++[>++++<-]+.")

(provide 'brainfuck-mode)

