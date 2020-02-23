;;;=============================================================================

;(load "c-mbee.cl")  

;===============================================================================
; 
;;;=============================================================================

(defvar *calc_xi* :un)

;enum keywords_1 {
;  YINIT, YFREE, YCALC, YTRUE,  

;  YGINT, YRINT, YQINT, 

;  Y_BEG, YTODO, 
;  Y_PEREBOR, YGSLSPUSK, 
;  Y_GENALGO, 
;};

(defvar YINIT  0)
(defvar YTRUE  1)
(defvar YCALC  2)
(defvar YFREE  3)

(defvar YREAD  4)
(defvar YWRITE 5)

(defvar POWER_DEF  0)
(defvar POWER_NOT -1)

;===============================================================================

(defvar MAX_DIM 1000) ; ������������ ����� ���������� !!!!!
(defvar MAXB 250)     ; ������������ ����� ���. �����������, � ����� ���. �������

;#define FN(n) (fun[(n)-1])
;#define XN(n) (xyz[(n)-1])

(defmacro XN (n)  `(aref xyz (- ,n 1)) )

;#define X1 (XN(1))
;#define X2 (XN(2))

;// ����� �������� �������� �������
(defclass YT_FPOINTS () (
;  int     num;
;  double  xyz[MAXB][MAX_DIM];
;  double  fun[MAXB];

  (num :accessor NUM)
  (xyz :accessor XYZ)
  (fun :accessor FUN)
))

(defclass YT_MINPROC () (
;  YT_PROC  proc;
  (proc    :accessor P_PROC)

;  char    *name;
;  int      dim;
;  double  *xyz_min; 
;  double  *xyz_max;

  (name    :accessor P_NAME)
  (dim     :accessor P_DIM)
  (xyz_min :accessor P_XYZ_MIN)
  (xyz_max :accessor P_XYZ_MAX)

;  double   xyz_err[MAX_DIM]; // ?? - ���� ������� �����������
  (xyz_err :accessor P_XYZ_ERR)

;  YT_FPOINTS *s_init; // ��������� ����������� ��� ������ 
;  YT_FPOINTS *s_calc; // ��������� (���������?) ������� 
;  YT_FPOINTS *s_true; // ��� ��� �������� ����������� �������-��������

  (s_init  :accessor S_INIT)  
  (s_calc  :accessor S_CALC)  
  (s_true  :accessor S_TRUE)  
))

;-------------------------------------------------------------------------------

;#define MM minproc

;#define P_DIM(p)  ((p)->dim)
;#define DIM       (P_DIM(minproc))
;#define PROC      (MM->proc)
;#define NAME      (MM->name)

(defmacro DIM  () `(P_DIM minproc))
(defmacro NAME () `(P_NAME minproc))

;#define P_XYZ_MIN(p) (((p)->xyz_min))
;#define P_XYZ_MAX(p) (((p)->xyz_max))
;#define P_XYZ_ERR(p) (((p)->xyz_err))

(defmacro XYZ_MIN () `(P_XYZ_MIN minproc))
(defmacro XYZ_MAX () `(P_XYZ_MAX minproc))
(defmacro XYZ_ERR () `(P_XYZ_ERR minproc))

;#define XYZ_MIN (P_XYZ_MIN(minproc))
;#define XYZ_MAX (P_XYZ_MAX(minproc))
;#define XYZ_ERR (P_XYZ_ERR(minproc))

;#define X_MIN   (XYZ_MIN[0])
;#define X_MAX   (XYZ_MAX[0])
;#define X_ERR   (XYZ_ERR[0])
;#define Y_MIN   (XYZ_MIN[1])
;#define Y_MAX   (XYZ_MAX[1])
;#define Y_ERR   (XYZ_ERR[1])
;#define Z_MIN   (XYZ_MIN[2])
;#define Z_MAX   (XYZ_MAX[2])
;#define Z_ERR   (XYZ_ERR[2])

;//---------------------------------------
;#define P_NUM(p) ((p)->num)
;#define P_XYZ(p) ((p)->xyz)
;#define P_FUN(p) ((p)->fun)

;(defmacro P_NUM (p) (list 'NUM p))
;(defmacro NUM_BEG () (list 'S_INIT (list 'P_NUM 'minproc) ))

(defmacro NUM_BEG () `(NUM (S_INIT minproc)) )
(defmacro NUM_END () `(NUM (S_CALC minproc)) )

(defmacro XYZ_BEG () `(XYZ (S_INIT minproc)) )
(defmacro XYZ_END () `(XYZ (S_CALC minproc)) )
(defmacro XYZ_TRU () `(XYZ (S_TRUE minproc)) )

(defmacro FUN_BEG () `(FUN (S_INIT minproc)) )
(defmacro FUN_END () `(FUN (S_CALC minproc)) )
(defmacro FUN_TRU () `(FUN (S_TRUE minproc)) )

;#define NUM_BEG  (P_NUM(MM->s_init))
;#define XYZ_BEG  (P_XYZ(MM->s_init))
;#define FUN_BEG  (P_FUN(MM->s_init))

;#define NUM_END (P_NUM(MM->s_calc))
;#define XYZ_END (P_XYZ(MM->s_calc))
;#define FUN_END (P_FUN(MM->s_calc))

;#define M_TRUE (MM->s_true)

(defmacro NUM_TRU () `(NUM (S_TRUE minproc)) )

;-------------------------------------------------------------------------------

(defclass YT_MINBOT () (
;  char   name[NAMELENG+1];   // ������������ (���������) ��� 
  (name    :accessor P_NAME)

;  long   long1, long2, long3;
;  double d1;
  (long1  :accessor LONG1)
  (long2  :accessor LONG2)
  (long3  :accessor LONG3)
  (d1     :accessor D1)

;  MINBOT_DATA bot_data;
;  MINBOT_TODO bot_todo;

  (bot_data :accessor BOT_DATA)
  (bot_todo :accessor BOT_TODO)

;  YT_MINPROC  *minproc;
;  int          s_power;
;  void        *v_param; 

  (minproc :accessor MINPROC)
  (s_power :accessor S_POWER)
  (v_param :accessor V_PARAM)
))

;===============================================================================
;
;-------------------------------------------------------------------------------
;BOOL
;IsXyzRavno (int dim, double *xyz_one, double *xyz_two, double eps)
;-------------------------------------------------------------------------------
(defun IsXyzRavno (dim xyz_one xyz_two eps)

;  int  i;

  (dotimes (i dim)
;    if (!(FRavno (xyz_one[i], xyz_two[i], eps))) {
;      return (FALSE);
;    }
    (when (not (FRavno (aref xyz_one i) (aref xyz_two i) eps))
      (return-from IsXyzRavno NIL)
      )
    )

;  return (TRUE);
  t
)
;-------------------------------------------------------------------------------
(defun make_xyz_from_fpoints (dim fpts num)

(let (
  (xyz (make-array dim))
  )

  (dotimes (i dim)
    (setf (aref xyz i) (aref (XYZ fpts) num i))
    )

  xyz
))
;-------------------------------------------------------------------------------
;BOOL
;fpoints_find_xyz (int dim, YT_FPOINTS *fpts, double *xyz_cur, double eps)
;-------------------------------------------------------------------------------
(defun fpoints_find_xyz (dim fpts xyz_cur eps)


;  int  num;

  (dotimes (num (NUM fpts))
;    double *xyz_end = &(fpts->xyz[num][0]);

    ;; ��e�� ������ ���� � ����� ������e��e� �e ��������, ���� ����������
    ;; � � �����e��e� ��e���� ������ ����e���e
    (let (
      (xyz_end (make_xyz_from_fpoints  dim fpts num))
      )

;    if (IsXyzRavno (dim, xyz_end, xyz_cur, eps))
;      return (TRUE);
    (when (IsXyzRavno dim xyz_end xyz_cur eps)
      (return-from fpoints_find_xyz t)
      )
    ))

;  return (FALSE);
  NIL
)
;-------------------------------------------------------------------------------
;void
;xyz_print_one (int dim, double *xyz)
;-------------------------------------------------------------------------------
(defun xyz_print_one (dim xyz)

  (dotimes (i dim)
;    printf ("%5.2f ", xyz[i]);
    (format t "~F " xyz)
    )

;  printf ("\n");
  (format t "~%")

)
;-------------------------------------------------------------------------------
;void
;fpoints_print (YT_FPOINTS *fpts, char *name, int dim)
;-------------------------------------------------------------------------------
(defun fpoints_print (fpts name dim)

  (dotimes (num (NUM fpts))
;    if (name)
;    printf ("               %s", name);
;    printf ("f= %7.2f  x= ", fpts->fun[0]);

    (format t "               ~A" name)
    (format t "f= ~F  x= " (nth 0 (FUN fpts)))

    ;; xyz_print_one (dim, fpts->xyz[num]);

    (let (
      (xyz (make_xyz_from_fpoints  dim fpts num))
      )
      (xyz_print_one  dim xyz)
    ))

)
;===============================================================================
;//
;-------------------------------------------------------------------------------
;YT_FPOINTS *
(defun fpoints_create (num_ dim_)

(let* (
;  (num_ MAXB)
;  (dim_ MAX_DIM)

;  YT_FPOINTS *fpts = (YT_FPOINTS *) malloc (sizeof (YT_FPOINTS));
  (fpts (make-instance 'YT_FPOINTS))
  )

;  double  xyz[MAXB][MAX_DIM];
;  double  fun[MAXB];

  (setf (XYZ fpts) (make-array (list num_ dim_))) ; ���e� ��� �����e ����e���� ������ ?
  (setf (FUN fpts) (make-list  num_))

  fpts
))
;-------------------------------------------------------------------------------
;void
;fpoints_copy (int dim, YT_FPOINTS *t/*to*/, YT_FPOINTS *f/*from*/)
;{
;  int n, d;

;  t->num = f->num;

;  for (n=0; n < f->num; n++) {
;    t->fun[n] = f->fun[n];   
;    for (d=0; d < dim; d++) {  
;    //for (d=0; d < MAX_DIM; d++) {  //� ����� ����� ��� ����������� ����������
;      t->xyz[n][d] = f->xyz[n][d];
;    }
;  }

;  return;
;}
;-------------------------------------------------------------------------------
(defun minproc_create_arrays (minproc num_ dim_)

(let* (
;  (num_ MAXB)
;  (dim_ MAX_DIM)
  )

  (setf (XYZ_MIN) (make-list dim_)) ; ���e� ��e�� ����e ������e �������?
  (setf (XYZ_MAX) (make-list dim_))

  (setf (XYZ_ERR) (make-list dim_))

  (setf (S_INIT minproc) (fpoints_create num_ dim_))
  (setf (S_CALC minproc) (fpoints_create num_ dim_))
  (setf (S_TRUE minproc) (fpoints_create num_ dim_))

))
;-------------------------------------------------------------------------------
;YT_MINPROC *
;minproc_create (YT_PROC proc)
;-------------------------------------------------------------------------------
(defun minproc_create_ (proc)

(let* (
;  (num_ MAXB)
;  (dim_ MAX_DIM)

  (minproc (make-instance 'YT_MINPROC))
  )

  (setf (P_PROC minproc) proc) ; ����e����-�����e
  ;  // �������� ���������-��� ??????

  minproc
))
;-------------------------------------------------------------------------------
(defun minproc_create (proc)

(let* (
;  (num_ MAXB)
;  (dim_ MAX_DIM)

  (minproc (minproc_create_ proc))
  )

  (minproc_create_arrays  minproc MAXB MAX_DIM)

  minproc
))
;-------------------------------------------------------------------------------
;void
;minproc_begin (YT_MINPROC *minproc, long long1, long long2)
;-------------------------------------------------------------------------------
(defun minproc_begin (minproc long1 long2)


  (setf (DIM) 0)
  (setf (NUM_BEG) 0)
  (setf (NUM_END) 0) ; // ����� ����� �������������

  (funcall (P_PROC minproc)  YINIT NIL NIL long1 long2 minproc NIL)

  (funcall (P_PROC minproc)  YTRUE NIL NIL     0     0 minproc NIL)

)
;-------------------------------------------------------------------------------
;YT_MINPROC *
;minproc_create_begin (YT_PROC proc)
;-------------------------------------------------------------------------------
(defun minproc_create_begin (proc)

(let (
  (num_ MAXB)
  (dim_ MAX_DIM)

  (minproc  (minproc_create_ proc))
  )

  (minproc_create_arrays  minproc num_ dim_)

  (minproc_begin minproc 0 0)

  minproc
))
;-------------------------------------------------------------------------------
;void
;minproc_set (YT_MINPROC *minproc, double set_min, double set_max, double set_err)
;-------------------------------------------------------------------------------
(defun minproc_set (minproc set_min set_max set_err)


  (dotimes (i (DIM))

    (setf (nth i (XYZ_MIN)) set_min)
    (setf (nth i (XYZ_MAX)) set_max)
    (setf (nth i (XYZ_ERR)) set_err)
  )

)
;-------------------------------------------------------------------------------
;double
;minproc_calc_proc (YT_MINPROC *minproc, double *xyz_cur)
;-------------------------------------------------------------------------------
; ��� �e����e����e����� ������, ������e� �� �e�e������� ���������
;-------------------------------------------------------------------------------
(defun minproc_calc_proc (minproc xyz_cur)

(let (
;  double ret;
  ret
  )
  
  ;(format t "minproc_calc_proc:   xyz_cur= ~s ~%" xyz_cur)
  ;(quit) ; !!!!!!!!!!!!1

;  PROC (YCALC, xyz_cur, NULL, 0,0, minproc, &ret);
  (setf ret
        (funcall (P_PROC minproc) YCALC xyz_cur NIL 0 0 minproc t))

  ret
))
;-------------------------------------------------------------------------------
;void
;minproc_write_xyzend_n (YT_MINPROC *minproc, double *xyz, int n)
;-------------------------------------------------------------------------------
(defun minproc_write_xyzend_n (minproc xyz n)

;  for (i=0; i<DIM; i++) {
;    XYZ_END[n][i] = xyz[i];
;  }
  (dotimes (i (DIM))
    (setf (aref (XYZ_END) n i) (aref xyz i))    
    )
)
;-------------------------------------------------------------------------------
(defun minproc_add_xyzend (minproc xyz)

;  if (NUM_END >= MAXB) {
;    Error ("minproc_add_xyzend: NUM_END >= MAXB");
;  }

  (when (>= (NUM_END) MAXB) 
    (error "minproc_add_xyzend: NUM_END >= MAXB")   
    )

  (minproc_write_xyzend_n  minproc xyz (NUM_END))

;  NUM_END++;
  (incf (NUM_END))

)
;-------------------------------------------------------------------------------
;void
;minproc_rand_init (YT_MINPROC *minproc, int num_multy)
;-------------------------------------------------------------------------------
(defun minproc_rand_init (minproc  num_multy)

(let (
;  int  n, i;
  v ;  double  v;
 )

;  //YRAND_C;
;  //YRAND_S;

;  (YRAND_F) ;  YRAND_F; // �� ����� ����� ��� �� ���������

;  //if (debug) printf ("num_multy= %d \n", num_multy);

;  for (n = NUM_BEG; n < num_multy; n++) {
  (loop for n from (NUM_BEG) to (- num_multy 1) do

     ;(format t "v= ")  ; if (debug) printf ("v= ");
    
;    for (i=0; i < DIM; i++) {
     (dotimes (i (DIM))
;      v = YRandF (XYZ_MIN[i], XYZ_MAX[i]);
       (setf v (YRandF (nth i (XYZ_MIN)) (nth i (XYZ_MAX)) ))

;      XYZ_BEG[n][i] = v;
       (setf (aref (XYZ_BEG) n i) v) ; ���e� ��� ����e���� ������ ?
       ;(format t "~4,2F " v) ; if (debug) printf ("% 4.2f ", v);
       )
;    }

;    FUN_BEG[n] = minproc_calc_proc (minproc, XYZ_BEG[n]);
    (setf (nth n (FUN_BEG)) 
          (minproc_calc_proc  minproc (make_xyz_from_fpoints  (DIM) (S_INIT minproc) n))
          )

    ;(format t "~4,2F " (nth n (FUN_BEG))) ; if (debug) printf ("  f= % 4.2f \n", FUN_BEG[n]);
    ;(format t "~%") 
    )

;  NUM_BEG = MAX (NUM_BEG, num_multy);
  (setf (NUM_BEG) (max (NUM_BEG) num_multy))

))
;-------------------------------------------------------------------------------
;void
;minproc_free (YT_MINPROC *minproc)
;{

;  PROC (YFREE, NULL, NULL, 0, 0, minproc, NULL);
;  free (minproc);

;  return;
;}
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
;// ���������� ����������� � ������ �������
;-------------------------------------------------------------------------------
;BOOL
;fpoints_compare (int dim, YT_FPOINTS *s_calc, YT_FPOINTS *s_true, double eps)
;-------------------------------------------------------------------------------
(defun fpoints_compare (dim s_calc s_true eps)

(let (
;  int    n;
;  BOOL   find;
  find xyz
  )

;  if (s_calc->num != s_true->num) // ��� ���������� �� ���-�� �������
;    return (FALSE);
  (unless (= (NUM s_calc) (NUM s_true))
    (return-from fpoints_compare NIL))

  (dotimes (n (NUM s_calc))
;    find = fpoints_find_xyz (dim, s_true, &(s_calc->xyz[n][0]), eps);
;    if (!find) return (FALSE);
    
    (setf xyz (make_xyz_from_fpoints  dim s_calc n))
    (setf find (fpoints_find_xyz  dim s_true xyz eps))
    (unless find 
      (return-from fpoints_compare NIL))
    )

;  return (TRUE);
  t
))
;-------------------------------------------------------------------------------
;void
;minproc_check_new_solution (YT_MINPROC *minproc, double *xyz_cur, double g)
;-------------------------------------------------------------------------------
(defun minproc_check_new_solution (minproc xyz_cur g)

(let (
;  BOOL    find;
  find
;  // ����� ��������� � ��������� ���������� ��������� !!!!
;  double  eps = /* EPS  */0.0001;
  (eps 0.0001)
  )

;  // ��� �������� ��� ������ ������������ �������� :

  (cond 
   ((> g (+ (nth 0 (FUN_END)) eps)) (return-from minproc_check_new_solution))
;  if      (g > FUN_END[0] + eps)  return; // ������� ��������
;  else if (g < FUN_END[0] - eps) { // ����� ����������� �������
   ((< g (- (nth 0 (FUN_END)) eps)) 
;    FUN_END[0] = g;
;    NUM_END = 0;
    (setf (nth 0 (FUN_END)) g)
    (setf (NUM_END) 0)
    (minproc_add_xyzend  minproc xyz_cur)
    )
;  } else { // ������� ��� ���� �������� ����� ������
   (t 
;    // ��������� ���� �� ��� ����� ������ !!!!
;    find = fpoints_find_xyz (DIM, MM->s_calc, xyz_cur, eps);
    (setf find (fpoints_find_xyz  (DIM) (S_CALC minproc) xyz_cur eps))

;    if (!find) { // �������� ����� �������� ������������ ������
;      minproc_add_xyzend (minproc, xyz_cur);
;    }
    (unless find ;// �������� ����� �������� ������������ ������
      (minproc_add_xyzend  minproc xyz_cur))
    )
  )

))
;===============================================================================
;
;===============================================================================
;-------------------------------------------------------------------------------
(defun botbees_init (bot long1 long2 long3 d1)

  (declare (ignore d1))

  (setf (LONG1 bot) long1)
  (setf (LONG2 bot) long2)
  (setf (LONG3 bot) long3)

)
;-------------------------------------------------------------------------------
(defun botbees_data (bot minproc)


  (setf (MINPROC bot) minproc)

)
;-------------------------------------------------------------------------------
(defun botbees_todo_main (bot
                          minvalue num_steps 
                          random-point-number 
                          loc_interval loc_bnumbers 
                          chosen-number 
                          decrease ; ��e�� ������ ����e� ��� ���e�e��� ����� �����e��� !
                          )

(let* (
  (minproc    (MINPROC bot))
  ;(random-point-number (LONG1 bot))

  (null-point NIL)
  )

  (unless (= (NUM_BEG) 0) 
    ;; �������e� ��������� �����
    (setf null-point (make-list (DIM)))
    (dotimes (i (DIM))
      (setf (nth i null-point) (aref (XYZ_BEG) 0 i)))
    )


  (multiple-value-bind (min_point min_val)
      (bee-cycle  *calc_xi* (DIM) 
                  minvalue
                  num_steps  ; m�����e���� ������ ������
                  
                  (XYZ_MIN) (XYZ_MAX) 
                  random-point-number ; �����e���� ����e������
                  
                  null-point        
                  loc_interval  ; ������� ����. ������ ����� ���e�
                  loc_bnumbers  
                  
                  chosen-number ; ������� ������ ��e� ������e� �� ���������
                  decrease      ; ���e�e��e� �����e��� ������       
                  )


    ;; �������e� ���e���� ����� (����e���� �������) 
    (dotimes (i (DIM))
      (setf (aref (XYZ_END) 0 i) (nth i min_point))    
      )

    ;; � ����e��e � ���� ����e
    (setf (nth 0 (FUN_END)) min_val)    
    )

  ;; ���� �����e�, ��� �e�e��e ����
  (setf (NUM_END) 1)
))
;-------------------------------------------------------------------------------
(defun botbees_todo (bot)

  (botbees_todo_main  bot 
                      NIL   ; 0.001
                      150   ; num_steps
                      10    ; random-point-number
                      0.1   ; loc_interval
                      5     ; loc_bnumbers
                      5     ; chosen-number
                      0.95  ; decrease
                      )

)
;-------------------------------------------------------------------------------
(defun botbees_todo_new (bot)

(let* (
  (minproc (MINPROC bot))

  (dim (DIM))
  xmin xmax 
  loc_interval minvalue
  )

  (setf xmin (nth 0 (XYZ_MIN)))
  (setf xmax (nth 0 (XYZ_MAX)))

  ;; ��e�� ���� ���-�� ���ee ���������������
  ;(setf loc_interval (/ (- xmax xmin) 100))
  ;(setf loc_interval 0.001) ; 0.0001 *** - floating point underflow
  (setf loc_interval 0.0001) ; 0.0001 *** - floating point underflow

  (setf minvalue NIL) ;0.001)

;  (format t "~%")
;  (format t "dim= ~S ~%"  dim)
;  (dotimes (i dim)
;    (format t "min= ~S  max= ~S  ~%" (nth i (XYZ_MIN)) (nth i (XYZ_MAX)) )
;    )
;  (format t "~%")

  ;(format t "min= ~S ~%" xmin)
  ;(format t "max= ~S ~%" xmax)
  ;(format t "interval= ~S ~%" loc_interval)

  (botbees_todo_main  bot
                      minvalue 
                      100   ; num_steps
                        0   ; random-point-number ;���� �� ����e���� �� 0
                      
                      loc_interval   ; loc_interval
                      (* 2 dim) ; loc_bnumbers
                      
                      2     ; chosen-number
                      0.95  ; decrease
                      )

))
;===============================================================================
;
;-------------------------------------------------------------------------------
;void 
;botperebor_init (void *b, 
;             long long1, long long2, long long3, double d1)
;-------------------------------------------------------------------------------
(defun botperebor_init (b long1 long2 long3 d1)

(declare (ignore long2 long3 d1))

;  YT_MINBOT *bot = (YT_MINBOT *) b;
;  bot->long1 /*s_power*/  = long1;

  (setf (LONG1 b) long1)

)
;-------------------------------------------------------------------------------
;void
;botperebor_data (void *self, void *mp)
;-------------------------------------------------------------------------------
(defun botperebor_data (self mp)

;  YT_MINBOT *bot = (YT_MINBOT *) self;
;  bot->minproc = (YT_MINPROC *) mp;

  (setf (MINPROC self) mp)

)
;-------------------------------------------------------------------------------
;void
;minproc_perebor_s (YT_MINPROC *minproc, int s_power)
;-------------------------------------------------------------------------------
(defun minproc_perebor_s (minproc s_power)

(let* (
;  int    dim;
;  // ���������� ���������� - �����/������ ��� ���� �����������/������������

;  int    ijk[MAX_DIM],  IJK[MAX_DIM];      // ������ � ��� �������
;  double xyz[MAX_DIM],  xyz_step[MAX_DIM]; // ���������� � �� ���
 
  (ijk_cur (make-array MAX_DIM))
  (IJK (make-array MAX_DIM))

;  (xyz      (make-array MAX_DIM))
;  (xyz_step (make-array MAX_DIM))
  (xyz      (make-array (DIM)))
  (xyz_step (make-array (DIM)))

;  double g;
;  BOOL   first;
  g first1 mf
  )

  ;(format t "minproc_perebor_s... ~%")
  ;(format t "DIM= ~S  s_power= ~S  ~%" (DIM) s_power)
;  // ������������� ����� �����, ��� ������ ��������!!!

  (if (= s_power 0)
      (dotimes (dim (DIM)) 
        (setf (aref xyz_step dim) (nth dim (XYZ_ERR)))
        (setf (aref IJK dim) 
              (1+ (/ (- (nth dim (XYZ_MAX)) (nth dim (XYZ_MIN))) (aref xyz_step dim)))  
              )
;      xyz_step[dim] = XYZ_ERR[dim];
;      IJK[dim] = (int) ((XYZ_MAX[dim] - XYZ_MIN[dim]) / xyz_step[dim] + 1); 
      )
      (dotimes (dim (DIM))
;      // ������ ������: �� ���������� �����, 
;      // ����������� ��� ���� �� ������������� ��������
        (setf (aref IJK dim) s_power)
        (setf (aref xyz_step dim) 
              (/ (- (nth dim (XYZ_MAX)) (nth dim (XYZ_MIN))) (- s_power 1))
              )
;      IJK[dim] = s_power;
;      xyz_step[dim] = (XYZ_MAX[dim] - XYZ_MIN[dim]) / (s_power - 1);
      )
      )

  ;(format t "FIRST1......... ~%")
;  first = TRUE;
  (setf first1 t)

;  MF *mf = MFOR_create (DIM, ijk, IJK); 
  (setf mf (MFOR_create (DIM) ijk_cur IJK))

  (MFOR_init mf)
  (loop while (MFOR_todo mf) do (progn

;  while (MFOR_todo (mf))  {
;  //FOR_ALL_ijk (ijk, IJK) { // ������� �� ���� �������� (���������� ��������� ���������)

;    // ��������� ���������� �-���������� (���� �� � ����� ����� ���� ����������� ���. ������!!)
;    for (dim=0; dim < DIM; dim++) {
;      xyz[dim] = XYZ_MIN[dim] + ijk[dim] * xyz_step[dim]; 
;    }
    (dotimes (dim (DIM))
      (setf (aref xyz dim) (+ (nth dim (XYZ_MIN)) (* (aref ijk_cur dim) (aref xyz_step dim))))
      )

;    (format t "xyz= ~S ~%" xyz)
;    // ������ ������� ��� ��� �������
;    g = minproc_calc_proc (minproc, xyz);
    (setf g (minproc_calc_proc  minproc xyz))
    ;(format t "minproc_calc_proc.......1 ~%")

    (when first1 
      ;FUN_END[0] = g; // ��� ������ ������� ���� ������� �� ��� ��������� �����������?
      (setf (nth 0 (FUN_END)) g); // ��� ������ ������� ���� ������� �� ��� ��������� �����������?
      (setf first1 NIL)
      )

    (minproc_check_new_solution  minproc xyz g)
    ;(format t "xyz= ~15S g= ~S ~%" xyz g)
  )) 

))
;-------------------------------------------------------------------------------
;void
;botperebor_todo (void *self)
;-------------------------------------------------------------------------------
(defun botperebor_todo (self)

(let (
;  YT_MINBOT *bot = (YT_MINBOT *) self;
  (bot self)
  )

;  minproc_perebor_s (bot->minproc, bot->long1 /*s_power*/);
  (minproc_perebor_s (MINPROC bot) (LONG1 bot)) ; 

))
;-------------------------------------------------------------------------------
;===============================================================================
;//
;===============================================================================
;-------------------------------------------------------------------------------
;YT_MINBOT *
;(defun minbot_create () 

;(let (
;  (bot (make-instance 'YT_MINBOT))
;  )

;  bot
;))
;-------------------------------------------------------------------------------
;void 
(defun minbot_init (b    ; void *
                    long1 long2 long3 
                    d1   ; double 
                    )
(let (
  (bot b)
  )

  (setf (LONG1 bot) long1)
  (setf (LONG2 bot) long2)
  (setf (LONG3 bot) long3)
  (setf (D1    bot)    d1)

))
;-------------------------------------------------------------------------------
;YT_MINBOT *
(defun minbot_make (name      ;   char
                    bot_init  ;   MINBOT_INIT
                    bot_data  ;   MINBOT_DATA 
                    bot_todo  ;   MINBOT_TODO
                    long1 long2 long3  ; long
                    d1        ;   double 
                    ) 

(let (
  ;(bot (minbot_create))
  (bot (make-instance 'YT_MINBOT))
  )

  (if (eq name NIL) (setf (P_NAME bot) "")
                    (setf (P_NAME bot) name)
                    )

  (setf (BOT_DATA bot) bot_data)
  (setf (BOT_TODO bot) bot_todo)

  (if (eq bot_init NIL) (     minbot_init  bot long1 long2 long3 d1)
                        (funcall bot_init  bot long1 long2 long3 d1)
                        )

  bot
))
;===============================================================================
;-------------------------------------------------------------------------------
