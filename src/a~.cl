; -*-   mode: lisp ; coding: koi8   -*- ----------------------------------------

;-------------------------------------------------------------------------------

(defvar CUR_DIR "a")

(load "./a-comm.cl")

;-------------------------------------------------------------------------------
(defun COMM (argus)

  (run_cdr_argus (first argus) argus "COMM ..")
)
;-------------------------------------------------------------------------------

(READ_AND_CALL_ARGUS  CUR_DIR)

;-------------------------------------------------------------------------------

; cl a~.cl COMM rand_1
; cl a~.cl COMM rand_4
; cl a~.cl COMM rand_2

;===============================================================================
