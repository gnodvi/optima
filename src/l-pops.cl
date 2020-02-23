;;;=============================================================================
;;; e_pops.cl
;;;=============================================================================


(defstruct ORGANISM  
  genotype  ; project program 

  (standardized-fitness 0)
  (adjusted-fitness     0)
  (normalized-fitness   0)
  (hits                 0)
)

;;;=============================================================================

(defvar *check_already_created* t)

(defvar *program* :unbound)

(defvar *get_starter*    #'(lambda (program) program))
(defvar *genotype_print* #'(lambda (genotype) (format t "~S ~%" genotype)))

(defvar *size-of-population* :unbound)
(defvar *best-of-population* :unbound) 

;; ����� �������� ������ � ���������; ���
;; ��� :fitness-proportionate, :tournament
;; ��� :fitness-proportionate-with-over-selection
(defvar *method-of-selection*                         :unbound)

(defvar *tournament-size* :unbound
  "The group size to use when doing tournament selection.")

;; ���-�������..
;; ������������, ����� �������������, ��� ��� ����� 0-�� ��������� - ���������.
;;
(defvar *generation-0-uniquifier-table* (make-hash-table :test #'equal))

;;;=============================================================================

;-------------------------------------------------------------------------------
(defun check-already-created (
       new-genotype 
       population 
 
       ;; ����� �������� ��������� "������"
       r_ind_index r_attempts-at-this-individual 
       do_attempts
       )

(let (
  ;; Turn the defstruct representation of the 'genotype' into a list so that 
  ;; it can be compared using an EQUAL hash table.
  ;; defstruct instances have to be compared with EQUALP
  (program-as-list new-genotype)

  (ind_index                   (symbol-value r_ind_index))
  (attempts-at-this-individual (symbol-value r_attempts-at-this-individual))
  )

  ;;--------------------
  (cond 
   
   ;;-----------------------
   ((not (gethash program-as-list *generation-0-uniquifier-table*))

    ; ������ ���������� �� � ������
    (setf (aref population ind_index) (make-ORGANISM :genotype new-genotype))
    (incf ind_index)

    (setf (gethash program-as-list *generation-0-uniquifier-table*) t) ;??
    (setf attempts-at-this-individual 0)                               ;??
    )

   ;;-----------------------
   ((> attempts-at-this-individual 20) ;; ���� ������� ������� ��� ������� �����

    (funcall do_attempts)
    )

   ;;-----------------------
   (:otherwise
    (incf attempts-at-this-individual))
   )  
  ;;--------------------

  (set r_ind_index                    ind_index)
  (set r_attempts-at-this-individual  attempts-at-this-individual)
)) 
;-------------------------------------------------------------------------------
(defun population_set_seeded (pop seeded-genotypes)

(let (
  (num_seeded (length seeded-genotypes))
  new-genotype 
  )

  (do 
      ((i 0))              ; ���������� �����
      ((= i num_seeded)) ; ������� ���������
   
    ;; Pick a seeded individual
    (setf new-genotype (nth i seeded-genotypes)) 

    ;; ������ ���������� �� � ������
    (setf (aref pop i) (make-ORGANISM :genotype new-genotype))
    (incf i)    
  )
  
  ;; Return the population that we've just created.
  pop
))
;-------------------------------------------------------------------------------
(defun population_create_seeded (seeded-genotypes)

(let (
  (num_seeded (length seeded-genotypes))
  pop_min 
  )

  (setf pop_min   (make-array num_seeded))
  (population_set_seeded  pop_min seeded-genotypes)

  (setf *size-of-population*  num_seeded)   

  pop_min
))
;-------------------------------------------------------------------------------
;  ������� ���������; ��� - ������ �������� "size-of-population", �������
;  ��������������� ��� �������� �������������� �������;

;  ���� "program" ������ ������ (�����) ���������������� ���������������
;  ��������� ����������, �� ����������� ������ N ��������, ���
;  N = (length seeded-programs); ��� ���� ������ N ������� ������������
;  ��������� �������� ���������; ��� ����� ������ ��� �������;
;-------------------------------------------------------------------------------
(defun population_create_news (population i_min i_max
                                create_genotype do_attempts
                                )

(let (
  (attempts-at-this-individual 0)
  new-genotype 
  )
  (declare (special attempts-at-this-individual 
                    ))

  (do 
      ((i    i_min)) ; ���������� �����
      ((>= i i_max)) ; ������� ���������
    (declare (special i))    ; ����� ������ ��� ���������� �����������
   
    ;; �����e� ����� �e����� (���e��)
    (setf new-genotype (funcall create_genotype i)) 

    ;; ��� ������� ��e��e� ��� ��������
    (if *check_already_created*
        ;; Check if we have already created this program.
        ;; If not then store it and move on. If we have then try again.
        (check-already-created  new-genotype 
                                population  
                                
                                ;; ������ ��� �������
                                'i  
                                'attempts-at-this-individual do_attempts)       
        (progn
          ;; ������ ���������� � ������
          (setf (aref population i) (make-ORGANISM :genotype new-genotype))
          (incf i)
          )
    )
    
  )

  ;; Return the population that we've just created.
  population
))
;-------------------------------------------------------------------------------
(defun population_copy_to_from (pop_to pop_from)
(let (
  (pop_from_size (array-dimension pop_from 0))
  )

  (do 
      ((i 0))     ; ���������� �����
      ((= i pop_from_size)) ; ������� ���������
   
    ;; ������ ���������� �� � ������
    (setf (aref pop_to i) (aref pop_from i))
    (incf i)    
  )
  
))
;-------------------------------------------------------------------------------
(defun population_expand (population_min 
                           size_max
                           create_genotype do_attempts
                           )
(let (
  (size_min       *size-of-population*)
  (population_max (make-array size_max))
  )

  (population_copy_to_from  population_max population_min)

  (population_create_news  population_max size_min size_max 
                 create_genotype do_attempts)
  
  ;; Flush out uniquifier table to that no pointers
  ;; are kept to generation 0 individuals.
  (clrhash *generation-0-uniquifier-table*)

  (setf *size-of-population*  size_max) 
  
  ;; Return the population that we've just created.
  population_max
))
;-------------------------------------------------------------------------------
(defun population_create ( 
                           size-of-population
                           seeded-genotypes 
                           create_genotype do_attempts
                           )
(let* (
  (population_min (population_create_seeded  seeded-genotypes))
  )

  (population_expand   population_min
                       size-of-population
                       create_genotype do_attempts
                       )

))
;-------------------------------------------------------------------------------
; ������ ���� ��������� (��� �������)
;-------------------------------------------------------------------------------
(defun population_print (pop &optional (line_print 'format_line75))  

(let (
  (*print-pretty* t) 
  )

  (format_line75) 
  (format t "PRINT-POULATION ~%")
  (format_line75) 
 
  (dotimes (index (length pop))
  (let ( 
     (individual (aref pop index))
     )

    (unless (= index 0) 
      (funcall line_print)
      ) 
    (format t "~2D]   ~5S    ~S ~%"
            index
            (ORGANISM-standardized-fitness individual)
            (ORGANISM-genotype              individual)
            )
  ))

  (format_line75)
))
;-------------------------------------------------------------------------------
; �������� ���������� � ������ ����� ���������; ��� �� �������� ������ �����������,
; �� �������� �������� ��������� �������� (�������� � ���������..)
;-------------------------------------------------------------------------------
(defun population_zeroize_fitness (pop)

  (dotimes (index (length pop))
    (let ((individual (aref pop index)))

      (setf (ORGANISM-standardized-fitness individual)  0.0)
      (setf (ORGANISM-adjusted-fitness     individual)  0.0)
      (setf (ORGANISM-normalized-fitness   individual)  0.0)
      (setf (ORGANISM-hits                 individual)    0)
    )
  )
)
;-------------------------------------------------------------------------------
(defun population_evaluate_fitness (pop
                                    fitness-function fitness-cases)
(let (
  )

  (dotimes (index (length pop))
    (let* (
         (individual (aref pop index))
         (genotype  (ORGANISM-genotype individual))  
         )

      (if *debug_print* (format t "pop71.. ~%"))
      ;; ------------------------------------------
      (setf *program* genotype)
      ;; ------------------------------------------
      ;(if *debug_print* (format t "fitness-function= ~S  ~%" fitness-function))
      ;(if *debug_print* (format t "genotype= ~S  ~%" genotype))
      ;(if *debug_print* (format t "*get_starter*= ~S  ~%" *get_starter*))

      (multiple-value-bind (standardized-fitness hits)
          (funcall fitness-function
                   ;genotype ;
                   (funcall *get_starter* genotype) ;starter
                   fitness-cases)

        (if *debug_print* (format t "pop72.. ~%"))
        ;; Record fitness and hits for this individual.
        (setf (ORGANISM-standardized-fitness individual) standardized-fitness)
        (setf (ORGANISM-hits                 individual) hits)
      )
      (if *debug_print* (format t "pop73.. ~%"))

    )
  )
))
;-------------------------------------------------------------------------------
; ��������� ��������������� � ���������������� ������� ��� ������ ����� ���������
;-------------------------------------------------------------------------------
(defun population_normalize_fitness (pop)

(let (
  (sum-of-adjusted-fitnesses 0.0)
  )

  (dotimes (index (length pop))
    (let ((individual (aref pop index)))

      ;; Set the adjusted fitness.
      (setf (ORGANISM-adjusted-fitness individual)
            (/ 1.0 (+ 1.0 (ORGANISM-standardized-fitness individual))))

      ;; Add up the adjusted fitnesses so that we can normalize them.
      (incf sum-of-adjusted-fitnesses (ORGANISM-adjusted-fitness individual))
    )
  )

  ;; Loop through population normalizing the adjusted fitness.
  (dotimes (index (length pop))
    (let ((individual (aref pop index)))

      (setf (ORGANISM-normalized-fitness individual)
            (/ (ORGANISM-adjusted-fitness individual)
               sum-of-adjusted-fitnesses))
  ))

))
;-------------------------------------------------------------------------------
; ��������� ��������� �� ���������������� �������;
; ������ ��������� ������������ ��������������
;-------------------------------------------------------------------------------
(defun sort-population-by-fitness_0 (population)

  ;; ����������� ������� ���������� - ����� ���� �������, �� �� �������
  ;; ������� �� ������ ����-�����������

  (sort population #'> :key #'ORGANISM-normalized-fitness)

)
;-------------------------------------------------------------------------------
; ������� ������� ������� ��������� (�������� �������� ��������� �� ������ ������)
; - ��������� ��������� ������������ �� �������� ��������
;-------------------------------------------------------------------------------
(defun sort-population-by-fitness_1
    (population &optional (low 0) (high (length population)))


  (sort_1 population low high 
          #'ORGANISM-normalized-fitness)

)
;-------------------------------------------------------------------------------
(defun sort_1 (population low high key_func)


(unless (>= (+ low 1) high)
;(when (>= (+ low 1) high) (error "(>= (+ low 1) high)"))

(let* (
  (pivot (funcall key_func (aref population low)))
  (index1 (+ low  1))
  (index2 (- high 1))
  )
  
  (loop 
    (do () ((or (>= index1 high)
                ;(<= (ORGANISM-normalized-fitness (aref population index1)) pivot)))
                (<= (funcall key_func (aref population index1)) pivot)))
      (incf index1))
    
    (do () ((or (>= low index2)
                ;(>= (ORGANISM-normalized-fitness (aref population index2)) pivot)))
                (>= (funcall key_func (aref population index2)) pivot)))
      (decf index2))
    
    (when (>= index1 index2) (return nil))
    (rotatef (aref population index1) (aref population index2))
    (decf index2)
    )
  
  (rotatef (aref population low) (aref population (- index1 1)))

  (sort-population-by-fitness_1 population low index1)
  (sort-population-by-fitness_1 population index1 high)
)

)
  population
)
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; ����������� ������ ����� � ����� ������� ���������
;-------------------------------------------------------------------------------
(defun population_report (pop report_name)
  
(let (
  (best-individual    (aref pop 0))
  (size-of-population (length pop))
  (sum                0.0) ; ��� ���������� ����� ��������
  (*print-pretty*       t)
  )
  
  ;; ��������� ����� "standardized fitnesses"
  (dotimes (index size-of-population)
    (incf sum (ORGANISM-standardized-fitness (aref pop index)))
    )
  
  (format_line75)
  (format t "~A ~%" report_name)

  (format t "Average standardized fitness = ~S ~%" (/ sum (length pop)))
  (format t "Best    standardized fitness = ~D and ~D hit~P. ~%"            
          (ORGANISM-standardized-fitness best-individual)
          (ORGANISM-hits                 best-individual)
          (ORGANISM-hits                 best-individual) ; ��. ��������� "s"
          )
  (format t "It was: ~%")            

  (funcall *genotype_print* (ORGANISM-genotype best-individual))

  (format_line75)
  (format t "~%")
  
))
;-------------------------------------------------------------------------------
(defun population_utils (pop 
                            fitness-function fitness-cases 
                            sort-population 
                            )

  ;; ���������� �������-���������
  (if *debug_print* (format t "pop6.. ~%"))
  (population_zeroize_fitness  pop)
  
  ;; ��������� ������� ������ �����; ���������� ��������
  ;; ����������� � ����� ������;
  (if *debug_print* (format t "pop7.. ~%"))
  (population_evaluate_fitness  pop fitness-function fitness-cases )
  
  ;; ������������� ������� (������������� ��������� � �.�.)
  (if *debug_print* (format t "pop8.. ~%"))
  (population_normalize_fitness  pop)
  
  (if *debug_print* (format t "pop9.. ~%"))
  ;; ������������� ��������� ��� ����� ������� ������������� "�������";
  (funcall sort-population pop)
  
  (if *debug_print* (format t "pop10.. ~%"))
  (setf *best-of-population* (aref pop 0)) ;; ������ �� ������ (�e����) ����� 
                                           ;; � ���������
  
  pop
)
;===============================================================================

;-------------------------------------------------------------------------------
; ��������� (piks) ��� ��������� ����� �� ��������� � ���������� ���� ������
;-------------------------------------------------------------------------------
(defun find-tournament-selection_0 (population)

(let (
  (individual-a (aref population (random-integer (length population))))
  (individual-b (aref population (random-integer (length population))))
  )

  (if (< (ORGANISM-standardized-fitness individual-a)
         (ORGANISM-standardized-fitness individual-b))

      (ORGANISM-genotype individual-a)
      (ORGANISM-genotype individual-b)
    )

))
;-------------------------------------------------------------------------------
;   Picks *tournament-size* individuals from the population at random and
;   returns the best one.
;-------------------------------------------------------------------------------
(defun find-tournament-selection (population)

(let (
  (numbers (pick-k-random-individual-indices *tournament-size* (length population)))
  )

  (loop 
    with best         = (aref population (first numbers))
    with best-fitness = (ORGANISM-standardized-fitness best)

    for number in (rest numbers)
    for individual = (aref population number)
    for this-fitness = (ORGANISM-standardized-fitness individual)

    when (< this-fitness best-fitness)
    do (setf best individual)

    (setf best-fitness this-fitness)

    ;finally (return (ORGANISM-genotype best))
    finally (return best)
    )

))
;-------------------------------------------------------------------------------
; ���� ����� � ���������, ��� ��������������� ������� - ������, ���
; �������� ��������;
;
; ��� ��� ��� �����, ��� ��������� �� ���������, ������� � ������
; � �������� (��������) �������, ���� �� �� �������� �������� ������ (?��� ���?)
;-------------------------------------------------------------------------------
(defun find-fitness-proportionate (
            after-this-fitness ; �� ������ ���� 0 !
            population
            )

;(format *error-output* "----------- ~%")
;(format *error-output* "after-this-fitness = ~s ~%" after-this-fitness)
;(break)

(let* ( ; ��������� ����������
  (sum-of-fitness  -0.0)
  (population-size (length population))

  index-of-selected-individual ; ���� ��������� let, � ������ ��� ������ let*
  )

  ;----------------------------------------------------
  (SETF index-of-selected-individual 

   (do ((index 0 (+ index 1)))
       ;; ������� ������ �� �����
       ((or (>= index population-size)

;-----------------------------------------------------
; ����� ���� �����������?
            (> sum-of-fitness after-this-fitness)  
;            (>= sum-of-fitness after-this-fitness) ; 0 >= 0 
;-----------------------------------------------------
            ) 

        ;; ������������ ��������
        (if (>= index population-size)
            ;(- (length population) 1)
            (- population-size 1)
            (- index 1)) ; ���� ����� ��������� ������� ������, �� ����� ����� -1 !
        )

     ;(format *error-output* "index = ~s ~%" index)

     ;; ���� �����:  ��������� �������� �������
     (incf sum-of-fitness
           (ORGANISM-normalized-fitness (aref population index)))
     )
  )
  ;----------------------------------------------------
  ;)
  
;  (format *error-output* 
;          "sum-of-fitness              = ~s ~%" sum-of-fitness)
;  (format *error-output* 
;          "after-this-fitness          = ~s ~%" after-this-fitness)
;  (format *error-output* 
;          "population-size             = ~s ~%" population-size)
;  (format *error-output* 
;          "index-of-selected-individual= ~s ~%" index-of-selected-individual)
;  (format *error-output* "----------- ~%")
;  (exit)

  ;; ��������e� ������ �� �E����� �����
  ;(ORGANISM-genotype
  ; (aref population index-of-selected-individual))

  (aref population index-of-selected-individual)

))
;-------------------------------------------------------------------------------
;   Picks a random number between 0.0 and 1.0 biased using the
;   over-selection method.
;-------------------------------------------------------------------------------
(defun random-floating-point-number-with-over-selection 
  (population)

(let (
  (pop-size (length population))
  )

  (when (< pop-size 1000)
    (error "A population size of ~D is too small for over-selection." pop-size))

  (let ((boundary (/ 320.0 pop-size)))
    ;; The boundary between the over and under selected parts.

    (if (< (random-floating-point-number 1.0) 0.8) ; 80% are in the over-selected part

      (random-floating-point-number boundary)

      (+ boundary
         (random-floating-point-number (- 1.0 boundary))))
  )
  
))
;-------------------------------------------------------------------------------
;   ���� ����� � ��������� � ������������ � �������� ������� ��������
;   
;-------------------------------------------------------------------------------
(defun find_organism (population)

  (ecase *method-of-selection*

    (:tournament (find-tournament-selection
                  population))

    (:fitness-proportionate-with-over-selection
          (find-fitness-proportionate
                 (random-floating-point-number-with-over-selection population)
                 population))

    (:fitness-proportionate   ; ---->
          (find-fitness-proportionate
                 (random-floating-point-number 1.0) ; ���o 0!
                 population))
  )
)
;-------------------------------------------------------------------------------
(defun find_genotype (population)
(let (
  organism
  )

  (setf organism (find_organism population))

  (ORGANISM-genotype organism)
))
;;;=============================================================================
;;;
;===============================================================================
;-------------------------------------------------------------------------------
(defun pops_0_eval	             
  (program fitness-cases)	                                     

(declare (ignore  program fitness-cases))	                     

(let (fitn hits
   ) 
  
  (setf fitn (random-floating-point-number 1.0))

  (setf hits (random-integer 5))

  (values fitn hits )
))	                                                             
;-------------------------------------------------------------------------------
(defun pops_0 (argus)  

(declare (ignore argus))

(let (
  (pop (population_create_seeded (list 
                           '(1 2 3 4 5) 
                           '(6 7 8 9 0)
                           '(0.1  0.2  0.3  0.4  0.5) 
                           )
                          ))
  )

  (population_print pop)
  ;(setf *debug_print* t)

  (population_utils pop 
                    'pops_0_eval  NIL ; fitness-cases 
                    ;'evaluate-sfitness-test1 NIL ; fitness-cases 
                    'sort-population-by-fitness_0 
                    )

  (population_print pop)
  (population_report pop "REPORT:")

  (format t "~%")
))
;===============================================================================
;-------------------------------------------------------------------------------
(defun pops_kernel_init ()

  ;(setf *get_starter*  #'(lambda (program) (nth *l-1* program)))
  ;(setf *genotype_print* (lambda (genotype) (genotype_print_adf genotype)))
  (setf  *get_starter*    #'(lambda (program) program))
  (setf  *genotype_print* #'(lambda (genotype) (format t "~S ~%" genotype)))

)
;-------------------------------------------------------------------------------

(pops_kernel_init)

; e��� �e ��������� ����, �� ������:
;*** - NTH: :UNBOUND is not a non-negative integer

;===============================================================================
