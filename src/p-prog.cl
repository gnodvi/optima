
;; Muffle compiler-notes globally
#+SBCL (declaim (sb-ext:muffle-conditions warning style-warning sb-ext:compiler-note))

;;;=============================================================================

;;;=============================================================================

;; ���� ��������� � ������� � ������ ��������� ����� ������������
;; ��������� � �����-������ (any - �����?) ����� ������ (including terminals - 2�����)
(defvar *crossover-at-any-point-fraction*             :unbound)

;; ���� ��������� � ������� � ������ ��������� ����� ������������
;; ��������� � �������������� (����������) ����� ������
(defvar *crossover-at-function-point-fraction*        :unbound)

;; ������������ ������� ��� ������ ���������� ���������� ���������
(defvar *max-depth-for-new-individuals*               :unbound)

;; ������������ ������� ����� ������ ��������� �����������
(defvar *max-depth-for-individuals-after-crossover*   :unbound)

;; ������������ ������� ����� ����������� ���������� ��������
(defvar *max-depth-for-new-subtrees-in-mutants*       :unbound)

;;---------------------------------------------------------

(defvar *eval_prog*   :unbound)

(defvar *minimum-depth-of-trees* :unbound)
(defvar *full-cycle-p*           :unbound)

;; ����� ������-������
(defvar *number-of-fitness-cases* :unbound)

(defvar *is_print*    :unbound)

;-------------------------------------------------------------------------------

(defvar *sms_list*    :unbound)
(defvar *l*           :unbound)
(defvar *l-1*         :unbound)

;(defvar *is_ADF_depth_minus_1*  :unbound)
;(defvar *ADF_sort_population* :unbound)

(defvar *is_ADF_as_OLD*  :unbound)

;;;=============================================================================
; (load "a_tree.cl")
;
; E��� ������������ ������ � �e�e����� (������e� � �e�e������ ������e)
; �� ���e��� ��� ����� � ���e����� ���� �������.
;
;;;=============================================================================
;;;
;-------------------------------------------------------------------------------
; ������� ������ ���������� ��� ���� � ������;
;-------------------------------------------------------------------------------
(defun create-arguments-for-function (
            number-of-arguments ; ������� ��� �������� ������� ����������
            function-set argument-map terminal-set 
            allowable-depth
            full-p)

(let (
   (_list  (list function-set argument-map terminal-set)) 
)

  (if (= number-of-arguments 0)
      nil
      (cons (create-individual-subtree   
                    _list ; function-set argument-map terminal-set
                    allowable-depth nil full-p)
            (create-arguments-for-function 
                    (- number-of-arguments 1) 
                    function-set argument-map terminal-set
                    allowable-depth full-p))
  )

))
;-------------------------------------------------------------------------------
(defun cons_func_args (
       choice 
       function-set argument-map terminal-set 
       allowable-depth full-p) 

(let (
  (function            (nth choice function-set))
  (number-of-arguments (nth choice argument-map))
  )

  (cons function
        (create-arguments-for-function 
                number-of-arguments 
                function-set argument-map terminal-set
                (- allowable-depth 1) full-p))
))
;-------------------------------------------------------------------------------
;   ������� ��������� ����������, ��������� �������� ������� � ���������.  
;-------------------------------------------------------------------------------
(defun create-individual-subtree (
  _list ; fset amap tset
  allowable-depth ; ���������� ������� ������������ ���������,
                  ; ���� 0, �� ����� ������� ������ ���������;

  top-node-p      ; ������, ������ ����� ����� ��� �� �������� ���� � ������;
                  ; ��� ��������� ���� ���������, ��� �� ������ ������ ������� �� ����
                  ; ������;
  full-p          ; ���������� ����������� �� ��� ����� ������� (�������);
  )
  ;; ------------------------------
  (let (

  (fset (first  _list))
  (amap (second _list))
  (tset (third  _list))
  )   

   (cond 

   ;; ----------------------------
   ((<= allowable-depth 0) ; ��� �������� "maxdepth", ������� ������ ������� terminal
    (choose-from-terminal-set tset))
   ;; ----------------------------

   ;; ----------------------------
   ((or full-p top-node-p) ; ������ ��� ������ ������� ����, ������� �������� ������ �������
    ;(let* (
          ;(l (length fset))
          ;(choice  (random-integer l))
          ;choice
    ;      )

      ;(setf choice (random-integer l)) ; ���e�� ��e��� �e���e 2 � 3 �� �e���e�???
      ;(if *debug_print* (format t "l= ~A   choice= ~A ~%" l choice))
      (cons_func_args (random-integer (length fset)) ;choice 
                      fset amap tset 
                      allowable-depth full-p)
    ;)
    )
   ;; ----------------------------
   
   ;; ----------------------------
   (:otherwise  ; �������� �� ����� ������� � ����������
    (let (
         (choice (random-integer        ; ������e��� - �e��e� ����� ���������������
                  (+ (length tset)      ; ����e ������� ?? � ���� �� �������������� !!
                     (length fset))))
         )

      (if (< choice (length fset))
          ;; �� ������� �������, ������� ����������� �� � ��������
          ;; �������� ������ ���� ������
          (cons_func_args choice 
                          fset amap tset 
                          allowable-depth full-p)

          ;; �� ������� ����, ������� ����������� ���
          (choose-from-terminal-set tset))
      ))
   ;; ----------------------------
   )

))
;-------------------------------------------------------------------------------
;   Create a new random program (by method_of_generation)
;-------------------------------------------------------------------------------
(defun create-program-branch (
       _list
       method_of_generation
       minimum-depth-of-trees  maximum-depth-of-trees
       ind_index  full-cycle-p)

  (create-individual-subtree
    _list

    (ecase method_of_generation ; ���������� ������� ������������ ���������
      ((:full :grow)         maximum-depth-of-trees)
      (:ramped-half-and-half (+ minimum-depth-of-trees (mod ind_index ;??
                                                            (- maximum-depth-of-trees
                                                               minimum-depth-of-trees)))))

    t ; ������, ������ ����� ����� ��� �� �������� ���� � ������;

    (ecase method_of_generation ; ���������� ����������� �� ��� ����� ������� (�������);
      (:full                            t)
      (:grow                          nil)
      (:ramped-half-and-half full-cycle-p)) ; �e��e� ������?
  )

)
;;;=============================================================================
;
;-------------------------------------------------------------------------------
(defun conf_0 (argus)

(let (
  (maxd (parse-integer (nth 0 argus)))

  (_list  (list  '(+ - * %)  '(2 2 2 2)  '(:floating-point-random-constant)))
  branch
  )

  ;(setf *debug_print* t)  
  (seed_set_random)

  (setf branch (create-individual-subtree   
       _list 
       maxd ; ���������� ������� ���������, ���� 0, �� ����� ������� ������ ��������� 
       t    ; ������, ������ ����� ����� ��� �� �������� ���� � ������;
            ; ��� ��������� ���� ���������, ��� �� ������ ������ ������� �� ���� ������
       t    ; ���������� ����������� �� ��� ����� "�������" (�� ����e� �� ������)
       )
   )

  (format t "~%")
  (format t "~S ~%" branch)

  (format t "~%")
))
;;;=============================================================================
;
;
;-------------------------------------------------------------------------------
;   Given a tree or subtree, a pointer to that tree/subtree and
;   an index return the component subtree that is 
;   numbered by Index. 
 
;   We number left to right, depth first.
;-------------------------------------------------------------------------------
;  ��� �������, ��� ������� ���������� �����, ���� �� ���������..
;-------------------------------------------------------------------------------
(defun get-subtree (tree pointer-to-tree index)

  (if (= index 0)
    ;; ���� ��� ����� � ��������� �� ����, �� ������� ��������������?
    ;; ����� ������ � ������: .. ??
    (values pointer-to-tree (copy-tree tree) index)

    ;; � ����� ������� ������:
    (if (consp tree)

        ;; ���� ��� ������ �������� "�����", �� ���� ������ ������:
        ;; � ����� ��� ����, ���� � ��� ��������?
        ;; --------------------------------------
        (do* (
              (tail      (rest tree)  (rest tail))  ; (var1 init1 step1)
              (argument (first tail) (first tail))  ; (var2 init2 step2)
              )
              ((not tail) (values nil nil index))   ; (end-test . result)

            (multiple-value-bind 
                (new-pointer new-tree new-index)
                (get-subtree  argument tail (- index 1))

            (if (= new-index 0) ; ��������� �� ������� "������"
                (return (values new-pointer new-tree new-index)) ; ����� �� ����� DO
                (setf index new-index)) ; ���������������� ��� ����������� ������
          )
        )
        ;; � ����� ���������� "��������" � ��������� ������
        ;; ����� ������ � ������: .. ??
        ;; --------------------------------------
        (values nil nil index))
  )
)
;===============================================================================
; � 9-�, ���� �������� ������ �� 5-�� ������� ��� ���������� �����������
; � ����� �����. 

; ����� ������������, � ������� ������� COPY-TREE �������� ����� ������� 
; ��������. 
; �����, ������������ �������������� ��������� "crossover fragment (subtree)" 
; ����� ������� �������� � �� ��������������� ������ �����������, ��� ����� �� 
; �������� �� "crossover fragment (subtree)" ����� ������� ��������. 

; ����� �������������� ��������� ���������� � ������,
; the resulting altered copies become the offspring. The original parents 
; remain in the population and can often repeatedly participate in other 
; operations during the current generation. ����� �������, the selection of parents 
; is done with replacement (i.e., reselection) allowed.
;-------------------------------------------------------------------------------

; copy-list list

; This returns a list that is equal to list, but not eq. Only the top level of 
; list structure is copied; that is, copy-list copies in the cdr direction but 
; not in the car direction. If the list is ``dotted,'' that is, (cdr (last list)) 
; is a non-nil atom, this will be true of the returned list also. 


; copy-tree object

; copy-tree is for copying trees of conses. The argument object may be any 
; Lisp object. If it is not a cons, it is returned; otherwise the result is 
; a new cons of the results of calling copy-tree on the car and cdr of the 
; argument. In other words, all conses in the tree are copied recursively, 
; stopping only when non-conses are encountered. Circularities and the sharing 
; of substructure are not preserved. 

;-------------------------------------------------------------------------------
(defun max-depth-of-tree (tree)

  (if (consp tree)
      (+ 1 (if (rest tree)
               (apply #'max
                      (mapcar #'max-depth-of-tree (rest tree)))
             0))
    1)
)
;-------------------------------------------------------------------------------
; ���� ������ � ����� males and females �� �������� �����������,
; ��������, �� ����� �� �� �� ����������� ����������� �������.
; ���� ����� ����� ��������� maxdepth, �� ������������ ������ �����.

; � 1-� ����� (koza-1.lisp) ������ >= � ���� ������ ������ ������� ����������� >
; ������ ������ �� �� ��� ����� �� ��������..
;-------------------------------------------------------------------------------
(defun validate-crossover (male new-male  female new-female)

(let ( ; ��������� ����������
  (  male-depth  (max-depth-of-tree (first new-male)))
  (female-depth  (max-depth-of-tree (first new-female)))
  )

  (values

   (if (or (= 1 male-depth)
           (>= male-depth     ;; >= counts 1 depth for root above branches
               *max-depth-for-individuals-after-crossover*))
       male
      (first new-male))

   (if (or ( = female-depth 1)
           (>= female-depth *max-depth-for-individuals-after-crossover*))
       female
       (first new-female))

  ) ; ���������� ���� ���������� ������
  
))
;-------------------------------------------------------------------------------
; ��������� ����������� ����������� ����� � ����� ����� �����������
; 
;-------------------------------------------------------------------------------
(defun crossover_at_points (male female 
                                 count_points get_subtree)

(let (
  ;; ������� ����� � ��������������� ��������, �� ������� �����������
  ;; �����������; (��� ������ �����!)
  (  male-point (random-integer (funcall  count_points male)))
  (female-point (random-integer (funcall  count_points female)))

  ;; �������, �������� �������, ������ ��� �� ������������ ������������ �����
  ;; �����, �������� �����������; 
  ;; ��������� ����� ����������� � �������� ���������;
  ;; ����������� �� ����� �������� ��������� ������ � ������ ���������;

  (  new-male (list (copy-tree   male)))  
  (new-female (list (copy-tree female))) ;; ��� ����� ��� ��������. �������.?
              ;; ����� ��� ������? ���� ������ � ��� ���������� ���������.. ?
  ;; ������ ����� - ��������� � �������� ����-����, ����� ������������ ������ NIL,
  ;; ��� ������������ � ������������ ������..?
  )

  ;; Get the pointers to the subtrees indexed by male-point
  ;; and female-point

  (multiple-value-bind 
      (male-subtree-pointer male-fragment) ; index �� �����
      (funcall  get_subtree (first new-male) new-male male-point)

  (multiple-value-bind 
      (female-subtree-pointer female-fragment)
      (funcall  get_subtree (first new-female) new-female female-point)

    ;; ������������ ����� �����, "���������" ������������� ����������
    ;; ������ ������;

    (setf (first   male-subtree-pointer) female-fragment)
    (setf (first female-subtree-pointer)   male-fragment)
  ))

  ;; ��������, ��� ����� ����� �� ������� ������� (�� �������),
  ;; ���� �� ���, �� �������� ������ �����..
  (validate-crossover  male new-male  female new-female)
))
;-------------------------------------------------------------------------------
(defun crossover-at-any-points-within-branch (male female)


  (crossover_at_points  male female 
                        'count-crossover-points 'get-subtree)

)
;-------------------------------------------------------------------------------
;   Performs crossover on the two programs (branches) at a function
;   (internal) point in the trees.
;-------------------------------------------------------------------------------
(defun crossover-at-function-points-within-branch (male female)


  (crossover_at_points  male female 
                        'count-function-points 'get-function-subtree)

)
;;;=============================================================================
;-------------------------------------------------------------------------------
(defun set_sms_l (l)

  (setf *l*   l)
  (setf *l-1* (- *l* 1))

)
;-------------------------------------------------------------------------------
(defun set_sms_list (_list)

  (setf *sms_list* _list)

  (set_sms_l (list-length _list))

)
;-------------------------------------------------------------------------------
(defun gp_crossover (individual_1 individual_2 fraction)

  (funcall
   (if (< fraction *crossover-at-function-point-fraction*)
       'crossover-at-function-points
       'crossover-at-any-points)
   individual_1 individual_2)

)
;-------------------------------------------------------------------------------
(defun gp_init_0 ()

  (setf *minimum-depth-of-trees* 1)
  (setf *full-cycle-p*           nil)

)
;-------------------------------------------------------------------------------
; ����������� ���������, ������������� ��� ����� �������
;-------------------------------------------------------------------------------
(defun gp_print_parameters ()

  (format t "Max depth of new individuals:             ~D ~%" *max-depth-for-new-individuals*)
  (format t "Max depth of new subtrees for mutants:    ~D ~%" *max-depth-for-new-subtrees-in-mutants*)
  (format t "Max depth of individuals after crossover: ~D ~%" *max-depth-for-individuals-after-crossover*)
  (format t "Crossover at any point fraction:          ~D ~%" *crossover-at-any-point-fraction*)
  (format t "Crossover at function points fraction:    ~D ~%" *crossover-at-function-point-fraction*)

  (format t "Number of fitness cases:                  ~D ~%" *number-of-fitness-cases*)

  (format_line75)
)
;-------------------------------------------------------------------------------
;
; ������� "reduce" ����������� ��� �������� ������������������ ��������� 
; �������� ��������;
;
; mapcar operates on successive elements of the lists. First the function is 
; applied to the car of each list, then to the cadr of each list, and so on.;

;-------------------------------------------------------------------------------
; ������� ������� ���������� ������� ;
;-------------------------------------------------------------------------------
(defun count_cross_points (program ret)

  (if (consp program)
      (+ 1 (reduce #'+ (mapcar #'count_cross_points 
                               (rest program) 
                               (make-list (list-length program) :initial-element ret)
                               ) 
                   ))
      ret) 
)
;-------------------------------------------------------------------------------
;  ��������� ����� ����� � ������ (���������);  
;  (�������� ������� ��� �� ��� � ���������)
;-------------------------------------------------------------------------------
(defun count-crossover-points (program)

 (count_cross_points  program 1)

)
;-------------------------------------------------------------------------------
;  ��������� ����� �������������� (����������) �����
;  � ���������;
;-------------------------------------------------------------------------------
(defun count-function-points (program)

 (count_cross_points  program 0)

)
;-------------------------------------------------------------------------------
;   Given a tree or subtree, a pointer to that tree/subtree and
;   an index return the component subtree that is 
;   labeled with an internal point that is numbered by Index. 
 
;   We number left to right, depth first.
;-------------------------------------------------------------------------------
(defun get-function-subtree (tree pointer-to-tree index)

  (if (= index 0)

    (values pointer-to-tree (copy-tree tree) index)
    
    (if (consp tree)
        ;; --------------------------------------
        (do* (
              (tail (rest tree) (rest tail))
              (argument (first tail) (first tail))
              )
              ((not tail) (values nil nil index))
 
          (multiple-value-bind 
              (new-pointer new-tree new-index)
              (if (consp argument) ; ������ ����� ������� ?? 
                  (get-function-subtree  argument tail (- index 1))
                  (values  nil nil index))

          (if (= new-index 0)
              (return (values new-pointer new-tree new-index))
            (setf index new-index))
          )
       )

      ;; --------------------------------------
      (values nil nil index))
  )
)
;-------------------------------------------------------------------------------
;    - The selection of the
;      branch is biased according to the number of
;      points in that branch.
;-------------------------------------------------------------------------------
(defun branch_select_ind_true (program)

(let (
  ind selected-point points_list sum
  (program-as-list program)
  )

  (setf points_list (make-list *l*))

  ;; �������� ������ �� ���-�� ����� ����������� � ������ ���.������
  (dotimes (i *l*)
    (setf (nth i points_list)
           (count-crossover-points (nth i program-as-list)) 
           )
  )

  ;; ---------------------------------------------------------------
  ;; ������� ��������� ����� �� ����� ���� ����������
  ;; - �������������� ����. �������, �������� ��������� ���� �������
  ;; ---------------------------------------------------------------
  (setf selected-point (random-integer (reduce #'+ points_list)))
  ;; ---------------------------------------------------------------

  ;; ������ �� ���������� ��������� ���� ��� ����� ������
  (setf sum 0)

  (dotimes (i *l*)
    (setf sum (+ sum (nth i points_list)))
    (if (< selected-point sum)
        (progn 
            (setf ind i)
            (return))
      )
  )

  ind
))
;-------------------------------------------------------------------------------
(defun branch_select_ind (program)

  (if (= *l* 1) 
      0
      (branch_select_ind_true program)
      )
)
;-------------------------------------------------------------------------------
; ���������� ���������, ������ (�������) ��������� ����� � ������
; � ������� ����� ����������, ��������� ��� �� �������, ��� � ���������
; ��������� ���������
;-------------------------------------------------------------------------------
(defun mutate_branch (branch-tree ind)

(let (
  (fun_list (get_sms ind))     
  mutation-point new-subtree new-branch _new-branch
  )

  (setf mutation-point (random-integer (count-crossover-points branch-tree)))
  ;(if *debug_print* (format t "mutation-point= ~A ~%" mutation-point))

  (setf new-subtree (create-individual-subtree
                fun_list
                *max-depth-for-new-subtrees-in-mutants* t nil))
  ;(if *debug_print* (format t "new-subtree= ~A ~%" new-subtree))

  (setf _new-branch (copy-tree branch-tree))
  (setf new-branch (list _new-branch))
  ;; ������ ����� - ��������� � �������� ����-����, ����� ������������ ������ NIL,
  ;; ��� ������������ � ������������ ������..?

  ;(setf new-branch (list (copy-tree branch-tree)))
  ;(if *debug_print* (format t "new-branch= ~A ~%" new-branch))

  (multiple-value-bind 
      (subtree-pointer fragment)
      ;; ������� ��������� �� ����� �������
      ;(get-subtree (first new-branch) new-branch mutation-point)
      (get-subtree _new-branch new-branch mutation-point)

    ;; �� ����������, �� ��� �� �������� �����
    (declare (ignore fragment))

    ;(if *debug_print* (format t "subtree-pointer= ~A ~%" subtree-pointer))
    ;; �������� ����� ����������
    (setf (first subtree-pointer) new-subtree)
  )

  new-branch
))
;-------------------------------------------------------------------------------
(defun mutate (program)

(let (
  ind branch-tree new-branch
  new_program
  )

  (setf ind (branch_select_ind program)) ;; ������� �e��� (���������) 
  (setf branch-tree (nth ind program))
  
  (setf new-branch (mutate_branch branch-tree ind))
 
  ;(setf new_program (copy-individual-substituting-branch  _new-branch program ind_branch))
  (setf new_program (copy-individual-substituting-branch (first new-branch) program ind))

  new_program
))
;-------------------------------------------------------------------------------
; ������ ����� ��������� "program-to-copy" ������� ���� ����� (����������
; ���������� "branch") ����� ������ ���������, ��������� �� ����� (������������)
;-------------------------------------------------------------------------------
(defun copy-individual-substituting-branch
       (new-branch-subtree  program_old ind_branch)

(let (
  (program_new (make-list *l*))
  ) 

  ;; ��������, �������� ��������� program_old
  (dotimes (index  *l*)

    (setf (nth index program_new) 
          (if (= index ind_branch)
              new-branch-subtree
              (copy-tree (nth index program_old))
              ))
  )

  program_new
))
;-------------------------------------------------------------------------------
;   ��������� ����������� �������� Male � Female by calling
;   the function How-To-Crossover-Function, which will cause it
;   to perform crossover at either function points or at any point.

;   The crossover happens between a compatible pair of branches
;   in the two parents.
;   Once the crossover has happened the function returns two new
;   individuals to insert into the next generation.
;-------------------------------------------------------------------------------
(defun crossover-selecting-branch
       (how-to-crossover-function  M F) ; M=male F=female (���������)

(let* (
  (ind (branch_select_ind M))
  (M_branch (nth ind M))
  (F_branch (nth ind F))
  )

  (multiple-value-bind (new_M_branch new_F_branch)
      (funcall how-to-crossover-function
               M_branch F_branch
               )

    (values 
     (copy-individual-substituting-branch  new_M_branch M ind)
     (copy-individual-substituting-branch  new_F_branch F ind)
     )
  )

))
;-------------------------------------------------------------------------------
;   Performs crossover on the programs at any point
;   in the trees.
;-------------------------------------------------------------------------------
(defun crossover-at-any-points (M F)

  (crossover-selecting-branch 
            #'crossover-at-any-points-within-branch M F)
)
;-------------------------------------------------------------------------------
;  ��������� ����������� ���� �������� � �������������� (����������) �����, 
;  � �������� ��������� ����� ��������
;-------------------------------------------------------------------------------
(defun crossover-at-function-points (male female)

  (crossover-selecting-branch
            #'crossover-at-function-points-within-branch  male  female)
)
;-------------------------------------------------------------------------------
(defun do_attempts_gp_old (
                       r_min-depth-of-trees
                       )

(let (
  (minimum-depth-of-trees  (symbol-value r_min-depth-of-trees))
  )

    (format t "--------- do_attempts_gp -------------- ~%")
    (format t "minimum-depth-of-trees= ~A ~%" minimum-depth-of-trees)
    ;; ������ ��� ������� ���� ��� �������� ���������, ������� ���������� 
    ;; ������� �������
    (incf minimum-depth-of-trees)

    ;; ���������� � �����. ������� ����, ����� ������� �� �� ������ � �����������
    (setf *max-depth-for-new-individuals*
          (max *max-depth-for-new-individuals* minimum-depth-of-trees))

    (format t "minimum-depth-of-trees= ~A ~%" minimum-depth-of-trees)
    (format t "--------------------------------------- ~%")
  (set r_min-depth-of-trees       minimum-depth-of-trees) ;;????
))
;-------------------------------------------------------------------------------
(defun do_attempts_gp ()

  (incf *minimum-depth-of-trees*)
  
  ;; ���������� � �����. ������� ����, ����� ������� �� �� ������ � �����������
  (setf *max-depth-for-new-individuals*
        (max *max-depth-for-new-individuals* 
             *minimum-depth-of-trees*)
        )
)
;-------------------------------------------------------------------------------
(defun get_sms (i)

  (when (>= i (list-length *sms_list*))
  ;(when (> i *l-1*)
        (setf i 0))

  (nth i *sms_list*)
)
;-------------------------------------------------------------------------------
;   Creates a new individual with ADF structure.
;-------------------------------------------------------------------------------
(defun create-new-program_ADF_ (
                                size
                                minimum-depth-of-trees
                                maximum-depth-of-trees                        
                                ind_index full-cycle-p
                                )
(let (
   (program_new (make-list size))
   ) 

  (if *debug_print* (format t "create-new-program_ADF_ ~%"))
  (if *debug_print* (format t "size= ~A ~%" size))

  (dotimes (i  size)
    (setf (nth i program_new) 
          (create-program-branch (get_sms i) 
                                 *method-of-generation*
                                 minimum-depth-of-trees 
                                 
                                 (if *is_ADF_as_OLD*
                                     maximum-depth-of-trees 
                                   (- maximum-depth-of-trees 1) ; ��� ���� ����� ..2part
                                   ;; We count one level of depth for the root above all 
                                   ;; of the branches that get evolved. 
                                   )
                                 ind_index full-cycle-p)
          )
    )
  
  (if *debug_print* (format t "create-new-program_ADF_ ~%"))

  program_new  
))
;-------------------------------------------------------------------------------
(defun create_gp_program (ind_index)

  (when (zerop (mod ind_index
                    (max 1 (- *max-depth-for-new-individuals*
                              *minimum-depth-of-trees*))
                    ))
    (setf *full-cycle-p* (not *full-cycle-p*)))
  
  ;; Create a new random program.
  (create-new-program_ADF_ *l*
                           *minimum-depth-of-trees* 
                           *max-depth-for-new-individuals*
                           ind_index  
                           *full-cycle-p*
                           )
)
;;;=============================================================================

;-------------------------------------------------------------------------------
;(eval-when (:execute ) 
;(eval-when (:load-toplevel ) 
;(eval-when (:compile ) 
;-------------------------------------------------------------------------------
(defun genotype_print_adf (
               program ;; genotype ; the structure to be printed
               )
  
  (dotimes (i  *l-1*)
    (format t  "ADF~D: ~S ~%" i (nth i program))
    )

  (format t  "RPB0: ~S ~%" (nth *l-1* program))

)
;-------------------------------------------------------------------------------
(defun gp_kernel_init ()

  ;(c_gena_init)
  (setf  *is_print* t)

  ;;(setf *eval_prog* 'fast-eval)
  (setf *eval_prog*  'eval)

  (setf *flag_error* nil)
  (setf *is_ADF_as_OLD* nil)

  (setf *get_starter*  #'(lambda (program) (nth *l-1* program)))
  (setf *genotype_print* (lambda (genotype) (genotype_print_adf genotype)))

)
;-------------------------------------------------------------------------------
;)

(gp_kernel_init)

;;;=============================================================================
;;;
;-------------------------------------------------------------------------------
; The most popular termination criterion is to stop the current run if we have 
; reached a prespecified maximum number G of generations to be run or if we
; have attained some prespecified perfect level of performance. This level of 
; performance may be the achievement of a standardized-fitness of zero or the 
; achievement of a hit for 100% of the fitness cases. 
;-------------------------------------------------------------------------------
(defun define_termination_criterion_HITS (
        current-generation                                 
        maximum-generations	                                     
        best-standardized-fitness	                             
        best-hits)
	                                             
  ;; best-hits is the number of hits for the individual in the population 
  ;; with the best (i.e., lowest) standardized fitness. Note that
  ;; occasionally the highest number of hits is attained by an individual 
  ;; in the population other than the individual with the
  ;; best standardized-fitness.

  ;; Line states that one of the four arguments (i.e. best-standardized-fitness) 
  ;; is to be ignored for this particular problem.  
  (declare (ignore best-standardized-fitness))	                     

  (values	                                                     
    (or (>= current-generation  maximum-generations)	             
        (>= best-hits          *number-of-fitness-cases*)
    ))	                                                             
)	                                                             
;-------------------------------------------------------------------------------
(defun set_problem_parameters (problem-function)

(let ( 
  (fitness-cases  NIL)
  fitness-function termination-predicate

  fitness-cases-creator 
  parameter-definer  
  )

  (multiple-value-setq (
            fitness-cases-creator fitness-function
            parameter-definer
            termination-predicate
            ) 
    (funcall problem-function)
            )
 
  (funcall parameter-definer) 
  (when (not (eq fitness-cases-creator NIL))
    (setf fitness-cases (funcall fitness-cases-creator))
  )

  (values  fitness-cases fitness-function termination-predicate)  
))
;-------------------------------------------------------------------------------
(defun run-g-p-system (problem-function
                      ;seed
                      maximum-generations
                      size-of-population
                      
                      ;&rest seeded-programs
                      seeded-programs
                      )

(let ( ; ��������� ����������
  population 
  fitness-cases fitness-function termination-predicate
  )

  ;; -------------------------------
  (multiple-value-setq (
            fitness-cases fitness-function
            termination-predicate
            ) 
    (set_problem_parameters problem-function)
    )
  ;; -------------------------------
    
  (gp_init_0)

  (setf population (population_create 
                                        size-of-population
                                        seeded-programs
                                       
                                        'create_gp_program
                                        'do_attempts_gp
                                        ))

  (execute_generations_  population  maximum-generations
                         (if *is_ADF_as_OLD*
                             'sort-population-by-fitness_1
                             'sort-population-by-fitness_0
                           )

                         *method-of-selection* 
                         fitness-function fitness-cases     
                         termination-predicate 

                         (+ *crossover-at-function-point-fraction*
                                *crossover-at-any-point-fraction*)
                         *reproduction-fraction*
                         'gp_crossover 'mutate

                         #'(lambda (maximum-generations) (progn 
                           (ga_print_parameters maximum-generations)
                           (gp_print_parameters)
                           ))
                         *is_print* 
                         )
  
  ;; ���������� "population" � "fitness cases" (��� �������) 
  (values population fitness-cases)  

))
;-------------------------------------------------------------------------------
(defun run-genetic-programming-system (problem-function
                                       seed
                                       maximum-generations
                                       size-of-population

                                       &rest seeded-programs
                                       )
(let (
  )

  (seed_set seed)

  (run-g-p-system problem-function
                 ;;seed
                 maximum-generations
                 size-of-population
                 
                 seeded-programs
                 )
  
))
;;;=============================================================================


;;;=============================================================================
;;;
;-------------------------------------------------------------------------------
(defun calc_R (z P)

(let ((EPS (- 1.0 z))
      R)  

  (case  P
      (1  (setf R 0.0))
      ;(0  (setf R 99999))
      (0  (setf R NIL))
      (otherwise (setf R (/ (log EPS) (log (- 1.0 P)))) )
      )
  R
))
;-------------------------------------------------------------------------------
(defun test_R_one (z P)

(let ((R (calc_R z P)))

  (format t "R= ~A []= ~A ~%" R (ceiling R))

))
;-------------------------------------------------------------------------------
(defun test_R ()

(let ((z 0.99))  

  (test_R_one z 0.09)
  (test_R_one z 0.68)
  (test_R_one z 0.78)
  (test_R_one z 0.90)
  (test_R_one z 0.99)

  ;; Figure 8.2 shows a graph of the number of independent runs R(z) required to 
  ;; yield a success with probability z = 99% as a function of the
  ;; cumulative probability of success P(M, i). 

  ;; P(M, i)     independent runs are required
  ;; ---------------------------------------------
  ;; 0.09        48

  ;; 0.68         4
  ;; 0.78         3  
  ;; 0.90         2  
  ;; 0.99         1 

  ;; The three values of P(M, i) of 68% (i.e., about two-thirds), 
  ;; 78% (i.e., about three-quarters), and 90% are important thresholds
  ;; since they are the smallest percentages of success for which only four, three, 
  ;; or two independent runs, respectively, will yield a success with a
  ;; probability of z = 99%.
  ;;                                                            (Page 195)

  ;; ������� ����������: (�.�. � ����� ������� �� ceiling, � floor !)
  ;; R= 48.829777 []= 49 
  ;; R= 4.0416293 []= 5 
  ;; R= 3.0414684 []= 4 
  ;; R= 2.0000007 []= 3 
  ;; R= 1.0 []= 1 
))
;-------------------------------------------------------------------------------
(defun runs_GPS (num_runs
                 problem  seed  num_gens  size)
  
  (setf  *is_print*  nil) ; �� �������� ������ ���� ��� ��������

  ;; ������� ������������� �������� ��������� ������...
  ;; (format t "seed= ~A  ~%"  seed)
  (if (< seed 0) ;; ��� �e��� (40 (runs_GPS   5 'MAJORITY-ON  0.0 21 100)) �e �������e���!

      ;(setf seed (park-miller-randomizer))
      (setf seed (YRandF 0 1.0)) ; ���e��� !!!

      ;(format t "seed>=0 ~%") ;; t 
   ) 
  ;; (format t "seed= ~A  ~%"  seed)

  ;; -----------------------------------------------
  ;; ��������� ����������
  (let* (results sum pp P
                 )

  ;; �������� ������ ��� ����������� � ������� ���
  (setf  results (make-array num_gens))
  (dotimes (i num_gens)
    (setf (aref results i) 0)
    )
  
  ;; �������� ����� ���������� (��������)
  (dotimes (i num_runs)
    (if (= i 0) 
        (setf  *is_print_run_info*  t)
        (setf  *is_print_run_info*  nil)
      )
    (format t "~4D) ~%" i)
    (run-genetic-programming-system  problem seed num_gens size)
    ;; ����� ���� ������ - ��� ������ ����� ��� ���?
    ;; � ���� ��, �� �����������:
    ;(format t "CALC_HITS= ~D ~%"  (individual-hits  *best-of-run*))
    ;(format t "TRUE_HITS= ~D ~%"  *number-of-fitness-cases*)
    ;(format t "~%")  

    (if (= (ORGANISM-hits  *best-of-run*) *number-of-fitness-cases*) 
    (let* (
           (gen *generation-of-best-of-run*)
           (res (aref results gen))
           )
      ;; ��������� ���������� ������� ������ �� ���� ���������
      (setf (aref results gen) (+ res 1))
      ))
    )
  
  ;; ����������� ������ ����������� (�������������� �� ����������)
  (format_line75)
  (format t "~%")

  (setf  sum 0)
  (dotimes (i num_gens)

  (let (R R_min R_max ind ind_min ind_max)

    (setf  sum (+ sum (aref results i)))

    (setf  pp (/ sum num_runs)) ; ������������ �����������
    (setf  P (* 100.0 pp))      ; ������������ ����������� (� ���������)

    (setf  R (calc_R 0.99 pp))

    (format t "~2A]   ~3A ~4A ~6,2F %    " i (aref results i) sum P)
    (format t "R= ~7,1F    " R)

    (if R (progn
              (setf  R_min (floor   R))
              (setf  R_max (ceiling R))
              (setf  ind     (* R (+ i 1) size))
              (setf  ind_min (* R_min (+ i 1) size))
              (setf  ind_max (* R_max (+ i 1) size))
              (format t "I= ~10,2F [~7D  ~7D]" ind ind_min ind_max)
              ))

    (format t "~%")
    )
  )

;===============================================================================
  ;; �� ����� ��� ���� ��� � � �����, ������ ������� �������� �� "����������" �����������
  ;; ��� ������� ���������, � "����������" ���������� �������, � ����� ��� ��� ��������.
  
  ;; We start the process of measuring the amount of processing required by 
  ;; experimentally obtaining an estimate for the probability g(M, i) that a
  ;; particular run with a population of size M yields, for the first time, 
  ;; on a specified generation i, an individual satisfying the success predicate
  ;; for the problem. The experimental measurement of g(M, i) usually requires 
  ;; a substantial number of runs.
  ;; In any event, once we have obtained the instantaneous probability g(M, i) 
  ;; for each generation i, we compute the cumulative probability of
  ;; success P(M, i) for all the generations between generation 0 and generation i.
  ;;                                                                  (Page 194)
))   
;;;=============================================================================
;-------------------------------------------------------------------------------
(defun koza_test_num (name num)

(let ((form)
  )

  (setf form (funcall (read-from-string  name) (parse-integer  num)))
       
  (eval form)
  (format t "~%")

))
;-------------------------------------------------------------------------------
;;;=============================================================================
(defun RUN (argus)

(let (
  (name (first argus))
  )

(cond 

   ((eq name NIL)  (progn 
       (format t "~%")
       (format t "KOZA-RUN ~%")
       (format t "~%")
       ))

   (t  (progn 
         ;(compile 'koza_test_num)
         ;(compile 'run-genetic-programming-system)
         ;(compile 'execute-generations)  ;; ������-�� �� ����������..
         ;(if (not (compiled-function-p #'execute-generations))
         ;    (exit)
         ;    )
         ;(format t "RUN ~%")
         ;(compile-file "koza-3.cl") ; �����������, �� � ������ �� ����?
         (koza_test_num  name (second argus))
       ))
)  

))
;-------------------------------------------------------------------------------
(defun test1 (argus)  (declare (ignore argus))

(let (tr1 tr2)

  (setf tr1     '(and a1 a2)
        )

  (setf tr2 '(or (and a3 a4) a5)
        )

  (format t "tr1 = ~A ~%"  tr1)
  (format t "tr1_count-function-points = ~A ~%"  (count-function-points  tr1))
  (format t "tr1_count-crossover-points= ~A ~%"  (count-crossover-points tr1))
  (format t "~%")
  (format t "tr1_count_cross_points_0 = ~A ~%"   (count_cross_points  tr1 0))
  (format t "tr1_count_cross_points_1 = ~A ~%"   (count_cross_points  tr1 1))
  (format t "~%")

  (format t "tr2 = ~A ~%"  tr2)
  (format t "tr2_count-function-points = ~A ~%"  (count-function-points  tr2))
  (format t "tr2_count-crossover-points= ~A ~%"  (count-crossover-points tr2))

  (format t "~%")
))
;;;=============================================================================

