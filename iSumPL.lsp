
(defun c:iSumPL () 
  (princ "version 0.1.8 /n")
  ;; Main function to calculate the total length of polylines based on selection mode.
  (setq selection-set nil)
  (setq total-length 0.0)
  (initget "Normal Style Layer")
  (setq option (getkword "Select the selection mode \n[Normal/Style/Layer]: <Normal>"))

  (cond 
    ;; Normal Mode: Select any polylines
    ((or (not option) (= option "Normal"))
     (setq selection-set (ssget '((0 . "LWPOLYLINE"))))
    )

    ;; Style Mode: Select polylines matching the style of a reference polyline
    ((= option "Style")
     (progn
      (princ "\nSelect reference polyline for style:")
      (setq selection-set (ssget '((0 . "LWPOLYLINE"))))
      (if (and selection-set (= (sslength selection-set) 1)) 
        (progn 
          (setq ref-entity (ssname selection-set 0)) ; Get the first (and only) entity from the selection set
        )
        (princ "\nPlease select exactly one polyline.")
      )
      ; (setq ref-entity (car (ssget '((0 . "LWPOLYLINE")))))
      (if ref-entity 
        (progn 
          (setq ref-entity-data (entget ref-entity))
          ;  (print ref-entity-data) ; Debugging step to print entity data
          (setq ref-color (cdr (assoc 62 ref-entity-data)))
          (setq ref-linetype (cdr (assoc 6 ref-entity-data)))
          (if (or (null ref-linetype) (equal ref-linetype "ByLayer")) 
            (setq ref-linetype (cdr 
                                  (assoc 6 
                                        (tblsearch "LAYER" 
                                                    (cdr (assoc 8 ref-entity-data))
                                        )
                                  )
                                )
            )
          )
          ;  (print ref-linetype) ; Debugging step to print linetype
          (if ref-linetype 
            (setq selection-set (ssget 
                                        (list (cons 0 "LWPOLYLINE") 
                                              (cons 62 ref-color)
                                              (cons 6 ref-linetype)
                                        )
                                )
            )
            (princ "\nLinetype not found or not assigned.")
          )
        )
      )
     )
    )

    ;; Layer Mode: Select polylines matching the layer of a reference polyline
    ((= option "Layer")
     (progn
      (princ "\nSelect reference polyline for layer:")
      (setq ref-entity (car (ssget '((0 . "LWPOLYLINE")))))
      (if ref-entity 
        (progn 
          (setq ref-entity-data (entget ref-entity))
          (setq ref-layer (cdr (assoc 8 ref-entity-data)))
          (setq selection-set (ssget 
                                      (list '(0 . "LWPOLYLINE") (cons 8 ref-layer))
                              )
          )
        )
      )
     )
    )
  )

  ;; Calculate the total length of selected polylines
  (setq total-length 0.0)
  (if selection-set 
    (progn 
      (setq i 0)
      (while (< i (sslength selection-set)) 
        (setq entity (ssname selection-set i))
        (setq entity-length (vlax-curve-getDistAtParam entity 
                                                       (vlax-curve-getEndParam entity)
                            )
        )
        (setq entity-length-rounded (ceiling entity-length))
        (setq total-length (+ total-length entity-length-rounded))
        (setq i (1+ i))
      )
      (princ 
        (strcat "\nTotal Length: " 
                (rtos total-length 2 0)
                " mm, "
                "Total Length: "
                (rtos (ceiling (/ total-length 1000)) 2 0)
                " m"
        )
      )
    )
  )
  (princ)
)

(defun ceiling (x) 
  (if (= x (fix x)) 
    x
    (1+ (fix x))
  )
)