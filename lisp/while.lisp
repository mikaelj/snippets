defmacro while (test &rest body)
  `(loop while ,test do ,@body))

(defvar *foo* 0)
(while (< *foo* 10)
  (format t "foo: ~A~%" *foo*)
  (incf *foo*))
