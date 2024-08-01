; (defun c:iGetLoc () 
;   (if (= divide-by nil) (setq divide-by 2500))
;   (if (= add-by nil) (setq add-by 1))

;   (while t 
;     (initget "Select DivideBy AddBy Mode Exit")
;     (setq option (getkword "\n[Select/DivideBy/AddBy/Mode/Exit]: <Select>"))

;     (cond 
;       ((= option "Select")
;        (progn 
;          (princ "\nSelect Dimension")
;          (setq selection-set (ssget '((0 . "DIMENSION"))))
;          (if selection-set 
;            (princ 
;              (strcat "\nNumber of dimensions selected: " 
;                      (itoa (sslength selection-set))
;              )
;            )
;            (princ "\nNo dimensions selected.")
;          )
;        )
;       )
;       ((= option "DivideBy")
;        (progn 
;          (setq tmp-divide-by (getreal 
;                                (strcat "\nDivide By <" (rtos divide-by 2 0) ">: ")
;                              )
;          )
;          (if tmp-divide-by 
;            (setq divide-by tmp-divide-by)
;          )
;          (princ (strcat "\nNew Divide By value: " (rtos divide-by 2 0)))
;        )
;       )
;       ((= option "AddBy")
;        (progn 
;          (setq tmp-add-by (getreal (strcat "\nAdd By <" (rtos add-by 2 0) ">: ")))
;          (if tmp-add-by 
;            (setq add-by tmp-add-by)
;          )
;          (princ (strcat "\nNew Add By value: " (rtos add-by 2 0)))
;        )
;       )
;       ((= option "Exit")
;        (progn 
;          (princ "\nExiting...")
;          (exit)
;        )
;       )
;       (t        (progn 
;          (princ "\nSelect Dimension")
;          (setq selection-set (ssget '((0 . "DIMENSION"))))
;          (if selection-set 
;            (princ 
;              (strcat "\nNumber of dimensions selected: " 
;                      (itoa (sslength selection-set))
;              )
;            )
;            (princ "\nNo dimensions selected.")
;          )
;        ))
;     )

;     ;; Only proceed to editing if the user has selected dimensions and the option is not Select, DivideBy, or AddBy
;     (if 
;       (and selection-set 
;            (not (eq option "DivideBy"))
;            (not (eq option "AddBy"))
;       )
;       (progn 
;         (setq i 0)
;         (princ "its get here")
;         (while (< i (sslength selection-set)) 
;           (setq entity-name        (ssname selection-set i)
;                 entity             (entget entity-name)
;                 entity-measurement (cdr (assoc 42 entity))
;                 count              (+ (/ entity-measurement divide-by) add-by)
;                 text               (strcat (rtos count 2 0) " LOC")
;                 i                  (1+ i)
;           )
;           (princ (strcat "\nEditing dimension: " (vl-princ-to-string entity-name)))
;           (command "._dimedit" "_N" text entity-name "")
;         )
;         ;; Clear the selection set after editing
;         (setq selection-set nil)
;       )
;     )
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