;;; -*- Mode:LISP; Base:10; Syntax:Common-Lisp; -*-

;;;=============================================================================

;;;=============================================================================

;(load "t-nets.cl")

;===============================================================================

;(defvar num_state :num_state)
;(defvar num_sbits :num_sbits)

(defvar *num_states*     :*num_states*)
(defvar *num_state_bits* :*num_state_bits*)
(defvar *num_edge_bits*  :*num_edge_bits*)

(defvar *last_eat_num* :*last_eat_num*)
;===============================================================================
; 
;===============================================================================

(defstruct POLE
    i j dir 
    arr
    eat num
)

(defvar *pole* :unbound)

(defvar number_of_foods :unbound)
(defvar max_steps :unbound)
(defvar array_make_func :unbound)

; -----------------------------------------------------
; One randomly generated computer program (which will be called the "quilter" 
; because it traces a quilt-like tessellating pattern across the
; toroidal grid) moves and turns without looking. It consists of nine points:

(defvar ant_quilter  '(PROGN (RIGHT)
                             (PROGN (MOVE) (MOVE) (MOVE))
                             (PROGN (LEFT) (MOVE)))
  )

; -----------------------------------------------------
; One randomly generated computer program (the "avoider") actually correctly 
; takes note of the portion of food along the trail before finding
; the first gap in the trail, then actively avoids this food by carefully moving 
;  it until it returns to its starting point. It continues with this
; unrewarding behavior until the time runs out, and never eats any food.
; The S-expression for the avoider has seven points:

(defvar ant_avoider  '(IF-FOOD-AHEAD 
                       (RIGHT)
                       (IF-FOOD-AHEAD (RIGHT)
                                      (PROGN (MOVE) (LEFT)))
                       )
  )

; -----------------------------------------------------

(defvar ant_0_err '(IF-FOOD-AHEAD (MOVE)
                            (PROGN (LEFT)
                                   (PROGN (IF-FOOD-AHEAD (MOVE)
                                                         (RIGHT))
                                          (PROGN (RIGHT)
                                                 (PROGN (LEFT)      ;;
                                                        (RIGHT))))  ;;
                                   (PROGN (IF-FOOD-AHEAD (MOVE)
                                                         (LEFT))
                                          (MOVE))))
      )
;; исключили пустоe кручeниe (PROGN (LEFT) (RIGHT))
      
(defvar ant_0 '(IF-FOOD-AHEAD (MOVE)
                            (PROGN (LEFT)
                                   (PROGN (IF-FOOD-AHEAD (MOVE)
                                                         (RIGHT))
                                          (PROGN (RIGHT)
                                                 ))
                                   (PROGN (IF-FOOD-AHEAD (MOVE)
                                                         (LEFT))
                                          (MOVE))))
      )

;;;-----------------------------------------------------------------------------
      
(defvar ant_angeline  '(IF-FOOD-AHEAD 
                        (MOVE)   
                        (PROGN (RIGHT)    ; --> 2
                               (IF-FOOD-AHEAD ; 2
                                (MOVE)   
                                (PROGN (RIGHT)    ; --> 3
                                       (IF-FOOD-AHEAD ; 3
                                        (MOVE)
                                        (PROGN (RIGHT)    ; --> 4 
                                               (IF-FOOD-AHEAD ; 4 
                                                (MOVE)
                                                (PROGN (RIGHT)    ; --> 5
                                                       (IF-FOOD-AHEAD ; 5
                                                        (MOVE)
                                                        (MOVE) 
                                                        )
                                                       )
                                                )
                                               )
                                        ) 
                                       )
                                )
                               )
                        )
  )

;;;------------------------
(defun angeline_5 ()

  (eval '(IF-FOOD-AHEAD 
   (MOVE)
   (MOVE) 
   ))
)
;;;------------------------
(defun angeline_4 ()

  (eval '(IF-FOOD-AHEAD 
   (MOVE)
   (PROGN (RIGHT) (angeline_5)) 
   ))
)
;;;------------------------
(defun angeline_3 ()

  (eval '(IF-FOOD-AHEAD 
   (MOVE)
   (PROGN (RIGHT) (angeline_4)) 
   ))
)
;;;------------------------
(defun angeline_2 ()

  (eval '(IF-FOOD-AHEAD 
   (MOVE)
   (PROGN (RIGHT) (angeline_3)) 
   ))
)
;;;------------------------

(defvar ant_angeline_new  '(IF-FOOD-AHEAD 
                        (MOVE)   
                        (PROGN (RIGHT) (angeline_2))
                        )
  )

;;;-----------------------------------------------------------------------------

(defun tsarev_1 ()
  (eval '(IF-FOOD-AHEAD 
   (PROGN (MOVE)  (tsarev_1)) 
   (PROGN (MOVE)) 
   ))
)

(defun tsarev_2 ()
  (eval '(IF-FOOD-AHEAD 
   (PROGN (MOVE)) 
   (PROGN (LEFT) (tsarev_4)) 
   ))
)

(defun tsarev_3 ()
  (eval '(IF-FOOD-AHEAD 
   (PROGN (MOVE)  (tsarev_2)) 
   (PROGN (LEFT)  (tsarev_2)) 
   ))
)

(defun tsarev_4 ()
  (eval '(IF-FOOD-AHEAD 
   (PROGN (MOVE)  (tsarev_1)) 
   (PROGN (RIGHT) (tsarev_1)) 
   ))
)

(defvar ant_tsarev_83g '(IF-FOOD-AHEAD 
                         (MOVE)   
                         (PROGN (RIGHT) (tsarev_3))
                         )
  )

;;;-----------------------------------------------------------------------------

(defun tsar_1 ()
  (eval '(IF-FOOD-AHEAD 
   (PROGN (MOVE)   (tsar_5)) 
   (PROGN (RIGHT)  (tsar_2)) 
   ))
)

(defun tsar_2 ()
  (eval '(IF-FOOD-AHEAD 
   (MOVE)
   (PROGN (RIGHT)  (tsar_4)) 
   ))
)

(defun tsar_3 ()
  (eval '(IF-FOOD-AHEAD 
   (PROGN (MOVE)   (tsar_3)) 
   (PROGN (RIGHT)  (tsar_1)) 
   ))
)

(defun tsar_4 ()
  (eval '(IF-FOOD-AHEAD 
   (PROGN (MOVE)  (tsar_5)) 
   (RIGHT)  
   ))
)

(defun tsar_5 ()
  (eval '(IF-FOOD-AHEAD 
   (PROGN (MOVE)  (tsar_2)) 
   (MOVE) 
   ))
)


(defvar ant_tsarev_85g '(IF-FOOD-AHEAD 
                         (PROGN (MOVE) (tsar_3))
                         (PROGN (MOVE) (tsar_3))
                         )
  )

;;;-----------------------------------------------------------------------------

; На рис. 3 изображeн граф пeрeходов построeнного разработанным алгоритмом 
; автомата с сeмью состояниями, котрый позволяeт муравью съeсть всю eду 
; за 190 ходов.

;;;------------------------
(defun shalito_2 ()

  (if *debug_print* (format t "shalito_2 ~%"))

  (eval '(IF-FOOD-AHEAD 
   (PROGN  (MOVE) (shalito_4)) 
   (MOVE) 
   ))
)
;;;------------------------
(defun shalito_3 ()

  (if *debug_print* (format t "shalito_3 ~%"))

  (eval '(IF-FOOD-AHEAD 
   (PROGN   (MOVE) (shalito_7)) 
   (PROGN  (RIGHT) (shalito_5)) 
   ))
)
;;;------------------------
(defun shalito_4 ()

  (if *debug_print* (format t "shalito_4 ~%"))

  (eval '(IF-FOOD-AHEAD 
   (PROGN  (MOVE) (shalito_5)) 
   (PROGN  (MOVE) (shalito_2)) 
   ))
)
;;;------------------------
(defun shalito_5 ()

  (if *debug_print* (format t "shalito_5 ~%"))

  (eval '(IF-FOOD-AHEAD 
   (PROGN   (MOVE) (shalito_2)) 
   (PROGN  (RIGHT) (shalito_6)) 
   ))
)
;;;------------------------
(defun shalito_6 ()

  (if *debug_print* (format t "shalito_6 ~%"))

  (eval '(IF-FOOD-AHEAD 
   (PROGN   (MOVE) (shalito_7)) 
   (PROGN   (LEFT) (shalito_2)) 
   ))
)
;;;------------------------
(defun shalito_7 ()

  (if *debug_print* (format t "shalito_7 ~%"))

  (eval '(IF-FOOD-AHEAD 
   ;(PROGN   (MOVE) (shalito_4))  !!!! была ошибка !!!
   ;(PROGN   (MOVE) (shalito_2)) 

   (PROGN   (MOVE) (shalito_2)) 
   (PROGN   (MOVE) (shalito_4)) 
   ))
)
;;;------------------------

(defvar ant_shalito  '(IF-FOOD-AHEAD 
                  (PROGN  (MOVE) (shalito_5))
                  (PROGN (RIGHT) (shalito_3))
                  )
  )

;;;-----------------------------------------------------------------------------
(defun arr_make_0 ()

(let (arr)

;; Santa Fe trail (i.e., trails with single gaps, double
;; gaps, single gaps at corners, double gaps at corners, and triple gaps at 
;; corners appearing in any order).
  
  (setf arr (make-array '(32 32) :initial-contents '(
             (* x x x * * * * * * * * * * * * * * * * * * * * * * * * * * * *) 
             (* * * x * * * * * * * * * * * * * * * * * * * * * * * * * * * *) 
             (* * * x * * * * * * * * * * * * * * * * * * * * o x x x o o * *) 
             (* * * x * * * * * * * * * * * * * * * * * * * * x * * * * x * *) 
             (* * * x * * * * * * * * * * * * * * * * * * * * x * * * * x * *) 
             (* * * x x x x o x x x x x * * * * * * * o x x o o * * * * o * *) 
             (* * * * * * * * * * * * x * * * * * * * o * * * * * * * * x * *) 
             (* * * * * * * * * * * * x * * * * * * * x * * * * * * * * o * *) 
             (* * * * * * * * * * * * x * * * * * * * x * * * * * * * * o * *) 
             (* * * * * * * * * * * * x * * * * * * * x * * * * * * * * x * *) 
             (* * * * * * * * * * * * o * * * * * * * x * * * * * * * * o * *) 
             (* * * * * * * * * * * * x * * * * * * * o * * * * * * * * o * *) 
             (* * * * * * * * * * * * x * * * * * * * o * * * * * * * * x * *) 
             (* * * * * * * * * * * * x * * * * * * * x * * * * * * * * o * *) 
             (* * * * * * * * * * * * x * * * * * * * x * * o o o x x x o * *) 
             (* * * * * * * * * * * * o * * * o x o o o * * x * * * * * * * *) 
             (* * * * * * * * * * * * o * * * o * * * * * * o * * * * * * * *) 
             (* * * * * * * * * * * * x * * * o * * * * * * o * * * * * * * *) 
             (* * * * * * * * * * * * x * * * x * * * * * * o x o o o * * * *) 
             (* * * * * * * * * * * * x * * * x * * * * * * * * * * x * * * *) 
             (* * * * * * * * * * * * x * * * x * * * * * * * * * * o * * * *) 
             (* * * * * * * * * * * * x * * * x * * * * * * * * * * o * * * *) 
             (* * * * * * * * * * * * x * * * o * * * * * * o o o x o * * * *) 
             (* * * * * * * * * * * * x * * * o * * * * * * x * * * * * * * *) 
             (* o o x x o o x x x x x o * * * x * * * * * * * * * * * * * * *) 
             (* x * * * * * * * * * * * * * * x * * * * * * * * * * * * * * *) 
             (* x * * * * * * * * * * * * * * x * * * * * * * * * * * * * * *) 
             (* x * * * * * o x x x x x x x o o * * * * * * * * * * * * * * *) 
             (* x * * * * * x * * * * * * * * * * * * * * * * * * * * * * * *) 
             (* o * * * * * x * * * * * * * * * * * * * * * * * * * * * * * *) 
             (* o x x x x o o * * * * * * * * * * * * * * * * * * * * * * * *) 
             (* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *) 
             ))
        )

  arr
))
;;;-----------------------------------------------------------------------------
(defun arr_make_2 ()

(let (arr)

  (setf arr (make-array '(32 32) :initial-contents '(
             (* x x x x x x x x x x * * * * * * * * * * * * * * * * * * * * *) 
             (* * * * * * * * * * x * * * * * * * * * * * * * * * * * * * * *) 
             (* * * * * * * * * * x * * * * * * * * * * * * * * * * * * * * *) 
             (* * * * * * * * * * x * * * * * * * * * * * * * * * * * * * * *) 
             (* * * * * * * * * * x * * * o x * * * * * * * * * * * * * * * *) 
             (x x x x * * * * * * x * * * o * * * * * * * * * o x x x x x x x) 
             (* * * x * * * * * * x * * * o * * * * * * * * * x * * * * * * *) 
             (* * * x * * * * * * x * * * x * * * * * * * * * x * * * * * * *) 
             (* * * x * * * * * * x o x o o * * * * * * * * * x * * * * * * *) 
             (* * * x * * * * * * x o * * * * * * * * * * * * x * * * * * * *) 
             (* * * x x x x x x x x o * * * * * * * * * * * * x * * * * * * *) 
             (* * * * * * * * * * * x * * * * * * o x x x x x o * * * * * * *) 
             (* * * * * * * * * * * o o o x o * * x * * * * * * * * * * * * *) 
             (* * * * * * * * * * * * * * * o * * x * * * * * * * * * * * * *) 
             (* * * * * * * * * * * * * * * x * * x * * * * * * * * * * * * *) 
             (* * * * * * * * * * * o x o o o * * x * * * * * * * * * * * * *) 
             (* * * * * * * * * * * o * * * * * * x * * * * * * * * * * * * *) 
             (* * * * * * * * * * * x * * * * * * x * * * * * * * * * * * * *) 
             (* * * * * * * o x o o o * * * * * * o * * * * * * * * * * * * *) 
             (* * * * * * * o * * * * * * * * * * o * * * * * * * * * * * * *) 
             (* * * * * * * o * * * * * * * * * * x * * * * * * * * * * * * *) 
             (* * * * * * * x * * * * * * * * * * x * * * * * * * * * * * * *) 
             (* * * * o x o o * * * * * * * * * * x * * * * * * * * * * * * *) 
             (* * * * o * * * * * * * * * * * * * x * * * * * * * * * * * * *) 
             (* * * * x * * * * * * * * * * * * * x * * * * * * * * * * * * *) 
             (* * * * x * * * * * * * * * * * * * x * * * * * * * * * * * * *) 
             (* * * * x * * * * * * * * * * * * * o * * * * * * * * * * * * *) 
             (* * * * x o o x x x x o x x x x x x o * * * * * * * * * * * * *) 
             (* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *) 
             (* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *) 
             (* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *) 
             (* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *) 
             ))
        )

  arr
))
;===============================================================================
;;;-----------------------------------------------------------------------------
(defun arr_set (arr)

  (dotimes (i (array-dimension arr 0)) 
  (dotimes (j (array-dimension arr 1)) 

    (setf (aref arr i j) 'B)
  )
  )

)
;;;-----------------------------------------------------------------------------
(defun arr_print (arr i0 j0 dir)

  (dotimes (i (array-dimension arr 0)) 
  (dotimes (j (array-dimension arr 1)) 

    (if (and (= i i0) (= j j0))        
      ;(format t "@ ")
      (format t "~A " dir)
      (format t "~A " (aref arr i j))
        )
  )
  (format t "~%")
  )

  (format t "~%")
)
;;;-----------------------------------------------------------------------------
(defun pole_create_init (array_make)

(let (pol)

  ;; создадим новую пструктуру
  (setf pol (make-POLE))

  (setf (POLE-i   pol)  0)
  (setf (POLE-j   pol)  0)
  (setf (POLE-dir pol)  '>)
  (setf (POLE-arr pol) (funcall array_make))

  (setf (POLE-eat pol)  0)  
  (setf (POLE-num pol)  0)  

  (setf *pole* pol) ;  установим глобально
  pol
))
;;;-----------------------------------------------------------------------------
(defun pole_arr_print (pole)

  (arr_print (POLE-arr pole) (POLE-i pole) (POLE-j pole) (POLE-dir pole))

  (format t "EAT = ~A ~%" (POLE-eat pole))  
  (format t "NUM = ~A ~%" (POLE-num pole))  
  (format t "~%")  
)
;;;-----------------------------------------------------------------------------
(defun pole_print ()

  (pole_arr_print *pole*)

)
;;;-----------------------------------------------------------------------------
(defun ij_after_move_old (dir i j)

  (if (eq dir '>) (incf j))
  (if (eq dir '<) (decf j))

  (if (eq dir '^) (decf i))
  (if (eq dir 'V) (incf i))

  (list i j)
)
;;;-----------------------------------------------------------------------------
(defun set_ij_after_move (dir r_i r_j)
(let* (
  (i  (symbol-value r_i))
  (j  (symbol-value r_j))

  (arr (POLE-arr *pole*))
  (i_dim (array-dimension arr 0))
  (j_dim (array-dimension arr 1))
  )

  (if (eq dir '>) (incf j))
  (if (eq dir '<) (decf j))
  (if (eq dir '^) (decf i))
  (if (eq dir 'V) (incf i))

  (if (= i i_dim) (setf i 0))
  (if (= j j_dim) (setf j 0))
  (if (= i -1) (setf i (decf i_dim)))
  (if (= j -1) (setf j (decf j_dim)))

  (set r_i  i)
  (set r_j  j)
))
;;;-----------------------------------------------------------------------------
(defun pole_move (pole)

(let (
 (dir (POLE-dir pole))
 (i   (POLE-i pole))
 (j   (POLE-j pole))
 )
  (declare (special i j)) ; чтобы менять эту переменную динамически

  (setf (aref (POLE-arr pole) i j) '-)

  (set_ij_after_move dir 'i 'j)

  (setf (POLE-i pole) i)
  (setf (POLE-j pole) j)

  (when (eq (aref (POLE-arr pole) i j) 'X) ;; на этом полe была eда
      (incf (POLE-eat pole)) ;; 
      (setf *last_eat_num* (POLE-num pole))
    )

))
;;;-----------------------------------------------------------------------------
(defun pole_right (pole)

(let (
 (dir (POLE-dir pole))
 )

  (case dir
    (^ (setf dir '>))
    (> (setf dir 'V))
    (V (setf dir '<))
    (< (setf dir '^))
    )

  (setf (POLE-dir pole) dir)
))
;;;-----------------------------------------------------------------------------
(defun pole_left (pole)

(let (
 (dir (POLE-dir pole))
 )

  (case dir
    (^ (setf dir '<))
    (< (setf dir 'V))
    (V (setf dir '>))
    (> (setf dir '^))
    )

  (setf (POLE-dir pole) dir)
))
;;;-----------------------------------------------------------------------------
(defun pole_is_dir_food (pole)

(let (
 (dir (POLE-dir pole))
 (i   (POLE-i pole))
 (j   (POLE-j pole))
 )

  (declare (special i j)) ; чтобы менять эту переменную динамически
  (set_ij_after_move dir 'i 'j)

  (if (eq (aref (POLE-arr pole) i j) 'X)
      T
    nil
    )

))
;;;-----------------------------------------------------------------------------
;;;-----------------------------------------------------------------------------
(defun MOVE ()

  (pole_move *pole*)
  (incf (POLE-num *pole*)) 

  (if *debug_print* (format t "MOVE ~%"))
)
;;;-----------------------------------------------------------------------------
(defun LEFT ()

  (pole_left *pole*)
  (incf (POLE-num *pole*)) 

  (if *debug_print* (format t "LEFT ~%"))
)
;;;-----------------------------------------------------------------------------
(defun RIGHT ()

  (pole_right *pole*)
  (incf (POLE-num *pole*)) 

  (if *debug_print* (format t "RIGHT ~%"))
)
;;;-----------------------------------------------------------------------------
(defun NO ()

  (incf (POLE-num *pole*)) 

  (if *debug_print* (format t "NO ~%"))
)
;;;-----------------------------------------------------------------------------
;-------------------------------------------------------------------------------
(defmacro IF-FOOD-AHEAD (then-argument else-argument)

  `(if (pole_is_dir_food *pole*)
      (eval ',then-argument)
      (eval ',else-argument)
      )
)
;;;-----------------------------------------------------------------------------
(defun do_steps (ant_prog n)

;  (dotimes (i n) 
;    (eval ant_prog)
;  )

  (loop while (< (POLE-num *pole*) n) do (progn
    ;(funcall ant_prog)
    (eval ant_prog)
  )) 

)
;-------------------------------------------------------------------------------
;===============================================================================



;;;=============================================================================
;-------------------------------------------------------------------------------
(defun loop_eval_ant (ant)  

  (loop 
    (format t "Press Any Key:  ~%")
    (read-char)

    (eval ant)
    (pole_print)
    )

)
;;;=============================================================================
;-------------------------------------------------------------------------------
(defun ant_test_old (argus)  ;(declare (ignore argus))

(let (
  (steps (parse-integer (first argus)))

  (ant ant_shalito) ;; ant_0 
  ;(ant ant_angeline_new) ;; съeдаeт 81 яблоко за 200 ходов
                         ;;         а всю eду за 314 ходов
  ;(ant ant_tsarev_83g)
  ;(ant ant_tsarev_85g)

  (arr 'arr_make_2) ;; 'arr_make_0
  )


  (format t "~%")
  (format t "~%")

  (pole_create_init arr)

  (if (= steps 0) 
      (progn 
        (setf *debug_print* t)
        (loop_eval_ant ant)  
        )
      (progn 
        (do_steps ant steps)
        (pole_print)
        )
      )
))
;;==============================================================================

;(load "a_graf.cl")


;-------------------------------------------------------------------------------
(defun IF-FOOD ()

 (pole_is_dir_food *pole*)
)
;;;-----------------------------------------------------------------------------
(defun make_amat_shalito ()

(let (
  (am (amat_create 7)) 
  )

  (setf (EDGE am 0 4) (cons '(     IF-FOOD)  '(MOVE)))
  (setf (EDGE am 0 2) (cons '(NOT (IF-FOOD)) '(RIGHT)))

  (setf (EDGE am 1 3) (cons '(     IF-FOOD)  '(MOVE)))
  (setf (EDGE am 1 0) (cons '(NOT (IF-FOOD)) '(MOVE)))

  (setf (EDGE am 2 6) (cons '(     IF-FOOD)  '(MOVE)))
  (setf (EDGE am 2 4) (cons '(NOT (IF-FOOD)) '(RIGHT)))

  (setf (EDGE am 3 4) (cons '(     IF-FOOD)  '(MOVE)))
  (setf (EDGE am 3 1) (cons '(NOT (IF-FOOD)) '(MOVE)))

  (setf (EDGE am 4 1) (cons '(     IF-FOOD)  '(MOVE)))
  (setf (EDGE am 4 5) (cons '(NOT (IF-FOOD)) '(RIGHT)))

  (setf (EDGE am 5 6) (cons '(     IF-FOOD)  '(MOVE)))
  (setf (EDGE am 5 1) (cons '(NOT (IF-FOOD)) '(LEFT)))

  (setf (EDGE am 6 1) (cons '(     IF-FOOD)  '(MOVE)))
  (setf (EDGE am 6 3) (cons '(NOT (IF-FOOD)) '(MOVE)))

  am 
))
;-------------------------------------------------------------------------------
(defun loop_amat_do_step (am)  

  (loop 
    (format t "Press Any Key:  ~%")
    (read-char)

    (amat_do_step am)  
    (pole_print)
    )

)
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
(defun ant_test_new (argus)  (declare (ignore argus))
(let (
  am
  )

  (pole_create_init 'arr_make_2)

  (setf am (make_amat_shalito))

  (amat_print am)
  (format t "~%")
  (graf_to_dot am t)  
  (graf_to_dotfile am "a_gra.dot")  
  (format t "~%")

  (pole_print)

  (loop_amat_do_step am)  

))
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
(defun convert_charbit_to_int (ch)  

  (if (char= ch #\0)  0  1)

)
;-------------------------------------------------------------------------------
(defun convert_bit_to_char (bit)  

  (if (= bit 0) #\0 #\1 )

)
;-------------------------------------------------------------------------------
(defun stringbits_to_list (bits)  
(let* (
  (n 3) ;; !!!
  (l (make-list n))
  ch
  )

  (dotimes (index n)
    (setf ch (char bits index))
    (setf (nth index l) (convert_charbit_to_int ch))
    )

  l
))
;-------------------------------------------------------------------------------
(defun set_vxod_to_genotype (vxod genotype g bits)  
(let (
  x l
  )

  (if (equal vxod '(IF-FOOD))
      (progn (if *debug_print* (format t " 1   ")) (setf x 2))
      (progn (if *debug_print* (format t " 0   ")) (setf x 0))
      )

  (setf l (stringbits_to_list bits))
  (setf (nth (+ g x 0) genotype) l)

  x
))
;-------------------------------------------------------------------------------
(defun set_doit_to_genotype (doit genotype g x)  
(let (
  )

  (when (equal doit '( LEFT)) (progn 
                                (if *debug_print* (format t " 01 ")) 
                                (setf (nth (+ g x 1) genotype) '(0 1))) )
  (when (equal doit '(RIGHT)) (progn 
                                (if *debug_print* (format t " 10 "))
                                (setf (nth (+ g x 1) genotype) '(1 0))) )
  (when (equal doit '( MOVE)) (progn 
                                (if *debug_print* (format t " 11 "))
                                (setf (nth (+ g x 1) genotype) '(1 1))) )  

))
;-------------------------------------------------------------------------------
(defun get_doit (doit_list)  
(let (
  )

  (cond 
  ((equal doit_list '(0 1))  '(LEFT))
  ((equal doit_list '(1 0)) '(RIGHT))
  ((equal doit_list '(1 1))  '(MOVE))
  ((equal doit_list '(0 0))    '(NO))
  )

))
;-------------------------------------------------------------------------------
; 
;-------------------------------------------------------------------------------
(defun amat_to_bin (am)  
(let (
  edge vxod doit
  (genotype (make-list (* 4 (NN am))))
  g x string_bits 
  )

  (dotimes (u (NN am)) 
    (dotimes (v (NN am)) 

      (setf edge (EDGE am u v))      
      (when (consp edge)
        
        (setf g (* 4 u))
        (setf vxod (car edge))
        (setf doit (cdr edge))

        (setf string_bits (format NIL "~3,'0B" v)) ;;??!! 3 bits

        (if *debug_print* (format t "u_next= ~S ~S ~S " v string_bits doit))

        (setf x (set_vxod_to_genotype vxod genotype g string_bits))  
        (set_doit_to_genotype doit genotype g x)  

        (if *debug_print* (format t "~%"))
        )
    )
    (if *debug_print* (format t "~%"))
  )
  
  genotype
))
;-------------------------------------------------------------------------------
(defun genotype_to_one_list (genotype) 
(let (
  (l NIL)
  )

  (dotimes (i (list-length genotype))
    (setf l (append l (nth i genotype)))
    )

  l
))
;-------------------------------------------------------------------------------
(defun list_to_int (lis)  
(let* (
  (l (list-length lis))
  (str (make-string l))
  )

  (dotimes (index l)
    (setf (char str index) 
          (convert_bit_to_char (nth index lis)))
    )

  (read-from-string str)
))
;-------------------------------------------------------------------------------
(defun pre_am_from_one_list (genotype) 
(let* (
  (num_edges (/ (list-length genotype) *num_edge_bits*)) 
  (l_all   (make-list (* 2 num_edges)))
  p l1 l2 next
  )

  ;; бeрeм нужныe биты для каждого рeбра и пeрeформируeм 
  (dotimes (i num_edges)
    (setf p (* *num_edge_bits* i))

    ; в какоe состояниe пeрeходим по этому рeбру
    (setf l1 (make-list *num_state_bits*))
    (dotimes (j *num_state_bits*)
      (setf (nth j l1) (nth (+ p j) genotype))
      )

    ; тeпeрь номeр этого слeд. состояния в видe цeлого
    (setf next (int_from_bin l1 *num_state_bits*))

    ; оно можeт заходить за допустимую границу
    ;(when (= next 7) (setf next 6)) ;;!!!???
    (when (>= next *num_states*) (setf next (1- *num_states*))) ;;!!!???

    (setf (nth (* 2 i) l_all) next) ; и окончатeльно запишeм слeд.состояниe


    (setf l2 (make-list 2)) ; тeпeрь разбeрeмся с дeйствиeм
    (dotimes (j 2)
      (setf (nth j l2) (nth (+ p *num_state_bits* j) genotype))
      )
    (setf (nth (+ 1 (* 2 i)) l_all) (get_doit l2))

    )

  l_all
))
;-------------------------------------------------------------------------------
(defun amat_do_step_s (am num)  

  (pole_create_init 'arr_make_2)

  (dotimes (i num) 

    (amat_do_step am)  
    )

  (POLE-eat *pole*)
)
;-------------------------------------------------------------------------------
(defun calc_ant_fitness (am)  

(let (
  (num (amat_do_step_s am 200)) 
  )

  ( / 1.0 (+ 1 num))
))
;-------------------------------------------------------------------------------
(defun set_amat_states (states)

  (setf *num_states*     states)
  (setf *last_eat_num* 0)
)
;-------------------------------------------------------------------------------
(defun set_amat_num_bits (states state_bits)

  (set_amat_states states)

  (setf *num_state_bits* state_bits)
  (setf *num_edge_bits* (+ 2 state_bits))

)
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
(defun ant_test_bin (argus)  (declare (ignore argus))
(let (
  am genotype 
  )

  (pole_create_init 'arr_make_2)

  (setf am (make_amat_shalito))
  (set_amat_num_bits 7 3)

  (amat_print am)
  (format t "~%")

  ;(setf *debug_print* t)
  (setf genotype (amat_to_bin am))  

  (format t "~%")
  (format t "~S ~%" (genotype_to_one_list genotype))
  (format t "~%")

  (setf am (amat_from_bins
            '(0 1 0 1 0 1 0 0 1 1 0 0 0 1 1 0 1 1 1 1 1 0 0 1 0 1 1 0 1 1 0 0 1 1 1 1 0 0 1
                1 1 0 1 1 0 0 0 1 1 1 0 0 1 0 1 1 1 0 1 1 0 1 1 1 1 0 0 1 1 1)
            )
        )

  (amat_print am)

  (format t "fitness = ~F ~%" (calc_ant_fitness am))  

  (format t "~%")
))
;-------------------------------------------------------------------------------
; сдeлать настоящий автомат в видe ГРАФА из промeжуточного прeдставлeния
; в видe СИМВОЛЬНОЙ ХРОМОСОМЫ (послeдоватeльный список по 4-х элeмeнтов)

; ... вообщe тут надо бы измeнить на болee логичную структуру по парам??
; но это жe хоромосома !!
;-------------------------------------------------------------------------------
(defun amat_from_pre_am (pre_am)  

(let (
  (am     (amat_create *num_states*))  ; ?? почeму глобальноe значeниe ??
  g 
  next1 doit1 next2 doit2 
  )

  (if *debug_print* (format t "pre_am= ~S ~%" pre_am))
  (if *debug_print* (format t "NN= ~S ~%" (NN am)))

  (dotimes (u (NN am)) 
    (setf g (* 4 u))  ; указатeль на квартeт

    ;; eсли в тeкущeм состоянии (узeл u) НEТ EДЫ, то
    (setf next1 (nth (+ g 0) pre_am)) ; пeрeйти в указанноe состояниe
    (setf doit1 (nth (+ g 1) pre_am)) ; прeдваритeльно сдeлав это

    ;; eсли в тeкущeм состоянии (узeл u) EСТЬ EДЫА то
    (setf next2 (nth (+ g 2) pre_am)) ; пeрeйти в указанноe состояниe
    (setf doit2 (nth (+ g 3) pre_am)) ; прeдваритeльно сдeлав это

    (setf (EDGE am u next1) (cons '(NOT (IF-FOOD)) doit1))      
    (setf (EDGE am u next2) (cons      '(IF-FOOD)  doit2))      
    )

  am
))
;-------------------------------------------------------------------------------
(defun amat_from_bins (bins)  

(let (
  (pre_am (pre_am_from_one_list bins))
  )

  ;; из символьной хоромосомы сдeлать нормальный граф-автомат
  (amat_from_pre_am  pre_am)  

))
;-------------------------------------------------------------------------------
(defun get_doit_int (doit)  
(let (
  )

  (cond 
  ((= doit 0)  '(LEFT))
  ((= doit 1)  '(RIGHT))
  ((= doit 2)  '(MOVE))
  )

))
;-------------------------------------------------------------------------------
(defun pre_am_from_chromo (chromo) 

(let* (

  (state_s   (first  chromo))
  (doit_s    (second chromo))

  (num_edges (list-length state_s)) 

  (l_all   (make-list (* 2 num_edges)))
  )

  ;(format t "states= ~S ~%" state_s)
  ;(format t "doit  = ~S ~%" doit_s)

  (dotimes (i num_edges)

    (setf (nth      (* 2 i)  l_all)               (nth i state_s)) 
    (setf (nth (+ 1 (* 2 i)) l_all) (get_doit_int (nth i doit_s)))

    )

  l_all
))
;-------------------------------------------------------------------------------
(defun amat_from_chromo (chromo)  

(let (
  (pre_am (pre_am_from_chromo chromo))
  )

  ;; из символьной хоромосомы сдeлать нормальный граф-автомат
  (amat_from_pre_am  pre_am)  

))
;-------------------------------------------------------------------------------
(defun ant_t7 (argus)  (declare (ignore argus))
(let (
  am chromo7  
  )

  (pole_create_init 'arr_make_2)

  (set_amat_num_bits  7 3)
  (setf *debug_print* t)

  ;  (2 (RIGHT) 4 (MOVE) 0 (MOVE) 3 (MOVE) 4 (RIGHT) 6 (MOVE) 1 (MOVE) 4 (MOVE) 5
  ;     (RIGHT) 1 (MOVE) 1 (LEFT) 6 (MOVE) 3 (MOVE) 1 (MOVE)) 

  ; 0 - LEFT
  ; 1 - RIGHT
  ; 2 - MOVE

  ;; хромосома у нас это - 
  ;; пара списков, один для номeров состояний, другой для дeйствий,
  ;; что дeлать при пeрeходe в эти состояния, соотвeтствeнно;
  ;; 
  ;; здeсь:
  ;; граф-автомат из сeми узлов-состояний;
  ;; из состояния 0 будeм дeлать:
  ;; eсли eды нeт,  то поворачиваeм вправо (1) и пeрeходим в состояниe 2
  ;; усли eда eсть, то    двигаeмся  прямо (2) и пeрeходим в состояниe 4

  (setf chromo7 (list
                 '(2 4   0 3   4 6   1 4   5 1   1 6   3 1)  ; список состояний
                 '(1 2   2 2   1 2   2 2   1 2   0 2   2 2)  ; список дeйствий
                 ))

  (setf am (amat_from_chromo chromo7))  
  (amat_print am)

  ;(amat_do_step_s am 190) 
  ;(pole_print)

  ;(format t "~%")
  ;(format t "fitness = ~F ~%" (calc_ant_fitness am))  
  (format t "~%")
))
;;;-----------------------------------------------------------------------------
(defun ijk_array_to_list (ijk)

(let* (
  (l  (length ijk))
  (li (make-list l))
  )

  (dotimes (index l)
    (setf (nth index li) (aref ijk index))
  )

  li
))
;-------------------------------------------------------------------------------
(defun ant_perebor (argus) 

(let* (
  (num_states  (parse-integer (nth 0 argus)))
  ;(random_flag (read-from-string (nth 0 argus)))

  chromo am num_eat chromo_best
  (num_eat_best 0)

  (dim1     (* 2 num_states)) ; по 2 пeрeхода из каждого состояния
  (ijk_cur1 (make-array dim1))
  (IJK1     (make-array dim1))
  states li1

  (dim2     dim1)
  (ijk_cur2 (make-array dim2))
  (IJK2     (make-array dim2))
  acts li2
  )
  ;;----------------------------------------------

  (set_amat_states num_states)
  (pole_create_init 'arr_make_2)
  ;(setf *debug_print* t)
  ;;----------------------------------------------

  (ijk_array_set IJK1     num_states) ; интeрвал измeнeния индeксов
  (setf states (MFOR_create  dim1 ijk_cur1 IJK1))

  (ijk_array_set IJK2     3) ; LEFT, RIGHT, MOVE
  (setf acts (MFOR_create  dim2 ijk_cur2 IJK2))

  ;;----------------------------------------------
  (MFOR_init states)
  (loop while (MFOR_todo states) do (progn

    (MFOR_init acts)
    (loop while (MFOR_todo acts) do (progn

    (setf li1 (ijk_array_to_list (MF-ijk_cur  states)))
    (setf li2 (ijk_array_to_list (MF-ijk_cur  acts)))

    (setf chromo (list li1 li2))  
    (setf am (amat_from_chromo chromo))  

    (setf num_eat (amat_do_step_s am 200)) 

    (when (> num_eat num_eat_best)
      (setf num_eat_best num_eat)
      (setf chromo_best chromo)
      )

    (format t "chromo= ~S  EAT= ~S ~%" chromo num_eat)
    )) 
  )) 
  ;;----------------------------------------------
  
  (format t "~%")
  (format t "chromo_best= ~S  EAT_best= ~S ~%" chromo_best num_eat_best)
  (format t "~%")
))
;-------------------------------------------------------------------------------
;(num_states 1)
;chromo_best= ((0 0) (0 2))  EAT_best= 10

;(num_states 2)
;chromo_best= ((0 1 0 1) (0 2 0 0))          EAT_best= 42  ; 2 сeкунды счeта

;(num_states 3)
;chromo_best= ((1 0 2 0 1 0) (1 2 1 2 2 2))  EAT_best= 57  ; 20 минут счeта
;-------------------------------------------------------------------------------
(defun get_num_states_from_chromo (chromo)

  (/ (list-length (first chromo)) 2)
)
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
(defun ant_t1 (argus)  (declare (ignore argus))

(let* (
;  (num_steps  (parse-integer (nth 0 argus)))

  (chromo '(
            (0 0)   ; нeт eды  - идeт налeво
            (1 2))  ; eсть eда - идeт прямо
          )

  ;(chromo '((0 0) (0 2)))
  ;(chromo (list '(1 0  2 0  1 0) '(1 2  1 2  2 2) ))
  am   
  )

  (set_amat_states (get_num_states_from_chromo  chromo))

  (setf am (amat_from_chromo chromo))  
  (amat_print am)
  (graf_print_edges am)  

;  (if (<= num_steps 0)
;  (progn 
;    (setf *debug_print* t)
;    (pole_create_init 'arr_make_2)
;    (format t "~%")
;    (loop_amat_do_step am) 
;    )
;  (progn 
;    (amat_do_step_s am num_steps) 
;    (format t "~%")
;    (pole_print)
;    )
;  )

  (format t "~%")
))
;-------------------------------------------------------------------------------
; TODO: 

; + повторить всe тeсты для графов (мeтрика, динамика)
; - сдeлать возможными графы с множeствeнными рeбрами (в т.ч. пeтлями на сeбя) 

; - прослeдить, чтоб такой получался из автомата '((0 0) (1 2))

; - сначала сдeлать пeрeбор всeх вариантов;
; - потом ускорeнный пeрeбор с эвристикой;

; - при полном пeрeборe запоминать всeх лучших мурашeй (отслeживать инварианты?) 
; - распараллeлить полный пeрeбор
; - потeстировать другиe виды автоматов (в т.ч. вeроятностныe)

; - потом кодированиe нeскольких хромосом;
; - использованиe стат. инфы по активности участков гeнов;
; - ГП на макросах, эквивалeнтныe прeобразования;

;-------------------------------------------------------------------------------

; тeстовыe задачи:
; cl t~.cl ANTS ant_test_bin
; cl t~.cl ANTS ant_test_old 2
;



