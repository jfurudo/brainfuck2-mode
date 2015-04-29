(setq load-path (cons "~/Development/Emacs-Lisp/brainfuck-mode" load-path))
(require 'brainfuck-output-mode)

(defface brainfuck-face-output-focused '((t . (:background "red" :foreground "black"))) "Face for the tile 2" :group 'brainfuck-mode-faces)

(setq brainfuck-mode-memory-size 10)

(defun interpret-brainfuck (source interval)
  "Interpret brainfuck program."
  (let ((pointer 0)
        (memory (make-vector brainfuck-mode-memory-size 0))
        (program-counter 0)
        (output-buffer (get-buffer-create "*brainfuck-output*"))
        (result ""))
    (pop-to-buffer output-buffer)
    (brainfuck-output-mode)
    (let ((i 0))
      (while (< program-counter (length source))
        (let ((operater (substring source program-counter (+ program-counter 1))))
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
        (brainfuck-mode-show)
        (sit-for interval)
        (incf program-counter)
        (incf i)))
    ))

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
(defun brainfuck-execlude-operater ())

(defun brainfuck-mode-show ()
  "Show memory state."
  (erase-buffer)
  (let ((source-line "source: ")
        (pointer-line "pointer: ")
        (memory-line "address: ")
        (result-line "result: "))
    (setq source-line (concat source-line source))
    (setq pointer-line (concat pointer-line (number-to-string pointer)))
    (let ((i 0))
      (while (< i brainfuck-mode-memory-size)
        (setq memory-line
              (concat memory-line " "
                      (format "%02x" (aref memory i))))
        (setq i (+ i 1))))
    (set-buffer output-buffer)
    (put-text-property (brainfuck-source-point ?s) (brainfuck-source-point ?e) 'face 'brainfuck-face-output-focused source-line)
    (put-text-property (brainfuck-memory-point ?s) (brainfuck-memory-point ?e) 'face 'brainfuck-face-output-focused memory-line)
    (insert (concat source-line "\n" pointer-line "\n" memory-line "\n" result-line result))))

(defun brainfuck-source-point (start-or-end)
  (if (= start-or-end ?s)
      (+ 8 program-counter)
    (+ 8 (+ 1 program-counter))))

(defun brainfuck-memory-point (start-or-end)
  (if (= start-or-end ?s)
      (+ 10 (* 3 pointer))
    (+ 12 (* 3 pointer))))

(interpret-brainfuck "+++++++++[>++++++++<-]>.<+++++++++[>+++<-]>++.+++++++..+++.<+++++++++[>-------<-]>----.<+++++++++[>-<-]>---.<+++++++++[>++++++<-]>+.<+++++++++[>++<-]>++++++.+++.------.--------." 0.05)

(provide 'brainfuck-mode)
