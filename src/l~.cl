;===============================================================================
;
;
;===============================================================================

(defvar CUR_DIR "l")

(load "./a-comm.cl")

;-------------------------------------------------------------------------------
(defun CPOP (argus)

  (my_load "l-pops.cl" CUR_DIR) ;

  (run_cdr_argus (first argus) argus "CPOP ..") 
)
;-----------------------------------------
;
;-------------------------------------------------------------------------------
(defun SORT-TEST (argus)

  (my_load "l-sort.cl" CUR_DIR) (use-package :a_sort)

  (run_cdr_argus (first argus) argus "SORT ..")
)
;-------------------------------------------------------------------------------
(defun SORT-TABS (argus)

  (my_load "l-sort.cl" CUR_DIR) (use-package :a_sort)
  (my_load "l-tabs.cl" CUR_DIR) (use-package :a-ctab)

  (load "l_test.li")
  (run_cdr_argus (first argus) argus "TEST ..")
)
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
(defun TOUR (argus)

  (my_load "l-tabs.cl" CUR_DIR) (use-package :a-ctab)

  (load "l-tour.cl")
  (run_cdr_argus (first argus) argus "TEST ..")

)
;===============================================================================


(READ_AND_CALL_ARGUS  CUR_DIR)

; ==============================================================================
; TODO: 

; - ���e����� ���e������e����� ����e�� (��e��� �� ��e���);
; - ������ ��������� ���e ��e���� ������ ����e�� ���-���;
; - 
; - ���e�������e ���������� (���ee ������ ��������� �����e���� � ����� ������);
; - �������� ����������, ����� ����������� ���������� ��� �������� ����������;

;===============================================================================
