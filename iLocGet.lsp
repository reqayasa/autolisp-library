;; Filename: iLocGet.lsp
;; Purpose: Automatically calculate the number of sockets based on length measurements
;;          from dimension lines and update the dimension lines with the calculated values.
;; Parameters:
;; - Select: Select dimension lines to calculate.
;; - DivideBy: Change the divisor value used in the calculation.
;; - AddBy: Change the value to add after dividing.
;; - Threshold: Set the threshold value to control rounding. If the fractional part of the 
;;              calculated value is less than or equal to the threshold, it rounds down; 
;;              otherwise, it rounds up.
;; Date: August 2, 2024
;; Version: 0.8

(defun c:iLocGet () 
  (princ "version 0.8")
  (if (= divide-by nil) (setq divide-by 2500))
  (if (= add-by nil) (setq add-by 1))
  (if (= mode nil) (setq mode "Normal"))
  (if (= threshold nil) (setq threshold 0.25))

  (while t 
    (princ 
      (strcat "\nCurrent Settings: Mode = " 
              mode
              ", Devide by = "
              (rtos divide-by 2 3)
              ", Add by = "
              (rtos add-by 2 3)
              ", Threshold = "
              (rtos threshold 2 3)
      )
    )
    (initget "Select DivideBy AddBy Threshold Mode")
    (setq option (getkword "\n[Select/DivideBy/AddBy/Threshold/Mode]: <Select>"))

    (cond 
      ((= option "Select") (SelectDimensions))
      ((= option "DivideBy") (SetDivideBy))
      ((= option "AddBy") (SetAddBy))
      ((= option "Threshold") (SetThreshold))
      ((= option "Mode") (SetMode))
      (t (SelectDimensions))
    )

    (if (and selection-set (eq option "Select")) 
      (EditDimensions)
    )
  )
  (princ)
)

(defun SelectDimensions () 
  (princ "\nSelect Dimension")
  (setq selection-set (ssget '((0 . "DIMENSION"))))
  (if selection-set 
    (progn 
      (EditDimensions)
      (princ 
        (strcat "\nNumber of dimensions selected: " 
                (itoa (sslength selection-set))
        )
      )
    )
    (princ "\nNo dimensions selected.")
  )
)

(defun SetDivideBy () 
  (setq tmp-divide-by (getreal 
                        (strcat "\nDivide By <" (rtos divide-by 2 3) ">: ")
                      )
  )
  (if tmp-divide-by 
    (setq divide-by tmp-divide-by)
  )
  (princ (strcat "\nNew Divide By value: " (rtos divide-by 2 3)))
)

(defun SetAddBy () 
  (setq tmp-add-by (getreal (strcat "\nAdd By <" (rtos add-by 2 3) ">: ")))
  (if tmp-add-by 
    (setq add-by tmp-add-by)
  )
  (princ (strcat "\nNew Add By value: " (rtos add-by 2 3)))
)

(defun SetThreshold () 
  (setq tmp-threshold (getreal (strcat "\nThreshold <" (rtos threshold 2 3) ">: ")))
  (if tmp-threshold 
    (setq threshold tmp-threshold)
  )
  (princ (strcat "\nNew Threshold value: " (rtos threshold 2 3)))
)

(defun EditDimensions (/ entity-name entity entity-measurement count text i) 
  (setq i 0)
  (princ "its get here")
  (while (< i (sslength selection-set)) 
    (setq 
      entity-name        (ssname selection-set i)
      entity             (entget entity-name)
      entity-measurement (cdr (assoc 42 entity))
      count              (RoundWithThreshold 
                            (+ (/ entity-measurement divide-by) add-by)
                            threshold
                          )
      text               (if (= mode "Normal") 
                            (strcat (rtos count 2 0) " LOC")
                            (strcat 
                              (rtos entity-measurement 2 0) 
                              "\n"
                              (rtos count 2 0)
                              " LOC / "
                              (rtos (/ entity-measurement (- count 1)) 2 0)
                            )
                          )
      i                  (1+ i)
    )
    (princ (strcat "\nEditing dimension: " (vl-princ-to-string entity-name)))
    (command "._dimedit" "_N" text entity-name "")
  )
  ;; Clear the selection set after editing
  (setq selection-set nil)
  (princ "\nFinished editing dimensions.")
)

(defun SetMode () 
  (initget "Normal Verbose")
  (setq tmp-mode (getkword (strcat "\nMode [Normal/Verbose] <" mode ">:")))
  (if tmp-mode 
    (setq mode tmp-mode)
  )
  (princ (strcat "\nNew Mode value: " mode))
)

(defun RoundWithThreshold (number threshold) 
  (if (<= (- number (fix number)) threshold) 
    (fix number)
    (1+ (fix number))
  )
)
