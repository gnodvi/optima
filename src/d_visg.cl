;;; -*- Mode:LISP; Base:10; Syntax:Common-Lisp; -*-

;;;=============================================================================

;(load "a-comm.cl")

;lisper]$ *** - (USE-PACKAGE (#<PACKAGE LTK>) #<PACKAGE COMMON-LISP-USER>): 1 name
;      conflicts remain
;      Which symbol with name "VALUE" should be accessible in
;       #<PACKAGE COMMON-LISP-USER>
;      ?

(load "T/ltk") (use-package :ltk)
(load "b-ltkx.cl")

(load "./a-comm.cl")
(load "b-comp.cl")
(load "d-plot.cl")

; XY-PLOT
;
;===============================================================================
;
;-------------------------------------------------------------------------------
;
;
;
;-------------------------------------------------------------------------------
(defun YDrawLine (canvas x1 y1 x2 y2 color)       
    
  (create_line canvas (list x1 y1 x2 y2) color 1)  
    
)
;-------------------------------------------------------------------------------
(defun YDrawRectF (canvas x y w h color)       
   
;  XSetForeground (dpy, gc, color);    
;  XFillRectangle (dpy, drawable, gc, x, y, w, h);    
(let (
  (o (create-rectangle canvas  x y (+ x w) (+ y h)))
  )

  (itemconfigure canvas o "fill" color)   
))  
;-------------------------------------------------------------------------------
(defun YDrawRectB (canvas x y w h color)   
  
;  //w--;   
;  //h--;   
;  YDrawLine (x,   y,   x+w, y,   color);   
;  YDrawLine (x,   y+h, x+w, y+h, color);   
;  YDrawLine (x,   y+h, x,   y,   color);   
;  YDrawLine (x+w, y,   x+w, y+h, color); 

(let (
  (o (create-rectangle canvas  x y (+ x w) (+ y h)))
  )

  (itemconfigure canvas o "outline" color)     
)) 
;-------------------------------------------------------------------------------
;void   
;YDrawRectFB (Int x, Int y, Int width, Int height, YT_COLOR fcolor, YT_COLOR lcolor)   
;{   
;  YDrawRectF (x, y, width, height, fcolor);   
;  YDrawRectB (x, y, width, height, lcolor);   
;  return;   
;}   
;/*-----------------------------YPaintString--------------------------------*/ 
;void 
;YPaintString (char *text, int x, int y, YT_COLOR color) 
;{ 
;  CALCXY (x, y); 
 
;#if defined(FLTK)
;  YSetFont(Y_FONT); /*??*/ 
;	FSetColor (color);
;	/* fl_color(color); */  /*??*/
;  y += 4; /*??!!!*/
;	fl_draw(text, x, y); /*??*/
;#elif defined(API_W) 
;  SetTextColor (svw.hdc, color); 
;  TextOut (svw.hdc, x, y - FONTH / 2, text, strlen (text)); 
;#else  
;  y += 4; /*??!!!*/
;  XSetForeground (DPY, SV->gc, color); 
;  XDrawString (DPY, SV->win, SV->gc, x, y, text, strlen (text)); 
;  XFlush (DPY); 
;#endif 
;} 
;/*------------------------------YDrawString--------------------------------*/ 
;void 
;YDrawString (char *text, int x, int y, YT_COLOR color) 
;{ 
;  switch (DRAW_MODE) { 
;  case YMETA: 
;    YMetaAdd (YSTRING, NULL, x, y, 0, 0, color, 0, 0, text); 
;    break; 
;  case YREAL: 
;    YPaintString (text, x, y, color); 
;    break; 
;  case YPOST: 
;    y += 4; 
;    YTransf (&x, &y); 
;    PS_Setcolor (color); 
;    fprintf (POST_FILE, "%d %d %s \n", x, y, "moveto"); 
;    fprintf (POST_FILE, "( %s ) show \n", text); 
;    PS_Stroke (); 
;    break; 
;  default: ;; 
;  } 
 
;} 
;/*-----------------------------YDrawStringImp------------------------------*/ 
;-------------------------------------------------------------------------------
;void 
(defun YDrawStringImp (canvas 
      text  ; char *text, 
      x0    ; int x0, 
      y0    ; int y0, 
      color ; YT_COLOR color, 
      horz  ; int horz, 
      vert  ; int vert
      ) 

(declare (ignore color horz vert))

;  int     x, y, w, h; 
 
;  w = YStringW (text); 
;  h = YStringH (text); 
;  ANTICALCWH (w, h); 
 
;  if      (horz == YLEFT)  x = x0 - w; 
;  else if (horz == YNONE)  x = x0 - w / 2; 
;  else if (horz == YRIGHT) x = x0; 
;  else 
;    YError ("YDrawStringImp-1"); 
 
;  if      (vert == YUP)    y = y0 - h / 2; 
;  else if (vert == YNONE)  y = y0; 
;  else if (vert == YDOWN)  y = y0 + h / 2; 
;  else 
;    YError ("YDrawStringImp-2"); 
 
;  YDrawString (text, x, y, color);
   (create-text  canvas  x0 y0 text)

) 
;-------------------------------------------------------------------------------
;
;
;

;typedef struct {
;  YT_BOOL exist;
;  char   *legend;
;  YT_SPACE *xlist, *ylist;
;  int     ii;
;  YT_COLOR color;
;} VT_PLOT;

;VT_PLOT *V1PlotCreate (void);
;void     V1PlotInit (VT_PLOT *, char *, int);
;void     V1PlotPut (VT_PLOT *, int, YT_SPACE, YT_SPACE);

;#define COL_SIZE_DARKS  9
;typedef struct {
;  char     title[50], axeX[50], axeY[50];
;  int      scrx, scry, scrw, scrh;
;  YT_SPACE x_min, x_max, y_min, y_max;
;  YT_BOOL  is_title, is_axeX, is_axeY;
;  int      legends_style;
;  YT_COLOR backgr, foregr;
;  YT_COLOR darks[COL_SIZE_DARKS];
;} VT_CAM1D;

;VT_CAM1D *V1CamCreate (void);

;#define MAX_PLOTS 20
;typedef struct {
;  VT_CAM1D *cam1d;
;  VT_PLOT plot[MAX_PLOTS];
;  YT_SPACE xmin, xmax, ymin, ymax;
;} VT_W1D;

;VT_W1D  *V1Create (void);
;void     V1Init (VT_W1D *, char *, char *, char *);

;
;
;
;/*===============================render1======================================*/
;/*                                                                            */
;/*--------------------------------mREND1--------------------------------------*/
;long
;mREND1 (PFUNC_VAR)
;{
;  typedef struct {
;    ABCD;
;  } YT_USR;

;  static VT_W1D *w1d = NULL;
;  static int hTitle, hAxeX, hAxeY;
;  static void *meta = NULL;

;  VT_CAM1D *cam1d;
;/*   static char *commands[] = */
;/*   { "XX","YY", NULL}; */
;  YT_RECT rect;
;  char   *text[] =
;  {
;    "Accepts data PLOT (simply diagram)",
;    "makes their rendering and result ",
;    "places on the screen:", 
;    NULL
;  };

;  switch (message) {
;  case YCREATE:
;    U_MALLOC;
;    WND->name = "Render1";
;    meta = YMetaCreate (1000);
;    break;
;/*   case MM_FORWARD: */
;/*     break; */
;  case MM_LAT1:
;    w1d = VLatToW1D ((VT_LAT *) PDATA);
;    YGoto (YDRAWITEM, 0, 0, 0, 0);
;    break;
;  case MM_W1D:
;    w1d = (VT_W1D *) PDATA;
;    YGoto (YDRAWITEM, 0, 0, 0, 0);
;    break;
;  case MM_APPLY:
;    YGoto (YWND2MOD, 0, 0, 0, 0);
;    YGoto (YDRAWITEM, 0, 0, 0, 0);
;    break;
;  case YDRAWITEM:
;    rect.x = 5;
;    rect.y = 5;
;    rect.w = 300;
;    rect.h = 200;
;    cam1d = w1d->cam1d;
;    cam1d->scrx = rect.x;
;    cam1d->scry = rect.y;
;    cam1d->scrw = rect.w;
;    cam1d->scrh = rect.h;
;    /* meta = YMetaCreate (1000); */	/*?! */
;    YMetaInit (meta, 0, 0, 310, 210);

;    YMetaBegin (meta, "");
;    V1DrawMain (w1d);
;    YMetaEnd ();

;    /* YMetaDrawTo (meta, mScreen_id, TRUE, id); */
;    YMetaDrawTo (meta, SvisRend(1), TRUE, id);
;    break;
;  case YGETSIZE:
;    MYSIZE_IS (W_MOD, H_MOD);
;    break;
;  case YOPEN:
;  case YDRAW:
;    YDrawRectF (0, 0, WND->w, WND->h, WIN->color);
;    YDrawStrings (text, 20, 30);
;    if (!w1d)
;      break;
;    cam1d = (w1d)->cam1d;
;    YBeginGroup ("Color", 10,120, 100,60, YColor(""));
;    YWnd (Ph(), COLORS, "Back-nd", 10,10, 20,20, LP(cam1d->backgr),0,0,0, CLR_DEF);
;    YWnd (Ph(), COLORS, "Fore-nd", 10,35, 20,20, LP(cam1d->foregr),0,0,0, CLR_DEF);
;    YEndGroup ();
;    YBeginGroup ("Inscript", 120,120, 190,100, YColor(""));
;    YWnd (&hTitle, EDIT, "Title: ", 60,10, 95,20, (long)(cam1d->title),0,0,0, CLR_DEF);
;    YWnd (&hAxeX,  EDIT, "Axe Х: ", 60,35, 95,20, (long)(cam1d->axeX), 0,0,0, CLR_DEF);
;    YWnd (&hAxeY,  EDIT, "Axe Y: ", 60,60, 95,20, (long)(cam1d->axeY), 0,0,0, CLR_DEF);
;    YWnd (Ph(), CHECK, "", 160,10, 20,20, 0,LP(cam1d->is_title),0,0, CLR_DEF);
;    YWnd (Ph(), CHECK, "", 160,35, 20,20, 0,LP(cam1d->is_axeX), 0,0, CLR_DEF);
;    YWnd (Ph(), CHECK, "", 160,60, 20,20, 0,LP(cam1d->is_axeY), 0,0, CLR_DEF);
;    YEndGroup ();
;    break;
;  case YWND2MOD:
;    cam1d = (w1d)->cam1d;
;    strcpy (cam1d->title, (char *) YGetData (hTitle));
;    strcpy (cam1d->axeX,  (char *) YGetData (hAxeX));
;    strcpy (cam1d->axeY,  (char *) YGetData (hAxeY));
;    break;
;  case YLBUTT:
;  case YRBUTT:
;    break;
;  case YCLOSE:
;    YWndClean (id);
;    break;
;  default: ;;;
;  }

;  RETURN_TRUE;
;}
;/*-----------------------------V1Init---------------------------------------*/
;void
;V1Init (VT_W1D *w1d, char *title, char *axeX, char *axeY)
;{
;  VT_PLOT *plot;
;  int     i;
;/* VT_CAM1D *cam1d=w1d->cam1d; */

;  for (i = 0; i < MAX_PLOTS; i++) {
;    plot = &(w1d->plot[i]);
;    plot->exist = FALSE;
;    plot->legend = "";
;    plot->xlist = NULL;
;    plot->ylist = NULL;
;  }

;  title++;
;  axeX++;
;  axeY++;
;}
;/*----------------------------V1CamCreate-----------------------------------*/
;VT_CAM1D *
;V1CamCreate ()
;{
;  VT_CAM1D *cam1d;

;  if (!(cam1d = (VT_CAM1D *) malloc (sizeof (VT_CAM1D))))
;            YError ("V1CamCreate");

;  cam1d->scrx = 0;
;  cam1d->scry = 0;
;  cam1d->scrw = 10;
;  cam1d->scrh = 10;
;  cam1d->is_title = TRUE;
;  cam1d->is_axeX = TRUE;
;  cam1d->is_axeY = TRUE;
;  strcpy (cam1d->title, "Demo example");
;  strcpy (cam1d->axeX, "Horizontal");
;  strcpy (cam1d->axeY, "Vertical");
;  cam1d->legends_style = YUP;

;  cam1d->backgr = YColor("white");
;  cam1d->foregr = YColor("black");

;  cam1d->darks[0] = YColor("black");
;  cam1d->darks[1] = YColor("red");
;  cam1d->darks[2] = YColor("green");
;  cam1d->darks[3] = YColor("blue");
;  cam1d->darks[4] = YColor("yellow");
;  cam1d->darks[5] = YColor("green");
;  cam1d->darks[6] = YColor("fuchsia");
;  cam1d->darks[7] = YColor("olive");
;  cam1d->darks[8] = YColor("purple");

;  return (cam1d);
;}
;/*----------------------------V1PlotCreate----------------------------------*/
;VT_PLOT *
;V1PlotCreate ()
;{
;  VT_PLOT *plot;

;  if (!(plot = (VT_PLOT *) malloc (sizeof (VT_PLOT))))
;            YError ("V1PlotCreate");
;  return (plot);
;}
;/*----------------------------V1PlotInit------------------------------------*/
;void
;V1PlotInit (VT_PLOT *plot, char *legend, int ii)
;{

;  plot->exist = TRUE;
;  plot->legend = legend;
;  plot->xlist = VListCreate (ii);
;  plot->ylist = VListCreate (ii);
;  plot->ii = ii;

;}
;/*-----------------------------V1PlotPut------------------------------------*/
;void
;V1PlotPut (VT_PLOT *plot, int i, YT_SPACE x, YT_SPACE y)
;{
;  VListPut (plot->xlist, i, x);
;  VListPut (plot->ylist, i, y);
;  return;
;}
;/*-------------------------------V1Create-----------------------------------*/
;VT_W1D *
;V1Create ()
;{
;  VT_W1D *w1d;

;  if (!(w1d = (VT_W1D *) malloc (sizeof (VT_W1D))))
;            YError ("V1Create");
;  w1d->cam1d = V1CamCreate ();

;  return (w1d);
;}
;/*-----------------------------V1PlotAdd------------------------------------*/
;YT_BOOL
;V1PlotAdd (VT_W1D *w1d, VT_PLOT *pplot)
;{
;  VT_PLOT *plot;
;  int     i;

;  for (i = 0; i < MAX_PLOTS; i++) {
;    plot = &(w1d->plot[i]);
;    if (plot->exist) 
;      continue;

;    *plot = *pplot;
;    return (TRUE);
;  }

;  YMessageBox ("Too many PLOT!", "OK");
;  return (FALSE);
;}
;-------------------------------------------------------------------------------
;void 
;V1CalcMinMax (VT_W1D *w1d) 
;{ 
;  VT_CAM1D *cam1d = w1d->cam1d; 
;  VT_PLOT *plot; 
;  YT_SPACE xmin, xmax, x, ymin, ymax, y; 
;  int     i, k; 
 
;  xmin = YMAXSPACE; 
;  xmax = YMINSPACE; 
;  ymin = YMAXSPACE; 
;  ymax = YMINSPACE; 
;  for (k = 0; k < MAX_PLOTS; k++) { 
;    plot = &(w1d->plot[k]); 
;    if (!(plot->exist))   
;      continue; 
 
;    for (i = 0; i < plot->ii; i++) { 
;      x = plot->xlist[i]; 
;      y = plot->ylist[i]; 
;      xmin = YMIN (x, xmin); 
;      xmax = YMAX (x, xmax); 
;      ymin = YMIN (y, ymin); 
;      ymax = YMAX (y, ymax); 
;    } 
;  } 
 
;  cam1d->x_min = w1d->xmin = xmin; 
;  cam1d->x_max = w1d->xmax = xmax; 
 
;  cam1d->y_min = w1d->ymin = ymin; 
;  cam1d->y_max = w1d->ymax = ymax; 
 
;  return; 
;} 
;-------------------------------------------------------------------------------
;int  
;YVertString (int x0, int y0, char *string, YT_COLOR color, YT_BOOL drawing)  
;{  
;  int   i = 0, x, y;  
;  char  bukva[2] = {'\0', '\0'};  
  
;  x = x0 - YStringW ("W") / 2;  
;  y = y0 + YStringH ("H");  
  
;  for (i = 0; i < strlen (string); i++) {  
;    *&(bukva[0]) = *&(string[i]);  
;    if (drawing)  
;      YDrawString (bukva, x, y, color);  
;    y += YStringH (bukva);  
;  }  
  
;  return (y - y0);  
;}  
;-------------------------------------------------------------------------------
;void  
;YDrawVString (char *string, int x0, int y0, YT_COLOR color)  
;{  
  
;  YVertString (x0, y0, string, color, TRUE);  
  
;}  
;-------------------------------------------------------------------------------
;int  
;YVertStringH (char *string)  
;{  
  
;  return (YVertString (0, 0, string, YColor("black"), FALSE));  
;}  
;-------------------------------------------------------------------------------
;void 
;V1DrawAxeX (int x0, int y0, int w, YT_COLOR color, 
;	    YT_SPACE xmin, YT_SPACE xmax, int pointer) 
;{ 
;  int     l = 5, x, d = 10; 
;	char Y_STR[256]; 
 
;  if (pointer) { 
;    YDrawLine (x0 + w, y0, x0 + w + pointer, y0, color); 
;    YDrawSymbol ("right>", x0 + w + pointer - 10, y0 - 5, 10, 10, color); 
;  } 
;  x = x0; 
;  sprintf (Y_STR, "%.1f", xmin); 
;  YDrawLine (x, y0, x, y0 + l, color); 
;  YDrawStringImp (Y_STR, x, y0 + d, color, YRIGHT, YDOWN); 
 
;  x = x0 + w / 2; 
;  sprintf (Y_STR, "%.1f", xmin + (xmax - xmin) / 2); 
;  YDrawLine (x, y0, x, y0 + l, color); 
;  YDrawStringImp (Y_STR, x, y0 + d, color, YNONE, YDOWN); 
 
;  x = x0 + w - 1; 
;  sprintf (Y_STR, "%.1f", xmax); 
;  YDrawLine (x, y0, x, y0 + l, color); 
;  YDrawStringImp (Y_STR, x, y0 + d, color, YLEFT, YDOWN); 
 
;} 
;-------------------------------------------------------------------------------
;void 
;V1DrawAxeY (int x0, int y0, int h, YT_COLOR color, 
;	    YT_SPACE ymin, YT_SPACE ymax, int pointer) 
;{ 
;  int     l = 5, y; 
;	char Y_STR[256]; 
 
;  if (pointer) { 
;    YDrawLine (x0, y0 - h, x0, y0 - h - pointer, color); 
;    YDrawSymbol ("up>", x0 - 5, y0 - h - pointer, 10, 10, color); 
;  } 
;  y = y0; 
;  sprintf (Y_STR, "%.1f", ymin); 
;  YDrawLine (x0, y, x0 - l, y, color); 
;  YDrawStringImp (Y_STR, x0 - l, y, color, YLEFT, YUP); 
 
;  y = y0 - h / 2; 
;  sprintf (Y_STR, "%.1f", ymin + (ymax - ymin) / 2); 
;  YDrawLine (x0, y, x0 - l, y, color); 
;  YDrawStringImp (Y_STR, x0 - l, y, color, YLEFT, YNONE); 
 
;  y = y0 - h + 1; 
;  sprintf (Y_STR, "%.1f", ymax); 
;  YDrawLine (x0, y, x0 - l, y, color); 
;  YDrawStringImp (Y_STR, x0 - l, y, color, YLEFT, YDOWN); 
 
;} 
;-------------------------------------------------------------------------------
;void 
;V1DrawLegends (VT_W1D *w1d, int x0, int y0) 
;{ 
;  VT_CAM1D *cam1d = w1d->cam1d; 
;  VT_PLOT *plot; 
;  int     i, x; 
;  char   *title = "Legends: "; 
 
;  x = x0; 
;  YDrawStringImp (title, x, y0, cam1d->foregr, YRIGHT, YUP); 
;  x = x + YStringW (title); 
;  for (i = 0; i < MAX_PLOTS; i++) { 
;    plot = &(w1d->plot[i]); 
;    if (!(plot->exist))   
;      continue; 
 
;    YDrawStringImp (plot->legend, x, y0, plot->color, YRIGHT, YUP); 
;    x = x + YStringW (plot->legend) + 10; 
;  }; 
 
;} 
;-------------------------------------------------------------------------------
;void 
;V1DrawOne (VT_W1D *w1d, VT_PLOT *plot, int xscr, int yscr, int wscr, int hscr) 
;-------------------------------------------------------------------------------
(defun v1_draw_one (canvas xlist ylist 
                           xxmin xxmax yymin yymax
                           xscr yscr wscr hscr
                           color
                           ) 

(let* (
  ;(xlist (X plot))
  ;(ylist (PP_STEP_F plot 0 0))
  (num   (list-length xlist))
  ;(count 1)

  x1 y1 x2 y2 ;  static int x1, y1, x2, y2; 
  xx yy ;  YT_SPACE yymin, yymax, yystep, yy; 
  ;;  YT_SPACE xxmin, xxmax, xxstep, xx; 
  x y ;  int     d, x, y; 
   
;  xxmin = w1d->xmin; 
;  xxmax = w1d->xmax; 
  ;(xxmin  0)
  ;(xxmax 10)
  (xxstep (/ (- xxmax xxmin) wscr)) ; физичeский шаг по X на один пиксeл экрана
 
;  yymin = w1d->ymin; 
;  yymax = w1d->ymax; 
  ;(yymin -1)
  ;(yymax +1)
  (yystep (/ (- yymax yymin) hscr)) ; физичeский шаг по Y на один пиксeл экрана
  ) 
 
;  (format t "xxmin= ~s ~%" xxmin)
;  (format t "xxmax= ~s ~%" xxmax)
;  (format t "yymin= ~s ~%" yymin)
;  (format t "yymax= ~s ~%" yymax)

  (dotimes (d num) ; рисуeм один график-линию циклом по всeм точкам 
    (setf xx (nth d xlist))
    (setf yy (nth d ylist))

    (setf x  (floor (/ (- xx xxmin) xxstep))) ; координаты графиков в пиксeлах
    (setf y  (floor (/ (- yy yymin) yystep)))

    (setf x  (+ xscr x)) ; с иксами всe просто

    ;; а вот "y" подразумeваeтся от лeвого-нижнeго угла,
    ;; но в LTK примитивы рисуются от лeвого-вeрхнeго угла, поэтому:
    ;(setf y  (+ yscr y))
    (setf y  (+ yscr (- hscr y)))

    (if (= d 0) (progn 
        (setf x1 x)
        (setf y1 y)
      ) (progn 
        (setf x2 x)
        (setf y2 y)
        (YDrawLine canvas x1 y1 x2 y2 color) ;plot->color) 
        (setf x1 x2)
        (setf y1 y2)
        )
        )
    )
 
))
;-------------------------------------------------------------------------------
;(defun plot_win (ti plot iw ih ih_one)

;(let (
;  (yi  1)

;  ;; создаем экранную форму и рисуем главную рамочку
;  (win (win_create iw ih))
;  )

;  (win_rect  win '= '! 0 0 iw ih) ; почeму нe рисуeт '| ??

;  ;; здесь надо идти не по списку функций, а по фреймам!
;  (loop for wi from 0 until (= (aref (FR plot) wi 0) -1) do

;    (plot_win_main  plot win  wi ti  1 yi (- iw 2) ih_one)

;    (incf yi ih_one)

;    (win_horz  win '= yi 2 (- iw 3))
;    (incf yi)
;  )

;  ;; выводим экранную форму
;  (win_draw  win 0 0)

;))
;-------------------------------------------------------------------------------
(defun plot_gui_lines (canvas plot ti wi 
                            x y w h)

(let* (
  (colors '("green" "blue" "red" "yellow"))
  fi 
  )

  (loop for li from 0 do
    (setf fi (aref (FR plot) wi li))
    (when (= fi -1) (return))

    (v1_draw_one canvas (X plot) (PP_STEP_F plot ti fi)
                 (PP_XMIN plot fi) (PP_XMAX plot fi) 
                 (PP_FMIN plot fi) (PP_FMAX plot fi) 
                 x y w h (nth fi colors))
  )

))
;-------------------------------------------------------------------------------
;void 
;V1DrawAll (VT_W1D *w1d, int xscr, int yscr, int wscr, int hscr) 
;-------------------------------------------------------------------------------
(defun v1_draw_frame (canvas plot ti wi
                           xscr yscr wscr hscr) 

(let* (
  ;(ti 0)
;  (colors '("green" "blue" "red" "yellow"))
;  VT_CAM1D *cam1d = w1d->cam1d; 
;  VT_PLOT *plot; 

;  int     i, i_plot, x, y, w, h; 
;  int     arrowX = 20, arrowY = 20; 
;  int     left, right, top, bottom; 

;  char   *axeX = cam1d->axeX; 
;  char   *axeY = cam1d->axeY; 
;  YT_BOOL is_axeX = cam1d->is_axeX, is_axeY = cam1d->is_axeY; 

;  YT_COLOR color = cam1d->foregr; 
;	char Y_STR[256]; 
 
;  sprintf (Y_STR, "%.1f", w1d->ymin); 
;  left = YStringW (Y_STR); 
;  sprintf (Y_STR, "%.1f", w1d->ymax); 
;  left = YMAX (left, YStringW (Y_STR)); 
;  left += 5;			/* for negative values ?! */ 
;  if (is_axeY) 
;    left = left + YStringW ("W") + 5; 
  (left  30)
 
;  top = arrowY; 
;  right = arrowX; 
  (top   30)
  (right 30)
 
  (bottom 30)
;  bottom = 5 + YStringH ("H"); 
;  if (is_axeX) 
;    bottom = bottom + YStringH (axeX) + 5; 
 
  (x  (+ xscr left))
  (w  (- wscr left right))
  (y  (+ yscr top))
  (h  (- hscr top bottom))
  )
 
;  if (is_axeY)  
;    YDrawVString (axeY, xscr + YStringH ("H") / 2, y + h / 2 - YVertStringH (axeY) / 2, color); 
;  if (is_axeX)  
;    YDrawStringImp (axeX, x + w / 2, yscr + hscr, color, YNONE, YUP); 
 
  (YDrawRectB canvas x y w h "black")  

;  V1DrawAxeX (x, y + h - 1, w, color, w1d->xmin, w1d->xmax, right); 
;  V1DrawAxeY (x, y + h - 1, h, color, w1d->ymin, w1d->ymax, top); 
 
  (plot_gui_lines  canvas plot ti wi  x y w h)

;  if (cam1d->legends_style == YUP) 
;    V1DrawLegends (w1d, x + 30, y); 
 
))
;-------------------------------------------------------------------------------

;  (W  400)
;  (H  300)
;  (defconstant *W*  620)
;  (defconstant *H*  500)
(defconstant *W*  500)
(defconstant *H*  400)

;/*---------------------------V1DrawMain-------------------------------------*/
;void
;V1DrawMain (VT_W1D *w1d)
;{
;  VT_CAM1D *cam1d = w1d->cam1d;
;  int     xscr = cam1d->scrx, yscr = cam1d->scry, wscr = cam1d->scrw, hscr = cam1d->scrh;
;  int     title_h = 20, y_line;
;  YT_COLOR color = cam1d->foregr;

;  YDrawRectF (xscr, yscr, wscr, hscr, cam1d->backgr);
;  YDrawRectB (xscr, yscr, wscr, hscr, color);

;  if (cam1d->is_title) {
;    y_line = yscr + title_h;
;    YDrawLine (xscr, y_line, xscr + wscr, y_line, color);
;    YDrawStringImp (cam1d->title, xscr + wscr / 2, yscr + title_h / 2, color, YNONE, YNONE);
;    yscr += title_h;
;    hscr -= title_h;
;  }
;  V1CalcMinMax (w1d);
;  V1DrawAll (w1d, xscr + 10, yscr + 10, wscr - 20, hscr - 20);

;  wscr++;
;  hscr++;
;}
;-------------------------------------------------------------------------------
;void 
;V1DrawMain (VT_W1D *w1d) 
;-------------------------------------------------------------------------------
(defun v1_draw_main (c plot ti)

(let* (
  wnum h_step
;  VT_CAM1D *cam1d = w1d->cam1d; 
;  int     xscr = cam1d->scrx, yscr = cam1d->scry, wscr = cam1d->scrw, hscr = cam1d->scrh; 

  (xscr 10) ; лeвый вeрхний угол
  (yscr 10)
  ;(wscr 380) 
  ;(hscr 280)
  (wscr (- *W* (* xscr 2))) 
  (hscr (- *H* (* yscr 2)))

  ;(wscr (window-width  *tk*)) ; ??
  ;(hscr (window-height *tk*)) ; ??

  ;(wscr  (screen-width))  ; это вeсь экран !
  ;(hscr  (screen-height))

  (title_h  20) y_line ;  int     title_h = 20, y_line; 
  (color "black") ;  YT_COLOR color = cam1d->foregr;
  ) 
 
  ;(format t "wscr= ~s ~%" wscr)
  ;(format t "hscr= ~s ~%" hscr)

;  YDrawRectF (xscr, yscr, wscr, hscr, cam1d->backgr); 
  (YDrawRectF c  xscr yscr wscr hscr "white") ; нарисовали всю подложку
 
  ;; eсли надо, то нарисуeм заголовок
;  if (cam1d->is_title) {  ;-------------------------------
  (setf y_line (+ yscr title_h)) 

;    YDrawLine (xscr, y_line, xscr + wscr, y_line, color); 
  (YDrawLine c  xscr y_line (+ xscr wscr) y_line color)

;    YDrawStringImp (cam1d->title, xscr + wscr / 2, yscr + title_h / 2, color, YNONE, YNONE); 
  (YDrawStringImp c (PP_STEP_NAME plot ti) ;"TITLE" 
                  (+ xscr (/ wscr 2))
                  (+ yscr (/ title_h 2)) color 
                  NIL NIL ;YNONE YNONE
                  ) 

  (incf yscr title_h) ;    yscr += title_h; 
  (decf hscr title_h) ;    hscr -= title_h; 
;  }  ;----------------------------------------------------

;  V1CalcMinMax (w1d); 
  ;(plotstep_create plot)
  (plot_min_max_wnum plot)

  (setf wnum (WNUM plot))
  (setf h_step (/ hscr wnum))
  ;(format t "wnum= ~s ~%" wnum) 

  ;(loop for wi from 0 until (= (aref (FR plot) wi 0) -1) do
  ;; идeм циклом по всeм фрeймам и отрисовываeм их цeликом
  (dotimes (wi wnum)

    (v1_draw_frame c plot ti wi
                 xscr (+ yscr (* h_step wi)) wscr h_step
                 )
  )
 
))
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
(defun plot_print_gui (plot)

(with-ltk ()
(let* (
;  (W  400)
;  (H  300)
  (W  *W*)
  (H  *H*)
  (c    (make-instance 'canvas :width W :height H ;:background "white"
                       ))
  )

  (v1_draw_main c plot *ti*)

  (bind c "<ButtonPress-1>" (lambda (evt) (declare (ignore evt))
           (when (> *ti* 0) 
             (decf *ti*)
             (v1_draw_main c plot *ti*))
           )
        )

  (bind c "<ButtonPress-3>" (lambda (evt) (declare (ignore evt))
           (when (< *ti* (- (L_TNUM plot) 1) )
             (incf *ti*)
             (v1_draw_main c plot *ti*))
          )
        )

  (pack c)

)
))
;===============================================================================
;===============================================================================
