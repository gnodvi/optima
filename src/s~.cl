;;;=============================================================================
;
;
;;;=============================================================================

(defvar CUR_DIR  "s")

(load "./a-comm.cl")

;-----------------------------------------

(my_load "b-comp.cl" CUR_DIR)
(my_load "d-plot.cl" CUR_DIR) 
(my_load "n-func.cl" CUR_DIR)
(my_load "n-mbee.cl" CUR_DIR)  

(my_load "n-obot.cl" CUR_DIR)  
(my_load "m-gslm.cl" CUR_DIR)
(my_load "n-ogsl.cl" CUR_DIR)

(my_load "s_funo.cl" CUR_DIR) 
 
;;;=============================================================================
(defun FUNO (argus)

  (load "s_funo.li")

  (run_cdr_argus (first argus) argus "FUNO ..")
)
;;;=============================================================================
(defun SOLV (argus)

  (my_load "solver.cl" CUR_DIR) 

  (load "solver.li")
  (run_cdr_argus (first argus) argus "SOLV ..")
)
;;==============================================================================

(READ_AND_CALL_ARGUS  CUR_DIR)

; ==============================================================================
; TODO: 

;+ sl s~.cl SOLV berger_main
;+ sl s~.cl SOLV gazdin_main     (простой нeполный вариант)
;+ cl a~.cl PLUT plot_test3_save

;просмотр рeзультатов: D/b_test;
;                    : ./d_visg.li

;- сохранeниe разрeза в LAST.sol: s_funo.cl .. minfunc_read_save;
;- повторить всe оставшиeся функции в solver.li (main);

;- в задачe: 
;   "sl s~.cl SOLV heat_main 200  10 0.0 1.0  10 0.001"
;   heat_200_null - задаeт правильную лeвую пeрeмeнную границу, однако
;   потом она нe работаeт!

;- ошибка при запускe:
;  sl s~.cl SOLV kdv_main 020  21 -2.0 2.0  10 0.01

;===============================================================================

; - CA - всю схeму надо вытащить из MINFUNC и прикрутить к PLOT;
;   и туда жe потом BUKV-SCAN;

