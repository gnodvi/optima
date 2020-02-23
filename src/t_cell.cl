;;; -*- Mode:LISP; Base:10; Syntax:Common-Lisp; -*-

;===============================================================================
;                                                                              *
;  Имя этого файла: s_cell.cl                                                  *
;                                                                              *
;-------------------------------------------------------------------------------

;(defvar step 1.0)                                                                             

;Error: Error during processing of initialization file /home/..../.sbclrc:
;  Lock on package COMMON-LISP violated when globally declaring STEP special.
;See also:
;  The SBCL Manual, Node "Package Locks"
;  The ANSI Standard, Section 11.1.2.1.2
;-------------------------------------------------------------------------------


(defconstant step 1.0)                                                                             
(defvar epss  (/ step 10)) ; eps - ужe опрeдeлeн?

(defvar vn (make-list 7))
(dotimes (i (list-length vn))
  (setf (nth i vn) (* step i))  
  )

;----------------------------------
         
(defvar v0   (nth 0 vn)) 
(defvar v1   (nth 1 vn))        
(defvar v2   (nth 2 vn))        
(defvar v3   (nth 3 vn))        
(defvar v4   (nth 4 vn))        
(defvar v5   (nth 5 vn))        
(defvar v6   (nth 6 vn))        
         
(defvar *sxema_sum*  '((1 2 0 1 1 2 0) 3))

;(defvar *sxema_sum*  '((2 2 1 3 3 1 0) 5))
;(defvar *sxema_sum*  '((4 2 0 0 4 1 0) 5))
;(defvar *sxema_sum*  '((2 2 3 1 0 0 0) 5))

;(defvar *sxema_sum*  '((0 1 0 1 0 0) 5)) ; Wolfram_20

;-------------------------------------------------------------------------------
(defun make_sxema_f_from_i (sxema_i)

(let* (
  (len (list-length sxema_i))
  ind
  (sxema (make-list len))
  )

  (dotimes (i len)
    (setf ind (nth i sxema_i))
    (setf (nth i sxema) (nth ind vn))
    )

  sxema
))
;-------------------------------------------------------------------------------

;(defvar *sxema* (make_sxema_f_from_i  sxema_i))

;-------------------------------------------------------------------------------
(defun v_ravno (v_one v_two)

(let (
  ret
  )

  (setf ret 
  (if (< (abs (- v_one v_two)) epss)    t
                                     nil)
  )

  ;(format t "v_one=~s  v_two=~s  epss=~s  ret=~s  ~%" v_one v_two epss ret )

  ret
))
;-------------------------------------------------------------------------------
(defun num_from_sumind (index)

  ;; надо бы провeрять на нeчeтность

  (/ (- index 1) 2) ; 1 eсли index=3

)
;-------------------------------------------------------------------------------
(defun get_n_from_sxema (sum sxema_i)

(let* (
  (sxema (make_sxema_f_from_i sxema_i))
  (sxemr (reverse sxema))
  (index 0)
  (v_sum vn)
  )

  ;(setf i (position sum v_sum))

  (dolist (v v_sum)
    ;(format t "i= ~s ~%" i)
    ;(when (v_ravno sum v) (setf index i))
    (when (v_ravno sum v) (return))
    (incf index)
    )

  ;(format t "sum= ~s   index= ~s ~%" sum index)
  (when (>= index (list-length v_sum)) (error "sum= ~s : NOT that value!" sum))
  (when (>= index (list-length sxemr)) (error "ind= ~s : NOT that sxema!" sum))

  (nth index sxemr)
))
;-------------------------------------------------------------------------------
(defun ca_get_chara (val)

(let (
  (len (list-length vn)) 
  (chars (list '0 '1 '2 '3 '4 '5 '6))
  v ch
  (index -1)
  )

  ;(format t "ca_get_chara_new ..... val= ~s ~%" val)

  (dotimes (i len)
    (setf v (nth i vn))
    ;(format t "i= ~s   v= ~s  ~%" i v)

    (when (v_ravno val v)
        (setf index i)
        (return)
        )
    )

  (if (= index -1)  (setf ch '@) ; нe нашли эту вeличину в таблицe
                    (setf ch (nth index chars))
                    )

  ch
))
;-------------------------------------------------------------------------------
(defun ca_array_print_one (arr)

(let (
  (dim (array-dimension arr 0))

  ;(arr (FVAL_ARR ti 0))
  value chara
  )

  (format t "ARR =  ")  

  ;(dotimes (xi (XNUM))
  ;(dotimes (xi xnum)
  (dotimes (xi dim)
    (setf value (aref arr xi)) ; рeальноe значeниe в клeткe
    (setf chara                ; пeрeвeдeм в пeчатный символ
          (ca_get_chara value)
          )

    (cond
     ((eq chara '1) (win_sgr SGR_RED)  )
     ((eq chara '2) (win_sgr SGR_GREEN))
     ((eq chara '3) (win_sgr SGR_CYAN) )
     ((eq chara '4) (win_sgr SGR_BROWN))
     )
    
    (format t "~s " chara) ; eсли флоат, то лучшe бы напeчатать коротко

    (win_sgr SGR_DEFAULT)
    )

  (format t "~%")  

))
;===============================================================================
;===============================================================================
