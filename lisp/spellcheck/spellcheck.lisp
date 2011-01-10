;;;; Literal translation of Peter Norvig's spell corrector (http://norvig.com/spell-corrector.html)
;;;; by Mikael Jansson <mikael@lisp.se>
;;;;
;;;; 1e6 times faster than the Python version on a Quad Xeon 2,6 GHz.

(defpackage :spellcheck
  (:use :cl))
(in-package :spellcheck)
(ql:quickload "cl-ppcre")
(ql:quickload "alexandria")

(defun words (string)
  (cl-ppcre:all-matches-as-strings "[a-z]+" string))

(defun train (words)
  (let ((frequency (make-hash-table :test 'equal)))
    (dolist (word words)
      ;; default 1 to make unknown words OK
      (setf (gethash word frequency) (1+ (gethash word frequency 1)))
      )
    frequency))

(defvar *freq* (train (words (nstring-downcase (alexandria:read-file-into-string #P"big.txt"))))
(defvar *alphabet* "abcdefghijklmnopqrstuvwxyz")

;;; edits of one character
(defun edits-1 (word)
  (let* ((splits     (loop for i from 0 upto (length word)
                           collecting (cons (subseq word 0 i) (subseq word i))))
         (deletes    (loop for (a . b) in splits
                           when (not (zerop (length b)))
                            collect (concatenate 'string a (subseq b 1))))
         (transposes (loop for (a . b) in splits
                           when (> (length b) 1)
                            collect (concatenate 'string a (subseq b 1 2) (subseq b 0 1) (subseq b 2))))
         (replaces   (loop for (a . b) in splits
                           nconcing (loop for c across *alphabet*
                                          when (not (zerop (length b)))
                                            collect (concatenate 'string a (string c) (subseq b 1)))))
         (inserts    (loop for (a . b) in splits
                           nconcing (loop for c across *alphabet*
                                          collect (concatenate 'string a (string c) b)))))
    (nconc deletes transposes replaces inserts))) 

(defun known-edits-2 (word)
  (loop for e1 in (edits-1 word) nconcing
        (loop for e2 in (edits-1 e1)
              when (multiple-value-bind (value pp) (gethash e2 *freq* 1) pp)
                collect e2)))

(defun known (words)
  (loop for word in words
        when (multiple-value-bind (value pp) (gethash word *freq* 1) pp)
        collect word))

(defun correct (word)
  (loop for word in (or (known (list word)) (known (edits-1 word)) (known-edits-2 word) (list word))
        maximizing (gethash word *freq* 1)
        finally (return word)))

(time (loop for i from 1 to 1000000 do (correct "something")))

