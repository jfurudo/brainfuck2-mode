(setq load-path (cons "~/Development/Emacs-Lisp/brainfuck-mode" load-path))
(require 'brainfuck-output-mode)

(defvar brainfuck-mode-map (make-keymap))

(define-key brainfuck-mode-map "\C-xe" 'brainfuck-eval-buffer)

(defun brainfuck-mode ()
  (interactive)
  (setq major-mode 'brainfuck-mode)
  (setq mode-name "brainfuck-mode")
  (use-local-map brainfuck-mode-map))


(defface brainfuck-face-output-focused '((t . (:background "red" :foreground "black"))) "Face for the tile 2" :group 'brainfuck-mode-faces)

;; TODO: Replace to buffer local valiable.
(setq brainfuck-mode-memory-size 100)

(defun brainfuck-interpret (source step-execute)
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
        (let ((command (substring source program-counter (+ program-counter 1))))
          (brainfuck-execute-command)
          )
        (if step-execute
            (progn 
              (brainfuck-mode-show)
              (message "(N)ext / (E)nd step exexute")
              (let ((input (read-char)))
                (if (= input ?e)
                    (setq step-execute nil)))))
        (incf program-counter)
        (incf i)))))

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

(defun brainfuck-execute-command ()
  "Execute a command."
  (cond
   ((string= command "+")
    (aset memory pointer (+ (aref memory pointer) 1)))
   ((string= command "-")
    (aset memory pointer (- (aref memory pointer) 1)))
   ((string= command ">")
    (incf pointer))
   ((string= command "<")
    (decf pointer))
   ((string= command ".")
    (setq result (concat result (format "%c" (aref memory pointer)))))
   ((string= command ",")
    (aset memory pointer (read-char)))
   ((string= command "[")
    (if (= (aref memory pointer) 0)
        (jump-to-close-bracket)))
   ((string= command "]")
    (if (not (= (aref memory pointer) 0))
        (jump-to-open-bracket)))
   ;; Command "#" is braek point.
   ((string= command "#")
    (setq step-execute t)))
  )

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
        ;; (if (= (% i 16) 0)
        ;;     (setq memory-line (concat memory-line "\n         ")))
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

(brainfuck-interpret "+++++++++[>++++++++<-]>.<+++++++++[>+++<-]>++.+++++++..+++.<+++++++++[>-------<-]>----.<+++++++++[>-<-]>---.<+++++++++[>++++++<-]>+.<+++++++++[>++<-]>++++++.+++.------.-------*-.<,." t)
;; (brainfuck-interpret "+++++++++[>++++++++<-]>.<+++++++++[>+++<-]>++.+++++++..+++.<+++++++++[>-------<-]>----.<+++++++++[>-<-]>---.<+++++++++[>++++++<-]>+.<+++++++++[>++<-]>++++++.+++.------.--------.<+++++++++[>----------<-]>..<+++++++++[>++++++<-]>++.<+++++++++[>+++++<-]>+++.<+++++++++[>-<-]>--------.++++++++.+++++.--------.<+++++++++[>+<-]>++++++.<+++++++++[>--<-]>.++++++++.<+++++++++[>--------<-]>---.<+++++++++[>+++++<-]>+++++++.<+++++++++[>+<-]>++++++++.<+++++++++[>++<-]>+.----.<+++++++++[>---------<-]>---.<+++++++++[>++++<-]>+.<+++++++++[>+++<-]>++++.+++++.<+++++++++[>+<-]>++.-----.+++." nil)

(add-to-list 'auto-mode-alist '("\\.bf" . brainfuck-mode))

(provide 'brainfuck-Mode)
