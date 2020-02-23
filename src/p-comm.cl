

;===============================================================================
; p_real.cl 
;===============================================================================

; For example, the ordinary LISP division function / should not be 
; in the function set of this symbolic regression problem because
; of the possibility of a division by zero. One way to protect against division 
; by zero is to include the protected division function % in the
; function set, instead of the ordinary LISP division function /.

; Alternatively, we could have achieved closure by defining the division function 
; so as to return the symbolic value :undefined and then rewriting each of the 
; ordinary arithmetic functions so as to return the symbolic value :undefined 
; whenever they encounter :undefined as one of their arguments.

; If the square root function can encounter a negative argument or if the 
; logarithm function can encounter a nonpositive argument in a problem where the 
; complex number that ordinarily would be returned is unacceptable, we can 
; guarantee closure by using a protected function. For example, the protected 
; square root function SRT takes one argument and returns the square root of 
; the absolute value of its argument. It might be programmed as
;-------------------------------------------------------------------------------

; ����� ��� ���.. ���� ��-�������� ����������� �������������� �������
; � �������� ����� ������ , ��� �� ��������� ..
; 
; �� � ���� ��� �� ������, ���� ������������ �� ��������� �������� - � ���
; �� ������ ������������!
;-------------------------------------------------------------------------------

(defvar *flag_error*  :unbound) ; ��� ��� ��� ���� ����������� ������...


;-------------------------------------------------------------------------------
(defun % (numerator denominator)

  ;(values 
  (if (= 0 denominator) 
      (progn
        ;(format t ".............. = 0 denominator .............  ~%")        
        ;(setf *flag_error* t)
        ;100000000000000000000000000000

        1 ; ������ ��� ??  
        ;; ��� �����, ��� � ��� ����� �������� ���� ����� ������������!

        ;; ���� ����� ��� ��������: ���� ������� ����� ����� � ���������
        ;; ���� ����������� ���������� � ����� ��� ������������
        ;; ���� ��� ������ ��� ���������! numerator denominator
      )
      (/ numerator denominator)
  )
  ;)
)
;-------------------------------------------------------------------------------
; The Protected Square Root Function
;-------------------------------------------------------------------------------
(defun rSQRT (argument)

  (sqrt (abs argument))

)
;-------------------------------------------------------------------------------
; The Protected Natural Logarithm Function
;-------------------------------------------------------------------------------
(defun rLOG (argument)

  (if (= 0 argument) 
      0 
      (log (abs argument))
      )

)
;-------------------------------------------------------------------------------
(defun rEXP (x)

  (if (or (< x -80) (> x 80)) 
    
    (progn
      (setf *flag_error* t)
      1.0 ;; ������� �����-������ �����, ���� ��������� ������� ����������
          ;; ����� �����������
    )

    (exp  x)
    )
)
;-------------------------------------------------------------------------------
(defun test3 (argus)  (declare (ignore argus))

(let (
   (x -0.052631557)
   y y1 y2 y3
   )

  (format t "~%")
  (format t "x= ~A ~%" x)

  (setf y1 (% X (rEXP 0.46651602)))
  (setf y2 (% (% -1.3165262 X) y1))

  (format t "y1= ~A ~%" y1)
  (format t "y2= ~A ~%" y2) ; -757.7787

  (setf y3 (rEXP y2))
  (format t "y3= ~A ~%" y3)

  (setf y 
        (rEXP y3)
        )

  (format t "y= ~A ~%" y)
  (format t "~%")
))
;-------------------------------------------------------------------------------

