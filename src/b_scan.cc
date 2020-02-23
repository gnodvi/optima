// =============================================================================
// ��� ����� �����: pois.c 

//----------------------------------------------------------------------------*/
// 
//    ��������������� ��������� 
//       �����������  
//  
//------------------------------------------------------------------------------
 
#include <math.h> 
#include <stdio.h>
 
#define A x [i-1] [j-1] 
#define B x [i-1] [j  ] 
#define C x [i-1] [j+1] 
#define D x [i  ] [j-1] 
#define E x [i  ] [j  ] 
#define F x [i  ] [j+1] 
#define G x [i+1] [j-1] 
#define H x [i+1] [j  ] 
#define J x [i+1] [j+1] 

#define TRUE  1 
#define FALSE 0 

//#define II 256 
//#define JJ 256 

#define II 10
#define JJ 10 

#define SKIP while(getchar()!='\n') 
 
//------------------------------------------------------------------------------
/* svertka (float x[][JJ], float y[][JJ], int ii, int jj,  */
/*          int   *h[])  */

/* svertka (float x[][JJ], float y[][JJ], int ii, int jj,  */
/*          int   h[][3])  */

//------------------------------------------------------------------------------
svertka (x, y, ii, jj, h) 
  int   ii,jj, h[][3]; 
  float x[][JJ], y[][JJ]; 

{ 
  int i,j,n,m; 
  int norm=0; 
  float sum;
 
  for (n=0; n<3; n++) 
  for (m=0; m<3; m++) {
    norm = norm + h[n][m];
    //fprintf (stderr, "%d \n", h[n][m]);
  }

  // ��������� ����� ��e� ��������e���� �����
  //fprintf (stderr, "norm= %d \n", norm);

  for (i=1; i<ii-1; i++) 
  for (j=1; j<jj-1; j++) 
  { 
    sum = 0; 
    for (n=0; n<3; n++) 
    for (m=0; m<3; m++) 
      sum = sum + h[n][m] * x[i+n-1][j+m-1]; 

    y[i][j] = sum / norm; // � e��� norm=0 ?!

    /*     printf("\n%d %d %f %f",i,j,x[i][j],y[i][j]);*/ 
  } 

  return; 
} 
//------------------------------------------------------------------------------
//
//    puts(" 1 - ���������� �������             "); 
//
//------------------------------------------------------------------------------
void
filter_by_maska (float x[][JJ], float y[][JJ], int ii, int jj, char otv) 
 
{ 
  int h1[3][3] = {  1,1,1,    1,1,1,   1,1,1};             
  //    puts(" 1  1  1           ����� 1                             ");   
  //    puts(" 1  1  1               ���������� ���� (�������������� ");    
  //    puts(" 1  1  1               ����������)                     "); 

  int h2[3][3] = { {1,1,1,}, {1,2,1,}, {1,1,1}};            
  //    puts(" 1  1  1           ����� 2                             ");   
  //    puts(" 1  2  1               ���������� ���� (�������������� ");    
  //    puts(" 1  1  1               ����������)                     "); 

  int h3[][3]  = {  0,-1, 0, -1, 5,-1,  0,-1, 0 };             
  //    puts(" 0 -1  0           ����� 3                             ");   
  //    puts("-1  5 -1               ������������� ������            ");    
  //    puts(" 0 -1  0               (��������������� ����������)    "); 

  int h4[][3]  = { -1,-1,-1, -1, 9,-1, -1,-1,-1 };            
  //    puts("-1 -1 -1           ����� 4                             ");   
  //    puts("-1  9 -1               ---//---//---                   "); 
  //    puts("-1 -1 -1                                               "); 

  int h5[][3]  = {  1,-2, 1, -2, 5,-2,  1,-2, 1 };               
  //    puts(" 1 -2  1           ����� 5                             ");   
  //    puts("-2  5 -2               ---//---//---                   "); 
  //    puts(" 1 -2  1                                               ");          

  switch  (otv) 
  { 
  case '1'  :  svertka (x,y, ii,jj, h1); return; 
  case '2'  :  svertka (x,y, ii,jj, h2); return; 
  case '3'  :  svertka (x,y, ii,jj, h3); return; 
  case '4'  :  svertka (x,y, ii,jj, h4); return; 
  case '5'  :  svertka (x,y, ii,jj, h5); return; 
  } 
  
} 
//------------------------------------------------------------------------------
//
//    printf("\n\n   ���� ��������� �������� : \n\n"); 
//    puts(" 1 - �������������  (nn*mm)          "); 
//    puts(" 2 - �������������� (nn*mm)          "); 
//
//------------------------------------------------------------------------------
//      ��������� ������ � ��������������  
//      �����  (n*m). 
//  
//------------------------------------------------------------------------------
median_1_run (float x[][JJ], float y[][JJ], int ii, int jj, 
              int nn, int mm) 
{ 
  int   i,j,n,m, /* nn,mm, */ num,width,pol_nn,pol_mm; 
  int   index, compare(); 
  float base[81]; 
 
  num = nn*mm; 
  width = sizeof (float); 

  pol_nn = (nn-1)/2; 
  pol_mm = (mm-1)/2; 

  for (i=pol_nn; i<ii-pol_nn; i++) 
  for (j=pol_mm; j<jj-pol_mm; j++) 
  { 
    index=0; 
    for (n=0; n<nn; n++) 
    for (m=0; m<mm; m++) 
      base[index++] = x[i+n-pol_nn][j+m-pol_mm]; 

    qsort (base, num, width, compare); 
    y[i][j] = base[num/2]; 
  } 

  return; 
} 
//------------------------------------------------------------------------------
//        ��������� ������ � �������������� 
//        �����  (m*n) 
//  
//------------------------------------------------------------------------------
median_2_run (float x[][JJ], float y[][JJ], int ii, int jj, 
              int nn, int mm) 
{ 
  int i,j,n,m, /* nn,mm, */ num,width,pol_nn,pol_mm; 
  float base[81]; 
  int index,compare();
 
  num=nn+mm-1; 
  width=sizeof (float); 
  pol_nn=(nn-1)/2; 
  pol_mm=(mm-1)/2; 

  for (i=pol_nn;i<ii-pol_nn;i++) 
  for (j=pol_mm;j<jj-pol_mm;j++) 
  {    
    index=0; 
    for(n=0;n<nn;n++) 
    for(m=0;m<mm;m++) 
      if(n==pol_nn || m==pol_mm) 
        base[index++]=x[i+n-pol_nn][j+m-pol_mm]; 

    qsort(base,num,width,compare); 
    y[i][j]=base[num/2]; 
    } 

  return; 
}    
//------------------------------------------------------------------------------ 
int
compare (float **arg1, float **arg2) 
{ 

  return (*arg1-*arg2); 
} 
//------------------------------------------------------------------------------
//
//    puts("          � � � � _ 3  (������� 'SOMATOM')    "); 
//    puts("<��> - �����                                    "); 
//    puts(" 1 - ������������ (������)                    "); 
//    puts(" 2 - ������������ (����. ������� ��������)    "); 
//    puts(" 3 - ���������                                "); 
//    puts(" 4 - ������������� �������                    "); 
//    puts(" 5 - ������������ (������������� �������)     "); 
//    puts(" 6 - �����������                              "); 
//    puts(" 7 - ������������ (������� 2*2)               "); 
//    puts(" 8 - ������� (� ���. ������������ �������)    "); 
//    puts(" 9 - ��������� (������� 5*5)                  "); 
//
//------------------------------------------------------------------------------
//    ������������ ������ (������). 
//  
//------------------------------------------------------------------------------
void
menu_31 (float x[][JJ], float y[][JJ], int ii, int jj) 
{ 
  int h[][3] =       {              
    1, 2, 1,                
    2, 4, 2,                 
    1, 2, 1  };            
         
  svertka(x,y,ii,jj,h); 

  return; 
}  
//------------------------------------------------------------------------------
//    ������������ ������ (����.������� ��������). 
//  
//------------------------------------------------------------------------------
void
menu_32 (float x[][JJ], float y[][JJ], int ii, int jj) 
{ 
  int i,j;
 
  for(i=1;i<ii-1;i++) 
  for(j=1;j<jj-1;j++) 
    y[i][j]=sqrt ( A+ B+ C+ 
                   D+    F+ 
                   G+ H+ J)/8; 

  return; 
}  
//------------------------------------------------------------------------------
//    ��������� ������. 
//  
//------------------------------------------------------------------------------
void
menu_33 (float x[][JJ], float y[][JJ], int ii, int jj) 
{ 
  int i,j; 

  for (i=1; i<ii-1; i++) 
  for (j=1; j<jj-1; j++) 
    y[i][j] = 2 * sqrt (pow(A+B+C-G-H-J,2) + pow(A+D+G-C-F-J,2)); 

  return; 
}  
//------------------------------------------------------------------------------
//     ������ ������������� �������. 
//  
//------------------------------------------------------------------------------
void
menu_34 (float x[][JJ], float y[][JJ], int ii, int jj) 
{ 
 
  int h[][3] =        { 
    -2, 1,-2,               
    1, 6, 1,              
    -2, 1,-2   };
              
  svertka(x,y,ii,jj,h); 

  return; 
}  
//------------------------------------------------------------------------------
//   ������������ ������ (������������� �������). 
// 
 
#define LIMIT 30 
//------------------------------------------------------------------------------
void
menu_35 (float x[][JJ], float y[][JJ], int ii, int jj) 
{ 
  int i,j; 
  float raz,fil1; 

  for(i=1;i<ii-1;i++) 
  for(j=1;j<jj-1;j++) 
  { 
    fil1=(A+2*B+C+2*D+4*E+2*F+G+2*H+J); 
    raz=2*E-fil1; 

    if(fabs(raz)>LIMIT)  y[i][j]=raz; 
    else                 y[i][j]=fil1; 
  } 

  return; 
} 
//------------------------------------------------------------------------------
//    ����������� ������. 
//  
//------------------------------------------------------------------------------
void
menu_36 (float x[][JJ], float y[][JJ], int ii, int jj) 
{ 
  int h[][3] = {              
    -1,-1,-1,                                                
     1, 3,-1,                  
     1, 1,-1      };
          
  svertka (x,y,ii,jj,h);
 
  return; 
} 
//------------------------------------------------------------------------------
//    ������������ ������ (������� 2*2). 
//  
//------------------------------------------------------------------------------
void
menu_37 (float x[][JJ], float y[][JJ], int ii, int jj) 
{ 
  int i,j; 

  for(i=1;i<ii-1;i++) 
  for(j=1;j<jj-1;j++) 
    y[i][j]=(A+B+D+E)/4; 

  return; 
} 
//------------------------------------------------------------------------------
//    ������� ������ (� ����������� ������������ �������). 
//  
//------------------------------------------------------------------------------
void
menu_38 (float x[][JJ], float y[][JJ], int ii, int jj) 
{ 
 
return; 
} 
//------------------------------------------------------------------------------
//    ��������� ������ (������� 5*5). 
//  
//------------------------------------------------------------------------------
void
menu_39 (float x[][JJ], float y[][JJ], int ii, int jj) 
{ 
 
  return; 
} 
//------------------------------------------------------------------------------
//      ���������������� ��������� ��� ����� �� ���������� 
//      (����� ��������� �������). 
//  
//    puts(" 4 - ��������-�� (����� ��������� �������) "); 
//------------------------------------------------------------------------------
void
menu_4_otv (float x[][JJ], float y[][JJ], int ii, int jj, char otv) 
{ 
 
  int h1[][3] = {  0,-1, 0, -1, 4,-1,  0,-1, 0 };   // ���e ��e ���e��e ..           
/*     puts("                0 -1  0     ");        */
/*     puts(" ����� 1       -1  4 -1     ");        */
/*     puts("                0 -1  0     ");        */

  int h2[][3] = { -1,-1,-1, -1, 8,-1, -1,-1,-1 };                
/*     puts("               -1 -1 -1     ");        */
/*     puts(" ����� 2       -1  8 -1     ");        */
/*     puts("               -1 -1 -1     ");        */

  int h3[][3] = {  1,-2, 1, -2, 4,-2,  1,-2, 1 }; 
/*     puts("                1 -2  1     ");        */
/*     puts(" ����� 3       -2  4 -2     ");        */
/*     puts("                1 -2  1     ");        */
             
  int *h; 
  //int   h[][];

  if      (otv=='1')  h = h1[0]; 
  else if (otv=='2')  h = h2[0]; 
  else if (otv=='3')  h = h3[0]; 

  svertka (x, y, ii, jj, h);         

}
//------------------------------------------------------------------------------
//      ���������������� ��������� �������              
//      (�������� ����������� �����).               
//
//------------------------------------------------------------------------------
// puts(" 5 - ��������-�� (���������������)         "); 
//------------------------------------------------------------------------------
void
menu_5_otv (float x[][JJ], float y[][JJ], int ii, int jj, char otv) 
{ 
 
  // puts("          �����  ���������� :    ");  
  // puts("                                 "); 

  int h1[][3] = {  1, 1, 1,  1,-2, 1, -1,-1,-1 };  //  �����    
  int h2[][3] = {  1, 1, 1, -1,-2, 1, -1,-1, 1 };  //  ������-������ 
  int h3[][3] = { -1, 1, 1, -1,-2, 1, -1, 1, 1 };  //  ������   
  int h4[][3] = { -1,-1, 1, -1,-2, 1,  1, 1, 1 };  //  ���-������ 
  int h5[][3] = { -1,-1,-1,  1,-2, 1,  1, 1, 1 };  //  �� 
  int h6[][3] = {  1,-1,-1,  1,-2,-1,  1, 1, 1 };  //  ���-����� 
  int h7[][3] = {  1, 1,-1,  1,-2,-1,  1, 1,-1 };  //  �����  
  int h8[][3] = {  1, 1, 1,  1,-2,-1,  1,-1,-1 };  //  ������-�����  

  int *h;                

  if      (otv=='1') h = h1[0]; 
  else if (otv=='2') h = h2[0]; 
  else if (otv=='3') h = h3[0]; 
  else if (otv=='4') h = h4[0]; 
  else if (otv=='5') h = h5[0]; 
  else if (otv=='6') h = h6[0]; 
  else if (otv=='7') h = h7[0]; 
  else if (otv=='8') h = h8[0];
 
  svertka (x, y, ii, jj, h); 

}
//------------------------------------------------------------------------------
//       ���������������� ��� �����������      
//       ����������� ����� ��������� ������.  
/*----------------------------------------------------------------------------*/ 
//    puts(" 6 - ��������-�� (����� ��������� ������)  "); 
/*----------------------------------------------------------------------------*/
void 
menu_6_otv (float x[][JJ], float y[][JJ], int ii, int jj, char otv) 
{ 
  int h1[][3] = { -1, 2,-1, -1, 2,-1, -1, 2,-1 }; // �����/��            
  int h2[][3] = { -1,-1,-1,  2, 2, 2, -1,-1,-1 }; // �����/������            
  int h3[][3] = { -1,-1, 2, -1, 2,-1,  2,-1,-1 }; // ���-�����/������-������             
  int h4[][3] = {  2,-1,-1, -1, 2,-1, -1,-1, 2 }; // ������-�����

  int *h; 

      if (otv=='1')     h = h1[0]; 
 else if (otv=='2')     h = h2[0]; 
 else if (otv=='3')     h = h3[0]; 
 else if (otv=='4')     h = h4[0]; 

 svertka (x, y, ii, jj, h); // � ��e� ����� ���e��� ����� ! ������� � NAN !

}
//----------------------------------------------------------------------------*/
//
//----------------------------------------------------------------------------*/
void
a_init_all (float a[][JJ], float val) 
{ 
  int i, j;

  for (i=0; i< II; i++)
  for (j=0; j< JJ; j++) {
    a[i][j] = val; // ��������e� 
  }

  return;
}
//----------------------------------------------------------------------------*/
void
a_init_rect (float a[][JJ], 
             int imin, int imax,
             int jmin, int jmax,
             float val) 
{ 
  int i, j;

  for (i=imin; i<= imax; i++)
  for (j=imin; j<= jmax; j++) {
    a[i][j] = val;
  }

  return;
}
//----------------------------------------------------------------------------*/
void
a_print (float a[][JJ]) 
{ 
  int i, j;

  for (i=0; i< II; i++) {
    for (j=0; j< JJ; j++) {
      printf ("% 5.1f ", a[i][j]);
    }
    printf ("\n");
  }

  return;
}
//----------------------------------------------------------------------------*/
void
pois_test () 
{ 

  float x[II][JJ]; // ������� ������
  float y[II][JJ]; // ��������

  int i, ii = II; 
  int j, jj = JJ; 

  printf ("\n");
  
  a_init_all  (x, 0); 
  a_init_rect (x, 2,6, 2,6,  1); 

  a_print (x); 
  printf ("-------------------------------------------- \n");
  printf ("\n");

/*   a_init_all (y, 0); */
/*   poi (x, y, &ii, &jj) ; */
/*   a_print (y); */

  //-------------------------------------------------------
  a_init_all (y, 0); menu_31 (x, y, ii, jj);  a_print (y); 
  printf ("\n");
  a_init_all (y, 0); menu_32 (x, y, ii, jj);  a_print (y); 
  printf ("\n");
  a_init_all (y, 0); menu_33 (x, y, ii, jj);  a_print (y); 
  printf ("\n");
  a_init_all (y, 0); menu_34 (x, y, ii, jj);  a_print (y); 
  printf ("\n");
  a_init_all (y, 0); menu_35 (x, y, ii, jj);  a_print (y); 
  printf ("\n");
  a_init_all (y, 0); menu_36 (x, y, ii, jj);  a_print (y); 
  printf ("\n");
  a_init_all (y, 0); menu_37 (x, y, ii, jj);  a_print (y); 
  //-------------------------------------------------------

/*   printf ("\n"); */
/*   a_init_all (y, 0); menu_6_otv (x, y, ii, jj, '2'); a_print (y);  */
// ��e � ���e���� ������� (�������) 
  printf ("-------------------------------------------- \n");
  printf ("\n");
/*   a_init_all (y, 0); menu_5_otv (x, y, ii, jj, '1'); a_print (y);  */


  a_init_all (y, 0); median_1_run (x, y,  ii, jj,  3, 3); a_print (y); 
  printf ("\n");
  a_init_all (y, 0); median_2_run (x, y,  ii, jj,  3, 3); a_print (y); 
  printf ("\n");

  a_init_all (y, 0); filter_by_maska (x, y, ii, jj, '1'); a_print (y); 

  printf ("\n");
  return;  
} 
// =============================================================================



// =============================================================================
// ��� ����� �����: scan.c 

/* - ������������ ����� 
 * - ����� ���������� ������������� 
 * - ������������ ����� ����������� �������������� 
 */ 

#define II_SCR 500 
#define JJ_SCR 500 

#undef  II // ��� �e ��e�� ���������, �� ���� �����
#undef  JJ
#define II  200 
#define JJ  200 

#define NN  200 
#define MM  200 
#define	INF 1.0e10 
#define	PI  3.14 
#define FALSE 0 
#define TRUE 1 
#define FSKIP(x) while ((getc(x))!='\n') 
//#define SKIP while (getchar()!='\n') 
 
#define ATR_BUKVA  '@' 
#define ATR_POINT  '*' 
#define ATR_DUGA   ')' 
#define ATR_FLAG   '+' 
#define ATR_VERT   '|' 
#define ATR_CIRC   '$' 
#define ATR_OTREZ  '/' 
#define ATR_END    '-' 
 
//#include <stdlib.h> 
#include <math.h> 
#include <string.h> 
#include <stdio.h> 
 
float d_line = 1.0; // ������ �����   

int   
  d_cell = 2,       // ������ ����������
  lit_x  = 0,       // ����� �� �  
  lit_y  = 0,       // ����� �� y  
  ii     = 50,      // ����������� �� x 
  jj     = 50,      // ����������� �� y
  rap    = 2,       // 
  ii_scr = 23,      // ����������� �� x 
  jj_scr = 80,      // ����������� �� y 
  pole_i = 1,       // ������ '����-���'
  pole_j = 1,       // ������ '����-�����'
  l_step = 1,       // ����������. �����.
  h_line = 10;      // ������ ������ 

float 
  //contr = 1, 
  const_shum = 0.1; // ������� ����  

//----------------------------------------------------------------------------*/
void
disp_p (float p[][MM], int nn, int mm) 
{ 
  int n ,m;
 
  for (n=0;n<nn;n++) 
  { 
    for (m=0;m<mm;m++) 
      if (p[n][m]==0) putchar('0'); 
      else            putchar('1'); 
    putchar('\n'); 
  } 
  
  return; 
}	 
/*---------------------------------------------------*/ 
void
disp_scr (int scr[][JJ_SCR], int ii_scr, int jj_scr) 
{ 
  int i,j; 

  for (i=0;i<ii_scr;i++) 
    { 
    for (j=0;j<jj_scr;j++) 
        if (scr[i][j]==0) putchar('0'); 
        else              putchar('1'); 
    putchar('\n'); 
    } 

  return; 
}	 
//----------------------------------------------------------------------------*/
float 
l_point (float x0, float y0, float x1, float y1) 
{ 

  return (sqrt((x1-x0)*(x1-x0)+(y1-y0)*(y1-y0))); 

} 
//----------------------------------------------------------------------------*/
float 
l_circ (float x0, float y0, float r, float xc, float yc) 
{ 

  return (abs(r-sqrt((x0-xc)*(x0-xc)+(y0-yc)*(y0-yc)))); 

} 
//----------------------------------------------------------------------------*/
float 
l_otrez (float x0, float y0, float x1, float y1, float x2, float y2) 
{ 
  float a,b,c,l,xp,yp; 

  a  = (x2-x1) * (x2-x1); 
  b  = (y2-y1) * (y2-y1); 
  c  = (y2-y1) * (x2-x1); 
  xp = (a*x0 + b*x1 + c * (y0 - y1)) / (a + b); 
  yp = (a*y1 + b*y0 + c * (x0 - x1)) / (a + b); 
  
  if      (x1 < x2) 
    if      (xp < x1) l = sqrt ((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0)); 
    else if (xp > x2) l = sqrt ((x2-x0) * (x2-x0) + (y2-y0) * (y2-y0)); 
    else              l = sqrt ((xp-x0) * (xp-x0) + (yp-y0) * (yp-y0)); 

  else if (x2 < x1)  
    if      (xp < x2) l = sqrt ((x2-x0) * (x2-x0) + (y2-y0) * (y2-y0)); 
    else if (xp > x1) l = sqrt ((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0)); 
    else              l = sqrt ((xp-x0) * (xp-x0) + (yp-y0) * (yp-y0)); 

  else if (x1 == x2)  
  if      (y1 < y2)  
    if      (yp < y1) l = sqrt ((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0)); 
    else if (yp > y2) l = sqrt ((x2-x0) * (x2-x0) + (y2-y0) * (y2-y0)); 
    else              l = sqrt ((xp-x0) * (xp-x0) + (yp-y0) * (yp-y0)); 
  else if (y2 < y1) 
    if      (yp < y2) l = sqrt ((x2-x0) * (x2-x0) + (y2-y0) * (y2-y0)); 
    else if (yp > y1) l = sqrt ((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0)); 
    else              l = sqrt ((xp-x0) * (xp-x0) + (yp-y0) * (yp-y0)); 
  
  return (l); 
} 
//----------------------------------------------------------------------------*/
float 
l_duga (float x0, float y0, float r, float xc, float yc, 
        float x1, float y1, float x2, float y2) 
{ 

  float fi0, fi1, fi2, l; 

 if      (y1 == yc)   
   if (x1 > xc)      fi1 =     PI / 2.0; 
   else              fi1 = 3 * PI / 2.0; 
 else if (y1 <  yc)  fi1 =     PI + atan ((x1-xc) / (y1-yc)); 
 else if (x1 <= xc)  fi1 = 2 * PI + atan ((x1-xc) / (y1-yc)); 
 else                fi1 =          atan ((x1-xc) / (y1-yc)); 
 
 if      (y2 == yc)   
   if (x2 > xc)      fi2 =     PI / 2.0; 
   else              fi2 = 3 * PI / 2.0; 
 else if (y2 <  yc)  fi2 =     PI + atan ((x2-xc) / (y2-yc)); 
 else if (x2 <= xc)  fi2 = 2 * PI + atan ((x2-xc) / (y2-yc)); 
 else                fi2 =          atan ((x2-xc) / (y2-yc)); 
 
 if      (y0 == yc)   
   if (x0 > xc)      fi0 =     PI / 2.0; 
   else              fi0 = 3 * PI / 2.0; 
 else if (y0 < yc)   fi0 =     PI + atan ((x0-xc) / (y0-yc)); 
 else if (x0<= xc)   fi0 = 2 * PI + atan ((x0-xc) / (y0-yc)); 
 else                fi0 =          atan ((x0-xc) / (y0-yc)); 
 
 if        (fi1 < fi2) 
   if ((fi1 <= fi0) && (fi0 <= fi2))  
     l = abs (r - sqrt ((x0-xc) * (x0-xc) + (y0-yc) * (y0-yc))); 
   else       
     l = INF; 

 else  if ((fi1 <= fi0) || (fi0 <= fi2)) 
     l = abs (r - sqrt ((x0-xc) * (x0-xc) + (y0-yc) * (y0-yc))); 
 else       
     l = INF;
 
 return (l); 
} 
//----------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------- 
 *  ������� �������  
 *     ��������� ����� 
 */ 
//----------------------------------------------------------------------------*/
void
work_bukva (float tab[15][10], float p[][JJ], char *bukva, 
            int *nn_cur, int *mm_cur)  
{ 
  int   i, j, k, kk, bl_wh [II][JJ]; 
  float	x0, y0, l_min, rapid, w, h, dx, dy; 
  char  ch; 
  
  float l ;//, 
  //l_point(), l_duga(), l_otrez(), l_circ(); 
  
  /* ������������ ����-�������  ������ */ 
  
  *bukva = tab[0][1]; 
  w  = tab[0][2]; 
  h  = tab[0][3]; 
  dx = w / ii; 
  dy = h / jj;
 
  for (i=0; i<ii; i++)  
  for (j=0; j<jj; j++)  
  { 
    l_min = INF; 
    x0 = j * dx; 
    y0 = (ii - i - 1) * dy; 

    for (k=1; tab[k][0]!=9; k++)  
    { 
      if      (tab[k][0]==1) l = l_point (x0,y0, tab[k][1], tab[k][2]); 
      else if (tab[k][0]==2) l = l_circ  (x0,y0, tab[k][1], tab[k][2], tab[k][3]); 
      else if (tab[k][0]==3) l = l_otrez (x0,y0, tab[k][1], tab[k][2], tab[k][3], tab[k][4]); 
      else if (tab[k][0]==4) l = l_duga  (x0,y0, tab[k][1], tab[k][2], tab[k][3], tab[k][4], 
                                                 tab[k][5], tab[k][6], tab[k][7]); 
      else  exit (1); 
      if (l < l_min)  l_min = l; 
    }  /* ���������� ���. ���������� �� ��� */ 

    if (l_min < d_line / 2.0)  bl_wh[i][j] = 1; 
    else                       bl_wh[i][j] = 0; 
  } 

  { 
    int   n, m, nn, mm, g, h, i, j; 
    float teta, sum, ro[NN][MM]; 
    
    nn = (ii - lit_y) / d_cell; 
    mm = (jj - lit_x) / d_cell; 
    *nn_cur = nn; 
    *mm_cur = mm;
 
    teta = (d_cell * d_cell) / 2.0; 
    for (n = 0; n < nn; n++)  
    for (m = 0; m < mm; m++) 
    { 
      sum = 0; 
      for (i=0; i<d_cell; i++)  
      for (j=0; j<d_cell; j++)  
          if (bl_wh [n*d_cell+i+lit_y][m*d_cell+j+lit_x] == 1) sum++;
 
      if (sum < teta)   p[n][m] = 0; 
      else              p[n][m] = 1; 
    } 
  } 

  return; 
}  
/*---------------------------------------------------------------*/ 
duga_duga (float ra, float xa, float ya, float rb, float xb, float yb, 
           char flag, float *x, float *y) 
{ 

  float m, n, a, b, c, xp1, yp1, xp2, yp2, xp, yp, fi; 
  float fi_delta = PI / 360; 
  
  m   = - (yb-ya) / (xb-xa); 
  n   = (yb*yb - ya*ya + xb*xb - xa*xa + ra*ra - rb*rb) / (xb-xa) / 2; 
  a   = m*m + 1; 
  b   = (m*n - m*xb - yb) * 2; 
  c   = xb*xb - 2*xb*n + n*n + yb*yb - rb; 
  yp1 = (-b - sqrt (b*b - 4*a*c)) / 2 / a; 
  xp1 = m*yp1 + n; 
  yp2 = (-b + sqrt (b*b - 4*a*c)) / 2 / a; 
  xp2 = m*yp2 + n; 
  xp  = xp1; 
  yp  = yp1;
 
  if      (yp == ya)   
    if (xp > xa)      fi =     PI / 2.0; 
    else              fi = 3 * PI / 2.0; 
  else if (yp <  ya)  fi =     PI + atan ((xp-xa) /(yp-ya)); 
  else if (xp <= xa)  fi = 2 * PI + atan ((xp-xa) /(yp-ya)); 
  else                fi =          atan ((xp-xa) /(yp-ya)); 

  fi = fi + fi_delta; 
  if (fi > 2*PI)  fi = fi - 2*PI; 

  xp=xa+ra*sin(fi); 
  yp=ya+ra*cos(fi); 

  if ((sqrt ((xp-xb)*(xp-xb) + (yp-yb)*(yp-yb)) < rb) && (flag == ATR_FLAG)) 
  { 
    *x = xp1; 
    *y = yp1; 
  } 
  else 
  { 
    *x = xp2; 
    *y = yp2; 
  } 

  return; 
} 
//----------------------------------------------------------------------------*/
duga_otrez (float ra, float xa, float ya, float xvert, 
            char flag, float *x, float *y) 
{ 
  if (flag == ATR_FLAG) 
    *y = ya + sqrt (ra*ra - (xvert-xa) * (xvert-xa)); 
  else 
    *y = ya - sqrt (ra*ra - (xvert-xa) * (xvert-xa));
 
  *x = xvert; 

  return; 
} 
//----------------------------------------------------------------------------*/
//----------------------------------------------------------------------------*/
int
find_read (FILE *in, char bukva, float t[15][10]) 
{ 
  int i, j, k, kk; 
  char ch; 
  int   offset; 
 
  fseek (in, 0, 0);
 
  while (1) 
  { 
    offset = ftell (in); 
    fscanf (in, " %c", &ch); 
    while (ch != ATR_BUKVA && ch != EOF) 
    { 
      FSKIP (in); 
      offset = ftell (in); 
      fscanf (in, " %c", &ch); 
    } 

    if (ch == EOF) return (-1); 
    else         { 
              
      if (bukva == '*') 
      {  fseek (in, offset, 0); break; } 
      fscanf (in, " %c", &ch); 
      if (ch == bukva) 
      { 
        fseek (in, offset, 0); 
        break; 
      } 
      else FSKIP (in); 
    } 
  } 
  /*-----------------------------------------------------*/ 

  for (k=0; ; k++) 
  { 
    fscanf (in, " %c", &ch);
 
    if      (ch == ATR_BUKVA) 
    { 
      t[k][0] = 0; 
      fscanf (in, " %c %f", &t[k][1], &t[k][2]); 
      t[k][3] = 32.5; 
    } 
    else if (ch == ATR_END) 
    { 
      t[k][0] = 9; 
      return (0); 
    } 
    else if (ch == ATR_POINT) 
    { 
      t[k][0] = 1; 
      fscanf (in, "%f %f", &t[k][1], &t[k][2]); 
    } 
    else if (ch == ATR_CIRC)  
    { 
      t[k][0] = 2; 
      fscanf (in, "%f %f %f", &t[k][1], &t[k][2], &t[k][3]); 
    } 
    else if (ch == ATR_OTREZ) 
    { 
      t[k][0] = 3; 
      fscanf (in, "%f %f %f %f", &t[k][1], &t[k][2], &t[k][3], &t[k][4]); 
    } 
    else if (ch == ATR_DUGA) 
    { 
      float xvert, x1, y1, x2, y2, rb, xb, yb; 
      char flag; 
      t[k][0] = 4; 

      fscanf (in, "%f %f %f", &t[k][1], &t[k][2], &t[k][3]); 
      fscanf (in, " %c", &ch); 
      if(ch == ATR_POINT) 
      { 
        fscanf (in, "%f %f", &t[k][4], &t[k][5]); 
      } 
      else if (ch == ATR_VERT) 
      { 
        fscanf(in,"%c %f",&flag,&xvert); 
        duga_otrez(t[k][1],t[k][2],t[k][3],xvert,flag,&t[k][4],&t[k][5]); 
      } 
      else if (ch == ATR_DUGA) 
      { 
        fscanf (in, "%c %f %f %f", &flag, &rb, &xb, &yb); 
        duga_duga (t[k][1], t[k][2], t[k][3], rb, xb, yb, flag, &t[k][4], &t[k][5]); 
      } 
      fscanf (in, " %c", &ch); 
      if (ch == ATR_POINT) 
      { 
        fscanf (in, "%f %f", &t[k][6], &t[k][7]); 
      } 
      else if (ch == ATR_VERT) 
      { 
        fscanf (in, "%c %f", &flag, &xvert); 
        duga_otrez (t[k][1], t[k][2], t[k][3], xvert, flag, &t[k][6], &t[k][7]); 
      } 
      else if (ch == ATR_DUGA) 
      { 
        fscanf (in, "%c %f %f %f", &flag, &rb, &xb, &yb); 
        duga_duga (t[k][1], t[k][2], t[k][3], rb, xb, yb, flag, &t[k][6], &t[k][7]); 
      } 
    } 
    else { puts ("������ �������� �����"); exit (1);} 
    FSKIP (in); 
  } 
} 
//----------------------------------------------------------------------------*/
//----------------------------------------------------------------------------*/
void
read_and_print_bukva (FILE *in1, char bukva) 
{ 
  float  p[NN][MM], tab[15][10]; 
  int    nn, mm;

  if (find_read (in1, bukva, tab) != 0 /* NULL */)  
  { 
    printf ("\n����� '%c' �� ������� !", bukva); 
    exit (0);
  } 
  
  work_bukva (tab, p, &bukva, &nn, &mm); 
  printf ("\n"); 
  disp_p (p,nn,mm); 
  printf ("\n"); 

  return;
}
//----------------------------------------------------------------------------*/
void
scan_test () 
{ 
  FILE  *in1; 
    
  if ((in1 = fopen ("b_scan.ab", "r")) == NULL) puts ("������ ��������"); 

  read_and_print_bukva (in1, 'A') ;
  read_and_print_bukva (in1, '�') ;
  //read_and_print_bukva (in1, 'E') ;

  fclose (in1); 
  return;  
} 
//----------------------------------------------------------------------------*/
//----------------------------------------------------------------------------*/
void
main_tests () 
{ 

  scan_test (); 

  pois_test (); 

  return;  
} 
//----------------------------------------------------------------------------*/
int
main (int argc, char** argv) 
{ 

  main_tests (); 

  return (1);  
} 
//----------------------------------------------------------------------------*/
