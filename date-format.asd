(in-package :cl-user)
(defpackage :date-format.asd
  (:use :cl :asdf))
(in-package :date-format.asd)

(defsystem date-format
  :depends-on (:cl-ppcre)
  :components ((:file "date-format")))