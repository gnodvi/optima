;===============================================================================
;
;
;===============================================================================

(defvar CUR_DIR "p")

(load "./a-comm.cl")

;===============================================================================
;
;-------------------------------------------------------------------------------
(defun EDIT (argus)

  ;(load "l-edit.cl")
  (my_load "p-edit.cl" CUR_DIR)

  (run_cdr_argus (first argus) argus "EDIT ..")

)
;===============================================================================
(defun BOOL (argus)

  (my_load "l-pops.cl" CUR_DIR)
  (my_load "n-mgen.cl" CUR_DIR)

  (my_load "p-prog.cl" CUR_DIR)

  (load "p_bool.li")
  (run_cdr_argus (first argus) argus "BOOL ..")

)
;-------------------------------------------------------------------------------
(defun OPTI (argus)

  (my_load "b-comp.cl" CUR_DIR)
  (my_load "n-func.cl" CUR_DIR)

  (my_load "l-pops.cl" CUR_DIR)
  (my_load "n-mgen.cl" CUR_DIR)

  (my_load "p-prog.cl" CUR_DIR)
  (my_load "p-comm.cl" CUR_DIR)

  (load "p_opti.li")
  (run_cdr_argus (first argus) argus "GENP ..")

)
;===============================================================================
; ==============================================================================

  (my_load "b-comp.cl" CUR_DIR) ; оказываeтся тожe нужeн для CELL

  (my_load "g-main.cl" CUR_DIR)
  (my_load "g-nets.cl" CUR_DIR)

;-------------------------------------------------------------------------------
(defun KOZA (argus)

  (my_load "n-func.cl" CUR_DIR)
  (my_load "l-pops.cl" CUR_DIR)
  (my_load "n-mgen.cl" CUR_DIR)
  
  (my_load "p-prog.cl" CUR_DIR)
  (my_load "p-comm.cl" CUR_DIR)

  (load "p_koza.li")
  (run_cdr_argus (first argus) argus "KOZA ..")
)
;-------------------------------------------------------------------------------
(defun REGR (argus)

  (my_load "n-func.cl" CUR_DIR)
  (my_load "l-pops.cl" CUR_DIR)
  (my_load "n-mgen.cl" CUR_DIR)
  
  (my_load "p-prog.cl" CUR_DIR)
  (my_load "p-comm.cl" CUR_DIR)

  (load "p_regr.li")
  (run_cdr_argus (first argus) argus "REGR ..")

)
;-------------------------------------------------------------------------------


(READ_AND_CALL_ARGUS  CUR_DIR)

; ==============================================================================
; TODO: 

; - попробовать GP (для всeх булeвых функций) а такжe ADF;
; - улучшить ADF, введя отдельную библиотеку для функций и стат. инфу на них;

; - BOOL: эквивалентные преобразования булевых выражений (автомат. поиск формул);
; - REAL: вместо защищенных функций - обработку особых ситуаций и их учет;

;===============================================================================
