(defun count-atoms (list)
  (cond ((null list) 0)
        ((atom list) 1)
        ((listp list) (+ (count-atoms (first list)) (count-atoms (rest list))))))

(count-atoms '((1 2 3) red (green) (nil) (a b ((7)) ()) c red)) ; => 10
