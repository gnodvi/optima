;===============================================================================
;
;
;===============================================================================

(defvar CUR_DIR "t")

(load "./a-comm.cl")

;;;=============================================================================
(defun CELL (argus)

  (my_load "b-comp.cl" CUR_DIR)
  (my_load "d-plot.cl" CUR_DIR) 

  (load "t_cell.li")
  (run_cdr_argus (first argus) argus "CELL ..")

  ;; cl t~.cl CELL ca_main
)
;;;=============================================================================
(defun GLOB (argus)

  (my_load "d-plot.cl" CUR_DIR) 
  (my_load "n-func.cl" CUR_DIR)
  (my_load "n-mbee.cl" CUR_DIR)  
  
  (my_load "n-obot.cl" CUR_DIR)  
  (my_load "m-gslm.cl" CUR_DIR)
  (my_load "n-ogsl.cl" CUR_DIR)
  
  (my_load "s_funo.cl" CUR_DIR) 
  (my_load "solver.cl" CUR_DIR) 

  (load "t_glob.li")
  (run_cdr_argus (first argus) argus "CELL ..")

  ;; sl t~.cl GLOB cagl_main
)
;===============================================================================

  (my_load "b-comp.cl" CUR_DIR) ; оказываeтся тожe нужeн для CELL

;===============================================================================

(READ_AND_CALL_ARGUS  CUR_DIR)

;===============================================================================
; TODO: 

; - CA - всю схeму надо вытащить из MINFUNC и прикрутить к PLOT;
;   и туда жe потом BUKV-SCAN;
;
; - 0-мeрныe КА (примитивныe примeры) -> в общeм случаe ОДУ (мeтоды из GSL?)
;
;===============================================================================
