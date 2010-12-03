(defun make-node (item &key (prev nil) (next nil))
  (if (null next)
      (list item prev)
      (list item prev next)))

(defun add-node (node linked-list)
  linked-list)

(defun set-next (node next)
  (setf (cddr node) next))
(defun set-prev (node prev)
  (setf (cadr node) prev))
(defun set-data (node data)
  (setf (car node) data))

(defvar *prev* (list 'previous nil))
(defvar *curr* (list 'current nil))
(defvar *next* (list 'next nil))

(defun test ()
  (format t "set next~%")
  (set-next *curr* *next*)
  (format t "curr: ~A~%" *curr*)
  (format t "set prev~%")
  (set-prev *curr* *prev*)
  (format t "curr: ~A~%" *curr*)
  )

(test)
