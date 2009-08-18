(defun make-password (length)
  (let ((capital (char-code #\A))
        (small (char-code #\a))
        (number (char-code #\0)))
    (coerce (loop for i from 0 to length
                  and p = (random 3)
                  when (= p 0) collect (code-char (+ capital (random 26)))
                  when (= p 1) collect (code-char (+ small (random 26)))
                  when (= p 2) collect (code-char (+ number (random 10))))
            'string)))

(make-password 8)
