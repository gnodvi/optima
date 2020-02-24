; -*-   mode: lisp ; coding: koi8   -*- ----------------------------------------

;-------------------------------------------------------------------------------
; Diagnostic Severity
; There are four levels of compiler diagnostic severity: 
;    error 
;    warning 
;    style warning 
;    note 
#+SBCL (declaim (sb-ext:muffle-conditions sb-ext:compiler-note))
#+SBCL (declaim (sb-ext:muffle-conditions style-warning))

(setf *read-default-float-format* 'long-float) 
;===============================================================================
;
; ����E�� �����E�E�E��� �� ������ �����-���E���
;
;===============================================================================

#+CLISP (defvar *lisper_home_dir* (namestring (EXT:cd))) 

(defvar GLOBAL_DIRS_TABL '( ; ���� � ������ �������e���� ����E��� "."

;  ("a" . "./Others") 
;  ("m" . "./Others")
  ("a" . ".") 
  ("m" . ".")

;-------------------------------
  ("b" . ".")
  ("d" . ".") 
  ("g" . ".")
  ("l" . ".")
  ("n" . ".")
  ("o" . ".")
  ("p" . ".")
  ("s" . ".")
  ("t" . ".")
  ("v" . ".")

  ))

;-------------------------------------------------------------------------------
(defun prefix_find (dirs_tabl bukva)

 (cdr (assoc bukva dirs_tabl :test #'string=))

)
;-------------------------------------------------------------------------------
(defun prefix_find_global (global_dirs_tabl  bukva_from  bukva_to)

(let (
  (prefix NIL)
      
  (dir_from (prefix_find  global_dirs_tabl  bukva_from))
  (dir_to   (prefix_find  global_dirs_tabl  bukva_to  ))
  )

  (if (string= dir_from ".")  (setf prefix dir_to)

    ; � �e�e�� ������, ����� �� ����� OTHERS ������e�
    (if (string= dir_to ".") 
        (setf prefix "..")
        (setf prefix ".")
     )
    )

  prefix
))
;-------------------------------------------------------------------------------
(defun get_bukva (fname)

  (subseq fname 0 1)
)
;-------------------------------------------------------------------------------
(defun my_load (fname      ; ��� ����� ��� �������� 
                bukva_from ; �� ������ ���e�� �������e� 
                )

(let* (
  (bukva_to (get_bukva fname))  ; � ����� ���e�e ���� ��������;
  (prefix   (prefix_find_global ; �e��e� �������e����� ���� � �����, 
             GLOBAL_DIRS_TABL   ; ���������� ������� ���e���; 
             bukva_from bukva_to))

  (filename   (concatenate 'string prefix "/"   fname))  ; ������������ + ���

  (fname_base (subseq fname 0 6))  ; ���� �� ���ee ����� 
  (filename_T (concatenate 'string prefix "/T/" fname_base)) 
  ; ������������ + ��� (�e� ������e���)

  ret 
  )

  (load filename)
  (return-from my_load) ; ���� ������ ���e� �� �������e.. ���������:
  ;; �e ����e����e��� ����������� ���e�e��� !!

  ;;-------------------------------------------------------------------
;  (format t "fname= ~s  ~%" fname )
;  (format t "fname_base= ~s  ~%" fname_base )
;  (format t "filename_T= ~s  ~%" filename_T )

  ; ��e�� ���� �� �������� ������� � ���e������ ./T �� ��e��e� ������� ���
  ; ����������������� ��e ��������
  (setf ret (load filename_T :if-does-not-exist nil))
  ;; �� � e��� ���e����� e���, � �������� �� ��� ��e ���e�e�?? !!

  (when (eq ret NIL) ; e��� �e� �����������������, ��
    ;(format t "filename_T = NIL ~%")   
    ; ���������� �������
    ;(compile-file filename :verbose NIL :output-file filename_T :print NIL) 
    (compile-file filename :output-file filename_T ) 
    (load filename_T) ; �������� ��e ����������������
    )

))
;;;=============================================================================
;
; ����E�� ������ ������� � �E����
;
;;;=============================================================================
(defun funcall_mode (mode argus)


  (funcall (read-from-string mode) argus)

)
;-------------------------------------------------------------------------------
(defun run_cdr_argus (name argus err_message)

(cond 
   ((eq name NIL)  (error err_message))
   (t  (progn 
         (funcall_mode name (cdr argus))
       ))
   )  
)
;-------------------------------------------------------------------------------
(defun replace-all (string part replacement &key (test #'char=))

"Returns a new string in which all the occurences of the part 
is replaced with replacement."

(with-output-to-string (out)
                       (loop with part-length = (length part)
                         for old-pos = 0 then (+ pos part-length)
                         for pos = (search part string
                                           :start2 old-pos
                                           :test test)
                         do (write-string string out
                                          :start old-pos
                                          :end (or pos (length string)))
                         when pos do (write-string replacement out)
                         while pos)
)
) 
;-------------------------------------------------------------------------------
#+:CLISP 
(defun run_e_tests (dir_cmd dir_tst  n level_bukva)

(let* (
  ;(dir (concatenate 'string dir_cmd "/" dir_tst "/" "*.*"))
  (dir (concatenate 'string dir_cmd "/" dir_tst "/" "*"))

  (dir_tst_files (directory dir)) ; ���e��-�� � �������� ������e �������e���
  ;; :wild and :newest            ; ����� �������� , ���� �� �e�e�e���� ?

  T_FILE rr cmd bb size keypress TRUE_FILE 

  (dir_tmp       (concatenate 'string *lisper_home_dir* "/T"))
  ;
  (CALC_FILE     (concatenate 'string dir_tmp "/a_CALC"))
  (CALC_FILE_SED (concatenate 'string dir_tmp "/a_CALC_SED"))
  (TRUE_FILE_SED (concatenate 'string dir_tmp "/a_TRUE_SED"))
  (DIFF_FILE     (concatenate 'string dir_tmp "/a_DIFF"))
  )

  ;(format t "dir_tst_files= ~s ~%" dir_tst_files)

  (dolist (i  dir_tst_files)

    (setf T_FILE (file-namestring i)) ; string representing just the name, type, and version     
    (setf TRUE_FILE (namestring i)) ; returns the full form of the pathname as a string

    ;; ����� ������e, �������, ��� ����e�� - ��e��� ���� �����...
    (setf rr  (subseq T_FILE  2   ))  ; ��������������� ������e

    (if (< (length T_FILE) n) 
      (setf bb nil)  ; �������� �������� �e ����e���� ������� (������e� "0:ls")
      (setf bb  (subseq T_FILE  n (1+ n)))  ; ���e �����e��� (����)
      )
  
    (when (string= bb level_bukva)    ; ��e� ������ ������ �� ������ ������

      (format t "~a  ... " T_FILE) ; �������� ���������� ���-������� ()

      ;; � ��������� �e������ �������, ������� ��� ����������� ���������:
      (setf cmd (replace-all rr "^"  "/")) ; ������� (!) ��������� ����-������� ����������
      (setf cmd (replace-all rr ","  " ")) ; � ����� ����-������� ��������

      (setf cmd (concatenate 'string cmd " 2> /dev/null")) ; ���� � ���� !
      (EXT:run-shell-command cmd :output CALC_FILE)  ; � ������ ���� ����?
;     �.�. ���� ����� � ����� ������ ��� �� �������� ���������, �� � �� ��������?
;
;
;----------------------------------------------
;      (format t "cmd= ~a  ~%" cmd)
;      (EXT:run-shell-command cmd)
;----------------------------------------------

      ;; ������ ���� ������� ��������� ����� � ������� ������ {}
      (EXT:run-shell-command "sed -e 's/{[^ ]*}/{-----}/g'" 
                             :input CALC_FILE :output CALC_FILE_SED)

      (EXT:run-shell-command "sed -e 's/{[^ ]*}/{-----}/g'" 
                             :input TRUE_FILE :output TRUE_FILE_SED)

      ;; �e�e�� ���� �������� ��� �����
      (setf cmd (concatenate 'string "diff --ignore-all-space " CALC_FILE_SED " " 

;                             TRUE_FILE_SED " 1>  2>&1 " DIFF_FILE ))
                             TRUE_FILE_SED " 1> " DIFF_FILE " 2>&1 " ))
;                      TRUE_FILE_SED " &> " DIFF_FILE)) ;- ������-�� �� �������� � ������

      (EXT:run-shell-command  cmd)

      ;; ��e�� ����� �������e�� ����e� ����� �����e��� 
      (setf size (FILE-STAT-size (POSIX:file-stat DIFF_FILE)))

      (if (= size 0) (format t "PASSED ~%")
      (progn ; ���������� ������� ��������� ���������� ������������

        (format t "~%") 
        (format t "------------------------------------------------------DIFF-----------~%")
        (EXT:run-shell-command  (concatenate 'string "more " DIFF_FILE))
        (format t "---------------------------------------------------------------------~%")
        (format t "~%")
        (format t "FAILED: do you wish to overwrite (y or n) ? ")

        (setf keypress (read))
        ;(format t "keypress= ~a ~%" keypress)

        (if (eql keypress 'Y) 
            (progn
              ;; ��������� ����� ����� ��� �������� !
              (setf cmd (concatenate 'string "cp " CALC_FILE " " TRUE_FILE))

              (EXT:run-shell-command  cmd)
              (format t "YES   : overwrite CALC -> TRUE !! ~%")
            )
            (progn
              (format t "NOT   : continue with this CALC ! ~%")
            )
        )
      ))
      
    ) ; when
  ) ; dolist

))
;-------------------------------------------------------------------------------
(defun run_tests (level_bukva dir_tst dir_cmd)
(let (
  (n  0) ; ������ �e���� �� �������� �������
  )

  (run_e_tests  dir_cmd dir_tst  n level_bukva)

))
;#-------------------------------------------------------------------------------
; ����������e �e������ ������
;#-------------------------------------------------------------------------------
#+:CLISP
(defun tst (LL OUT DIR_CMD CMD)

(let* (
  (CMD_TRUE (replace-all CMD "^"  "/")) ;; ���e� �������� ??!
  (T_FILE   (replace-all CMD " "  ","))

 ; (N_FILE   (concatenate 'string LL ":" T_FILE))
  (N_FILE   (concatenate 'string LL "-" T_FILE))

  (OUTS     (concatenate 'string OUT "/" N_FILE))
  (FULL_CMD (concatenate 'string 
                         CMD_TRUE " > " OUTS " 2> /dev/null"))
  )

  (format t "~s ... ~%" FULL_CMD)

  (EXT:cd DIR_CMD) 
  (EXT:run-shell-command  FULL_CMD)
))
;-------------------------------------------------------------------------------
(defun get_argus ()

#+:CLISP  (values EXT:*ARGS*)
;#+SBCL    (argus (cddr *posix-argv*)) ;linux
#+SBCL    (cdr *posix-argv*) ; cygwin

)
;-------------------------------------------------------------------------------
(defun READ_AND_CALL_ARGUS (level_bukva)

;(format *error-output* "*posix-argv*= ~s ~%" *posix-argv*)

(let* ( 
      
;#+:CLISP  (argus_  EXT:*ARGS*)
;#+SBCL    (argus_ (cddr *posix-argv*))
(argus_  (get_argus))

;(mode  (nth 0 argus_)) ; ��� ���������������� ��������
;(argus (cdr argus_))   ; ��������� ����� ������ (��� ������ �������)
mode  ; ��� ���������������� ��������
argus ; ��������� ����� ������ (��� ������ �������)
)
; -------------------------------------

;(format t "argus_= ~s  ~%" argus_)
;(format t "argus= ~s num_argus= ~s ~%" argus num_argus)
;(format t "car argus= ~s ~%" (car argus))
;(quit)

;(format t "Argus_= ~A ~%" argus_)
;(format *error-output* "ARGUS= ~s ~%" argus_)
(setf mode  (nth 0 argus_))
(setf argus (cdr argus_))  
;(format *error-output* "ARGUS= ~s ~%" argus)

;(format t "argus_= ~s  ~%" argus_)
;(format t "mode  = ~s  ~%" mode)
;(format t "argus = ~s  ~%" argus)
;(quit)

(format t "~%")

(cond 

   ((eq mode NIL)  (progn 
       #+:CLISP (run_e_tests  "." "./E/OUT"  5 level_bukva)
       #-:CLISP (format t "NOT CLISP - NOT WORKS !")
       ))

   (t  (progn 
       (funcall_mode mode argus)
       ))

)) 

)
;-------------------------------------------------------------------------------
;(defun READ_ARGUS_AND_CALL_ (main_proc)

;(let* ( 
;#+:CLISP  (argus_  EXT:*ARGS*)
;#+SBCL    (argus_ (cddr *posix-argv*))
;)


;(funcall  main_proc (list-length argus_) argus_)

;))
;;;=============================================================================
;
;
;
;;;=============================================================================

(defconstant  G_MAXDOUBLE  99999999999)
(defconstant -G_MAXDOUBLE -99999999999)

(defvar MAXVAL  G_MAXDOUBLE)
(defvar MINVAL -G_MAXDOUBLE)

(defvar  YMAXSPACE  G_MAXDOUBLE)
(defvar  YMINSPACE -G_MAXDOUBLE)

;(defconstant  G_PI 3.14)
(defconstant  G_PI 3.1415926535897932384626433832795028841971693993751) ; Glib

(defvar EPS   0.000001) ; The name of the lambda variable EPS is already in use to name a constant.

(defconstant FI_MAX   20)
(defconstant TI_MAX 2000)

(defvar TRUE  t)
(defvar FALSE NIL) ;; ?? ���e�� �e ��������� � Out ??

(defvar NUL  NIL)
;(defvar NULL  NIL)
;  Lock on package COMMON-LISP violated when globally declaring NULL special.
;See also:
;  The SBCL Manual, Node "Package Locks"
;  The ANSI Standard, Section 11.1.2.1.2

;(defmacro STDERR () 't)
(defmacro STD_ERR () 't)

;;;=============================================================================
;
;
;-------------------------------------------------------------------------------

; ������������ �� ������� ����������� ��-�������e�� ?
(defvar is_libc t) 
;(defvar is_libc NIL) 

; �� ��������� ���e� ��e���� ���������� ������������ ���������
; � ������ e��� �� ����e� �e� LIBC (������e� � ������� ?) ����� �����������

(defconstant LIBC_SO "libc.so.6") 

;(defconstant LIBC_SO "/bin/cygwin1.dll") 
;(defconstant LIBC_SO "e:\\W\\ROOT\\bin\\cygwin1.dll") 


#+SBCL  (defvar rand_SUF "_sbcl") 
#+CLISP (defvar rand_SUF "clisp") 

;-------------------------------------------------------------------------------
(when is_libc ;(progn 
;-------------------------------------------------------------------------------

#+SBCL (load-shared-object LIBC_SO)

#+CLISP
(FFI:default-foreign-language :stdc)
;----------------------------------------

#+CLISP
(FFI:DEF-CALL-OUT   clisp_libc_random
                    (:library LIBC_SO)
                    (:name "random")                     
                    (:return-type FFI:int)
                    )

;#+SBCL (alien-funcall (extern-alien "drand48" (function double)) )
#+CLISP
(FFI:DEF-CALL-OUT   clisp_libc_drand48
                    (:library LIBC_SO)
;                    (:name "drand48") 
                    (:name "drand48") 
;                    (:return-type FFI:long) ; single-float  double-float
                    (:return-type FFI:double-float) ; single-float  double-float
;                    (:return-type FFI:single-float) ; single-float  double-float
                    )

;#+SBCL (alien-funcall (extern-alien "srand48" (function void int)) seed)
#+CLISP
(FFI:DEF-CALL-OUT   clisp_libc_srand48
                    (:library LIBC_SO)
                    (:name "srand48") 
                    (:return-type NIL)
                    (:arguments   
                     (seed  FFI:uint) 
                     )
                    )



;#+SBCL (alien-funcall (extern-alien "srandom" (function void unsigned-int)) seed)
#+CLISP
(FFI:DEF-CALL-OUT   clisp_libc_srandom
                    (:library LIBC_SO)
                    (:name "srandom")                     
                    (:return-type NIL)
                    (:arguments   
                     (seed  FFI:uint) 
                     )
                    )

#+CLISP
(FFI:DEF-CALL-OUT   clisp_libc_time
                    (:library LIBC_SO)
                    (:name "time")                     
                    (:return-type FFI:uint)
                    (:arguments   
                     (val  FFI:uint) 
                     )
                    )

;-------------------------------------------------------------------------------
#+CLISP
(FFI:DEF-CALL-OUT   clisp_libc_system
                    (:library LIBC_SO)
                    (:name "system")                     
                    (:return-type FFI:int)
                    (:arguments   
                     (val  FFI:c-string) 
                     )
                    )
;------------------------------------------
;       #include <stdlib.h>

;       int system(const char *string);

;DESCRIPTION
;       system()  executes a command specified in string by calling /bin/sh -c
;       string, and returns after the command has been completed.  During exe-
;       cution of the command, SIGCHLD will be blocked, and SIGINT and SIGQUIT
;       will be ignored.
;------------------------------------------


;-------------------------------------------------------------------------------
#+CLISP
(FFI:DEF-CALL-OUT   clisp_libc_printf
                    (:library LIBC_SO)
                    (:name "printf")                     
                    (:return-type FFI:int)
                    (:arguments   
                     (val  FFI:c-string) 
                     )
                    )

;-------------------------------------------------------------------------------
);) ; is_libc
;-------------------------------------------------------------------------------

;NAME
;       printf,  fprintf,  sprintf,  snprintf,  vprintf,  vfprintf,  vsprintf,
;       vsnprintf - formatted output conversion

;SYNOPSIS
;       #include <stdio.h>

;       int printf(const char *format, ...);
;-------------------------------------------------------------------------------
(defun Y-system (str)

;(when is_libc 

#+SBCL  (alien-funcall (extern-alien "system" (function int c-string)) str)
#+CLISP (clisp_libc_system str)
;)

)
;-------------------------------------------------------------------------------
(defun Y-printf (str)

;#+SBCL (alien-funcall (extern-alien "system" (function int c-string)) str)

;#+CLISP (clisp_libc_system str)
#+CLISP (clisp_libc_printf str)

)
;-------------------------------------------------------------------------------
(defun Y-time (val)

#+SBCL (alien-funcall (extern-alien "time" (function int int)) val)

;#+CLISP (declare (ignore val))
#+CLISP (clisp_libc_time val)

)
;;;=============================================================================
;
; RANDOM    RANDOM    RANDOM    RANDOM    RANDOM    RANDOM    RANDOM    RANDOM    
;
;;;=============================================================================

(defvar *random_state_save* (make-random-state t)) 

(defconstant MAXRANDOM 1000000000)

;-------------------------------------------------------------------------------
; ����� ���������e �������
;-------------------------------------------------------------------------------
(defun srandom_save_or_read (seed)

; ����e���� - e��� ����� ����-���� ��e e���, �� ��������� e��
;             � ����e - ����� ������� ����� � �������� e�� � ����
; 
(let* (
  ;(fname "random-state.txt")
  ;(fname (concatenate 'string "R/a-rand." (format nil "~s" seed)))
  (fname (concatenate 'string "T/a-rand." (format nil "~s" seed) rand_SUF))
  )

  (with-open-file (finput fname 
                          :direction         :input      
                          :if-does-not-exist nil)

    (when (eq finput NIL) ; ����� �e�, ���� e�� ��������
      ;(format t "FILE NOT EXIST !!!~%")  
      (with-open-file (foutput fname 
                               :direction :output)
        (print *random_state_save* foutput)
      )
    )
  )

  ; �e�e�� ���� ����� e���, �� ������ �������e� e��
  (with-open-file (finput fname 
                          :direction         :input)
    (setf *random_state_save* (read finput))
    )

  ; � ��������� �����e� �������� ��� �������������
  (make-random-state *random_state_save*)
))
;===============================================================================
;
; ����e���-��������e ������� �� ��������� ������
;
;-------------------------------------------------------------------------------
(defun Y-srandom (seed)

;#+SBCL (alien-funcall (extern-alien "srandom" (function void unsigned-int)) seed)
;#+CLISP (declare (ignore seed))


(if is_libc 

#+SBCL  (alien-funcall (extern-alien "srandom" (function void unsigned-int)) seed)
#+CLISP (clisp_libc_srandom seed)

;    (declare (ignore seed))
;Misplaced declaration: (DECLARE (IGNORE SEED))
    )

)
;-------------------------------------------------------------------------------
;#+SBCL
;(defun srandom_set (seed)

;  (if (< seed 0) (Y-srandom (Y-time 0)) ; // ���������� �����������������
;                 (Y-srandom seed)       ; // ������������� 
;                 )
;)
;-------------------------------------------------------------------------------
;#+CLISP
(defun srandom_set (seed)

;#+SBCL
;  (if (< seed 0) (Y-srandom (Y-time 0)) ; // ���������� �����������������
;                 (Y-srandom seed)       ; // ������������� 
;                 )

;#+CLISP
;  (if (< seed 0) (setf *random-state* (make-random-state t)) 
;                 (setf *random-state* (srandom_save_or_read seed))      
;                 )


(if is_libc 

  (if (< seed 0) (Y-srandom (Y-time 0)) ; // ���������� �����������������
                 (Y-srandom seed)       ; // ������������� 
                 )

  (if (< seed 0) (setf *random-state* (make-random-state t)) 
                 (setf *random-state* (srandom_save_or_read seed))      
                 )
    )

)
;-------------------------------------------------------------------------------
(defun Y-random ()

;#+SBCL (alien-funcall (extern-alien "random" (function int)) )
;;#+CLISP (random MAXRANDOM )
;#+CLISP (if is_libc (clisp_libc_random)
;                   (random MAXRANDOM)
;                   )

(if is_libc 

#+SBCL  (alien-funcall (extern-alien "random" (function int)) )
#+CLISP (clisp_libc_random)

    (random MAXRANDOM)
    )

)
;-------------------------------------------------------------------------------
(defun Y-drand48 ()

;#+SBCL (alien-funcall (extern-alien "drand48" (function double)) )
;#+CLISP (/ (random MAXRANDOM) (* 1.0 MAXRANDOM))

(if is_libc 

#+SBCL  (alien-funcall (extern-alien "drand48" (function double)) )
#+CLISP (clisp_libc_drand48)

     (/ (random MAXRANDOM) (* 1.0 MAXRANDOM))
    )

)
;-------------------------------------------------------------------------------
(defun Y-srand48 (seed)

#+SBCL  (alien-funcall (extern-alien "srand48" (function void int)) seed)
;#+CLISP (declare (ignore seed))
#+CLISP (clisp_libc_srand48 seed)

)
;-------------------------------------------------------------------------------

; � CYGWIN �� ���������� ���� �� ������������ ���� ���:
(Y-srand48 2010)

;-------------------------------------------------------------------------------
(defun YRAND_F ()

;#+SBCL (Y-srand48 (Y-time 0))
;#+CLISP (setf *random-state* (make-random-state t)) 

(if is_libc 

    (Y-srand48 (Y-time 0))
    (setf *random-state* (make-random-state t)) 
    )
)
;-------------------------------------------------------------------------------
(defun my_sqrt (x)

#+SBCL  (alien-funcall (extern-alien "sqrt" (function double double)) x)
#+CLISP (sqrt x) ; �����e �� ���� � ������ �e�e� �� libc.. ?

)
;===============================================================================
;
; �e ����e���e (����������e �������-�������)
;
;-------------------------------------------------------------------------------
(defun YRAND (imin imax)

  (+ imin (mod (Y-random) (- imax imin -1)))

)
;-------------------------------------------------------------------------------
(defun YRandF (fmin fmax)

(let (
  (choise (Y-drand48))
  )

  (+ fmin (* choise (- fmax fmin)))
))
;-------------------------------------------------------------------------------
(defun YRAND_S ()

  (srandom_set -1)
)
;-------------------------------------------------------------------------------
(defun YRAND_C ()

  (srandom_set 2010)
)
;-------------------------------------------------------------------------------
(defun Rand123 (p1 p2 p3)

(declare (ignore p2))

(let (
  (y_rand (YRAND 1 100))
  )

  ;(format t "Rand123: ~s ~%" y_rand)

  (cond 
   ((< y_rand p1)  1)
   ((> y_rand p3)  3)
   (t              2)
   )

))
;-------------------------------------------------------------------------------
;BOOL
(defun RandYes (
       procent ; double procent
       )

  (if (= (Rand123 procent 0.0 (- 100.0 procent)) 1) 
      TRUE
      FALSE
      )
)
;-------------------------------------------------------------------------------
; ���������� ������-��������� ����� � ��������� ������
; � ���������       0.0 <= number < n
;
; 0.0 - ������� ��� ���? !
;-------------------------------------------------------------------------------
(defun random-floating-point-number (n)

  (YRandF 0 n)
)
;-------------------------------------------------------------------------------
; ���������� ������-��������� ������ � ��������� 0 ---> n-1
;-------------------------------------------------------------------------------
(defun random-integer (n)

(let (
  )

  (YRAND 0 (- n 1))
))
;-------------------------------------------------------------------------------
(defun seed_set (seed)

  (if (= 0 seed) 
      t ;(format t "SEEEED ~%") ;; ��� ������, ��� ���������� �� ���� ������

      ;(srandom_set seed)
      (srandom_set (round (* 2010 seed)))
   ) 

)
;-------------------------------------------------------------------------------
(defun seed_set_random ()
  
  (YRAND_S)
)
;===============================================================================
;
;-------------------------------------------------------------------------------
(defun rand_0 ()

  (dotimes (i 10)
    (format t "YRAND(1 4)= ~s ~%" (YRAND 1 4))
    )

)
;-------------------------------------------------------------------------------
(defun rand_1 (argus)  (declare (ignore argus))

(let (
  (seed  2009)
  )

(format t "~%")

(srandom_set seed)
(rand_0)  ; ����� �e���e�� �e��� 

(format t "~%")

(srandom_set seed)
(rand_0)  ; ����� �e���e�� �e��� 

(format t "~%")

))
;-------------------------------------------------------------------------------
(defun rand_2 (argus) (declare (ignore argus))

(let (
  (vmin -10.0) 
  (vmax   7.0)
  )

  (format t "time(0)= ~s  ~%" (Y-time 0))
  (format t "time(0)= ~s  ~%" (Y-time 0))
  (format t "~%")

  (YRAND_F)
  (format t "v= ~s  ~%" (YRandF vmin vmax))

  (YRAND_F)
  (format t "v= ~s  ~%" (YRandF vmin vmax))

))
;-------------------------------------------------------------------------------
(defun rand_3 (argus)  (declare (ignore argus))

  ;(setf *random-state* (make-random-state t))
  ;(setf *random-state* (make-random-state nil))
  
  (YRAND_S)
  ;(YRAND_C)
  ;(YRAND_F)

  (dotimes (i 20)
  
    (format t "  ~A  ~12S   ~A  ~%" 
            (YRAND 1  4)  ;(gal_irand 4) 
            (Y-drand48)   ;(gal_frand) 
            (YRAND 0 1)   ;(gal_brand) 
            ) 
    ) 

  (format t "~%")
)
;-------------------------------------------------------------------------------
(defun rand_4 (argus) (declare (ignore argus))

;#+SBCL (load-shared-object "libc.so.6")

  (format t "~%")
  (dotimes (i 10)
    (format t "Y-random= ~s ~%" (Y-random))
    )

  (format t "~%")
  (rand_0)

  (format t "~%")
  (dotimes (i 10)
    (format t "Y-drand48= ~s ~%" (Y-drand48))
    )

  (format t "~%")
  (dotimes (i 10)
    (format t "YRandF(1, 4)= ~s ~%" (YRandF 1 4))
    )

  (format t "~%")
)
;-------------------------------------------------------------------------------
(defun rand_5 (argus)  (declare (ignore argus))

(let (
  ;(seed  2009)
  )

  (format t "~%")

;(YRAND_C)
;(srandom_set seed)
;(rand_test_0)

  (srandom_set 2010)
  (format t "srandom_set 2010 ~%~%")

  (dotimes (i 10)
    (format t "YRAND(-7 +7)= ~s ~%" (YRAND -7 +7))
    )

  (format t "~%")
))
;===============================================================================

;-------------------------------------------------------------------------------
(defun rand_6 (argus) (declare (ignore argus))

  (setf is_libc NIL) ; ��������e� ����� ���������e ���������e ����. �������

  (srandom_set 201)

  (format t "~%")

  (dotimes (i 10)
    (format t "Y-random= ~s ~%" (Y-random))
    )

  (format t "~%")
)
;===============================================================================
;
;
;
;
;===============================================================================

(defvar *fmin* -5.0)
(defvar *fmax* +5.0)
;
;-------------------------------------------------------------------------------
(defun pick-k-random-individual-indices (k max)

(let (
  (numbers nil)
  )

  (loop 
    for n = (random-integer max)

    unless (member n numbers :test #'eql)
    do (push n numbers)

    until (= (length numbers) k)
    )

  numbers
))
;-------------------------------------------------------------------------------
; ��������� ����� ��������� �� ������������� ������;
; ���� ��������� �������� - ������ ��������� ��������, �� ��� ��� ��������������:
;
; ���� :Floating-Point-Random-Constant ��
;   ��������� ������������ ��������� �������� ��������� ��������� [-5.0 , 5.0]
;
; ���� :Integer-Random-Constant ��
;   ��������� ����� ��������� ��������� � ��������� [-10 , +10]
;-------------------------------------------------------------------------------
(defun choose-from-terminal-set (terminal-set)

(let* ( ; ��������� ����������
  (choice_int (random-integer (length terminal-set)))
  (choice     (nth choice_int terminal-set))

  ;(choice (nth (random-integer (length terminal-set)) terminal-set))
  )

  (case choice

    (:floating-point-random-constant
     ;; ������� �������� ����� "�������", �� ���� ��� ������������� �����
     ;; ���������� ������ ��������� �����, ����� "coerce";
     ;; ����� ����� ����� �������� ��������, ���� ����� �� [-5.0 , +5.0]
     ;(coerce (- (random-floating-point-number 10.0) 5.0)
     (coerce (- (random-floating-point-number (- *fmax* *fmin*)) (- 0.0 *fmin*))
             'single-float))

    (:integer-random-constant 
     (- (random-integer 21) 10)) ; �������� �������� [-10 , +10]

    (otherwise choice)) ; ������ ������ ���������� ��������� ��������
  
))
;-------------------------------------------------------------------------------
(defun int_from_bin (genotype bit_num)

(let (
  bit pos val
  (value 0)
  ) 
  
  (dotimes (i bit_num)
    (setf bit (nth i genotype))

    (when (= bit 1)
        (setf pos (- bit_num i 1))
        (setf val (expt 2 pos))
        (setf value (+ value val))
    )
  )

  value
))	                                                             
;===============================================================================
;
;
;
;
;;;=============================================================================

(defvar *test_var* :unbound)

(defvar *debug_print*  nil)

(pushnew :CCL *features*) ; ������� ���� ���� ����� ������� ���� (� �� :CLISP)

;;;=============================================================================
;-------------------------------------------------------------------------------
(defun my-command-line ()

  (or 

   #+SBCL *posix-argv*  
   #+LISPWORKS system:*line-arguments-list*
   #+CMU extensions:*command-line-words*
   nil)
)
;-------------------------------------------------------------------------------
;(defun main (&optional (n (parse-integer
;                           (or (car (last #+sbcl sb-ext:*posix-argv*
;                                          #+cmu  extensions:*command-line-strings*
;                                          #+gcl  si::*command-args*))
;                               "1"))))

;-------------------------------------------------------------------------------

;;;=============================================================================

(defstruct MF
    dim 
    ijk_cur
    IJK
    first index
)

;;;-----------------------------------------------------------------------------
(defun ijk_array_set (ijk value)

  (dotimes (index (length ijk))

    (setf (aref ijk index) value)
  )

)
;;;-----------------------------------------------------------------------------
(defun ijk_array_print (name ijk)

  (format t "~A  " name)

  (dotimes (index (length ijk))

    (format t "~A " (aref ijk index))
  )

  (format t "~%")
)
;-------------------------------------------------------------------------------
;;;-----------------------------------------------------------------------------
(defun MFOR_init (mf)

  (setf (MF-first   mf)     T)
  (setf (MF-index   mf)     -1) ; ����� ������ ��� ����

  (ijk_array_set (MF-ijk_cur mf) 0)

)
;;;-----------------------------------------------------------------------------
(defun MFOR_create (dim ijk_cur IJK)
(let* (
  mf
  )

  ;; �������� ����� ����������
  (setf mf (make-MF))

  ;; ������� � ��� ������� �������
  (setf (MF-dim     mf)     dim)
  (setf (MF-ijk_cur mf) ijk_cur)
  (setf (MF-IJK     mf)     IJK)

  ;(MFOR_init mf)

  mf
))
;;;-----------------------------------------------------------------------------
(defun MFOR_r (cur ijk_cur IJK)

  ;; ������ ����������� �������� �������� �������
  (setf (aref ijk_cur cur) (+ (aref ijk_cur cur) 1))

  
  (if (not (= (aref ijk_cur cur) (aref IJK cur))) 
      T ; ������ ������, ���� ��� ��� �������
    (progn  
    ;; ����� �� ���������, ������ ���� � ����. ������� ����������

        
    (if (= cur 0) ; ������, ���� ��� ��� ��������� (�����) ������,
        NIL       ; �� �����
      (progn 
      
      (setf (aref ijk_cur cur) 0) ; �������� ������� ������

      ;; � �������� ������� ������ �����
      ;; � ��� �� ��� ���� � ������� ����������?  �� �� �� ������������ ������ ���
      (MFOR_r  (- cur 1)  ijk_cur IJK)
      )
    )
  ))

)
;;;-----------------------------------------------------------------------------
(defun MFOR_todo (mf)

  (incf (MF-index mf)) ; ������ ����������� ���������� ������ ������ 

  (if (MF-first mf) ; ����� ������ ���� � �������� ���������� ����� ��������:
      (progn 

      (setf (MF-first mf) NIL)
      T ; ������ ������ �� ����� ������ 
      )

    ;; �����
    ;; ����������� ������� ������ ������ � ��� ������������� ���������� �����
    (MFOR_r  (- (MF-dim mf) 1)  (MF-ijk_cur mf) (MF-IJK mf))
  )
)
;
;-------------------------------------------------------------------------------
(defun format_line75 ()

  (format t "---------------------------------------------------------------------------~%")

)
;-------------------------------------------------------------------------------
(defun format_bord75 ()

  (format t "===========================================================================~%")

)
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
;BOOL
(defun FRavno (d1 d2 eps)
 
  (if (< (abs (- d1 d2)) eps)   
      t
    NIL
    )
)
;;;=============================================================================
;
;;;-----------------------------------------------------------------------------
(defun test4_ (argus)  (declare (ignore argus))

(let* (
  (dim     3)
  (ijk_cur (make-array dim))
  (IJK     (make-array dim))
  mf 
  )

  (ijk_array_set IJK     2) ; ������� ���������� '(nil t) 
  (setf mf (MFOR_create  dim ijk_cur IJK))
  (MFOR_init mf)

  (format t "~%")

  (loop while (MFOR_todo mf) do (progn

    (format t " ~2D)    " (MF-index mf))
    (dotimes (i (length ijk_cur))
      (format t "~4S  " (nth (aref ijk_cur i) '(nil t)))
    )
    (format t "~%")
  )) 

  (format t "~%")
))
;;;-----------------------------------------------------------------------------
(defun test5 (argus)  (declare (ignore argus))

(let* (
  (dim     3)
  (ijk_cur (make-array dim))
  (IJK     (make-array dim))
  mf
  )

  (ijk_array_set IJK     2)
  (setf mf (MFOR_create  dim ijk_cur IJK))
  (MFOR_init mf)

  (format t "~%")
  (ijk_array_print "ijk=" ijk_cur)
  (ijk_array_print "IJK=" (MF-IJK  mf))
  (format t "~%")

  (loop while (MFOR_todo mf) do (progn

    (ijk_array_print "ijk_cur=" (MF-ijk_cur  mf))

  )) 

  (format t "~%")
))
;-------------------------------------------------------------------------------
(defun test22 (argus)  (declare (ignore argus))

  (setf *test_var* 100)

  (if (eq *test_var* :unbound) (setf *test_var* 10))

  (format t "test_var = ~A ~%"  *test_var*)

  (format t "~%")
)
;-------------------------------------------------------------------------------
(defun test2 (argus)  (declare (ignore argus))

(let (l1)

  (setf l1 '(((AND AND OR NOT) (2 3 2 1) (D2 D1 D0))) )

  (format t "l1 = ~A ~%"  l1)
  (format t "(first l1) = ~A ~%"  (first l1))
  (format t "(last  l1) = ~A ~%"  (last  l1))
  (format t "(list-length  l1) = ~A ~%"  (list-length  l1))

  (format t "~%")
))
;;;=============================================================================

;-------------------------------------------------------------------------------
(defun test4 (argus)  (declare (ignore argus))

(let (
   index
   a0 a1 a2
   )
  (declare (ignore a0 a1 a2))

  (setf index 0)
  (format t "~%")

  (dolist (a2 '(nil t))
  (dolist (a1 '(nil t))
  (dolist (a0 '(nil t))

    (format t " ~D)    ~4S  ~4S  ~4S  ~%"
                index   a2   a1   a0
                )

    (incf index)
    )))

  (format t "~%")
))
;===============================================================================
;
;-------------------------------------------------------------------------------
(defun list_test (argus)  (declare (ignore argus))

(let (
   (ll  '(0 1 2 3 4))
   )

  (format t "list_test ~%")

  (format t "ll= ~A ~%" ll)
  (format t "l2= ~A ~%" (nthcdr 2 ll))
  (format t "l2= ~A ~%" (last ll 3))

  (format t "~%")
))
;-------------------------------------------------------------------------------
;// ���� ����� ���������� : "name", �������������, ��� ��� ����� "name=val" � 
;// ���������� ��������� �� "val"
;-------------------------------------------------------------------------------
;char*
;parse_read (char *name, int argc, char *argv[], int  j)
;{
;-------------------------------------------------------------------------------
(defun parse_read (name argus j)  (declare (ignore j))

(let (
  ;  char *ptr;
  (len (length name)) ;  int   len, i;
  p
  )

  ;(format t "parse_read: argus= ~s   name= ~s   len= ~s   ~%" argus name len)

  (dolist (ptr argus)

    ;(format t "ptr= ~s  ~%" ptr)

    ;(setf p (find '= ptr))
    (setf p (subseq ptr 0 len))
    ;(format t "p  = ~s  ~%" p)


    (when (string= name p)
      ;(format t "string= ~s ~%" (subseq ptr (+ len 1)))
      (return-from parse_read (subseq ptr (+ len 1)))
      )
    
;    if (strncmp (ptr, name, len) == 0)
;      return (ptr+len+1);    
    )

  NIL ;  return (NULL);
))
;-------------------------------------------------------------------------------
(defun d_print (num)

  (format *error-output*  "D....~s.... ~%" num)

)
;-------------------------------------------------------------------------------
;===============================================================================

