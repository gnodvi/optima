
;===============================================================================

;(defvar FI_MAX   20)
;(defvar TI_MAX 2000)

;===============================================================================

(defclass TT_FUNC () ( ; ������e�� ������� ?
  (l_name :accessor L_NAME)   ; char   *l_name;

  ; ������e �e�e�e���e (�e�e� ����������) ?
  (xmin   :accessor L_XMIN)  
  (xmax   :accessor L_XMAX)

  (fmin   :accessor L_FMIN)   
  (fmax   :accessor L_FMAX)
))

(defclass TT_STEP () (
  (title :accessor TITLE) ;  char     title[80];
  (f     :accessor F)     ;  double  *f[FI_MAX]; 
  ;(ti    :accessor L_TI) ;  �����e �� ���� ���� ��������
))

(defvar MAX_OUT 50)

;-------------------------------------------------------------------------------
(defclass YT_PLOT () (
  ;(ti       :accessor L_TI)   ; ������� �������� (������ ����, �������� � GTK+ ?)

  (fnum     :accessor L_FNUM)  ; int  fnum, xnum, tnum, tmax;
  (funcs    :accessor FUNCS)   ; TT_FUNC  funcs[FI_MAX];

  (xnum     :accessor L_XNUM)   ; � ��� ��� ������ ����e�����e�?
  (x        :accessor X)        ;  double  *x; ?????? ���e� ��� ������???
  (xmin_set :accessor XMIN_SET) ; double   xmin_set, xmax_set; 
  (xmax_set :accessor XMAX_SET) ; �������������� ������� (���e�� ��e��?)

  (tnum     :accessor L_TNUM)
  (steps    :accessor STEPS)   ;  TT_STEP  steps[TI_MAX]; 

  ;;  -----------------------------------------------------------
  ;; ������e �e�e�e���e:
  (tmax     :accessor TMAX)     ; ��� ���e�? (- tnum 1)

  ;;  -----------------------------------------------------------
  ;;  ������ ������� - ��� ��������������� ��������� ��� ������� ��������
  ;;  � �������� ������ �� ������� ������������ ��� ������� �������� �� �������;
  ;;  (�� ��������� ������ ������� ��������� ������ ��������
  ;;  ������ � ����� ���� �������� ���� ������ ������������� !)

  (fr       :accessor FR)    ; int  fr[MAX_OUT][MAX_OUT]; 
  (wnum     :accessor WNUM)  ; int  wnum; // ����������� ����� ����������
))
;-------------------------------------------------------------------------------

(defmacro PP_XMIN (p fi)  `(L_XMIN (nth ,fi (FUNCS ,p)))) ; (p)->funcs[(fi)]).xmin
(defmacro PP_XMAX (p fi)  `(L_XMAX (nth ,fi (FUNCS ,p))))

(defmacro PP_FMIN (p fi)  `(L_FMIN (nth ,fi (FUNCS ,p))))
(defmacro PP_FMAX (p fi)  `(L_FMAX (nth ,fi (FUNCS ,p))))

(defmacro PP_NAME (p fi)  `(L_NAME (nth ,fi (FUNCS ,p))) ) ; (p)->funcs[(fi)]).l_name

(defmacro PP_STEP_NAME (p ti)    `(TITLE      (nth ,ti (STEPS ,p))) )
(defmacro PP_STEP_F    (p ti fi) `(nth ,fi (F (nth ,ti (STEPS ,p)))) )


;-------------------------------------------------------------------------------
; MINFUNC - ���, �� ��������, PLOT � ������e����� ��������� FMOD
;           ��� �e�e���� � ������������ MINPROC.
;-------------------------------------------------------------------------------

;(defmacro XSTEP () `(P_XSTEP minfunc))
;(defmacro XVAL (xi) `(+ (XMIN) (* (XSTEP) ,xi)))
(defmacro P1_X (xi) `(nth ,xi (X plot)))

;-------------------------------------------------------------------------------

;(defmacro FVAl_ARR (ti fi) `(nth ,fi (P_FVAL (nth ,ti (P_STEPS minfunc)))))
;(defmacro FVAL_2D (ti fi xi yi) (list 'aref (list 'FVAl_ARR ti fi) xi yi))
;(defmacro Fn (fi) `(FVAL ti ,fi xi))

;(defmacro FVAL (ti fi xi) `(aref (FVAl_ARR ,ti ,fi) ,xi))
(defmacro PVAL (ti fi xi) `(nth ,xi (PP_STEP_F plot ,ti ,fi)))

;(defmacro Fun_ (xi ti) `(FVAL ,ti 0 ,xi))
(defmacro Pun_ (xi ti) `(PVAL ,ti 0 ,xi))

;//---------------------------------

;(defmacro FIMQ (fi) `(P_NAME (nth ,fi (P_FUNCS minfunc))))
(defmacro PIMQ (fi) `(PP_NAME plot ,fi)) ; ��� ��e e��� � PLOT

;-------------------------------------------------------------------------------
;(defun minfunc_put (fi minfunc xi ti val)
(defun plot_put (fi plot xi ti val)

  ;(setf (FVAL ti fi xi) val)
  ;(setf (FMOD    fi xi) FALSE) ; // ������ �� ������ �������

  (setf (PVAL ti fi xi) val)
)
;-------------------------------------------------------------------------------
(defun plot1_make_fdata (plot)

  (make-list (L_XNUM plot)) ; ������ �� ����� ���������������..
)
;-------------------------------------------------------------------------------
(defun plot_make_step_fi (plot ti fi)

(let (
  f_data
  )

  (setf f_data (plot1_make_fdata plot)) 
  (setf (PP_STEP_F plot ti fi) f_data)    ; P_LINE (plot,fi,0) = f_line;

))
;-------------------------------------------------------------------------------
(defun plot_make_step (plot ti fi)

(let (
  (step_name "PLOT_TEST")  ; "TITLE-STEP"
  )

  (setf (PP_STEP_NAME plot ti)  step_name)
  (plot_make_step_fi  plot ti fi)

))
;-------------------------------------------------------------------------------
; --> t_cell.li
;-------------------------------------------------------------------------------
(defun plot_put_all (plot ti fi val)

  (plot_make_step  plot ti fi) ; ����� �� �����e ��e ��e �����������
  ;(plot_make_step_new  plot ti)

  (dotimes (i (L_XNUM plot))
    (setf (nth i (X plot)) i) ; plot->x[i] = i;      
    (setf (nth i (PP_STEP_F plot ti 0)) val)
    )

)
;-------------------------------------------------------------------------------
;(defun minfunc_named (fi minfunc name)
(defun plot_named (fi plot name)

  ;(setf (FIMQ fi) name)
  (setf (PIMQ fi) name)
)
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
  
(defclass T_PLOTSTEP () (

  (plot   :accessor PLOT)    ;  YT_PLOT *plot;
  (ih_one :accessor IH_ONE)  ;  int      ih_one, iw, ih;
  (iw     :accessor IW)
  (ih     :accessor IH)
  (gp     :accessor GP)      ;  void    *gp;
  (first1 :accessor FIRST1)  ;  BOOL     first1;
  (first2 :accessor FIRST2)  ;  BOOL     first2;
))

;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
(defun plot_frames_init0 (plot)

  ;; ��������� ��������� ������ �������/��������:

  (dotimes (wi MAX_OUT)
  (dotimes (li MAX_OUT)
    ;;  plot->fr[wi][li] = -1; // ��� ��� �������!
    (setf (aref (FR plot) wi li) -1) 
    ))

)
;-------------------------------------------------------------------------------
(defun plot_frames_init1 (plot)

;  // ���� ��������� ������� ������ �������, 
;  // �������, ��� � ����� ������ - ���� ������..
;  int fi;

;  for (fi=0 ; fi < plot->fnum ; fi++) {
;    plot->fr[fi][0] = fi; 
;  }

  (dotimes (fi (L_FNUM plot))
    (setf (aref (FR plot) fi 0) fi)
    )

)
;-------------------------------------------------------------------------------
(defun plot_frames_init9 (plot)

;  int fi;
;  // �������� ��� ������� � ���� �����

;  for (fi=0 ; fi < plot->fnum ; fi++) {
;    plot->fr[0][fi] = fi; 
;  }

  (dotimes (fi (L_FNUM plot))
    (setf (aref (FR plot) 0 fi) fi)
    )
)
;-------------------------------------------------------------------------------
;int
(defun plot_get_wnum (plot)
(let (
  (wi 0)
  )

;  for (wi=0 ; plot->fr[wi][0] != -1; wi++) {
;    ;; 
;  }

  (loop 
    (when (= (aref (FR plot) wi 0) -1) (return))
    ;(setf wi (1+ wi))
    (incf wi)
    )

  wi
))
;-------------------------------------------------------------------------------
(defun step_create ()

(let* (
  (step (make-instance 'TT_STEP))
  )

;  double  *f[FI_MAX]; 
  (setf (F step) (make-list FI_MAX))

  step
))
;-------------------------------------------------------------------------------
(defun plot_create (fnum xnum tnum)

(let* (
  (plot (make-instance 'YT_PLOT))
;  ((FNUM plot) fnum) ; � ���e�� ��e�� �e���� ??
  )
 
  (setf (L_FNUM plot) fnum)
  (setf (L_XNUM plot) xnum)
  (setf (L_TNUM plot) tnum)
  (setf (TMAX plot) (- tnum 1))

  (setf (FUNCS plot) (make-list FI_MAX))
  (dotimes (fi fnum)
    (setf (nth fi (FUNCS plot)) (make-instance 'TT_FUNC)) ; ���� ���� �� �������!
    )

;  plot->x = (double*) malloc (xnum * sizeof(double));
  (setf     (X plot) (make-list xnum)) ; ????? ���e� ?????
  ;; ��� �� ��e�e�� ����� ���� ���� �e������e���e, � "��e���" - ��e �����e!!

  ;; �����e� ���� �� ��e�e�� (�� ���� "�����e")
  (setf (STEPS plot) (make-list TI_MAX))
  (dotimes (ti tnum)
    (setf (nth ti (STEPS plot)) (step_create)) 
    )

  ;; � ���e��� ��� ����� �����e�?
  ;(plot_make_step  plot ti fi)

  ;;------------------------------------------------------------
  ;; int fr[MAX_OUT][MAX_OUT]; 
  (setf (FR plot) (make-array (list MAX_OUT MAX_OUT)))

  ;; ��������� ��������� (���������) ������ �������:
  (plot_frames_init0  plot)

  ;; ��������� ��������� �������:
  (dotimes (fi fnum)
    (setf (PP_NAME plot fi) "")
    )

  ;;  ���� ��������� ������� ������ ������� - �� ������ ������� 
  (plot_frames_init1  plot)
  ;;------------------------------------------------------------

  ;(setf (L_TI plot) 0)

  (setf (XMIN_SET plot) 0) ; ��� ���� � �� �� ��������� ?!
  (setf (XMAX_SET plot) 0)

  plot
))
;-------------------------------------------------------------------------------
(defun plot_min_max_local (fi ti plot) 

(let (
  xmin ymin xmax ymax
  f_line
  (x (X plot))
  )

  (setf xmin   G_MAXDOUBLE)
  (setf xmax  -G_MAXDOUBLE)
  (setf ymin   G_MAXDOUBLE)
  (setf ymax  -G_MAXDOUBLE)

  (dotimes (i (L_XNUM plot))

    (when (< (nth i x) xmin) (setf xmin (nth i x)))
    (when (> (nth i x) xmax) (setf xmax (nth i x)))

    (setf f_line (PP_STEP_F plot ti fi))

    (when (< (nth i f_line) ymin) (setf ymin (nth i f_line)))
    (when (> (nth i f_line) ymax) (setf ymax (nth i f_line))) 
    )

  (values  xmin ymin xmax ymax)
))
;-------------------------------------------------------------------------------
(defun plot_min_max (fi plot)


  (setf  (PP_XMIN plot fi)  G_MAXDOUBLE)
  (setf  (PP_XMAX plot fi) -G_MAXDOUBLE)
  (setf  (PP_FMIN plot fi)  G_MAXDOUBLE)
  (setf  (PP_FMAX plot fi) -G_MAXDOUBLE)

  (dotimes (ti (L_TNUM plot))  ; // 0..1 ??

    (multiple-value-bind (xmin ymin xmax ymax) 
        (plot_min_max_local  fi ti plot)

    (setf (PP_XMIN plot fi) (MIN xmin (PP_XMIN plot fi)))
    (setf (PP_XMAX plot fi) (MAX xmax (PP_XMAX plot fi)))

    (setf (PP_FMIN plot fi) (MIN ymin (PP_FMIN plot fi)))
    (setf (PP_FMAX plot fi) (MAX ymax (PP_FMAX plot fi)))
    )
  )

  (when (FRavno (PP_FMIN plot fi) (PP_FMAX plot fi) EPS)
    ;; // !!!!!!!!!!!!!!!????
    (decf (PP_FMIN plot fi) 10.0)
    (incf (PP_FMAX plot fi) 10.0)
    )

)
;-------------------------------------------------------------------------------
; �������e� �������� ����e��� �� �������� �� ��e��e
;-------------------------------------------------------------------------------
(defun plot_get_minmax_frame (p wi)
;                       double *p_xmin, double *p_xmax, double *p_ymin, double *p_ymax)

(let* (
  xmin xmax ymin ymax
       is_xrang_calc
  fi 
  (li 0)

  )

  (setf xmin  (XMIN_SET p))
  (setf xmax  (XMAX_SET p))

  ;(format *error-output*  "plot_get_minmax_frame: xmin=~s xmax=~s ~%" xmin xmax)
  ;(format *error-output*  "PP_XMIN= ~s ~%" (PP_XMIN p 0))
  ;(format *error-output*  "PP_XMAX= ~s ~%" (PP_XMAX p 0))

  (if (>= xmin xmax) (progn  ; �������� ������ - ��������� ������� �� �����
    (setf is_xrang_calc t)
    (setf xmin  G_MAXDOUBLE)
    (setf xmax -G_MAXDOUBLE)
    )
    (setf is_xrang_calc NIL)
    )

  (setf ymin  G_MAXDOUBLE)
  (setf ymax -G_MAXDOUBLE) 

;  for (li=0; (fi = p->fr[wi][li]) != -1; li++) {
  (loop
    (setf fi (aref (FR p) wi li))
    (when (= fi -1) (return))

    (when (eq t is_xrang_calc) ; �������� ������
      (setf xmin (MIN xmin (PP_XMIN p fi)))
      (setf xmax (MAX xmax (PP_XMAX p fi)))
    )
     
    (setf ymin  (MIN ymin (PP_FMIN p fi)))
    (setf ymax  (MAX ymax (PP_FMAX p fi)))

    ;(setf li (1+ li))
    (incf li)
    )

  ;(format *error-output*  "plot_get_minmax_frame: xmin=~s xmax=~s ~%" xmin xmax)

  (values  xmin xmax ymin ymax)
))
;-------------------------------------------------------------------------------
;int 
;YInt (double f) 
;-------------------------------------------------------------------------------
(defun YInt (f) 
 
(let (
;  int     i; 
;  double   o;
  i o
  )
 
  ;i = (int) f; 
  (setf i (floor f)) 
  (setf o (- f i))

  (cond
   ((> o 0.5)   (incf i))
   ((< o -0.5)  (decf i))
   )
 
  i ; // ��������� �����
))
;-------------------------------------------------------------------------------
(defun plot_win_lines (plot win wi ti  
                            ix_0 iy_0 iw ih)

(let (
  fi 
  ;(li  0)
;  char znak[] = {'+', 'o', '*', '.', '#'};
  ;(znak (list '+ 'o '* 'q 's)) ; ���e�� �e����e� ������e 'O ��e��� 'o ??
  ;(znak (list '+' 'o' ))
  (znaki "+o*.#")

  x_step y_step x y ix iy
  )

  ;(format t "plot_win_lines .............. ~%")

;  for (li=0; (fi = plot->fr[wi][li]) != -1; li++) {
  (loop for li from 0 do
    (setf fi (aref (FR plot) wi li))
    (when (= fi -1) (return))

    ;; ��������� �������� ������
    (multiple-value-bind (xmin xmax ymin ymax) 
        (plot_get_minmax_frame plot wi)

      ;(format t "li=~s xmin=~s xmax=~s ymin=~s ymax=~s ~%" li xmin xmax ymin ymax)

      (setf x_step (/ (- xmax xmin) (- iw 1)))
      (setf y_step (/ (- ymax ymin) (- ih 1)))
      
      (setf x (X plot))              ; ������ ����� ��� �������
      (setf y (PP_STEP_F plot ti fi))  ; ������ �������
      
      (dotimes (i (L_XNUM plot))
        (setf ix (YInt (/ (- (nth i x) xmin) x_step)))
        (setf iy (YInt (/ (- (nth i y) ymin) y_step)))
        
        ;(win_char  win (nth li znak) (+ ix_0 ix) (- (+ iy_0 ih) (+ iy 1)))
        (win_char  win (char znaki li) (+ ix_0 ix) (- (+ iy_0 ih) (+ iy 1)))
        )
      )
    
    ;(setf li (1+ li))
    )

))
;-------------------------------------------------------------------------------
(defun print_tabl_one (win plot x y  f_0 f_1  i)
;                double *f_0, double *f_1, int i)

(declare (ignore f_1))
; �e����e� ������� ������ �e����� �������... � �����e � �e ��e��� !!

(let (
;  char str[80];
  str
  )

;  // ���� ���� 2-� ������, �� �������� ��� �������
;  // ���� �������� ��� ������������ ���� .. !!

;  //if (f_1)  sprintf (str, "%7.2f % f % f", plot->x[i], f_0[i], f_1[i]);
;  /* else */   sprintf (str, "%7.2f % f",     plot->x[i], f_0[i]);

  ;(format t ".... print_tabl_one: ~%" )

  ;(setf str (format nil "~7,2f  ~11,6f " (nth i (X plot)) (nth i f_0)))
  (setf str (format nil "~7,2f  ~11,6f " (P1_X  i) (nth i f_0)))
  (win_text win str x y)
))
;-------------------------------------------------------------------------------
(defun  win_plot_tabl_draw (fi0 fi1 ti win plot x y h)

(let (
;  int     i, j, h_all, h_beg, h_end;
;  double  *f_0, *f_1;

  h_all h_beg h_end j 
  f_0 f_1
  )

  (setf f_0 (PP_STEP_F plot ti fi0))

  (if (= fi1 (- 1))  
      (setf f_1 NIL)
      (setf f_1 (PP_STEP_F plot ti fi1))
      )

  ;(format t ".... win_plot_tabl_draw:  fi0= ~s  fi1= ~s  ~%" fi0 fi1)
  ;; // ������ ������� �������� �������
  (setf h_all (- h 2))
  ;(format t ".... 0 ~%" )

  (if (<= (L_XNUM plot) h_all) (progn ; ���������� ��� ��������

    ;(format t ".... 1 ~%" )
    (dotimes (i (L_XNUM plot))
      (print_tabl_one  win plot (+ x 2) (+ y i)  f_0 f_1 i)
      )
  ) (progn 
    ;(format t ".... 2 ~%" )
    ;h_end = h_all / 2 - 1; 
    (setf h_end (floor (- (/ h_all 2.0) 1))) ; floor
    (setf h_beg (- h_all h_end 1))

    ;(format t "h_all=~s  h_end=~s   h_beg=~s ~%"  h_all h_end h_beg)

    (dotimes (i h_beg) ; ������� ����� �������
      ;(format t ".... 31 ~%" )

      (print_tabl_one  win plot (+ x 2) (+ y i)  f_0 f_1 i)
      )
		
    ;(format t ".... 4 ~%" )
    (win_text win "..............." (+ x 2) (+ y h_beg))

    (setf y (+ y h_beg 1))

    (dotimes (i h_end) ; ������ ����� �������
      (setf j (- (L_XNUM plot) h_end (- 0 i)))
      (print_tabl_one  win plot (+ x 2) (+ y i)  f_0 f_1 j)
      )
  ))

))
;-------------------------------------------------------------------------------
(defun plot_win_right (plot win wi ti  x0 y0 hh)

(let (
  (fi0  (aref (FR plot) wi 0)) ; ������� ���� ������ 1-� ������
  (fi1  (aref (FR plot) wi 1))
  )

;  //char  str[80];
;  // ���� �� ����� �������� �������� (�� ������� � ����� �������� �� ��������)

  (win_text  win (PP_NAME plot fi0) (+ x0 2) y0)
;  // ����� ���� ������ �� ���������� ���..

;  //sprintf (str, "ymax =  % f", P_YMAX (plot, fi0));
;  //win_text (win, str, x0+2, y0+1);

  (win_plot_tabl_draw  fi0 fi1 
                       ti win plot  x0 (+ y0 2) (- hh 1))

;  //sprintf (str, "ymin =  % f", P_YMIN (plot, fi0));
;  //win_text (win, str, x0+2, y0 + hh-1);

))
;-------------------------------------------------------------------------------
(defun plot_win_main (plot win wi ti x y w h)

(let* (
;  // ���������� ������� ������
  (w2  (+ 21 10))
  ;(w1  (- w (+ w2 2)))
  (w1  (+ w (- w2) 2))
  )

  ;(format t "1........... ~%")
  ;; ������ ����� �������
  (plot_win_lines  plot win wi ti   x y (- w1 1) h)

  ;(format t "2........... ~%")
  ;; ������ �����������
  (win_vert win '! w1 y (+ y h))

  ;(format t "3........... ~%")
  ;; ������ ������ ����� (��� 1-�� �������, ���, ���� � ������� 1-�� �������)
  (plot_win_right  plot win  wi ti  w1 y h)


))
;-------------------------------------------------------------------------------
(defun plot_win (ti plot iw ih ih_one)

(let (
  (yi  1)

  ;; ������� �������� ����� � ������ ������� �������
  (win (win_create iw ih))
  )

  ;(format t "41 ..... ~%")
  (win_rect  win '= '! 0 0 iw ih) ; ���e�� �e ����e� '| ??
  ;(format t "42 ..... ~%")

  ;; ����� ���� ���� �� �� ������ �������, � �� �������!
  (loop for wi from 0 until (= (aref (FR plot) wi 0) -1) do

    ;(format t "wi=~s ti=~s yi=~s ~%" wi ti yi )
    (plot_win_main  plot win  wi ti  1 yi (- iw 2) ih_one)

    (incf yi ih_one)

    (win_horz  win '= yi 2 (- iw 3))
    (incf yi)
  )

  ;(format t "45 ..... ~%")

  ;; ������� �������� �����
  (win_draw  win 0 0)

))
;-------------------------------------------------------------------------------
(defun plot_print_info (p)

(let (
;  int fi, li, wi, wnum = plot_get_wnum (p);
  (wnum (plot_get_wnum p))
  )

  (format t "~%")
  (format t "PLOT_PRINT_INFO: ~%")

;  printf ("fnum=%d  xnum=%d  tnum=%d  tmax=%d   \n", 
;          p->fnum, p->xnum, p->tnum, p->tmax);
  (format t "fnum=~d  xnum=~d  tnum=~d  tmax=~d  ~%" 
          (L_FNUM p) (L_XNUM p) (L_TNUM p) (TMAX p))

  (format t "wnum=~d ~%" wnum)

;  for (wi=0; wi < wnum; wi++) {
  (dotimes (wi wnum)
    (format t "wi=~d  " wi)

;    for (li=0; (fi = p->fr[wi][li]) != -1; li++) {
;      //printf ("li=%d  ", li);
;      printf ("%s  ", P_NAME (p, fi));
;    }

    (format t "~%")
    )

  (format t "~%")
))
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
(defun plotstep_init_win (ps)

;  //ps->plot->wnum = plot_get_wnum (ps->plot);
;  int wnum = ps->plot->wnum;

(let (
  (wnum (WNUM (PLOT ps)))
  )

  (if (= wnum 1) (setf (IH_ONE ps) 18)) 
  (if (= wnum 2) (setf (IH_ONE ps) 13)) 
  (if (= wnum 3) (setf (IH_ONE ps)  9))
  (if (= wnum 4) (setf (IH_ONE ps)  8))
 
  (setf (IH ps) (+ (* wnum (IH_ONE ps)) wnum 1)) ;; ??
  (setf (IW ps) 70)
		
  (setf (FIRST1 ps) t)
  (setf (FIRST2 ps) t)

))
;-------------------------------------------------------------------------------
(defun plot_min_max_wnum (plot)

  (dotimes (fi (L_FNUM plot))
    (plot_min_max  fi plot)
    )
		
  (setf (WNUM plot) (plot_get_wnum plot))

)
;-------------------------------------------------------------------------------
(defun plotstep_create (plot)

(let (
  (ps (make-instance 'T_PLOTSTEP))
  )

  (setf (PLOT ps) plot)
  ps
))
;-------------------------------------------------------------------------------
(defun plot_step_beg (plot)

(let (
  (ps  (plotstep_create plot))
  )

  ;(format t "..... 1 ~%")
  (plot_min_max_wnum plot)
  ;(format t "..... 2 ~%")
  (plotstep_init_win  ps)
  ;(format t "..... 3 ~%")

  ps
))
;-------------------------------------------------------------------------------
(defun plot_step_do (ps ti)

(let (
;  int   i;
  (title (PP_STEP_NAME (PLOT ps) ti))
  )

;  if (!(ps->first1)) CUU;

;    if (ps->first2) ps->first2 = FALSE;
;    else for (i=0; i < ps->ih; i++) CUU;

;  printf ("%s \n", title);
;  (format t "~A ~%" (PP_STEP_NAME (PLOT ps) 0))
  (format t "~A ~%" title)

  ;(format t "3 ..... ~%")
  (plot_win  ti (PLOT ps) (IW ps) (IH ps) (IH_ONE ps))
  ;(format t "8 ..... ~%")
			
;  if (ps->first1) {
;    printf ("\n"); CUU; 
;    ps->first1 = FALSE;
;  }

  (format t "Command: ")

))
;-------------------------------------------------------------------------------
(defun plot_print_one (plot ti)

(let (
;  T_PLOTSTEP *ps;
  (ps (plot_step_beg  plot))
  )

  ;(format t "2 ..... ~%")
  (plot_step_do  ps ti)

  ;(plot_step_end  ps)

))
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
(defun plot_print (plot)

(let (
  ti
  (ti_incr  +1)
  ps
  ch ; char buff[80];
  )

  (setf ps (plot_step_beg plot))

  ;(setf ti (TMAX plot)) ; ������e� � ����e��e��..  � ���e� ����e � �e�����?
  (setf ti 0)

  (loop
     (plot_step_do ps ti)

;     (loop
;      fgets (buff, 50, stdin); CUU;
       (setf ch (read-char))
;       (setf ch (read))
       (incf ti ti_incr)

;      if      (buff[0] == '\n') ti += ti_incr;
;      else if (buff[0] ==  'g') ti = atoi(&(buff[1]));
;      else if (buff[0] ==  '[') ti = 0;
;      else if (buff[0] ==  ']') ti = plot->tmax;
;      else if (buff[0] ==  'q') goto end;
;      else continue;

       ;(when (equal ch 'q) (return)) ; ??
       (when (eql ch 'Q) (return)) 
       ;(when (char= ch 'Q) (return))  ; *** - CHAR=: argument Q is not a character

       (when (> ti (TMAX plot)) (setf ti 0))
;      break;
;       )
     )

))
;-------------------------------------------------------------------------------
;
;23.5. Accessing Directories

;The following function is a very simple portable primitive for examining a 
;directory. Most file systems can support much more powerful directory-searching 
;primitives, but no two are alike. It is expected that most implementations of 
;Common Lisp will extend the directory function or provide more powerful 
;primitives. 

;-------------------------------------------------------------------------------
(defun delete_files_in_dir (pathname)

(let (

;A list of pathnames is returned, one for each file in the file system that 
;matches the given pathname. (The pathname argument may be a pathname, a string, 
;or a stream associated with a file.) For a file that matches, the truename 
;appears in the result list. 

  (dir_list (directory pathname))
  )

  (dotimes (i (list-length dir_list))

;The specified file is deleted. The file may be a string, a pathname, or a stream
    (delete-file (nth i dir_list))
    )

))
;-------------------------------------------------------------------------------
(defun print_files_in_dir (pathname)

(let (
  (dir_list (directory pathname))
  )

  (dotimes (i (list-length dir_list))
    (format t "file= ~s ~%" (nth i dir_list))
    )

))
;-------------------------------------------------------------------------------
(defun write_line_to_file (plot ti fi name)

  ;(Y-system (format nil "mkdir D/~a_files"))  ; �o����� ����

  (with-open-file (ofile (format nil "D/~a_files/~a_~d" name name ti) 
                       :direction :output 
                       :if-exists :supersede)       
  
  ;;(format ofile "~A" (PP_STEP_F plot ti 0)) ; �e�� �e���� �� ��������
  
  (dotimes (j (L_XNUM plot))
    (format ofile "~a " (nth j (PP_STEP_F plot ti fi)))
  )
    
))
;-------------------------------------------------------------------------------
(defun delete_plot_files_dirs_in_D_dir ()

;(format *error-output* "11 ... ~%")

;(Y-system "pwd")  ; 
;(format *error-output* "12 ... ~%")

  (Y-system "rm -f D/*_files/*")  ; ������� �������� ��e ���� �� ������

;(format *error-output* "13 ... ~%")

  (Y-system "rmdir --ignore-fail-on-non-empty D/*_files")    
  ;; � ���e� �����e� �����e ����

;(format *error-output* "14 ... ~%")

)
;-------------------------------------------------------------------------------
; ������e��� ����e �� s_funo.cl -> minfunc_print_prepare
;-------------------------------------------------------------------------------
(defun plot_save (plot)

(let (
  name
  (work_dir "D")
  )

;(format *error-output* "10 ... ~%")

  ;; ��e�� ���� �� �������� ���e������ �� ������ ����� � �� ������
  (delete_plot_files_dirs_in_D_dir)

;(format *error-output* "19 ... ~%")

  ;; ---------------- ��e� ������ �� ��e� ��������
  (dotimes (fi (L_FNUM plot))
    (setf name (PP_NAME plot fi))
    (format *error-output* "PP_NAME= ~s ~%" name)    

    (Y-system (format nil "mkdir ~a/~a_files" work_dir name))  ; �o����� ���� ��� �������

    (dotimes (ti (L_TNUM plot)) ; �������� ���� ����� �� ������ ��e�e��
      (write_line_to_file plot ti fi name) 
    )
  )
  ;; ---------------------------------------------

  (Y-system (format nil "mkdir ~a/t_files" work_dir) )  ; �o����� ������ t-���� 

  ;; ��������e� �����e �����-��e�e��
  (dotimes (ti (L_TNUM plot))     
    (with-open-file (ofile (format nil "~a/t_files/t_~D" work_dir ti) 
                           :direction :output 
                           :if-exists :supersede
                           )       
      (format ofile "~d" ti)    )

  )

))
;-------------------------------------------------------------------------------
(defun dir_test (argus) (declare (ignore argus))


;  (delete_files_in_dir "P/t_files/t_*")
;  (delete_files_in_dir "P/u_files/u_*")

;  (print_files_in_dir "D/*")  ; CLISP ��e� ����e� ����� �e� ���e������ !
;  (format t "~%")
;  (print_files_in_dir "D/t_files/*")
;  (format t "~%")

;  (Y-system "ls -all") 

  (delete_plot_files_dirs_in_D_dir)

)
;===============================================================================
;
;
;===============================================================================
;-------------------------------------------------------------------------------
(defun plot_set_xvals (plot xnum fi_min fi_max_)

(let* (
  fi_step
  )

  (setf fi_step (/ (- fi_max_ fi_min) (- xnum 1)))

  ;; ��������� �������� "x
  (dotimes (i xnum)
    (setf (nth i (X plot)) (+ fi_min (* fi_step i)))
    )

))
;-------------------------------------------------------------------------------
;YT_PLOT*
(defun make_test3 (tnum xnum 
                        fi_min 
                        fi_max_ ; fi_max ????? ���e��-�� ��e� ������ 
                        ;;        MAKE-LIST: 6.28 is not a 32-bit number
                        )

(let* (
  (fnum  2)

  (plot  (plot_create fnum xnum tnum))
  )

  ; ??
  (plot_set_xvals  plot xnum fi_min fi_max_)

  (setf (PP_NAME plot 0)    "Sinus")
  (setf (PP_NAME plot 1)    "Cosin")

  ;; ���� �� ������� ��e ������� ..
  (dotimes (ti tnum)
    (plot_make_step_new  plot ti)
    )

  (dotimes (ti tnum)

    ;; ��������� �������� "f"
    (dotimes (xi xnum)
      ;(format t "ti=~s  xi=~s ~%" ti xi)
      (setf (PVAL ti 0 xi)    (sin (* (+ ti 1) (P1_X xi)))) ; fi=0
      (setf (PVAL ti 1 xi)    (cos             (P1_X xi)))
      )

    ;; ����� ���� ..
    (setf (PP_STEP_NAME plot ti) (format nil "ti = ~D" ti))    
    )

  plot
))
;-------------------------------------------------------------------------------
;YT_PLOT *
(defun plot_test3_prepare ()

(let (
  (plot (make_test3  10 100  0 (* 2 G_PI)))
  )

  ;; ��������� ��������� (���������) ������ �������:
  (plot_frames_init0 plot)

  ;; � 1-� ������:
  (setf (aref (FR plot) 0 0)  0)  ; "Sinus"
  (setf (aref (FR plot) 0 1)  1)  ; "Cosin"

  ;; �� 2-� ������:
  (setf (aref (FR plot) 1 0)  0)  ; "Sinus" 

  plot
))
;-------------------------------------------------------------------------------
(defun plot_test3 (argus)  (declare (ignore argus))

(let (
  (plot (plot_test3_prepare))
  )

  ;(format t "~%")
  (plot_print plot)

))
;-------------------------------------------------------------------------------
; �e� �� �����e �e���� - � �e��e �e�������, ��������� ��� �e�.. !!
;-------------------------------------------------------------------------------
(defun plot_test3_save (argus)  (declare (ignore argus))

(let (
  (plot (plot_test3_prepare))
  )

  (plot_save plot)
  (format t "~%")    
  (format t "plot_test3_save .. OK ~%")    
  (format t "~%")    

))
;===============================================================================
;
;-------------------------------------------------------------------------------
; ���e� ��e�� ���������� ��������� ����e �������
;
;-------------------------------------------------------------------------------
(defun plot_make_step_new (plot ti)

(let (
  (step_name "PLOT_TEST")  ; "TITLE-STEP"
  )

  (setf (PP_STEP_NAME plot ti)  step_name)

  (dotimes (fi (L_FNUM plot))
    (plot_make_step_fi  plot ti fi)
  )

))
;-------------------------------------------------------------------------------
(defun plot1_create (fnum tnum  xnum) ; ���e���� ������� �e�e�e����

(let* (
  (plot (plot_create  fnum xnum tnum))
  )

  ;; 0-� ���� ���e� ��e��� ���������
  (plot_make_step_new  plot 0)

  plot
))
;-------------------------------------------------------------------------------
(defun p1_test1_prepare ()

(let* (
  (fnum  2)
  (xnum 10)

  (plot (plot1_create  fnum 1  xnum))
  )

  (dotimes (xi (L_XNUM plot))
    (setf (P1_X      xi)             xi)  ; plot->x[i] = i; ???
    )

  (dotimes (fi (L_FNUM plot))
  (dotimes (xi (L_XNUM plot))
    (setf (PVAL 0 fi xi) (* (+ fi 1) xi)) ; f_line[i]  = (fi+1)*i;
    ))
	
  plot
))
;-------------------------------------------------------------------------------
(defun p1_test1 (argus)  (declare (ignore argus))

(let (
  (plot (p1_test1_prepare))
  )

  (plot_print_one plot 0)

))
;===============================================================================
;-------------------------------------------------------------------------------
(defun p2_test_prepare ()

(let* (
  (fnum  1)
  (xnum 10)
  (ynum 10)

  (plot (plot_create_new  fnum 1  (list xnum ynum)))
  )

;  (dotimes (xi (L_XNUM plot))
;    (setf (P1_X      xi)             xi)  ; plot->x[i] = i; ???
;    )

;  (dotimes (fi (L_FNUM plot))
;  (dotimes (xi (L_XNUM plot))
;    (setf (PVAL 0 fi xi) (* (+ fi 1) xi)) ; f_line[i]  = (fi+1)*i;
;    ))
	
  plot
))
;-------------------------------------------------------------------------------
(defun p2_test (argus)  (declare (ignore argus))

(let (
  (plot (p2_test_prepare))
  )

  ;(plot2_print_one plot 0)

))
;===============================================================================
