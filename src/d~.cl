;===============================================================================
;
;
;===============================================================================

(defvar CUR_DIR "d")

(load "./a-comm.cl")

;-------------------------------------------------------------------------------
(defun PLUT (argus)

  (my_load "b-comp.cl" CUR_DIR)
  (my_load "d-plot.cl" CUR_DIR)

  (run_cdr_argus (first argus) argus "PLUT ..")

  ;; cl d~.cl PLUT plot_test1
  ;; cl d~.cl PLUT plot_test3_save

  ;; cl d~.cl PLUT plot_test3
)
;===============================================================================


(READ_AND_CALL_ARGUS  CUR_DIR)

; ==============================================================================
; TODO: 

; - ������e��e �������� � ������e ������ � �������;
; - ������������ ��� PLOT-1D;

;===============================================================================
