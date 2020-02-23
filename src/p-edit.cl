
;;;=============================================================================
;;; e_edit.cl
;;;=============================================================================


;;;=============================================================================

; Appendix F:
; Editor for Simplifying S-Expressions

;;;=============================================================================

; ���� ������������ ����� ������ ��� �� ������ �������� S-��������� ������ �  
; ��������� ��� �������, �� ����������� ������ ��� �������� ��� ��������� 
; ���������� ������ S-��������� � �������� ������ � ������ � ��������.
; 
; �������� ��� ���� ����� �������� ����� (�������������)  ������, ������� 
; ���������� ��������� ������� �������������� � ������� S-���������. �������
; �������������� - ��������� ����������.

; ��������, ���� ������������ ������ ��������� ��������, ���� �� ��������� 
; ������ �����: ��������� "(and x x)" � "x", ����� ��� ��� ������� � 
; floating-point �����������: ��������� "(- x x)" � "0.0".
 
; ���������� ������ �������������� ����� ���� ����� �������� �� �������, ���������
; ������� ���������� ���� ������ � ������� ���� ������ � ����� ���������� 
; ������������ ������� ����������� �����-�� �������� ���� �� ����������� 
; ���������� ������ ������..

; ������� �������������� �������� ������� ����� "def-edit-rule". 
; � ����� �����������, 6 ������� ������ ����� ������� ���� ������ ��� ���������
; *booleanrules*.

; ������������ ����� ����������� ���� ����������� ������� �������������� ��� 
; ������ ���������� ��������.
;;;=============================================================================


;-------------------------------------------------------------------------------
;   ���������� ������ �� RULE-BASE ��� ��������������  SEXPRESSION �
;   ���������� �����.
;-------------------------------------------------------------------------------
(defun edit-top-level-sexpression (sexpression rule-base)

(let (
   (location (list sexpression)) ;; ����� ������ ��� ������������ ������ ?? 
   )                             ;; �������� ��� ������..

  ;; �, ������� - ����� � ����� ���� ������� ���� ��������?
  (edit-sexpression rule-base location sexpression)
  location
))
;-------------------------------------------------------------------------------
; ���� ���� ������ (������ ������), s-��������� � 
; location of that sexpression in the containing expression

; �������� ������� � s-��������� � ��� ���������� ����������
; (���� �� ����� ���������� ������������ ���������).
;-------------------------------------------------------------------------------
(defun edit-sexpression (rule-base location sexpression)

  ;; ��������� ������� �������������� � ������� ��������� (?);
  ;; ���� ���-�� ����������, ����������� �����..

  (when (consp sexpression) ; ������, �� ��� ��� ���� ��� ����-���� (?)

    (if *debug_print* (format *error-output* "consp sexpression ~%"))

    (do* (; var          init               step
          (args         (rest sexpression) (rest args))
          (arg          (first args)       (first args))
          (arg-location (rest sexpression) (rest arg-location))
          (changed-p                                       ; ����������
            (edit-sexpression rule-base arg-location arg)  ; ��������� 
            (edit-sexpression rule-base arg-location arg)) ; �������� �� ����
          )

         ;; ������� ��������� ����� � ��������� (end-test . result)
         (
          (not args)
          (when changed-p (edit-sexpression rule-base location sexpression))
         )

      nil ; ��������� ���� ����� (��� �������� ��� ������� � �����)
      )
  )

  ;; ��������� ������� �������������� � ����� ���������;
  ;; �������, ��� ���-�� ���� ��������, ����  �����-���� ������� ���������

  (let ((changed-p nil))

    (dolist (clause rule-base)
    (let* (
           (condition (second clause))
           (action    (third  clause))
           (applicable-p (funcall condition sexpression))
           )

      (when applicable-p ; (when p a b c) == (if p (progn a b c) nil) 
        (funcall action location sexpression)
        (setf changed-p t)
        )
    ))

    changed-p
  )

)
;-------------------------------------------------------------------------------
;   Is true of an sexpression if it evaluates to a constant.
;   Note that this can be a problem domain specific problem.
;-------------------------------------------------------------------------------
(defun constant-expression-p (sexpression)

  (if (consp sexpression)

      (do* (
            (args (rest sexpression) (rest args))
            (arg  (first args) (first args))
            )
          ((not args) t)

        ;; ���� �����
        (unless (constant-expression-p arg)
          (return nil))
        )

      ;;; Assumes that variable quantities are always symbols
      ;;; and assumes that any symbol that is not self-
      ;;; evaluating is not constant (this will fail for pi)
      ;;; so to solve more general problems some extra
      ;;; convention would be required.

      (or (not (symbolp sexpression))
          (keywordp sexpression)
          (and (boundp sexpression)
               (eq sexpression (symbol-value sexpression)))
          )
  )
)
;-------------------------------------------------------------------------------
;   Declares an edit rule called RULE-NAME in the RULE-BASE.  
;   SEXPRESSION-NAME is the local name to be given to the 
;   sexpression on which this rule is being invokes.  The
;   CONDITION clause is evaluated, and if it is true, the
;   ACTION clause is evaluated.  The action clause should 
;   make calls to REPLACE-SEXPRESSION to perform an edit.
;-------------------------------------------------------------------------------
(defmacro def-edit-rule  (rule-name rule-base (sexpression-name)
                          &key condition action)

  (assert (and condition action) ()
    "Both a condition and an action must be supplied.")

  `(setf ,rule-base
         (cons (list ',rule-name
                     #'(lambda (,sexpression-name) ,condition)
                     #'(lambda (location ,sexpression-name)
                         ,sexpression-name ,action))
               (remove (assoc ',rule-name ,rule-base :test #'eq)
                       ,rule-base)))
)
;-------------------------------------------------------------------------------
;   The form to use in an edit rule that registers an edit.
;   For example, if the sexpression being edited is to be 
;   replaced with the first argument to the function of the
;   sexpression then we would say:  (replace-sexpression (second
;   the-sexpression)), where the-sexpression is the name of the
;   sexpression supplied as an argument to def-edit-rule.  This
;   example would be useful if the function in question was an
;   identity function.  Thus:
;   (def-edit-rule remove-identity-functions *my-rule-base*
;                 (the-sexpression)
;    :condition (and (consp the-sexpression)
;                    (eq (first the-sexpression) 'identity))
;    :action (replace-sexpression (second the-sexpression)))
;-------------------------------------------------------------------------------
(defmacro replace-sexpression (new-sexpression)

  `(setf (first location) ,new-sexpression))

;;;=============================================================================




;;;=============================================================================
;;; 4) ���� ������

;;; ��� ����������� ������ ������ ��� ��������� ������� s-���������.
;;;=============================================================================

(defvar *boolean-rules* nil
  "The rule base for Boolean problems.")




;-------------------------------------------------------------------------------
; Transforms expressions of the form (not (not <xxx>)) into ;;; <xxx>.
;-------------------------------------------------------------------------------
(def-edit-rule not-not-x->-x *boolean-rules* (sexpression)

  :condition (and (consp sexpression)
                  (consp (second sexpression))
                  (eq (first sexpression) 'not)
                  (eq (first (second sexpression)) 'not))
  :action (replace-sexpression (second (second sexpression)))
)
;-------------------------------------------------------------------------------
; Transforms expressions of the form (or <xxx> t) into t.
;-------------------------------------------------------------------------------
(def-edit-rule or-t->-t *boolean-rules* (sexpression)

  :condition (and (consp sexpression)
                  (eq 'or (first sexpression))
                  (dolist (arg (rest sexpression) nil)
                    (when (and (constant-expression-p arg)
                               (eval arg))
                      (return t))))
  :action (replace-sexpression t)
)
;-------------------------------------------------------------------------------
; Transforms expressions of the form (and nil <xxx>) into nil.
;-------------------------------------------------------------------------------
(def-edit-rule and-nil->-nil *boolean-rules* (sexpression)

  :condition (and (consp sexpression)
                  (eq 'and (first sexpression))
                  (dolist (arg (rest sexpression) nil)
                    (when (and (constant-expression-p arg)
                               (not (eval arg)))
                      (return t))))
  :action (replace-sexpression nil)
)
;-------------------------------------------------------------------------------
; Transforms expressions of the form (and t <xxx>) into <xxx>.
;-------------------------------------------------------------------------------
(def-edit-rule and-t->-x *boolean-rules* (sexpression)

  :condition (and (consp sexpression)
                  (eq 'and (first sexpression))
                  (dolist (arg (rest sexpression) nil)
                    (when (and (constant-expression-p arg)
                               (eval arg))
                      (return t))))
  :action (let ((remaining-args
                  (remove-if #'(lambda (arg)
                                (and (constant-expression-p arg)
                                     (eval arg)))
                             (rest sexpression))))
            (replace-sexpression
              (case (length remaining-args)
                (0 t)
                (1 (first remaining-args))
                (otherwise (cons 'and remaining-args)))))
)
;-------------------------------------------------------------------------------
; Transforms expressions of the form (or <xxx> nil) into  <xxx>.
;-------------------------------------------------------------------------------
(def-edit-rule or-nil->-x *boolean-rules* (sexpression)

  :condition (and (consp sexpression)
                  (eq 'or (first sexpression))
                  (dolist (arg (rest sexpression) nil)
                    (when (and (constant-expression-p arg)
                               (not (eval arg)))
                      (return t))))
  :action (let ((remaining-args
                  (remove-if #'(lambda (arg)
                                (and (constant-expression-p arg)
                                     (not (eval arg))))
                             (rest sexpression))))
            (replace-sexpression
              (case (length remaining-args)
                (0 nil)
                (1 (first remaining-args))
                (otherwise (cons 'or remaining-args)))))
)
;-------------------------------------------------------------------------------
; In addition, the following rule converts multiple calls into one call with 
; multiple arguments:

; Combines calls to AND and OR into their polyadic forms, so 
; (and (and <xxx> <yyy>) <zzz>) will be transformed into (and  <xxx> <yyy> <zzz>).
;-------------------------------------------------------------------------------
(def-edit-rule polyadicize *boolean-rules* (sexpression)

  :condition (and (consp sexpression)
                  (member (first sexpression) '(and or)
                          :test #'eq)
                  (dolist (arg (rest sexpression) nil)
                    (when (and (consp arg)
                               (eq (first arg)
                                   (first sexpression)))
                      (return t))))
  :action (let ((interesting-arg
                  (dolist (arg (rest sexpression) nil)
                    (when (and (consp arg)
                               (eq (first arg)
                                   (first sexpression)))
                      (return arg)))))
            (replace-sexpression
              (cons (first sexpression)
                    (append (rest interesting-arg)
                            (remove interesting-arg
                                    (rest sexpression))))))
)
;;;=============================================================================
; � ����������, ������������ ����� �������� ������������ ���� �� ������� De Morgan.

; Since the total number of possible fitness cases is finite for Boolean 
; functions, it is possible to develop editing rules which evaluate a given
; subS-expression for all possible fitness cases. If the subS-expression 
; evaluates a particular constant value, that constant value can be substituted 
; for the S-expression. In this way, it is possible to simplify complicated 
; S-expressions to a constant.

;;;=============================================================================

;; 3) �������� ��� ��������� s-��������� (sexpressions)
;; 4) ���� ������ (��� ��������� ������� s-���������)

  
;-------------------------------------------------------------------------------
(defun edit_0 (argus)  (declare (ignore argus))

  (print (edit-top-level-sexpression '(and x t)         *boolean-rules*)) 
  (print (edit-top-level-sexpression '(and t x)         *boolean-rules*)) 
  (print (edit-top-level-sexpression '(not (not x))     *boolean-rules*)) 
  (print (edit-top-level-sexpression '(or  x t)         *boolean-rules*)) 
  (print (edit-top-level-sexpression '(and nil x)       *boolean-rules*)) 
  (print (edit-top-level-sexpression '(or  x nil)       *boolean-rules*)) 
  (print (edit-top-level-sexpression '(and (and x y) z) *boolean-rules*)) 

)
;-------------------------------------------------------------------------------
(defun edit_1 (argus)  (declare (ignore argus))

  (setf *debug_print* t)

  (print (edit-top-level-sexpression '(and x x)         *boolean-rules*)) 

)
;-------------------------------------------------------------------------------
(defun edit_2 (argus)  (declare (ignore argus))

  (setf *debug_print* t)

  (print (edit-top-level-sexpression 
          '(OR (AND (AND D0 D0) (NOT A0)) (AND D1 (AND D1 (OR D0 A0))))  
          *boolean-rules*)) 

;; normal form: 
;; '(or (AND (NOT A0) D0) (AND A0 D1))

)
;;;=============================================================================

