;;; Python-ish splice, first attempt.
(defun splice (list &key (start 0) (end nil) (step 1))
  (let* ((l (length list))
         (end (- (cond ((null end)  l)
                     ((< end 0)  (+ l end))
                     ((= end l)  (1- l))
                     (t end))
                 start))
         (sublist (subseq list start end)))
    (loop for i from 0 to end
          for elem in sublist
          when (zerop (mod i step))
          collect elem)))

;;; Usage

(defparameter *test* '(1 2 3 4 5 6 7))
(splice list :step 3)
(splice list :start 1 :step 3)
(splice *test* :end -1)


