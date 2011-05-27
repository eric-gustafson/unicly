;;; :FILE-CREATED <Timestamp: #{2011-04-11T11:51:10-04:00Z}#{11151} - by MON>
;;; :FILE unicly/unicly-types.lisp
;;; ==============================


(in-package #:unicly)
;; *package*

(deftype uuid-ub48 ()
 '(unsigned-byte 48))

(deftype uuid-ub32 ()
 '(unsigned-byte 32))

(deftype uuid-ub24 ()
  '(unsigned-byte 24))

(deftype uuid-ub16 ()
  '(unsigned-byte 16))

(deftype uuid-ub8 ()
  '(unsigned-byte 8))

(deftype uuid-byte-string ()
  '(simple-array character (16)))

(deftype uuid-bit-vector (&optional size)
   (let ((sz (or size '*)))
     `(simple-bit-vector ,sz)))

(deftype uuid-bit-vector-128 ()
  '(uuid-bit-vector 128))

;; (upgraded-array-element-type 
;;  (type-of (make-array 128 :element-type 'bit :initial-element 0)))

(deftype uuid-bit-vector-8 ()
  '(uuid-bit-vector 8))

(deftype uuid-bit-vector-null ()
  '(and uuid-bit-vector-128
    (satisfies %uuid-bit-vector-null-p)))

(deftype uuid-byte-array (&optional size)
  (let ((sz (or size '*)))
    `(simple-array uuid-ub8 (,sz))))

;; UUID v3 MD5 returns an array of type: (simple-array (unsigned-byte 8) (16))
(deftype uuid-byte-array-16 ()
  ;; expands to: (simple-array (unsigned-byte 8) (16)))
  '(uuid-byte-array 16))

(deftype uuid-byte-array-null ()
  ;; expands to: (simple-array (unsigned-byte 8) (16)))
  '(and uuid-byte-array-16 (satisfies %uuid-byte-array-null-p)))

;; UUID v5 SHA1 returns an array of type: (simple-array (unsigned-byte 8) (20))
(deftype uuid-byte-array-20 ()
  ;; expands to: (simple-array (unsigned-byte 8) (20))
  '(uuid-byte-array 20))

(deftype uuid-string-32 ()
  '(array character (32)))

(deftype uuid-string-36 ()
  '(array character (36)))

(deftype uuid-hex-string-32 ()
  '(and uuid-string-32 (satisfies string-all-hex-char-p)))

(deftype uuid-hex-string-36 ()
  '(and uuid-string-36 (satisfies uuid-hex-string-36-p)))


;;; ==============================
;;; :UUID-TYPE-PREDICATES
;;; ==============================

;;; :NOTE Following definition is unused on the assumption that it is guaranteed
;;;  that the following always returns (SIMPLE-BIT-VECTOR 0) on all implementations:
;;;  (type-of (make-array 0 :element-type 'bit :initial-element 0))
(defun uuid-verify-bit-vector-simplicity (putative-simple-bit-vector)
  (declare (bit-vector putative-simple-bit-vector)
           (optimize (speed 3)))
  (and (eql (array-element-type putative-simple-bit-vector) 'bit)
       (null (adjustable-array-p putative-simple-bit-vector))
       (null (array-has-fill-pointer-p putative-simple-bit-vector))))

(defun uuid-bit-vector-128-p (maybe-uuid-bit-vector-128)
  (typep maybe-uuid-bit-vector-128 'uuid-bit-vector-128))

(defun uuid-string-32-p (maybe-uuid-string-32)
  (typep maybe-uuid-string-32 'uuid-string-32))

(declaim (inline uuid-string-36-p))
(defun uuid-string-36-p (maybe-uuid-string-36)
  (declare (optimize (speed 3)))
  (typep maybe-uuid-string-36 'uuid-string-36))

(defun uuid-byte-array-p (maybe-uuid-byte-array)
  (typep maybe-uuid-byte-array 'uuid-byte-array))

(defun uuid-byte-array-16-p (maybe-uuid-byte-array-16)
  (typep maybe-uuid-byte-array-16 'uuid-byte-array-16))

(defun uuid-byte-array-20-p (maybe-uuid-byte-array-20)
  (typep maybe-uuid-byte-array-20 'uuid-byte-array-20))

(declaim (inline %uuid-byte-array-null-p))
(defun %uuid-byte-array-null-p (byte-array-maybe-null)
  ;; (%uuid-byte-array-null-p (uuid-byte-array-zeroed))
  ;; (%uuid-byte-array-null-p (make-array 16 :element-type 'uuid-ub8 :initial-element 1))
  (declare (uuid-byte-array-16 byte-array-maybe-null)
           (optimize (speed 3)))
  (loop for x across byte-array-maybe-null always (zerop x)))

;; (uuid-byte-array-null-p (make-array 20 :element-type 'uuid-ub8 :initial-element 1))

(defun uuid-byte-array-null-p (byte-array-maybe-null)
  (typep byte-array-maybe-null 'uuid-byte-array-null))

(defun uuid-byte-string-p (maybe-uuid-byte-string)
  (typep maybe-uuid-byte-string 'uuid-byte-string))

(defun uuid-hex-string-32-p (maybe-uuid-hex-string-32)
  (typep maybe-uuid-hex-string-32 'uuid-hex-string-32))

(declaim (inline uuid-hex-string-36-p))
(defun uuid-hex-string-36-p (maybe-uuid-hex-string-36)
  (declare (inline string-all-hex-char-p
                   uuid-string-36-p)
           (optimize (speed 3)))
  (when (uuid-string-36-p maybe-uuid-hex-string-36)
    (let ((split-uuid 
           (split-sequence:split-sequence-if #'(lambda (x) 
                                                 (declare (character x))
                                                 (char= #\- x))
                                             (the uuid-string-36 maybe-uuid-hex-string-36))))
      (declare (list split-uuid))
      (and (= (length split-uuid) 5)
           (equal (map 'list #'length split-uuid) (list 8 4 4 4 12))
           (loop
              for chk-hex in split-uuid
              always (string-all-hex-char-p (the string chk-hex)))))))

;;; ==============================


;; Local Variables:
;; indent-tabs-mode: nil
;; show-trailing-whitespace: t
;; mode: lisp-interaction
;; package: unicly
;; End:

;;; ==============================
;;; EOF
