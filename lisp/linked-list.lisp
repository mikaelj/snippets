(defun make-node (item &optional (next-node nil))
  (if (listp next-node)
    (list item next-node)
    (list item nil)))

(defun add-node (node linked-list)
  (setf (cdr linked-list) node)
  linked-list)

(defun set-data (node data)
  (setf (car node) data))

(defun test ()
  (let ((a (make-node 'apa))
        (b (make-node 'bepa)))
    (format t "a: ~A~%" a)
    (format t "b: ~A~%" b)
    (format t "adding a to b~%")
    (add-node a b)
    (format t "b is now: ~A~%" b)
    (format t "setting car of a to 'baz~%")
    ;(setf (car a) 'baz)
    (set-data a 'baz)
    (format t "b is now: ~A~%" b)
    ))


