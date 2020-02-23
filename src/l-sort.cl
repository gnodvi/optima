;===============================================================================
; *                                                                            *
; *  ��� ����� �����: d_sort.c                                                 *
; *                                                                            *
;-------------------------------------------------------------------------------
                                                                             
(defpackage "A_SORT" (:use "CL" "CL-USER" )
                     (:export :sort_main :sort_k
                              :ai_initialize :TO_RESET :LG_RESET 
                              :ai_copy :ai_reverse
                              :qsort_AF :ai_check_compare :TO_COUNT :LG_COUNT) 
                     )

(in-package :a_sort)

;#include "a_comm.h"
;#include "d_sort.h"

;===============================================================================

;#define AI int

;#define TO_RESET {take_count= 0;}
(defmacro TO_RESET () (list 'setf 'take_count 0))

;#define TO(left, right) {(left) = (right); take_count++;}
(defmacro TO (left right) (list 'progn (list 'setf left right) (list 'incf 'take_count)))

;#define TO_COUNT (take_count)
;(defmacro TO_COUNT () (list 'take_count))
(defmacro TO_COUNT () 'take_count)

;#define SWAP(i, j) (bsort_swap (array, (i), (j)))
(defmacro SWAP (i j) (list 'bsort_swap 'array i j))

;#define LG_RESET {comp_count= 0;}
(defmacro LG_RESET () (list 'setf 'comp_count 0))

;#define LG_COUNT (comp_count)
;(defmacro LG_COUNT () (list 'comp_count))
(defmacro LG_COUNT () 'comp_count)

;//-------------------------------------------
;typedef int (*T_SORTPROG) (int array[], int num); 


;===============================================================================
;-------------------------------------------------------------------------------

(defvar take_count 0)
(defvar comp_count 0)

;===============================================================================
;
;-------------------------------------------------------------------------------
;void
;ai_setval (int *Array, int Num, int val)
;{
;  int i;

;  for (i = 0; i < Num; i++) 
;    Array[i] = val;
 
;  return;
;}
;-------------------------------------------------------------------------------
;void
;ai_initialize (int *Array, int Num)
;-------------------------------------------------------------------------------
(defun ai_initialize (Array Num)

;  int i;

;  for (i = 0; i < Num; i++) 
  (dotimes (i Num)
    (setf (nth i Array)  i)
    )
 
)
;-------------------------------------------------------------------------------
;void
;ai_copy (int *dest, int *src, int Num)
;-------------------------------------------------------------------------------
(defun ai_copy (dest src Num)

;  int i;

;  for (i = 0; i < Num; i++) 
  (dotimes (i Num)
;    dest[i] = src[i];
    (setf (nth i dest) (nth i src))
    )
    
)
;-------------------------------------------------------------------------------
;void
;ai_print (int *Array, int Num)
;-------------------------------------------------------------------------------
(defun ai_print (Array)

;  for (i = 0; i < Num; i++) 
;    printf ("%2d ", Array[i]); 
;  printf ("\n");

  (format t "~s ~%" Array)

)
;-------------------------------------------------------------------------------
;void
;ai_swap (int *Array, int i, int j)
;-------------------------------------------------------------------------------
(defun ai_swap (Array i j)

(let (
  x
  )

  (setf x             (nth i array))
  (setf (nth i array) (nth j array))
  (setf (nth j array)  x)

;  int tmp = Array[i];
;  Array[i] = Array[j];
;  Array[j] = tmp;

))
;-------------------------------------------------------------------------------
;void
;ai_randomize (int *Array, int Num)
;-------------------------------------------------------------------------------
(defun ai_randomize (Array Num)

(let (
  j 
  )

  (dotimes (i Num) 
    (setf j (YRAND 0 (- Num 1)))

    (ai_swap Array i j)
    )
    
))
;-------------------------------------------------------------------------------
;void
;ai_reverse (int *Array, int Num)
;-------------------------------------------------------------------------------
(defun ai_reverse (Array Num)

(declare (ignore Num))

;  int i;

;  for (i = 0; i < Num / 2; i++) { ;; ???
;    int  j = Num - i - 1;
    
;    int tmp  = Array[i];
;    Array[i] = Array[j];
;    Array[j] = tmp;
    
;  }

  (setq Array (nreverse Array))
)
;-------------------------------------------------------------------------------
;int
;ai_check_compare (int *Array, int *orig, int Num)
;-------------------------------------------------------------------------------
(defun ai_check_compare (Arrey Orign Num)

  (dotimes (i Num)
;    if (Array[i] != orig[i]) 
;      return (G_FAILURE); 
    ;(when (\= (nth i Arrey) (nth i Orign))
    (when (not (eq (nth i Arrey) (nth i Orign)))
      (return-from ai_check_compare NIL)
      )
    )

;  return G_SUCCESS;
  t
)
;===============================================================================
;
;===============================================================================
;void 
;bsort_print (int array[], int num, int i, int j)
;{

;  if (BOTPRINT) {
;    printf ("I=%2d  J=%2d   ", i+1, j+1);
;    ai_print (array, num);
;  }

;  return;
;}
;-------------------------------------------------------------------------------
;inline void 
;bsort_swap (int array[], int i, int j)
;-------------------------------------------------------------------------------
(defun bsort_swap (array i j)

(let (
  x
  )

  (TO x             (nth i array))
  (TO (nth i array) (nth j array))
  (TO (nth j array)  x)

; (setf x (nth i array))               (incf take_count)
; (setf (nth i array) (nth j array))   (incf take_count)
; (setf (nth j array) x)               (incf take_count)

))
;-------------------------------------------------------------------------------
;YT_BOOL 
;LT (int left, int right)
;-------------------------------------------------------------------------------
(defun LT (left right)

  (incf comp_count)
;  return (left < right ? TRUE : FALSE);

  (if (< left right) t nil)
)
;-------------------------------------------------------------------------------
;YT_BOOL 
;GT (int left, int right)
;{

;  comp_count++;
;  return (left > right ? TRUE : FALSE);

;}
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;int 
;qsort_func (const void *a, const void *b) 
;{ 
;  int x = *((int*) a);
;  int y = *((int*) b);
 
;  return (x - y); 
;} 
;/*--------------------*/ 
;int 
;qsort_unix (int array[], int num) 
;{ 

;  qsort ((void *) array, num, sizeof (int), qsort_func); 

;  return (0); 
;} 
;-------------------------------------------------------------------------------


;===============================================================================
;/*
; *  A library of sorting functions
; *  Written by:  Ariel Faigon,  1987
; */
;-------------------------------------------------------------------------------
;/*
; |  void  shellsort (array, len)
; |  KEY_T  array[];
; |  int    len;
; |
; |  Abstract:	Sort array[0..len-1] into increasing order.
; |  Method:	Shell sort (ala Kernighan & Ritchie)
; */
;-------------------------------------------------------------------------------
;int 
;shellsort_AF (int array[], int num)
;{
;  int	gap, i, j;

;  for (gap = num / 2; gap > 0; gap /= 2) {

;    for (i = gap; i < num; i++)
;      for (j = i-gap; j >= 0 && GT(array[j], array[j+gap]); j -= gap) {
;        SWAP (j, j + gap);   
;      }
;  }

;  return 0;
;}
;-------------------------------------------------------------------------------
;/*
; |  void  quicksort (array, lower, upper)
; |  KEY_T  array[];
; |  int    lower, upper;
; |
; |  Abstract:	Sort array[lower..upper] into increasing order.
; |  Method:	C. A. R. Hoare's Quick-sort (ala Jon Bentley)
; */
;-------------------------------------------------------------------------------
;void  
;quicksort (int array[], int lower, int upper)
;-------------------------------------------------------------------------------
(defun quicksort (array lower upper)

(let (
  m ;  int  i, m;
  pivot ;  int  pivot;
  )

  ;(format t "quicksort: ~s ~s ~%" lower upper)

  (when (< lower upper) 

    (SWAP lower (round (/ (+ upper lower) 2.0)))
   
    (setf pivot (nth lower array))
    (setf m  lower)

    (loop for i from (+ lower 1) to upper do 
    (when (LT (nth i array) pivot)
        (incf m)
        (SWAP m i)  
    ))

    ;(format t "SWAP: ~s ~s ~%" lower m)
    (SWAP lower m)   

    (quicksort array lower (- m 1))
    (quicksort array (+ m 1) upper)
  )

))
;//-------------------------------------------------------
;int 
;qsort_AF (int array[], int num)
;//-------------------------------------------------------
(defun qsort_AF (array)

(let (
  (lower 0)
  (upper (- (list-length array) 1))
  )

  (quicksort array lower upper)
    
))
;===============================================================================
;//   ���������� �� ������ ������� ���������                                  // 
;//   (� ���������� ��������� - ��������� ���-�� �������)                     // 
;-------------------------------------------------------------------------------
;int 
;s_insertion_take (int array[], int num) 
;{ 
;  int  i, j; 
;  int  x; 
;  // array[0] - ������ ������� �������� ��� � ������ �������������
 
;  for (i= 1; i< num; i++) { // �� ������ ������� �������� ������ �������
;    TO(x, array[i]); // ��� ������������������ ��� ��� ��������

;    // ����� ������ ����� ��� ����� �������� � "������ �������������"
;    j = i; 
;    while (LT(x, array[j-1])  && (j> 0)) // �� ������� �������� ��� �� ������
;    { 
;      TO(array[j], array[j-1]); // ������� ����������� ������ ������� ��������
;      j--; 
;    } 

;    TO (array[j], x); // ��������� � ��� �����
;   } 
 
;  return 0; 
;} 
;-------------------------------------------------------------------------------
;//   ���������� �� ������ ������� ��������� (�� ���������)                   // 
;-------------------------------------------------------------------------------
;int 
;s_insertion_swap (int array[], int num) 
;{ 
;  int imin = 0;
;  int imax = num-1;
;  int  i, j; 
;  // array[0] - ������ ������� �������� ��� � �"����� �������������" 

;  for (i= imin+1; i<= imax; i++) { // �� ������ ������� �������� ������ �������

;    // ����� ������ ����� ��� ����� �������� � "������ �������������"
;    j = i; 
;    while (LT(array[j], array[j-1])  &&  (j> imin)) // ���� �� ������ ������
;    { 
;      //bsort_swap (array, j-1, j); // ������ �� ������� ������� ��� ����� 
;      SWAP(j-1, j); // ������ �� ������� ������� ��� ����� 
;      j--; 
;    } 
;    // ������ ������� ������ (���� ��� �� ����� ���� j==imin)
;  } // ���������� ���� ��������� ������
 
;  return 0; 
;} 
;-------------------------------------------------------------------------------
;//   ���������� �������� ������� (������������ ��������)                     // 
;-------------------------------------------------------------------------------
;int 
;s_selection (int array[], int num) 
;{ 
;  int imin = 0;
;  int imax = num-1;
;  int k; 
;  int x;  
;  int i, j;

;  // � "������������� ������" ���� ������ ���

;  for (i= imin; i<= imax-1; i++) // ��������� ������� - ��� �� ������ :-)
;  { 
;    // ���� �� ���� ��������������� ������ ���������� �������
;    k= i;      // ������� ��������, ��� ��� 1-� ������� ������
;    TO(x, array[i]); 

;    for (j= i+1; j <= imax; j++) 
;      if (LT(array[j], x)) { 
;        k= j; 
;        //x= array[k]; 
;        TO(x, array[k]); 
;      } 

;    // ������ ������� ��������� ����������� (k) � ������ ������� (i)
;    //array[k]= array[i]; 
;    TO(array[k], array[i]);
;    TO(array[i], x);  
;  } 
 
;  return (0); 
;} 
;-------------------------------------------------------------------------------
;//   ��������� ���������� (���������� ����� "��������").                     //
;//                                                                           //
;-------------------------------------------------------------------------------
;int 
;shakersort (int array[], int num) 
;{
;  int imin = 0;
;  int imax = num-1;
;  int j;
;  int l = imin+1;
;  int r = imax;
;  int k = imax;

;  do { // ������ ���� ���� �������� (�����-������ ��� �����-����)

;    for (j= r; j>= l; j--)     // ���� ������ ������, ������������ �������
;      if (GT(array[j-1], array[j])) {
;        SWAP (j-1, j);  // ����� ��� ��������� ������� � ����
;        k = j; // ����� (������) ���������� ������
;      }

;    l = k+1; // �������� ������� ����� ������������� ����� 

;    for (j= l; j<= r; j++)    // ���� ����� �������, ������������ �������
;      if (GT(array[j-1], array[j])) {
;        SWAP (j-1, j);   
;        k = j;
;      }

;    r = k-1;// �������� ������� ������ ������������� ����� 

;  }
;  //while (L > R); // ����� � ������ � ����� ���� ������ !
;  //while (L < R); // ����� � ���������� ���� ������ (���  num=10) !
;  while (l <= r);  // � ��� ��������� !

;  return (0);
;}
;-------------------------------------------------------------------------------
;//  ���������� "�����������"
;//  �.�. ������� ��������, ������� ������ ��������� ����������� �����..
;// 
;//  ��� ������ �������, ���� �� ���� �������� ����������� � ����. ������
;//  (��������� ���� � ����� ������, "������" �� ���� ������ ��������
;-------------------------------------------------------------------------------
;int 
;bubblesort (int array[], int num)
;{
;  int imin = 0;
;  int imax = num-1;
;  int i, j; 
;  int l = imin+1; // ������ ����� ����-��� �����
;  int r = imax;

;  for (i= l; i<= r; i++) { 

;    for (j= r; j>= i; j--) {
;      if (LT(array[j], array[j-1])) 
;        SWAP (j-1, j);  // ����� ��� ��������� ������� � ����

;      bsort_print (array, num, i, j);
;    }
;  }

;  return (0);
;  // ����� �������� ��������: 
;  // 1) ���� ������ �� ���� �� ������, �� �����������; 
;  // 2) ����� ���������� � ����� ���������� ������, ��� ����� ������� ���������;
;  // 3) ����� ������ ����������� ��������;
;}
;-------------------------------------------------------------------------------
;
;===============================================================================
(defun sort_main (argus)  (declare (ignore argus))

(let (
  (Orign '(44 55 12 42 94 18  6 67))
  (Sorts '( 6 12 18 42 44 55 67 94))
  )

;  int Num = sizeof (Orign)/sizeof (Orign[0]);

  (format t "~%")
  (ai_print Orign)     
  (ai_print Sorts)     
  (format t "~%")

  (qsort_AF Orign)
  ;(sort Orign '<)

  (ai_print Orign)     
  (format t "~%")

))
;;; --------------------------------------------------------------------

;LISP provides two primitives for sorting: sort and stable-sort.

;The first argument to sort is a list; the second is a comparison
;function. The sort function does not guarantee stability: if there are
;two elements a and b such that (and (not (< a b)) (not (< b a))), sort
;may arrange them in either order. The stable-sort function is exactly
;like sort, except that it guarantees that two equivalent elements
;appear in the sorted list in the same order that they appeared in the
;original list.

;Be careful: sort is allowed to destroy its argument, so if the original
;sequence is important to you, make a copy with the copy-list or copy-seq
;function.
 
;===============================================================================
; KORUCHOVA - 
; ���������� ����e���� ���������e��� ���������� ���� ������
; ��. ����e������ ���� ��������� (���, ����)

(DEFUN k-sort(b) (COND ((LISTP b) (COND ((NULL b) b)
(T (COND ((NULL (k-sort (CDR b))) b)
(T (COND ((<= (CAR (k-sort (CDR b))) (CAR b)) (CONS (CAR
(k-sort (CDR b))) (k-sort (CONS (CAR b) (CDR (k-sort (CDR
b))))))) (T (COND ((NULL (CDR b)) b) (T (CONS (CAR b)
(k-sort (CDR b))))))))))))))

;;; --------------------------------------------------------------------
(defun sort_k (argus)  (declare (ignore argus))

(let (
  (my-list '(2 1 5 4 6))
  )

  (print (sort my-list #'<))  ;(1 2 4 5 6)

  (print (sort my-list #'>))  ;(6 5 4 2 1)

  (print (k-sort my-list ))   ; 
))
;===============================================================================

;  (format t "3: ~s ~%" *package*)

