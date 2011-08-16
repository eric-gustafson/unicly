;;; :FILE-CREATED <Timestamp: #{2011-04-14T12:41:41-04:00Z}#{11154} - by MON>
;;; :FILE unicly/unicly.asd
;;; ==============================

;; ,----
;; | "I am sick to death of knee-jerk anti-LOOPism and I am beginning to
;; |  irrationally regard it as a plot to disable me as a programmer by
;; |  excommunicating my useful tools."
;; |
;; |     :SOURCE "Knee-jerk Anti-LOOPism and other E-mail Phenomena" p 17 
;; `---- :SEE http://ccs.mit.edu/papers/CCSWP150.html



(defpackage #:unicly-asd (:use #:common-lisp #:asdf))

(in-package #:unicly-asd)

(defsystem #:unicly
  :name "unicly"
  :licence "MIT"
  :version "04-18-2011"
  :maintainer "MON KEY"
  :description "UUID Generation per RFC 4122"
  :long-description "Lisp implementation of RFC 4122"
  :serial t
  :depends-on (:ironclad 
               :split-sequence
               #-sbcl :flexi-streams)
  :components ((:file "package")
               (:file "unicly-specials")
               (:file "unicly-utils")
               (:file "unicly-macros")
               (:file "unicly-types")
               (:file "unicly-class")
               (:file "unicly-bit-vectors")
               (:file "unicly-conditions")
               (:file "unicly"      )
               (:file "unicly-docs" )
               ;; (:file "unicly-compat")
               ;; (:file "unicly-deprecated")
               ))

(defmethod asdf:perform :after ((op asdf:load-op) (system (eql (asdf:find-system :unicly))))
  (pushnew :unicly cl:*features*)
  (let ((chk-if (probe-file (make-pathname 
                             :directory `(,@(pathname-directory (truename (asdf:system-source-directory :unicly))))
                             :name "unicly-loadtime-bind" :type "lisp"))))
    (and chk-if (load  chk-if))))


;;; ==============================
;;; EOF
