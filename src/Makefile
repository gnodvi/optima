# =============================================================================#
#
# =============================================================================#

B  = .

$(B)/T/b_scan.o : $(B)/b_scan.cc                                   
	gcc -fPIC -x c -o $@ -c $< 

#scan : T/t_scan.o                                   
#	gcc -o $@ $< -lm

$(B)/T/b_scan.so: $(B)/T/b_scan.o
	gcc -shared -o $@ $< -lm

#-------------------------------------------------------------------------------
G  = .

#G_FIND_B = $(G)/d~test
G_FIND_C = $(G)/g_find.cc
G_FIND_O = $(G)/T/g_find.o

$(G_FIND_O): $(G_FIND_C) 
	$(CC) $(FLAGS) -fpic  -x c -o $@ -c $^  

#$(G_FIND_B): $(G_FIND_O) 
#	$(CC) $(FLAGS) -o $@ $^ -lm  

$(G)/T/g_find.so: $(G_FIND_O) 
	gcc $(FLAGS) -shared -fpic  -o $@ $^

#-------------------------------------------------------------------------------
V  = .

V_RSB3_C = $(V)/v_rsb3.cc
V_RSB3_N = $(A_COMM_H) $(V_RSB__H)
V_RSB3_O = $(V)/T/v_rsb3.o
V_RSB3_SO = $(V)/T/v-rsb-.so

#-------------------------------------------------------------------------------

# =============================================================================#

#CC      = gcc -O2
#CC_OPTS = -D_UNIX -DTIME_WITH_SYS_TIME 
#T/x-pipe.so: x-pipe.cc
#	$(CC) $(CC_OPTS) -x c -o $@ -shared  -fPIC $<

# =============================================================================#
##---------------------------------------------------------------

PROG = $(B)/T/ltk.fas $(B)/T/b_scan.so $(G)/T/g_find.so $(V_RSB3_SO) #T/x-pipe.so #$(V_RSB3_O)  $(V_RSB2_O) #T/a-pops.fas

all:  $(PROG)

#---------------------------------------------------------------

$(B)/T/ltk.fas: $(B)/b-ltk+.cl
	clisp -c $< -o $@ --quiet 

#---------------------------------------------------------------

T/b-comp.fas: b-comp.cl
	clisp -c $< -o $@ --quiet 

T/l-pops.fas: l-pops.cl
	clisp -c $< -o $@ --quiet 

# как скомпилировать для SBCL ?
T/a-pops.fasl: a-pops.cl
	sbcl --eval "(progn (setf *read-default-float-format* 'long-float) (compile-file \"a-pops.cl\") (quit))"
#	sbcl --eval "(progn (load \"a-comm.cl\") (compile-file \"a-pops.cl\") (quit))"
#	sbcl --eval "(progn (compile-file \"a-pops.cl\") (quit))" ;; 0.1f0
	mv --target-directory=T *.fasl

#---------------------------------------------------------------

# The PIC command line flag tells GCC to produce code that does not contain
# references to specific memory locations for functions and variables, since
# it is not yet possible to know where the message code
# will be linked into the memory address space of any application that
# uses it.

#$(MYGSL_SO) : T/m-gs-l.o
#       gcc -shared -fpic -o $@ $^

#T/m-gs-l.o : m-gs-l.cc
#       $(CC) -x c -o $@ -c  $< $(GSL_INC)

# при расширeнии файла *.cc нeобходим флажок компилятору:
# "-x language"
#     Specify explicitly the language for the following input files

# =============================================================================#

$(V_RSB3_O): $(V_RSB3_C) $(V_RSB__H)
	$(CC) $(FLAGS) -x c -fpic -o $@ -c $(V_RSB3_C)

$(V_RSB3_SO): $(V_RSB3_O) 
	gcc $(FLAGS) -shared -fpic  -o $@ $^

# =============================================================================#

tcl_f8: $(PROG)
#	cl a~.cl 

#---------------------------------------------------------------
clean:
	rm -f $(PROG) *.o T/*.o T/*.lib T/*.fas T/*.fasl T/*.so  

# =============================================================================#

SLIST = *.lisp *.cl *.li *.dem *.sh *.tx *.tcl B E Makefile*  *.c *.cc *.ab Others
#Others/T - как исключить?

ARX_NAME = optimalist
save :  
	tar --ignore-failed-read -cvf $(ARX_NAME).tar $(SLIST)
	gzip -6 $(ARX_NAME).tar  
	(cd ../../A/lisper; mdat) 

#===============================================================================

