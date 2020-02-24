; -*-   mode: lisp ; coding: koi8   -*- ----------------------------------------

;-------------------------------------------------------------------------------

; ANSI  color-change escape sequences.
; Xterm Control Sequences (this is the file ctlseqs.ms)
; man console_codes

;#define ED  printf("\x1b[2J") // ������� �����
;#define EL  printf("\x1b[K")  // ������� ������
;#define CUP(row,col) printf("\x1b[%d;%dH", row,col) // ����������� ������

;#define CUU printf("\x1b[A")  // �� ���� ������ �����
;#define CUD printf("\x1b[B")  // �� ���� ������ ����
;#define CUF printf("\x1b[C")  // �� ���� ������ ������
;#define CUB printf("\x1b[D")  // �� ���� ������ �����

;#define SCP printf("\x1b[s")  // ������� ������� ������� �������
;#define RCP printf("\x1b[u")  // ����������� ������� �������

(defconstant SGR_DEFAULT  0)
(defconstant SGR_BOLD     1)

(defconstant SGR_BLACK   30)    
(defconstant SGR_RED     31)   
(defconstant SGR_GREEN   32) 
(defconstant SGR_BROWN   33)
(defconstant SGR_BLUE    34) 
(defconstant SGR_MAGENTA 35)
(defconstant SGR_CYAN    36) 
(defconstant SGR_WHITE   37)

;-------------------------------------------------------------------------------

;2.2.3. Non-standard Characters

;Any implementation may provide additional characters, whether printing 
;characters or named characters. Some plausible examples: 

;#\  #\  #\Break  #\Home-Up  #\Escape

;The use of such characters may render Common Lisp programs non-portable. 

;-------------------------------------------------------------------------------
;void
(defun win_sgr (
           par ; int par
           )

;  fflush (stdout); 
;  fprintf (stderr, "\033[ %d m", par); // �e� ������� ���� ��������, 
;                                       // ������e � �e������?

  ;; ���������� ��e� ��� "foreground"
  (format t "~a[ ~d m" #\Escape par)

)
;-------------------------------------------------------------------------------
(defun sgr_test (argus) (declare (ignore argus))

  (win_sgr SGR_BOLD)

  (win_sgr SGR_RED)     (format t "SGR_RED ~%")
  (win_sgr SGR_GREEN)   (format t "SGR_GREEN ~%")

  (win_sgr SGR_BROWN)   (format t "SGR_BROWN ~%") ; ��� � e��� �e���� !?
  (win_sgr SGR_BLUE)    (format t "SGR_BLUE ~%")
  (win_sgr SGR_MAGENTA) (format t "SGR_MAGENTA ~%")
  (win_sgr SGR_CYAN)    (format t "SGR_CYAN ~%")

  ;(format t "~%")
  ;(win_sgr 41)     (format t "SGR_41 ~%") ; background

  (win_sgr SGR_DEFAULT)

  (format t "~%")
)
;-------------------------------------------------------------------------------
; X3J13 voted in January 1989 (FORMAT-PRETTY-PRINT)   to specify that format 
; binds *print-escape* to t during the processing of the ~S directive. 
;-------------------------------------------------------------------------------
(defun sgr_test_old (argus) (declare (ignore argus))

  (format t "~%") 
  (format t "TEST PRINT ~%") 

  ;win_sgr (SGR_BOLD); 
  ;win_sgr (SGR_GREEN);

  ;(format t "\e]10;%s\a" 2) ; ��� �e ��������� ..
  ;(format t "\e[ ~d m" 2) ; ��� �e ��������� ..
  ;(format t "\e]10;%s\a" 2) ; ��� �e ��������� ..

  ;(win_sgr  SGR_GREEN)
  ;(format "~a " #\Escape)
  (format t "~a[ ~d m" #\Escape SGR_GREEN)
  (format t "~%") 

  (format t "TEST PRINT lisp ~%") 
  ;(Y-printf "TEST PRINT clib ~%") ; ���e �e �e�e��e� e��e��-����e�����e�������
  
  (format t "~s" #\Newline) ; ���e����e� ��� e��e��-������ �� �����
  (format t "~a" #\Newline) ; e��e��� ��������� � ����� �� �����
  ;;~% 
  ;;This outputs a #\Newline character, thereby terminating the current output line 
  ;;and beginning a new on;e (see terpri). 

  ;win_sgr (SGR_DEFAULT);

  (format t "TEST PRINT ~%") 
  (format t "~%") 

)
;===============================================================================
;
;   ������������ ���������� �������� ����������
;   � ���������� ������� �� ��������
;
;===============================================================================

;typedef struct {
;	int  w, h;
;	char p[100][100];
;} YT_WIN;

; ��e���� ������� ����e���� ��������

(defmacro WIN_H () (list 'array-dimension 'win 0))
(defmacro WIN_W () (list 'array-dimension 'win 1))

(defmacro WIN_XY (x y) (list 'aref 'win y x))

;===============================================================================

;------------------------------------win_char-----------------------------------
(defun win_char (win ch x y)

;  if (x<0)       {printf ("win_char: x<0 \n"); return;}
;  //if (x>=win->w) {printf ("win_char: x>=win->w \n"); return;}
;  if (x>=win->w) {
;    printf ("x=%d  y=%d  win->w=%d  win->h=%d  \n", x, y, win->w, win->h);
;    Error ("win_char: x>=win->w");
;    //return (FALSE);
;  }

;  if (y<0)       {printf ("win_char: y<0 \n"); return;}
;  if (y>=win->h) {printf ("win_char: y>=win->h \n"); return;}

;  win->p[y][x] = ch;
  (setf (aref win y x) ch)

)
;-------------------------------------------------------------------------------
(defun win_text (win text x y)

(let (
  ch
  )

  (dotimes (i (array-dimension text 0))
    (setf ch (char text i))
    (win_char  win ch (+ x i) y)
    )
  
))
;-------------------------------------------------------------------------------
(defun win_horz (win ch y_horz x1 x2)

;  int x;

;  for (x=x1; x<=x2; x++)
;    win_char (win, ch, x, y_horz);

  (loop for x from x1 to x2 do
    (win_char  win ch x y_horz)
    ) 

)
;-------------------------------------------------------------------------------
(defun win_vert (win ch x_vert my_y1 y2)

;  int y;

;  for (y=my_y1; y<=y2; y++)
;    win_char (win, ch, x_vert, y);

  (loop for y from my_y1 to y2 do
    (win_char  win ch x_vert y)
    ) 
)
;-------------------------------------------------------------------------------
(defun win_rect (win  ch_horz ch_vert  x y w h)

;  w--;
;  h--;
  (setf w (1- w))
  (setf h (1- h))

  (win_horz  win ch_horz  y       x (+ x w))
  (win_horz  win ch_horz  (+ y h) x (+ x w))

  (win_vert  win ch_vert  x       y (+ y h))
  (win_vert  win ch_vert  (+ x w) y (+ y h))

)
;-------------------------------------------------------------------------------
;(defun win_sgr (par)


;)
;------------------------------------win_init-----------------------------------
(defun win_init (win ch)

  (dotimes (x (WIN_W))
  (dotimes (y (WIN_H))
      (setf (WIN_XY x y) ch)
    ))

)
;-----------------------------------win_create----------------------------------
(defun win_create (w h)

(let (
  (win (make-array (list h w))) 
  )

  (win_init win #\Space)

  win
))
;-------------------------------------------------------------------------------
(defun win_draw (win x0 y0)

;  int i, j;
;  char buff[100] = "";
;  char left[100] = "";

  (dotimes (y y0)
    (format t "~%")
    )

;  for (j=0; j<x0; j++)
;    left[j] = ' ';
;  left[j] = '\0';

;  for (i=0; i<win->h; i++) {
;    strcpy (buff, left);
;    strcat (buff, (char*)(&(win->p[i][0])));
;    puts (buff);
;  }

  (dotimes (y (WIN_H))
    (dotimes (j x0) (format t " "))

    (dotimes (x (WIN_W))
      (format t "~A" (WIN_XY x y))
      )

    (format t "~%")
  )

)
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------

;typedef struct {
;  int     i, x, y, delta_x, delta_y, exchange, err, incx, incy;
;  int     x_old, y_old, x_left, x_right;
;  BOOL    begin, end;
;  int     align;
;} VT_HANDLINE;

;(defvar p-i)
;(defvar p-x)
;(defvar p-y)
(defvar p-delta_x)
(defvar p-delta_y)
;(defvar p-exchange)
(defvar p-err)
(defvar p-incx)
(defvar p-incy)

(defvar retun_x)
(defvar retun_y)

(defclass HANDLINE () (  
  (i        :accessor I)
  (x        :accessor X)
  (y        :accessor Y)
  (exchange :accessor EXCHANGE)
))

;-------------------------------------------------------------------------------
(defun VHandPixel (win x y ch)

  (win_char  win ch x y)

)
;-------------------------------------------------------------------------------
;BOOL
;(defun VHandLineFunc (VT_HANDLINE *p, BOOL flag, int *px1, int *py1,
;                 int *px2, int *py2)
;  int     x1, y1, x2, y2, delta;

;-------------------------------------------------------------------------------
(defun VHandLineFunc (line flag  x1 y1  x2 y2)

(let (
  delta 
  )

  (if (eq flag NIL) (progn
     (setf p-delta_x (- x2 x1))
     (setf p-delta_y (- y2 y1))
     (setf (X line) x1)
     (setf (Y line) y1)

     (cond
     ((> p-delta_x 0) (setf p-incx 1))
     ((= p-delta_x 0) (setf p-incx 0))
     (             t  (setf p-incx -1))
     )

     (cond
      ((> p-delta_y 0) (setf p-incy 1))
      ((= p-delta_y 0) (setf p-incy 0))
      (             t  (setf p-incy -1))
      )

    (setf p-delta_x (abs p-delta_x))
    (setf p-delta_y (abs p-delta_y))

    (if (> p-delta_y p-delta_x) (progn 
      (setf delta      p-delta_x)
      (setf p-delta_x  p-delta_y)
      (setf p-delta_y  delta)
      (setf (EXCHANGE line) t)
      )
      (setf (EXCHANGE line) NIL)
      )

    (setf p-err (- (* 2 p-delta_y) p-delta_x))
    (setf (I line)  1)
    (return-from VHandLineFunc t)
  ))


  (if (> (I line) p-delta_x)
    (return-from VHandLineFunc NIL)
    )

;  *px1 = p->x;
;  *py1 = p->y;
  (setf retun_x (X line))
  (setf retun_y (Y line))

  (loop while (>= p-err 0) do
    (if (eq (EXCHANGE line) t)  (setf (X line) (+ (X line) p-incx))
                                (setf (Y line) (+ (Y line) p-incy))
                                )
    (setf p-err (- p-err (* 2 p-delta_x)))
    )

  (if (eq (EXCHANGE line) t)  (setf (Y line) (+ (Y line) p-incy))
                              (setf (X line) (+ (X line) p-incx))
                              )
  (setf p-err (+ p-err (* 2 p-delta_y)))
  (setf (I line) (1+ (I line)))

  t
))
;-------------------------------------------------------------------------------
(defun VHandLine (win  x1 y1  x2 y2  ch)

;  VT_HANDLINE line;
;  int     x, y, dx, dy;
;  BOOL by_y;

(let (
  (line (make-instance 'HANDLINE))

  (dx  (- x2 x1))
  (dy  (- y2 y1))
  ;by_y  ?????????????
 )

  (if (and (= dx 0) (= dy 0))
    (error "VHandLine"))

;  if (abs (dy) > abs (dx))  by_y = TRUE;
;  else                      by_y = FALSE;
;  (if (> (abs dy) (abs dx)) 
;    (setf by_y t)
;    (setf by_y NIL)
;    )

  (VHandLineFunc line NIL x1 y1 x2 y2)

  (loop while (VHandLineFunc line t NIL NIL NIL NIL) do
    (VHandPixel  win retun_x retun_y ch)
  )

))
;-------------------------------------------------------------------------------
(defun win_line (win ch x1 y1 x2 y2)

  (VHandLine  win x1 y1 x2 y2 ch)

)
;-------------------------------------------------------------------------------
(defun win_triangle (win ch x1 y1 x2 y2 x3 y3)

  (win_line  win ch  x1 y1  x2 y2)
  (win_line  win ch  x2 y2  x3 y3)
  (win_line  win ch  x1 y1  x3 y3)

)
;-------------------------------------------------------------------------------
; ������������ ��� �������� ������� : 
;-------------------------------------------------------------------------------
(defun bj_drawellps (win ch             
                         x y              ; ����� �������� 
                         xcentre ycentre  ; ����� �������
                         asp_ratio        ; ����������� "������" �������
                         ) 
(let (
  (starty  (floor (*       y asp_ratio)))
  (endy    (floor (* (+ y 1) asp_ratio)))
  (startx  (floor (*       x asp_ratio)))
  (endx    (floor (* (+ x 1) asp_ratio)))
 )
 
;  for (x1 = startx; x1<endx; ++x1) { 
;  (loop for x1 from (1+ startx) to (1- endx) do
;  (do ((x1 startx)) ((not (< x1 endx)))
  (do ((x1 startx)) (NIL)

    (win_char  win ch (+ x1 xcentre) (+ y ycentre)) 
    (win_char  win ch (+ x1 xcentre) (- ycentre y)) 
    (win_char  win ch (- xcentre x1) (+ y ycentre)) 
    (win_char  win ch (- xcentre x1) (- ycentre y)) 

    (setf x1 (1+ x1))
    (when (not (< x1 endx)) (return))
    )
 
;  for (y1 = starty; y1<endy; ++y1) { 
;  (loop for y1 from (1+ starty) to (1- endy) do
;  (do ((y1 starty)) ((not (< y1 endy)))
  (do ((y1 starty)) (NIL)

    (win_char  win ch (+ y1 xcentre) (+ x ycentre)) 
    (win_char  win ch (+ y1 xcentre) (- ycentre x)) 
    (win_char  win ch (- xcentre y1) (+ x ycentre)) 
    (win_char  win ch (- xcentre y1) (- ycentre x)) 

    (setf y1 (1+ y1))
    (when (not (< y1 endy)) (return))
    )

))
;-------------------------------------------------------------------------------
(defun win_ellipse (win ch               
                        left  top       ; �������� ��������������; 
                        right bottom    ;  
                        ) 
(let* (
  ;;  int xcentre, ycentre, xradius, yradius; 
  ;;  //int xasp, yasp; 
  ;;  float asp_ratio; 
 
  (xradius  (/ (- right left) 2) ) 
  (yradius  (/ (- bottom top) 2) ) 
  (xcentre     (+ left xradius)  ) 
  (ycentre     (+ top  yradius)  )
 
  ;; getaspectratio (&xasp, &yasp); 
  ;; asp_ratio=(float)(yasp) / (float)(xasp); 
  (asp_ratio  1.0)

  y delta x 
  )

  (if (not (= yradius 0))
    (setf asp_ratio (* asp_ratio (/ (* 1.0 xradius) yradius)) ) 
      )

;  if (yradius!=0) 
;    asp_ratio = asp_ratio * ((float)(xradius)/(float)(yradius)); 

;  /* �������� ���������� */ 
;  // size=max(xradius,yradius); 
  (setf y xradius) 
  (setf delta (- 3 (* 2 xradius))) 

;  for (x=0; x<y; x++) { 
  (do ((x 0 (1+ x))) 
      ((not (< x y)))

    (bj_drawellps  win ch  x y xcentre ycentre asp_ratio)

    (if (< delta 0) 
        (setf delta (+ delta (+ (* 4 x) 6))) 
      (progn
        (setf delta (+ delta (+ (* 4 (- x y)) 10))) 
        (setf y (1- y)) ;;?? ���e� ����� ��e �������� ??
        ))
    )

;  x = y; 
;  if (y) bj_drawellps (/* obj, */win, ch, x, y, xcentre, ycentre, asp_ratio);

  (setf x y)
  (if (not (= y 0)) 
      (bj_drawellps  win ch x y xcentre ycentre asp_ratio))
 
))
;===============================================================================
;
;-------------------------------------------------------------------------------
(defun win_test1 ()

(let (
  (iw  60)  
  (ih  30)
  win
  )

  ;;  ������� �������� ����� � ������ ������� �������
  (setf win (win_create iw ih))  
  (win_rect  win '= '= 0 0 60 30)

  (win_line  win '*  2 2  15 15)
  (win_line  win '*  2 2  15  5)
  (win_ellipse  win '@  15 15  25 25)             
  (win_triangle win '$  40  5  35 20  50 15)
  
  (win_text win "win_text" 5 15)
  
  (win_draw  win 0 0) ; ������� �������� �����
))
;-------------------------------------------------------------------------------
(defun win_test_old (argus)  (declare (ignore argus))

  (format t "~%")

  ;(win_test0)
  (win_test1)

  (format t "~%")
)
;===============================================================================
;
;===============================================================================
