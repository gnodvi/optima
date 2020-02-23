;===============================================================================
;
;
;===============================================================================

(defvar CUR_DIR  "o")

(load "./a-comm.cl")

;-------------------------------------------------------------------------------
(defun ANTS (argus)

  (my_load "b-comp.cl" CUR_DIR)
  (my_load "g-main.cl" CUR_DIR)
  (my_load "g-nets.cl" CUR_DIR)

  (load "o-ants.cl")
  (run_cdr_argus (first argus) argus "ANTS ..")

  ;; cl o~.cl ANTS ant_test_bin
  ;; cl o~.cl ANTS ant_test_old 2
)
;-------------------------------------------------------------------------------
(defun GENA (argus)

  ;(format t "GENA .. 1 ~%")

  (my_load "b-comp.cl" CUR_DIR)
  (my_load "g-main.cl" CUR_DIR)
  (my_load "g-nets.cl" CUR_DIR)

  (my_load "l-pops.cl" CUR_DIR) ; для гeнeтeичeских тeстов
  (my_load "n-mgen.cl" CUR_DIR)
  (my_load "o-ants.cl" CUR_DIR)

  ;(format t "GENA .. 8 ~%")
  (load "o_gena.li")
  ;(format t "GENA .. 9  argus= ~s ~%" argus)

  (run_cdr_argus (first argus) argus "ANTS ..")

  ;; cl o~.cl GENA ant_test_ga @ 11 2
)
;-------------------------------------------------------------------------------
(defun GENP (argus)

  (my_load "l-pops.cl" CUR_DIR)
  (my_load "n-mgen.cl" CUR_DIR)
  (my_load "p-prog.cl" CUR_DIR) ; для тeстов ГП

  ;(my_load "o_gena.li" CUR_DIR)
  (my_load "o-ants.cl" CUR_DIR)

  (load "o_genp.li")
  (run_cdr_argus (first argus) argus "ANTS ..")

  ;; cl o~.cl GENP run s_07_2 01
)
;-------------------------------------------------------------------------------
;===============================================================================

(READ_AND_CALL_ARGUS  CUR_DIR)

;===============================================================================
;
;
; cl o~.cl GENA ant_test_ga @ 11 2
;
; error:
; `(INTEGER 0 (,ARRAY-DIMENSION-LIMIT))
;-------------------------------------------------------------------------------
