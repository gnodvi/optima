;;;=============================================================================
;;; e_gena.cl
;;;=============================================================================

;;;=============================================================================

;; доля популяции к которой в каждом поколении будет приеменяться
;; фитнесс-пропорциональная репродукция (с реселекцией) 
(defvar *reproduction-fraction* :unbound)

(defvar *crossover-fraction*        :unbound)
(defvar *mutate*     :unbound)
(defvar *crossover*  :unbound)

;; может быть одним из  :grow, :full, :ramped-half-and-half
(defvar *method-of-generation*                        :unbound)

(defvar *best_fitness* 0.0)

;; лучшая особь найденная за этот запуск
(defvar *best-of-run*                      :unbound)

;; поколение в котром была найдена эта "best-of-run" 
(defvar *generation-of-best-of-run*        :unbound)

(defvar *is_print_run_info*  t)

;===============================================================================
;
;-------------------------------------------------------------------------------
(defun define_termination_criterion_FITN (
        curr                                
        maxi	                                     
        best-fitness	                             
        best-hits)

  (declare (ignore curr maxi best-hits))	                     

  (format t "define_termination_criterion_FITN: best-fitness= ~S ~%" best-fitness)

  (<= best-fitness *best_fitness*) 
)	                                                             
;===============================================================================

;-------------------------------------------------------------------------------
(defun ga_print_parameters (maximum-generations)
  
  (format t "~%")
  (format t "Parameters used for this run: ~%")
  (format_line75)

  (format t "Maximum number of Generations:            ~D ~%" maximum-generations)
  (format t "Size of Population:                       ~D ~%" *size-of-population*)

  (format t "Reproduction fraction:                    ~D ~%" *reproduction-fraction*)

  (format t "Selection method:                         ~A ~%" *method-of-selection*)
  (format t "Generation method:                        ~A ~%" *method-of-generation*)
  ;(format t "Randomizer seed:                          ~D ~%" *seed*)

  (format t "Tournament group size: ~41T ~A ~%"  *tournament-size*)
  (format_line75)
)
;-------------------------------------------------------------------------------
; идем циклом по популяции выполняя каждую операцию (т.е, кроссовер, 
; фитнесс-пропорциональную репродукцию, мутацию) пока это соответствуем заданной 
; доле (specified fraction); 
 
; новые созданные программы накапливаются в "new-programs"
; пока вся популяция полностью не используется, а затем новые особи копируются
; на место старых, что уменьшает накладные расходы (consing новых групп особей);
;-------------------------------------------------------------------------------
(defun breed-new-population (population ;new-programs 
                                        )  
(let* (
  (population-size (length population))
  (new-genotypes (make-array *size-of-population*))
  
  ;(fraction_step (/ 1.0 population-size)) 
  ;(fraction     0)
  )

  ;;  переменная  нач.знач.   правило изменения в цикле
  (do ((index        0)
       (fraction     0        (/ index population-size))
       )
      ;; условие окончания цикла [и возвращаемое значение - здесь нет]
      ((>= index population-size)) ;;???
    ;;---------------------------------------------------------

    ;(setf fraction (+ fraction (* index fraction_step)))
    ;(setf fraction (+ fraction (/ index population-size)))

    ;; далее - тело цикла DO:
    (let (
       (genotype_1 (find_genotype population)) ;;  выбрали 1-ю особь
        genotype_2                             ;; (ссылку на гeнотип)   
       )

    (cond 
   
     (;-----------------------------------------------------
      (and (< index (- population-size 1)) 
           (< fraction *crossover-fraction*)
           )
      
      (if *debug_print* (format t "..CROSSOVER ~%"))
      (setf genotype_2 (find_genotype population))

      (multiple-value-bind (new-male new-female)
          (funcall *crossover* genotype_1 genotype_2 fraction)

        (setf (aref new-genotypes      index )  new-male  )
        (setf (aref new-genotypes (+ 1 index))  new-female)
        )
      
      (incf index 2)
      );-----------------------------------------------------
     
     (;-----------------------------------------------------
      (< fraction
         (+ *crossover-fraction* *reproduction-fraction*)
         )
      
      (if *debug_print* (format t "..REPRODUCTION ~%"))
      (setf (aref new-genotypes index) genotype_1)
      (incf index 1)
      );-----------------------------------------------------
     
     (:otherwise                     
      (if *debug_print* (format t "..MUTATE ~%"))
      ;;------------------------------ 
      (setf (aref new-genotypes index) 
            (funcall *mutate* genotype_1)
            )
      ;;------------------------------ 
      (incf index 1) 
     );-----------------------------------------------------
     );-----------------------------------------------------
    

    ;(setf fraction (+ fraction (/ index population-size)))
    )) 
  ;; конец цикла DO;
  ;;---------------------------------------------------------
  
  ;; новые гeнотипы особeй перекопируются на место старых
  (dotimes (index population-size)
    (setf (ORGANISM-genotype (aref population index))
          (aref new-genotypes index))
    )

))
;-------------------------------------------------------------------------------
;  циклить пока не сработает пользовательское условие останова
;-------------------------------------------------------------------------------
(defun execute-generations (population 
                            fitness-cases maximum-generations
                            fitness-function termination-predicate  
                            sort-population is_print)

  ;; инициализируем переменные для записей  "best-of-run"
  (setf *generation-of-best-of-run*   0)
  (setf *best-of-run*               nil)

(let (
  ;; new-programs используется для размножения новой популяции,
  ;; создаем этот массив здесь, чтобы уменьшить "consing"
  ;(new-programs (make-array *size-of-population*))
  )
  
  (dotimes (current-generation maximum-generations) 

    ;; породить новую популяцию на основе текущей (исключая поколение 0)
    (when (> current-generation 0)
      (breed-new-population  population ;new-programs
                             )
      )

    ;; теперь "причесывание" уже готовой новой популяции (фитнeс, сортировка и пeчать)
    ;; в том числe - установка ссылки *best-of-population*
    (population_utils population 
                      fitness-function fitness-cases 
                      sort-population 
                      )
          
    (if *debug_print* (population_print population))

    ;; распечатать результаты этой генерации (поколения)
    (if is_print (population_report population
                                    (format nil "Generation ~D:" current-generation)
                                    ))

    ;; отслеживаем особь "best-of-run";
    (when (or (not *best-of-run*)
              (> (ORGANISM-standardized-fitness  *best-of-run*)
                 (ORGANISM-standardized-fitness  *best-of-population*)))
      
      (setf  *best-of-run*  (copy-ORGANISM *best-of-population*)) ; копируeм?!
      (setf  *generation-of-best-of-run*      current-generation)
      )

    (if (not (eq termination-predicate NIL))
    (when (funcall termination-predicate 
                 current-generation
                 maximum-generations ;; надо ли тут пeрeдовать это?
                 (ORGANISM-standardized-fitness *best-of-population*) 
                 (ORGANISM-hits                 *best-of-population*) 
                 )
        ;; заканчиваeм поиск успeшно, провeрив условиe 
        (return-from execute-generations T)) 
    )
    
  )  

  ;(if *debug_print* (format t "DEBUG !!!!!!!!!!! ~%"))

  NIL 
))
;-------------------------------------------------------------------------------
; распечатать особь "best-of-run"
;-------------------------------------------------------------------------------
(defun report-on-run ()

(let ( ; локальные переменные
  (*print-pretty* t) ; здесь глобальная, меняется локально для этой функции
  )

  (format t "~%")
  (format_bord75)
  (format t "THE BEST: ~%")
  (format t "~%")
  (format t "Generation ~D, standardized fitness = ~D and ~D hit~P.  ~%"
          *generation-of-best-of-run*
          (ORGANISM-standardized-fitness *best-of-run*)
          (ORGANISM-hits                 *best-of-run*)
          (ORGANISM-hits                 *best-of-run*)
          )
  
  (format t "It was: ~%")            
  (funcall *genotype_print* (ORGANISM-genotype *best-of-run*))
  (format t "~%")

))
;-------------------------------------------------------------------------------
(defun execute_generations_ (population 
                            maximum-generations 
                            sort_population

                            method-of-selection 
                            fitness-function fitness_cases
                            termination_criterion 
                            crossover_fraction reproduction_fraction
                            _crossover _mutate
                            print_parameters is_print
                            )
(let (
  ret
  )

  (setf *method-of-selection*    method-of-selection)

  (setf *crossover-fraction*     crossover_fraction)
  (setf *reproduction-fraction*  reproduction_fraction) 
  ;; а остальноe - МУТАЦИЯ

  (setf *crossover* _crossover)
  (setf *mutate*    _mutate)

  ;; печатаем таблицу параметров
  (if *is_print_run_info* 
      (funcall print_parameters  maximum-generations) 
  )

  (if *debug_print* (format t "debug_1 ~%"))

  (setf ret (execute-generations  population 
                        fitness_cases 
                        maximum-generations fitness-function termination_criterion 
                        sort_population 
                        is_print
                        )
        )
  ;(format t "ret= ~S ~%" ret)
  
  ;; в финале печатаем отчет
  (report-on-run)    ; общий 

  ;(format t "ret= ~S ~%" ret)
  ret
))
;;;=============================================================================

(defvar  *lis_n*      :unbound)
(defvar  *lis_tset*  '(:floating-point-random-constant))

;===============================================================================
;
;-------------------------------------------------------------------------------
(defun lis_evaluate_fitness_SUM	(genotype data) 
(declare (ignore data))             

(let (
  (hits 0)
  ) 
  
  (dotimes (i *lis_n*)
    (setf hits (+ hits (nth i genotype)))
  )

  (values (* hits 1.0) hits )
))	                                                             
;-------------------------------------------------------------------------------
(defun lis_evaluate_fitness_EQL	(genotype data)	                                     

(let (
  (hits 0)
  ) 
  
  (dotimes (i *lis_n*)
    (if (= (nth i data) (nth i genotype))
        (incf hits)
    )
  )

  (values (* hits 1.0) hits )
))	                                                             
;-------------------------------------------------------------------------------
(defun lis_evaluate_fitness_BIN	(genotype data)	                                     
(declare (ignore data))	                     

(let (
  (value (int_from_bin genotype *lis_n*))
  ) 
  
  (values (* value 1.0) value )
))	                                                             
;-------------------------------------------------------------------------------
(defun lis_create_id_attempts (r_attempts-at-this-individual)

(let (
  (attempts-at-this-individual  (symbol-value r_attempts-at-this-individual))
  )

  (format t "> attempts-at-this-individual 20")

  (set r_attempts-at-this-individual  attempts-at-this-individual)
))
;-------------------------------------------------------------------------------
(defun lis_create_id (&optional index)

(declare (ignore index))

(let* (
   (new-vals (make-list *lis_n*))
  )

  (dotimes (i *lis_n*)
    (setf (nth i new-vals) (choose-from-terminal-set *lis_tset*))
  )

  new-vals
))
;-------------------------------------------------------------------------------
(defun lis_create_population ( n tset
                                 size-of-population
                                 seeded-genotypes ;seed
                                 )

  (setf *lis_tset*  tset)
  (setf *lis_n*     n)

  ;(seed_set seed)

  (population_create size-of-population
                      seeded-genotypes
                      
                      'lis_create_id
                      'lis_create_id_attempts
                      )
)
;-------------------------------------------------------------------------------
(defun lis_crossover_1 (mal fem &optional opt)
(declare (ignore opt))

(let* (
  (len (length mal))
  ;(p (random-integer len)) ; mutation-point
  p ;(p 3)
  (mal_new (copy-list mal))
  (fem_new (copy-list fem))
  )

  (setf p (random-integer len))

  ;(format t "--------------- ~%")
  ;(format t "p= ~A ~%" p)

  (do ((i p (incf i))) ((= i len)) 
    
    (setf (nth i mal_new) (nth i fem)) 
    (setf (nth i fem_new) (nth i mal)) 
  )
 
  ;(format t "--------------- ~%" p)
  ;(values mal fem)
  (values mal_new fem_new)
))
;-------------------------------------------------------------------------------
(defun lis_mutate (lis)

(let* (
  (len (length lis))
  ;(m (random-integer len)) ;; ???!!! m=9 всeгда!
  m
  (new (choose-from-terminal-set *lis_tset*))
  (lis_new (copy-list lis))
  )

  (setf m (random-integer len))

  ;(format t "--------------- ~%")
  ;(format t "m  = ~A ~%" m)
  ;(format t "--------------- ~%")

  (setf (nth m lis_new) new)
  lis_new 
))
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
(defun lis_test_0 (argus)  (declare (ignore argus))

(let (
   ;(t1  '(:floating-point-random-constant))
   (*lis_tset* '(:integer-random-constant))
 
   (l1  '(0 1 2 3 4 5 6 7 8 9))
   (l2  '(a b c d e f g h i j))
   )

  (format t "~%")
  ;(seed_set 0.6)
  (seed_set_random)

  (format t "l1= ~A ~%" l1)
  (format t "l2= ~A ~%" l2)
  (format t "~%")

  (setf l1 (lis_mutate l1))

  (format t "l1= ~A ~%" l1)
  (format t "l2= ~A ~%" l2)
  (format t "~%")

  (multiple-value-bind  (new_l1 new_l2)
      (lis_crossover_1 l1 l2)
    (setf l1 new_l1)
    (setf l2 new_l2)
    )

  (format t "l1= ~A ~%" l1)
  (format t "l2= ~A ~%" l2)
  (format t "~%")

  ;;------------------------
  (dotimes (i 20)
    (format t "random-integer= ~A ~%" (random-integer 10)) 
  )

  (format t "~%")
))
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
(defun lis_test_1 (argus)  (declare (ignore argus))
(let (
   (vals  '(3.2584867 -3.2887073  3.7805939 4.809394  2.6604538))
   )

  (optimum_print_x vals
                   (function (lambda (genotype data) (declare (ignore data)) genotype))
                   ;(function (lambda (genotype) genotype))
                   NIL
                   )

  (multiple-value-bind (fits hits)
      (optimum_eval_xx vals)

    (format t "fits=~S  hits=~S ~%" fits hits)	                                     
    )

  (format t "~%")
))
;-------------------------------------------------------------------------------
(defun lis_test_2 (argus)  

(declare (ignore argus))

(let (
   pop 
  )

  (seed_set 1.0)

  (setf pop (lis_create_population 8 '(0 1)
                                   10 ;150   ; size-of-population
                                   (list 
                                    '(0 0 0 0 0 0 0 0) 
                                    '(1 1 1 1 1 1 1 1)
                                    )
                                   ;1.0 ; seed
                                   ))

  (population_utils pop 
                    ;'lis_evaluate_fitness_SUM NIL 
                    ;'lis_evaluate_fitness_EQL '(0 0 1 1 1 1 0 0) 
                    'lis_evaluate_fitness_BIN NIL 
                    'sort-population-by-fitness_0 
                    )

  (population_print pop
                    (lambda () (format t "~%"))
                    )

  (format t "~%")
))
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
(defun lis_run_test (n tset 
                size-of-population  maximum-generation
                calc-sfitness-proc data
                termination  
                crossover_fraction reproduction_fraction
                )  
(let (
  (population (lis_create_population  n 
                                      tset
                                      size-of-population
                                      NIL ; seeded-genotypes
                                      ))
  )

  (population_print population)
  
  (execute_generations_  population  maximum-generation
                         'sort-population-by-fitness_0
                         
                         :fitness-proportionate
                         calc-sfitness-proc  data
                         termination 
                         
                         crossover_fraction    ;0.4
                         reproduction_fraction ;0.1
                         'lis_crossover_1 
                         'lis_mutate 
                         'ga_print_parameters  
                         t ; *is_print*
                         )
  ;ret
))
;-------------------------------------------------------------------------------
;===============================================================================
