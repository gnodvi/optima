/*******************************************************************************
 *                                                                             *
 *  ��� ����� �����: d~test.c                                                  *
 *                                                                             *
  ******************************************************************************
 */ 
                                                                             
//#include "a_comm.h"
//
//-------------------------------------------
typedef int YT_BOOL;                                                          
#include <stdio.h>
#include <stdlib.h>   
/* #include <string.h> */
/* #include <math.h>  */
/* #include <time.h>   */
/* #include <unistd.h>  */
/* #include <ctype.h>   */
/* #include <dirent.h>  */
/* #include <sys/time.h>  */
/* #include <sys/param.h> */
/* #include <sys/timeb.h> */
/* #include <assert.h> */
/* #include <stdarg.h> */
//-------------------------------------------

//#include "d_find.h"  
//#include "d_tree.h"  
/*******************************************************************************
 *                                                                             *
 *  ��� ����� �����: d_tree.h                                                  *
 *                                                                             *
  ******************************************************************************
 */  
    
//******************************************************************************

#ifndef MYTREE_H
#define MYTREE_H 

#include <limits.h>	/* for INT_MAX */

//******************************************************************************
#ifdef __cplusplus	/* let C++ coders use this library */
extern "C" {
#endif
//******************************************************************************


#define NO  101

/******************************************************************************/
#define MM_NEXT_MAX 50

typedef int TR_NVAL;

typedef struct {
  char   *name;
  TR_NVAL nval;
  char   *next_name[MM_NEXT_MAX];
  //---------------------------

  void   *pstr, *prev;
  void   *next_pstr[MM_NEXT_MAX];
} TR_NODE;


typedef struct {
  char    *name;     // ��� ��� ������ ������ (����� ��� �������������?)

  TR_NODE *root;     // ������ (������) ������
  TR_NODE *curn;     // ������� ����
} TR_TREE;

/*----------------------------------------------------------------------------*/
typedef struct {
  TR_NODE *node;
} TR_MOVE;


TR_TREE  *tr_create (TR_NODE/* _TXT */ nodes[]);
TR_TREE  *tr_create_new (char *nodestring[]);
void      tr_rotate (TR_NODE *cur);

void      tree_tests (); 

//******************************************************************************
#ifdef __cplusplus
}
#endif
//******************************************************************************

#endif /* MYTREE_H */
/*----------------------------------------------------------------------------*/




/*******************************************************************************
 *                                                                             *
 *  ��� ����� �����: d_tree.c                                                  *
 *                                                                             *
  ******************************************************************************
 */    


//#include "a_comm.h"
//
//-------------------------------------------
//typedef int YT_BOOL;  
#define SKIP_LINE  printf("\n")

#include <stdio.h>
#include <stdlib.h>   
#include <string.h>
/* #include <math.h>  */
/* #include <time.h>   */
/* #include <unistd.h>  */
/* #include <ctype.h>   */
/* #include <dirent.h>  */
/* #include <sys/time.h>  */
/* #include <sys/param.h> */
/* #include <sys/timeb.h> */
/* #include <assert.h> */
/* #include <stdarg.h> */

//-------------------------------------------

//#include "d_tree.h" 

//-------------------------------------------
void
Error (const char *msg)      
{

  fprintf (stderr, "Error: %s\n", msg);
  exit (EXIT_FAILURE);

}
//-------------------------------------------
/******************************************************************************/

/*----------------------------------------------------------------------------*/
TR_TREE * 
tr_create_beg ()
{
  TR_TREE *t = (TR_TREE *) malloc (sizeof(TR_TREE));

  t->name = "TREE";

  return (t);
}
/*----------------------------------------------------------------------------*/
void
tr_init_from_txt (TR_TREE *tr, TR_NODE nodes[])
{
  TR_NODE  *n_beg, *n_end, *n;
  char **name_end;
  int    i;

  
  for (n=nodes; n->name; n++) {
    // n->pstr = n; // ���� (����� ����) ���������� �����
    n->prev = NULL; // "������������" ������: �� ������ ������ ������
  }

  // ������ ���� - �������� ������ ����� ����� !!
  for (n_beg=nodes; n_beg->name; n_beg++) { 

    i = 0;
    // ���� �� ������ ����-����������
    for (name_end=&(n_beg->next_name[0]); *name_end!=NULL; *name_end++) {

      // � ����� ��������� ���� ������ � ������� ����� �����
      for (n_end=nodes; n_end->name; n_end++) { 

        if (!strcmp (n_end->name, *name_end)) { // ����� ����-�����
          n_beg->next_pstr[i++] = /* n_end->pstr */n_end;
          if (n_end->prev != NULL) Error ("init_from_txt: Too many PREV");
          n_end->prev = n_beg; // �������� ����������� ��� ����-������
        }
      }
    }
    n_beg->next_pstr[i]=NULL;
  }


  tr->root = tr->curn = &(nodes[0]);

  return;
}
/*----------------------------------------------------------------------------*/
TR_TREE *
tr_create (TR_NODE nodes[])
{
  TR_TREE *tr = tr_create_beg ();

  tr_init_from_txt (tr, nodes);
  
  return (tr);
}
/*----------------------------------------------------------------------------*/
void
tr_rotate (TR_NODE *cur)
{
  TR_NODE *n1, *n2, *n;
  int i, j, num;

  for (i = 0; (n = cur->next_pstr[i]) != NULL; i++) ;; // ������� ���������� �����
  num = i;

  for (i = 0; i < num; i++) {
    j = num-i-1;
    if (i >= j) break;

    n1 = cur->next_pstr[i];
    n2 = cur->next_pstr[j];

    cur->next_pstr[i] = n2;
    cur->next_pstr[j] = n1;
  }
  
  for (i = 0; (n = cur->next_pstr[i]) != NULL; i++)
    tr_rotate (n); 

  return;
}
/******************************************************************************/
/*----------------------------------------------------------------------------*/
void 
l_to_n (char *lines[], TR_NODE nodes[], int lev, int *nod) 
{

  lev++;
  
  //for (i = 0; (n = cur->next_pstr[i]) != NULL; i++)

  lev--;
  return;
}
/*----------------------------------------------------------------------------*/
void 
lines_to_nodes (char *lines[], TR_NODE nodes[], int *px, int y)
{
  char /* **pline, */ *line;

  //int x = *px;

  *px += 2;
   y  += 1;

  line = lines[y];

/*   if (line[*px+2] == '=') { */
/*     fprintf (stderr, "%s \n", line); */
/*     *px = x; */
/*     return; */

/*   } */

  printf ("Node: %c ", line[*px]);

  if (line[*px+2] == '=') {
    printf ("%c ", line[*px+4]);
  } else {
    printf ("NO ");
  }

  printf ("\n");
  

  //for (pline=lines+y+1; TRUE; *pline++) {
  //   if (*pline == NULL) break;
  //   line = *pline+x+2;
  //   if (line[0] == ' ') break;

    //fprintf (stderr, "%s \n", line);
    //lines_to_nodes (lines, nodes, &x, y+1);
  //}

  //x  -= 2;
  //*px = x;
  return;
}
/*----------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/
TR_TREE *
tr_create_new (char *lines[])
{

  TR_NODE nodes[50];
  //TR_TREE *tr;
  int x = -2;

  lines_to_nodes (lines, nodes,   &x, -1  /* 0, 0  */  /* 2, 1 */);

  //tr = tr_create (nodes);  
  //tr_rotate (tr->root);

  return (/* tr */NULL);
}
/******************************************************************************/
/*----------------------------------------------------------------------------*/
void 
tree_draw_simp_iter (TR_NODE *cur, int level) 
{
  TR_NODE *n;
  int      i, num;
  char     margin[100];

  level++;
  strcpy (margin, "                                          ");
  margin[2*level] = '\0';

  printf ("%s%s", margin, cur->name);
  if (cur->nval != NO)
  printf (" = %d ", cur->nval);
  printf ("\n");

  for (i = 0; (n = cur->next_pstr[i]) != NULL; i++) ;; // ������� ���������� �����
  num = i;

  for (i = num-1; i>=0; i--) {
    n = cur->next_pstr[i];
    tree_draw_simp_iter (n, level); 
  }


  level--;
  return;
}
/*----------------------------------------------------------------------------*/
void 
tree_draw_simp (TR_TREE *tr) 
{
  int level = -1;

  printf ("----- Tree Draw Simp ----- \n");

  tree_draw_simp_iter (tr->root, level); 

  printf ("-------------------------- \n");
  
  return;
}
/*----------------------------------------------------------------------------*/
void 
tree_tests () 
{
/******************************************************************************/
//                    _________A__________                 
//                    |                  |
//               _____B_____       ______C______            
//               |         |       |           |
//              D=7       E=6     F=10        G=9          
//                                             ^
/******************************************************************************/
  TR_NODE nodes[] = {
    {"A",      NO,  {"C", "B", NULL}}, 
    {  "C",    NO,  {"G", "F", NULL}}, 
    {    "G",   9,  { NULL}}, 
    {    "F",  10,  { NULL}}, 
    {  "B",    NO,  {"E", "D", "H", NULL}}, 
    {    "E",   6,  { NULL}}, 
    {    "D",   7,  { NULL}}, 
    //    {    "H",   5,  { NULL}}, 
    {NULL, 0,  { NULL}},
  };

  //{    "G",  NO,  { "B", NULL}}, // ���� ������������ ������

/*   char *lines[] = { */
/*     "A            ",  */
/*     "  C          ",  */
/*     "    G = 9    ",  */
/*     "    F = 10   ",  */
/*     "  B          ",  */
/*     "    E = 6    ",  */
/*     "    D = 7    ",  */
/*     NULL, */
/*   }; */

  TR_TREE *tr = tr_create (nodes);
  tr_rotate (tr->root);

  //TR_TREE *tr = tr_create_new (lines);

  SKIP_LINE;   
  tree_draw_simp (tr); 


  return;
}
/*----------------------------------------------------------------------------*/
/******************************************************************************/

/******************************************************************************/

/*******************************************************************************
 *                                                                             *
 *  ��� ����� �����: d_find.c                                                  *
 *                                                                             *
  ******************************************************************************
 */ 


//#include "a_comm.h"
//
//-------------------------------------------
#define FALSE 0
#define TRUE  1
#define YRAND(imin,imax) (imin+random()%(imax-imin+1)) 

//typedef int YT_BOOL;  
#define SKIP_LINE  printf("\n")
void
Error (const char *msg);      

#include <stdio.h>
#include <stdlib.h>   
#include <string.h>
#include <math.h> 
/* #include <time.h>   */
/* #include <unistd.h>  */
/* #include <ctype.h>   */
/* #include <dirent.h>  */
/* #include <sys/time.h>  */
/* #include <sys/param.h> */
/* #include <sys/timeb.h> */
#include <assert.h>
#include <stdarg.h>

//#include "d_find.h" 
/*******************************************************************************
 *                                                                             *
 *  ��� ����� �����: d_find.h                                                  *
 *                                                                             *
  ******************************************************************************
 */  
    
#include <limits.h>	/* for INT_MAX */

//******************************************************************************
#ifdef __cplusplus	/* let C++ coders use this library */
extern "C" {
#endif
//******************************************************************************

#define MM_MAX_EVAL   100
#define MM_MIN_EVAL  -100
#define MM_MOVES_MAX  50 //!!!

#define FIND_SIMP_FULL 0
#define FIND_BEST      1
#define FIND_BEST_FULL 2
#define FIND_BABY      3
#define FIND_KARL      4

#define MAXPLY_NOT    -1

/*----------------------------------------------------------------------------*/
typedef  long  (* MM_PROC_C) (long posi);
  //typedef  int   (* MM_PROC_F) (long pstr, long posi, long *p, long find_mode, void *p_work);   
typedef  int   (* MM_PROC_F) (long pstr, long posi, long *p, long find_mode/* , void *p_work */);   

// ������� ����� ���� ����� ������� � �������  ������ � ���� DOUBLE !!!!!!                         
typedef  int   (* MM_PROC_E) (long user, long posi,  int *p_numlev); // Evaluate position

typedef  long  (* MM_PROC_M) (long pstr, long posi, long move);
typedef  void  (* MM_PROC_U) (long pstr, long old_posi);
typedef  void  (* MM_PROC_FP) (long pstr, long posi);
typedef  char* (* MM_PROC_N) (/* long pstr, */ long p_move, long pstr_new);
typedef  char* (* MM_PROC_P) (long pstr, long posi);

typedef  void  (* MM_PROC_MAP) (long pstr, long posi, long moves[], int evals[], int levls[], int num);
typedef  void  (* MM_PROC_H) (long pstr, long posi, int eval, int numlev);

/*----------------------------------------------------------------------------*/
typedef struct {
  int     maxply;
  YT_BOOL is_alfa_beta;
  //int     alfa, beta; // ���� ���������� ������!

  int     gamer_color;

  MM_PROC_C   copy_posi;
  MM_PROC_F   find_moves;
  MM_PROC_E   evaluate;
  MM_PROC_M   make_move;
  MM_PROC_U   undo_move;
  MM_PROC_FP  free_posi;

  MM_PROC_N   name_move;
  MM_PROC_P   name_posi;
  MM_PROC_MAP moves_map;
  MM_PROC_H   set_to_hashtable;

  int    numlev;
  long   posis[100];
  int    posis_num;

} YT_MINMAX;
/*----------------------------------------------------------------------------*/

YT_MINMAX* mm_create (/* long pstr,  */
                    MM_PROC_C copy_posi, 
                    MM_PROC_F find_moves, MM_PROC_E evaluate,
                    MM_PROC_M make_move,  MM_PROC_U undo_move, MM_PROC_FP free_posi,
                    MM_PROC_N name_move,  MM_PROC_P name_posi, MM_PROC_MAP moves_map, 
                    MM_PROC_H   set_to_hashtable,
                    int gamer_color/* , int maxply */);

void mm_init2 (YT_MINMAX *mm, int maxply, YT_BOOL is_alfa_beta/* , int alfa, int beta */);

int   mm_minimax (YT_MINMAX *g, int alfa, int beta, 
                  long posi, long param, 
                  long *p_bestmove, int *count_ends, int *p_levl);

void  free_moves_all (long moves[], int num_moves);
void  minm_tests (); 

//******************************************************************************
#ifdef __cplusplus
}
#endif
//******************************************************************************

  //#endif /* MMGAME_H */
/*----------------------------------------------------------------------------*/

//#include "d_tree.h" 


//-------------------------------------------

/******************************************************************************/
//
//   ������ ���������� �������� ��� ������ ����������
//   ������������ � ������: a_find.c & x_comm.c  
//
/******************************************************************************/

/******************************************************************************/

void    dbg_proc_beg (char *str, int exp);
#define DBG_PROC_BEG(str, exp) dbg_proc_beg (str, exp)

void    DBG_PRINT (char *fmt, ...);
YT_BOOL DBG_IS_PRINT ();

void    dbg_proc_end ();
#define DBG_PROC_END(str) dbg_proc_end (str)

void    dbg_set_maxlevel (int mlevel);

#define LEFT left_buf                                                           
#define LEFT_BEG {LEFT[left_num]=' '; left_num+=2; LEFT[left_num]='\0';}        
#define LEFT_END {LEFT[left_num]=' '; left_num-=2; LEFT[left_num]='\0';}                       

/******************************************************************************/
/*----------------------------------------------------------------------------*/

char left_buf[80] = "\0                                          ";
int  left_num     = 0;

int   max_level = 0;
int   num_level = 0;
char  str_level[80][80];

#define DBG_PROC_BEG(str, exp) dbg_proc_beg (str, exp)

/*----------------------------------------------------------------------------*/
void 
dbg_set_maxlevel (int mlevel)
{

  max_level = mlevel;

}
/*----------------------------------------------------------------------------*/
void 
dbg_proc_beg (char *str, int expression)
{
  assert (expression);

  num_level++;
  strcpy  (str_level[num_level], str);

  //win_sgr (sgr_level[num_level]); 
  // ��������� ����� ��� ������, �� �������� � �����?!
  // � ����������� ����� �������� !!

  DBG_PRINT ("BEG: %s \n", str);

  LEFT_BEG; 
  return;
}
/*----------------------------------------------------------------------------*/
void 
dbg_proc_end ()
{
  LEFT_END; 

  DBG_PRINT ("END: %s \n", str_level[num_level]);

  num_level--;

  //win_sgr (sgr_level[num_level]);

  return;
}
/*----------------------------------------------------------------------------*/
YT_BOOL 
DBG_IS_PRINT ()
{

  if (num_level > max_level) 
    return (FALSE);

  return (TRUE);
}
/*----------------------------------------------------------------------------*/
void 
DBG_PRINT (char *fmt, ...)
{
  va_list argp;

  //if (!DEBUGING) 
  //  return;
  //if (!DBG_IS_PRINT())
  if (num_level > max_level) 
    return;

  //OUTD (left_num);
  printf ("%s", LEFT);

  // ����������� ����� ������ ���������� <stdarg.h>
  va_start (argp, fmt);
  //vfprintf (STDERR, fmt, argp);
  vprintf (fmt, argp);
  va_end   (argp);

  return;
}
// *****************************************************************************
// 
// TODO:
// 
// - ���-������� ������������ (������ � ����������� ��������);
// - ���������� ������ � ������ ������� ����� � ����� ������ � ������������ ���;
// - �����-���� ��������� (������� � ������� double);
// 
// - ������� DBG_PRINT �������� ���-��, ����� �� �������� � �������� � �������;
// - ����������� ��� ���������������� ����: ���������� ��� ��������� ������� (�� �������)!
// 
// - �������� ������� �� ��������� (��������) ���������� ��������� �������� (��� � �����);
// - ��� ������������ �������� ����� ������������ ����� ����-�� ��� ������;
// 
// - ��� ��������� ����������� �������� ������� �� ������;
// 
/*----------------------------------------------------------------------------*/
                                                                            
typedef struct {
  TR_TREE *tree; // �������� ������
  TR_NODE *node; // ������� �������
} SE_MAIN;

/*----------------------------------------------------------------------------*/
long  
se_copy_posi (/* long pstr, */ long posi)
{ 
  TR_NODE *old_posi = (TR_NODE *) posi;

  TR_NODE *new_posi = old_posi;
  // � ����� ������� ������ ������� ����������� ������ ����������, �.�.
  // �� ���� ��������� ����� � ������ � ������� ���������� ���������

  return ((long)new_posi); 
}
/*----------------------------------------------------------------------------*/
int 
se_evaluate (long user, long posi, int *p_numlev/* , int gamer_color */)
{ 
  //TR_TREE *t = (TR_TREE*) user; // ������� ��������� �����
  TR_NODE *n = (TR_NODE *) posi;

  // ����� ����� ������� ������� - ��� �����!
  //int   eval = (t->cur)->nval;
  TR_NVAL   eval = n->nval;
 
  // ���� �������� ���, �� ����� ������� ����� ������
  if (eval == NO) eval = 0 /* numlev */; 

  return (eval);
}
/******************************************************************************/
/*----------------------------------------------------------------------------*/
//#define NEW_TREE
//#ifdef  NEW_TREE
/*----------------------------------------------------------------------------*/
int  
se_find_moves_new (long pstr, long posi, long *p_moves, long find_mode)
{ 
  TR_NODE *n, *cur = (TR_NODE *) posi;

  TR_MOVE *move;
  int i, num=0;  // �� � ����, � � ���������� ������!!

  for (i = 0; (n = cur->next_pstr[i]) != NULL; i++) {
    move = malloc (sizeof (TR_MOVE)); 

    //fprintf (stderr, "%s \n", n->name);
    move->node = n;  

    (p_moves[num++]) = (long) move; 
  }

  return (num);
}
/*----------------------------------------------------------------------------*/
//#else
/*----------------------------------------------------------------------------*/
/* int   */
/* se_find_moves (long pstr, long posi, long *p_moves) */
/* {  */
/*   TR_NODE *cur = (TR_NODE *) posi; */

/*   TR_MOVE *move  */
/*   int num=0;   */

/*   if (cur->next1) { */
/*     move = malloc (sizeof (TR_MOVE));  */
/*     move->node=cur->next1;   */
/*     (p_moves[num++]) = (long) move;  */
/*   } */

/*   if (cur->next2) { */
/*     move = malloc (sizeof (TR_MOVE));  */
/*     move->node=cur->next2;   */
/*     (p_moves[num++]) = (long) move;  */
/*   } */

/*   return (num); */
/* } */
/*----------------------------------------------------------------------------*/
//#endif
/*----------------------------------------------------------------------------*/
long  
se_make_move (long pstr, long old_posi, long move)
{ 
  //TR_TREE *t = (TR_TREE*) pstr;
  TR_MOVE *m = (TR_MOVE*) move;

  //t->cur = m->node;  // ������� ��� (� ������) - ��� ������!
  // � ������ ������� � ������ ������ � �� �����!

  return ((long)(/* t->cur */m->node));  // ������� ��������� �� ����� �������
}
/*----------------------------------------------------------------------------*/
void  
se_undo_move (long pstr, long old_posi)
{ 
  //TR_TREE *t = (TR_TREE*) pstr;

  //TR_NODE *old_cur = (TR_NODE *) old_posi;

  // ��������� � ����������� ������ �������
  // ������������ "����������� ���� ������ �������"
  //cur = old_cur;
  //t->cur = old_cur;

  return;
}
/*----------------------------------------------------------------------------*/
char* 
se_name_move (/* long pstr, */ long move, long pstr_new)
{ 
  TR_TREE *tr = (TR_TREE *) pstr_new; 
  
  static char buffer[20];
  TR_MOVE *m;

  if (!move) return ("");

  m = (TR_MOVE*) move;

  //sprintf (buffer, "to_%s", (m->node)->name);
  sprintf (buffer, "%s to_%s", tr->name, (m->node)->name);

  return (buffer);
}
/*----------------------------------------------------------------------------*/
char* 
se_name_posi (long pstr, long posi)
{ 
  static char buffer[20];
  TR_NODE *n;

  if (!posi) return ("");

  n = (TR_NODE*) posi;

  DBG_PRINT ("posi: %s  \n", n->name);

  return (buffer);
}
/******************************************************************************/
/*----------------------------------------------------------------------------*/
YT_MINMAX *
mm_create (MM_PROC_C copy_posi,
           MM_PROC_F find_moves, MM_PROC_E evaluate,
           MM_PROC_M make_move,  MM_PROC_U undo_move, MM_PROC_FP free_posi, 
           //int	(*end_of_game)(AB_POS *), 
           // ��������������, ��� ������� ..
           MM_PROC_N name_move,  MM_PROC_P name_posi, MM_PROC_MAP moves_map, 
           MM_PROC_H set_to_hashtable,
           int gamer_color/* , int maxply */
)
{
  YT_MINMAX *mm;

  mm = malloc (sizeof *mm); //??
  if (!mm) 
    Error ("mm_create");

  mm->copy_posi	  = copy_posi;
  mm->find_moves  = find_moves;
  mm->evaluate	  = evaluate;
  mm->make_move	  = make_move;
  mm->undo_move	  = undo_move;
  mm->free_posi	  = free_posi;

  mm->name_move	  = name_move;
  mm->name_posi	  = name_posi;
  mm->moves_map	  = moves_map;
  mm->set_to_hashtable = set_to_hashtable;

  mm->numlev      = -1;
  mm->posis_num   =  0;
  mm->gamer_color = gamer_color;

  return (mm);
}
/*----------------------------------------------------------------------------*/
void 
mm_init2 (YT_MINMAX *mm, int maxply, YT_BOOL is_alfa_beta/* , int alfa, int beta */)
{

  mm->maxply       = maxply;
  mm->is_alfa_beta = is_alfa_beta;

  //mm->alfa = alfa;
  //mm->beta = beta;

  return;
}
/*----------------------------------------------------------------------------*/
void 
mm_push_posi (YT_MINMAX *g, long p)
{ 

  g->posis[g->posis_num] = g->copy_posi (/* g->pstr, */ p);
  (g->posis_num)++;

}
/*----------------------------------------------------------------------------*/
long
mm_pop_posi (YT_MINMAX *g)
{ 

  (g->posis_num)--;
  return (g->posis[g->posis_num]);

}
/*----------------------------------------------------------------------------*/
void
free_moves (long moves [], int  num_moves, long bestmove)
{
  int   i;

  for (i = 0; i < num_moves; i++) {
    if (moves[i] == bestmove) continue;

    free ((void*) moves[i]);
  }

  return;
}
/*----------------------------------------------------------------------------*/
void
free_moves_all (long moves[], int num_moves)
{
  int   i;

  for (i = 0; i < num_moves; i++) {
    free ((void*) moves[i]);
  }

  return;
}
/******************************************************************************/
#define ISMY_MOVE(m) (!(m->numlev%2))
//
/*----------------------------------------------------------------------------*/
int 
mm_minimax (YT_MINMAX *m, int alfa, int beta, 
            long old_posi, long pstr,   
            long *p_bestmove, int *count_ends, int *p_levl /* � ���� � eval - ����� ������ */)
{ 
  int   i,  best_eval, eval, best_levl, levl;
  long  bestmove = 0;

  long moves [MM_MOVES_MAX];   // ������ (����������) ��������� �����
  int  evals [MM_MOVES_MAX];   // ������ ������ ��� ������� ���� (��� �������� � ����)
  int  levls [MM_MOVES_MAX];   // ������ ������� ������ ������� ������
  int  num_moves; 

  DBG_PROC_BEG ("mm_minimax - INFO", TRUE);
  //if (m->name_posi) m->name_posi (pstr, old_posi); // DBG_PRINT
  DBG_PROC_BEG ("mm_minimax", TRUE);

  m->numlev++; // -1+1 = 0 ������� - � ������� ������ ���� � ��� ������������

  // ���� ���������� ������ �����
  num_moves = m->find_moves (pstr, old_posi, moves, /* find_mode */-10000);
 
  // �� �������� - ���������� ������ ���� ����� � ������� ��������� ��
  eval = m->evaluate (pstr, old_posi, // ��������� ������� (��� ������� ��������� ����) 
                      /* NULL */ &levl); 
                                      // ���������, ���� ���� � ���-�������
  if (levl == -1000)  // �� ���� �������� � ���-�������
  levl = m->numlev;   // ������� ��� �� ����� !!!!
  

  DBG_PRINT ("numlev   = %d (%d) \n", m->numlev, /* maxlev */ m->maxply);
  DBG_PRINT ("num_moves= %d \n", num_moves);

  if ( //-------- ��������������� ������: ����� �� ���� ������ �� ������ ? 
     (m->numlev == /* maxlev */m->maxply) ||  // �������� ������������ ������
     (num_moves == 0)      ||  // ������ ��� �����  
     (eval >= MM_MAX_EVAL) ||  // ��� ������ ������� ��������� ���� (�� �����-����)     
     (eval <= MM_MIN_EVAL)        
     ) 
  {  
    // ��������� ���������� �������� �������
    if (count_ends != NULL) (*count_ends)++;
    
    best_eval = eval;
    best_levl = levl /* m->numlev */;
    goto end;           // ���������� ������
  } //--------------------------------------------------------------------

  // ����� ����������� ����� ��� ������ ������ ����������� � ������;
  if (ISMY_MOVE(m))  best_eval = MM_MIN_EVAL-1000 ; // �� ������� 0, 2, 4.. ���� �������� "��� ����"
  else               best_eval = MM_MAX_EVAL+1000 ; // � �� ������ (����� ����� ���������) - �������
  best_levl = 0; //??

  for (i = 0; i < num_moves; i++) { //===================================
    DBG_PRINT ("move: %s \n", m->name_move (moves[i], pstr)); 

    long new_posi = m->make_move (pstr, old_posi, moves[i]);  // ������ ��������� � �������;
    if (m->name_posi) m->name_posi (pstr/* 0 */, new_posi); // DBG_PRINT

    // ���������� �������� ����     
    eval = mm_minimax (m, alfa, beta, 
                       new_posi, pstr, NULL, count_ends, &levl);   
    DBG_PRINT ("minimax= % d \n", eval); 
    evals[i] = eval;
    levls[i] = levl - m->numlev; 

    // ������� ��������� ������ ��� ������� � ���-�������
    // ���� ���� ������� �� ������, �� ������� ���� ������ ������ !!!!
    if (m->set_to_hashtable) m->set_to_hashtable (pstr, new_posi, eval, /* m->numlev */levl);

    // ���������� ������ ������
    // !bestmove  - � ������ ��� ����� ��� ������
    if ( 
        (eval > best_eval &&  ISMY_MOVE(m)) || 
        (eval < best_eval && !ISMY_MOVE(m)) ||
        (eval== best_eval &&  (YRAND(0,100)<50 || !bestmove)) 
       ) 
    {
      best_eval = eval; 
      best_levl = levl; 
      bestmove = moves[i];
    }
    
    if (m->free_posi) m->free_posi (/* pstr */0, new_posi);
    //if (is_alfa_beta) {
    if (m->is_alfa_beta) {
    //if (is_alfa_beta > 0) {
      // ������������� ������ ��� ����. ������ ���������
      if ( ISMY_MOVE(m)  &&  (best_eval > alfa))  alfa = best_eval;
      if (!ISMY_MOVE(m)  &&  (best_eval < beta))  beta = best_eval;

      // ���� ������ ��������� ���������������� ���������
      if (!ISMY_MOVE(m)  &&  (best_eval < alfa)) break;
      if ( ISMY_MOVE(m)  &&  (best_eval > beta)) break; // ����� ������ ������!!!
    }

    //if (m->free_posi) m->free_posi (pstr, new_posi);
  } //================================================================

  // ����� ������������ ���������� "����� ������ �����" ��� ������� �������;
  if (m->moves_map) m->moves_map (/* pstr */0, old_posi, moves, evals, levls,  num_moves);

  end: 

  if (ISMY_MOVE(m)) DBG_PRINT ("BestMax= % d  Move= %s \n", best_eval, m->name_move (bestmove, pstr));
  else              DBG_PRINT ("BestMin= % d  Move= %s \n", best_eval, m->name_move (bestmove, pstr));  
                
  if (p_bestmove) {  // ��� ������ � ����� ������ ���� � �������!!
    // ���� ������ �������� �� ���� - ����� ������ ������ ��� �� ������!
    if (!bestmove) bestmove = moves[0]; 

    *p_bestmove = bestmove; // ��� ��������� �� ��������� MOVE !!
  } else {
    free_moves_all (moves, num_moves);
  }

  m->numlev--;

  DBG_PROC_END ();
  if (count_ends) 
  DBG_PRINT ("CalcEnd= % d \n", *count_ends); 
  DBG_PROC_END ();

  if (p_levl) *p_levl = best_levl;
  return (best_eval);
}
/*----------------------------------------------------------------------------*/
//
/******************************************************************************/
void 
se_test_do (TR_NODE nodes[], int true_find, int true_nums, YT_BOOL is_alfa_beta) 
{
  int     alfa = MM_MIN_EVAL, beta = MM_MAX_EVAL;

  int   calc_nums = 0;
  int   maxply    = 10;
  int   calc_find;
  long  bestmove;

  TR_TREE *tr = tr_create (nodes);
  tr_rotate (tr->root);

  TR_NODE *n0 = tr->root; // ����� ������ ������ ��� ��� ��������� �������

  YT_MINMAX *mm = mm_create (NULL, se_find_moves_new , 
                           se_evaluate, se_make_move, NULL, NULL,
                           se_name_move, se_name_posi, NULL, NULL, 0);

  mm_init2 (mm,  maxply, is_alfa_beta/* , alfa, beta */);

  calc_find = mm_minimax (mm, alfa, beta, 
                          (long)(n0), (long)(tr), &bestmove, &calc_nums, NULL);

  if ((calc_find==true_find) && (calc_nums==true_nums)) {
    printf (".......... OK \n");
  } else {
    printf ("ERROR: se_test_do: (T_FIND=%d C_FIND=%d) (T_NUMS=%d C_NUMS=%d) BESTMOVE=%s \n", 
             true_find, calc_find,  true_nums, calc_nums,
             se_name_move (bestmove, (long)tr));
  }

  return;
}
/*----------------------------------------------------------------------------*/
void 
minm_tests () 
{

  TR_NODE nodes_1[] = {

  //  +  -  +    =================================================
  {"A", NO, {"D","C","B", NULL}}, 


  {  "D", NO, {"K","J", NULL}}, 

  {     "K", NO, {"P","N",  NULL}},  
  {        "P",  3,  { NULL}},      // ������� ���� ��� ������������� �� �� ����� ���!!     "X"  
  {        "N", 17,  { NULL}},      // ���� ��� ����� ��� ��������� ��� �������

  {     "J", NO, {"M","L",  NULL}}, // <- max = 15 -  ��� ��� ������ ���
  {        "M", 14,  { NULL}},  
  {        "L", 15,  { NULL}},  

  {  "C", NO, {"I","H","G", NULL}}, 

  {     "I",  4,  { NULL}},  // ���� ��� �� ������������� (���� ��������� ��� �� ������)    "X"   
  {     "H",  5,  { NULL}},  // ���� ��� �� �������: best_min < best_max (�� ����. ������)  
  {     "G", 10,  { NULL}},  // ���� ��� ���� ��� �������

  {  "B", NO, {"F","E", NULL}}, 
  {     "F",  8,  { NULL}}, // ������ ����� �� ��� ��� "B" - ���� ������� 
  {     "E", 10,  { NULL}},  

       {NULL, 0, { NULL}},
  }; 
  // =============================================================

  SKIP_LINE;
  se_test_do (nodes_1,  /*8*/15 /*������� ����*/, 9  /*����������� �����*/, /* FALSE */ FIND_SIMP_FULL); 
  se_test_do (nodes_1,  /*8*/15 /*������� ����*/, 9-2/*����������� �����*/, /* TRUE */ FIND_BEST_FULL  /*alfa-beta*/); 
  SKIP_LINE;

  return;
}
/******************************************************************************/
//
//
//
//
/*----------------------------------------------------------------------------*/
// 
/*----------------------------------------------------------------------------*/
void 
all_tests () 
{

  minm_tests ();
 
  printf ("\n");

  tree_tests (); 

  return;
}
/*============================================================================*/
int 
main (int argc, char** argv) 
{

  all_tests (); 

  return (0);
}
/*============================================================================*/

