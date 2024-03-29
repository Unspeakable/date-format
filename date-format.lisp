(defpackage :date-format
  (:use :cl)
  (:export :date-format))

(in-package :date-format)

(defvar *name-of-month* #("January" "February" "March" "April" "May"
                          "June" "July" "August" "September" "October"
                          "Norvember" "December"))
(defvar *name-of-week* #("Monday" "Tuesday" "Wednesday" "Thursday"
                         "Friday" "Saturday" "Sunday"))

(defun date-format (utime format)
  (multiple-value-bind (second minute hour date month year day-of-week)
      (decode-universal-time utime)
    (labels ((02num (value) (format nil "~2,'0D" value))
             (|%Y| () (format nil "~4,'0D" year))
             (|%y| () (02num (rem year 100)))
             (|%m| () (02num month))
             (|%B| () (aref *name-of-month* (1- month)))
             (|%b| () (subseq (|%B|) 0 3))
             (|%d| () (02num date))
             (|%H| () (02num hour))
             (|%I| () (02num (1+ (mod (1- hour) 12))))
             (|%p| () (if (<= 12) "PM" "AM"))
             (|%M| () (02num minute))
             (|%S| () (02num second))
             (|%A| () (aref *name-of-week* day-of-week))
             (|%a| () (subseq (|%A|) 0 3)))
      (loop :for (key . fn)
              :in `(("%Y" . ,#'|%Y|) ("%y" . ,#'|%y|) ("%m" . ,#'|%m|)
                    ("%B" . ,#'|%B|) ("%b" . ,#'|%b|) ("%d" . ,#'|%d|)
                    ("%H" . ,#'|%H|) ("%I" . ,#'|%I|) ("%p" . ,#'|%p|)
                    ("%M" . ,#'|%M|) ("%S" . ,#'|%S|) ("%A" . ,#'|%A|)
                    ("%a" . ,#'|%a|))
         :do (setf format (ppcre:regex-replace-all key format (funcall fn))))))
  format)
