(defun make-node (item &optional (next-node nil))
  (if (not (null next-node))
    (list item next-node)
    (list item)))

;; FIXME: add node to the end of the list, which means going through all linked lists
(defun add-node (node linked-list)
  (setf (cdr linked-list) node)
  linked-list)

(defun add-node (node linked-list)
  (format t "add-node entry~%")
  (loop for n on linked-list
        do (format t "add-node loop: ~A~%" n)
        when (null (car n)) do
        	(progn
            (format t "add-node/finally before: replacing ~A with ~A and total ~A~%" n node linked-list)
            (setf n node)
            (format t "add-node/finally after: ~A and total ~A~%" n linked-list))))

(defun test ()
  (let ((a (make-node 'apa))
        (b (make-node 'bepa))
        (c (make-node 'charlie)))
    (format t "a: ~S~%" a)
    (format t "b: ~S~%" b)
    (format t "adding a to b~%")
    (add-node a b)
    (format t "b is now: ~S~%" b)
    (format t "setting car of a to 'baz~%")
    (set-data a 'baz)
    (format t "b is now: ~S~%" b)
    (add-node b c)
    (format t "a: ~S; b: ~S; c: ~S~%" a b c)
    (add-node (make-node 'dolf) b)
    (format t "adding DOLF to b => ~S~%" b)
    ))

(defun test2 ()
  (let ((a (list 'a nil))
        (b (list 'b nil))
        (c (list 'c nil))
        (d (list 'd nil))
        (e (list 'e nil))
        (a* (list 'a nil))
        (b* (list 'b nil))
        (c* (list 'c nil))
        (d* (list 'd nil))
        (e* (list 'e nil)))
    (format t "a = ~A, b = ~A, c = ~A, d = ~A -- setting next/end of 'b' to 'a'~%" a b c d)
    (setf (cddr b) a) ; cddr = "invisible" nil
    (format t "a = ~A, b = ~A, c = ~A, d = ~A -- setting 'prev' of 'b' to 'c'~%" a b c d)
    (setf (cadr b) c) ; cadr = prev-pointer
    (format t "a = ~A, b = ~A, c = ~A, d = ~A -- setting 'a to 'aa~%" a b c d)
    (setf (car a) 'aa)
    (format t "a = ~A, b = ~A, c = ~A, d = ~A -- setting next/end of a to d~%" a b c d)
    (setf (cddr a) d) ; cddr = "invisible" nil
    (format t "a = ~A, b = ~A, c = ~A, d = ~A -- setting next of 'b' to e~%" a b c d)
    ;(setf (cddr b) e) 
    (format t "a = ~A, b = ~A, c = ~A, d = ~A, e = ~A -- setting next of c to e~%" a b c d e)
    (setf (cddr c) e) 
    (format t "a = ~A, b = ~A, c = ~A, d = ~A, e = ~A -- ~%" a b c d e)

    (set-next b* a*)
    (set-prev b* c*)
    (set-data a* 'aa)
    ;(setf (car a*) 'aa)
    (set-next a* d*)
    ;(set-next b* e*)
    (set-next c* e*)
    (format t "b = ~A, b* = ~A~%" b b*)
    
))

(defun set-next (node next)
  (setf (cddr node) next))
(defun set-prev (node prev)
  (setf (cadr node) prev))
(defun set-data (node data)
  (setf (car node) data))


(test)
