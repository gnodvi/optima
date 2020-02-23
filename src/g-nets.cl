
;(load "t-graf.cl")

;===============================================================================
;
;  �E��   �E��   �E��   �E��   �E��   �E��   �E��   �E��   �E��   �E��   �E��  
;
;===============================================================================

(defclass NET (GRAF) (
;  GRAF *gr;

  (i  :accessor I)
  (o  :accessor O)

;  int   i, o;
;  int  *activ, *activ_new, *a[2], num;
  (activ     :accessor ACTIVE)
  (activ_new :accessor ACTIVE_NEW)

  (a0   :accessor A0)
  (a1   :accessor A1)
  (num  :accessor NUM)
))


;-------------------------------------------------------------------------------
;NET *
;net_create (int nn)
;-------------------------------------------------------------------------------
(defun net_create (nn)

(let (
  (net (make-instance 'NET))
  )

  (graf_init_main net nn)  
  (graf_init net GR_RAND 0.0 0.0 GR_RAND NOS NOS)

  (setf (A0 net) (make-list nn))
  (setf (A1 net) (make-list nn))

  (dotimes (i nn)
    (setf (nth i (A0 net)) 0)
    (setf (nth i (A1 net)) 0)
    )

;  net->activ     = net->a[0];
;  net->activ_new = net->a[1];
  (setf (ACTIVE net)     (A0 net))
  (setf (ACTIVE_NEW net) (A1 net))

  (setf (NUM net) 0)

  net
))
;-------------------------------------------------------------------------------
;void
;net_set_activ (NET *net, int index)
;-------------------------------------------------------------------------------
(defun net_set_activ (net index)
  
  (setf (nth index (ACTIVE net)) 1)

)
;-------------------------------------------------------------------------------
(defun net_print (net)

(let (
  act
  )

  (graf_print net)

  (dotimes (i (NN net))
    (setf act (nth i (ACTIVE net)))
    
    (cond 
     ((= act 0) (format t "  -  "))
     ((= act 1) (format t "  +  "))
     (t          (format t "  ~s  " act))
     )
    )

  (format t "~%")

))
;-------------------------------------------------------------------------------
(defun net_activate (net)

(let* (
;  int i, j;
  edge
  
  (gr net)
  (nn (NN gr))
  )

  (dotimes (i nn)
;     if (! net->activ[i]) continue;
  ;(unless (not (= (nth i (ACTIVE net)) 1))
  (unless (= (nth i (ACTIVE net)) 0)

    (format t "activ= ~s  -> " i)

    (dotimes (j nn)
;       if (i == j) continue;  // ���� ��� ������ �� ����
    (unless (= i j)
       (setf edge (EDGE gr i j))
;       if  (edge == NOT) continue;
       (unless (= edge NOS)

       (format t " ~s" j)
       ;; ���������� ����� ����
       (setf (nth j (ACTIVE_NEW net)) 1)
    )))

     (format t "~%")
     ;; ������ ������ ��� ������
  ))

  ;; �������� ���������

  (if (= (NUM net) 0) (progn 
    (setf (ACTIVE net)     (A1 net))
    (setf (ACTIVE_NEW net) (A0 net))
    (setf (NUM net)  1)
  ) (progn 
    (setf (ACTIVE net)     (A0 net))
    (setf (ACTIVE_NEW net) (A1 net))
    (setf (NUM net)  0)
  ))

  ;; � ������� ����� ������� �������
  (dotimes (i nn)
    (setf (nth i (ACTIVE_NEW net)) 0)
  )

))
;-------------------------------------------------------------------------------
(defun net_test0 (argus)

(declare (ignore argus))

(let (
  (net  (net_create 3))
  )

  (setf (EDGE net 0 1) 1)
  (setf (EDGE net 1 2) 1)

  (net_set_activ net 0)
  (net_print net)

  (net_activate net)
  (net_print net)

  (net_activate net)
  (net_print net)

))
;-------------------------------------------------------------------------------




;===============================================================================
;
;  ��������   ���������   ��������   ��������   ��������   ��������   �������� 
;
;===============================================================================

(defclass AMAT (GRAF) ( 
   (active  :accessor ACTIVE)
))

;/*----------------------------------------------------------------------------*/
;
;-------------------------------------------------------------------------------
(defun amat_set_active (am index)  

  (setf (ACTIVE am) index)

)
;-------------------------------------------------------------------------------
(defun amat_create (nn)  

(let (
   am 
  )

  (setf am (make-instance 'AMAT))

  (graf_init_main am nn)  
  (amat_set_active am 0)  

  am
))
;-------------------------------------------------------------------------------
(defun amat_print (am)  

  (graf_print am)

  (format t "ACTIVE= ~S ~%" (ACTIVE am))
)
;-------------------------------------------------------------------------------
(defun amat_do_step (am)  
(let (
  (edge)
  )

  (dotimes (u (NN am)) ; ����e��e� ������ ��e �e��� 
    (setf edge (EDGE am (ACTIVE am) u)) ; ��������e �� ����� ����
    
    (if *debug_print* (format t "edge= ~S ~%" edge))

    (if (and (consp edge) ; e��� ��� ����-����
             (eq (eval (car edge)) T)) ; � ������� �e�e���� �������e���

        (progn
          (if *debug_print* (format t "~S ~S u_next= ~S ~%" (car edge) (cdr edge) u))
          (setf (ACTIVE am) u)
          (eval (cdr edge)) ; �������e� �e�����e �� �e�e���e
          (return) ; ���������e�, ��e �e�e���
        )
      )
    )

))
;/*----------------------------------------------------------------------------*/
; 
;-------------------------------------------------------------------------------
(defun amat_03 (argus)  

(declare (ignore argus))

(let (
  (am (amat_create 4)) 
  )

  (setf (EDGE am 0 1) (cons '(= 10 10) '(format t "DO STEP ~%")))

  (setf (EDGE am 1 2) NIL)
  (setf (EDGE am 1 3) T)
  (setf (EDGE am 2 3) T)
  (setf (EDGE am 3 0) T)

  (amat_print am)

  (amat_do_step am)  
  (amat_print am)

  (amat_do_step am)  
  (amat_print am)

  (amat_do_step am)  
  (amat_print am)

  (format t "~%")
))
;;;=============================================================================
;;;=============================================================================
