(setq load-path (cons "./" load-path))
(require 'ert)
(require 'brainfuck-mode)
(eval-when-compile
  (require 'cl))

(ert-deftest increment-test ()
  "test '+' operater"
    (should
     (equal
      (let ((pointer 0) (memory (make-vector brainfuck-mode-memory-size 0)))
        (brainfuck-execlude-operater pointer memory "+")
        (brainfuck-execlude-operater pointer memory "+")
        (aref memory pointer))
      2))
    (should
     (equal
      (let ((pointer 0) (memory (make-vector brainfuck-mode-memory-size 0)))
        (brainfuck-execlude-operater pointer memory ">"))
    1)))

(ert-deftest increment-pointer-test ()
  "test '>' operater"
  (should
   (equal
    (let ((pointer 0) (memory (make-vector brainfuck-mode-memory-size 0)))
      (brainfuck-execlude-operater pointer memory ">")
      (brainfuck-execlude-operater pointer memory ">"))
    2)))

