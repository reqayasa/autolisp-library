; (defun c:igetloc () 
;   (if (= DIVIDE_BY nil) (setq DIVIDE_BY 2500))
;   (if (= ADD_BY nil) (setq ADD_BY 1))
;   ; (setq DIVIDE_BY 2500)

;   (setq TMP_DIVIDE_BY (getreal (strcat "\n Divide By<" (rtos DIVIDE_BY 2 0) ">: " )))
;   (if TMP_DIVIDE_BY 
;     (setq DIVIDE_BY TMP_DIVIDE_BY)
;   )

;   (setq TMP_ADD_BY (getreal (strcat "\n Add By<" (rtos ADD_BY 2 0) ">: " )))
;   (if TMP_ADD_BY 
;     (setq ADD_BY TMP_ADD_BY)
;   )
  
;   ; (initget "Select DivideBy AddBy Mode")
;   ; (setq OPTION (getkword 1 "[Select/DivideBy/AddBy/Mode]"))
  
;   (princ "\nSelect Dimension")
;   (setq 
;     LIST_DIM (ssget '((0 . "DIMENSION")))
;     LEN      (sslength LIST_DIM)
;     LEN1     LEN
;   )

;   (repeat LEN 
;     (setq
;       LEN2             (1- LEN1)
;       ENTITYNAME       (ssname LIST_DIM LEN2)
;       ENTITYDATA       (entget ENTITYNAME)
;       ENTITYMEASURMENT (cdr (assoc 42 ENTITYDATA))
;       CALC_LOC         (+ (/ ENTITYMEASURMENT DIVIDE_BY) ADD_BY)
;       LOC_STRING       (strcat (rtos CALC_LOC 2 0) " LOC")
;       LEN1             LEN2
;     )
;     (command "._dimedit" "_N" LOC_STRING ENTITYNAME "")
;   )

;   (princ)
; )



(defun c:iGetLoc () 
  (if (= divide-by nil) (setq divide-by 2500))
  (if (= add-by nil) (setq add-by 1))

  (while t 
    (princ (strcat "\nCurrent Settings: Devide by = " (rtos divide-by 2 0)
                ", Add by = " (rtos add-by 2 0) 
    ))
    (initget "Select DivideBy AddBy Mode")
    (setq option (getkword "\n[Select/DivideBy/AddBy/Mode]: <Select>"))

    ;; Check if the user pressed Escape
    (if (not option) 
      (progn 
        (princ "\nExiting...")
        (exit)
      )
    )

    (cond 
      ((= option "Select") (SelectDimensions))
      ((= option "DivideBy") (SetDivideBy))
      ((= option "AddBy") (SetAddBy))
      (t (SelectDimensions))
    )

    ;; Only proceed to editing if the user has selected dimensions and the option is not Select, DivideBy, or AddBy
    (if 
      (and selection-set 
           (not (eq option "DivideBy"))
           (not (eq option "AddBy"))
      )
      (EditDimensions)
    )
  )
  (princ)
)

(defun SelectDimensions () 
  (princ "\nSelect Dimension")
  (setq selection-set (ssget '((0 . "DIMENSION"))))
  (if selection-set 
    (princ 
      (strcat "\nNumber of dimensions selected: " 
              (itoa (sslength selection-set))
      )
    )
    (princ "\nNo dimensions selected.")
  )
)

(defun SetDivideBy () 
  (setq tmp-divide-by (getreal 
                        (strcat "\nDivide By <" (rtos divide-by 2 0) ">: ")
                      )
  )
  (if tmp-divide-by 
    (setq divide-by tmp-divide-by)
  )
  (princ (strcat "\nNew Divide By value: " (rtos divide-by 2 0)))
)

(defun SetAddBy () 
  (setq tmp-add-by (getreal (strcat "\nAdd By <" (rtos add-by 2 0) ">: ")))
  (if tmp-add-by 
    (setq add-by tmp-add-by)
  )
  (princ (strcat "\nNew Add By value: " (rtos add-by 2 0)))
)

(defun EditDimensions () 
  (setq i 0)
  (princ "its get here")
  (while (< i (sslength selection-set)) 
    (setq entity-name        (ssname selection-set i)
          entity             (entget entity-name)
          entity-measurement (cdr (assoc 42 entity))
          count              (+ (/ entity-measurement divide-by) add-by)
          text               (strcat (rtos count 2 0) " LOC")
          i                  (1+ i)
    )
    (princ (strcat "\nEditing dimension: " (vl-princ-to-string entity-name)))
    (command "._dimedit" "_N" text entity-name "")
  )
  ;; Clear the selection set after editing
  (setq selection-set nil)
  (princ)
)