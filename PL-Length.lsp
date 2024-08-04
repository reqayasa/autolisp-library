(defun c:plLength ()
  (princ "\nversion 0.0.5")
  (princ "\nSelect polyline as Reference:")

  ;; Get the selection set of polylines
  (setq selection-set (ssget '((0 . "LWPOLYLINE"))))

  ;; Initialize list for unique line-groups
  (setq line-reference '())

  ;; Check if anything was selected
  (if selection-set
    (progn
      ;; Initialize counter
      (setq i 0)

      ;; Loop through each entity in the selection set
      (while (< i (sslength selection-set))
        ;; Get the entity name and entity data
        (setq ent-name (ssname selection-set i))
        (setq ent (entget ent-name))

        ;; Extract linetype and color
        (setq line-type (cdr (assoc 6 ent)))
        (setq color (cdr (assoc 62 ent)))
        (setq line-group (list line-type color))

        ;; Check if line-group is unique before adding
        (if (not (member line-group line-reference))
          (setq line-reference (cons line-group line-reference)))

        ;; Increment the counter
        (setq i (1+ i))
      )
      
      (princ "\nSelect polyline:")
      (setq selection-set nil)

      ;; Get the selection set of polylines
      (setq selection-set (ssget '((0 . "LWPOLYLINE"))))
      
      (if selection-set 
        (progn 
          (setq i 0)
          (while (< i (sslength selection-set))
            (setq ent-name (ssname selection-set i))
            (setq ent (entget ent-name))

            ;; Extract linetype and color
            (setq line-type (cdr (assoc 6 ent)))
            (setq color (cdr (assoc 62 ent)))
            (setq line-group (list line-type color))
          )          
        ))
      
      

      ;; Print unique line-groups
      (princ "\nUnique Linetype and Color of Selected Polylines:")
      (foreach group line-reference
        (princ (strcat "\nLinetype: " (if (car group) (car group) "None")
                      ", Color: " (if (cadr group) (itoa (cadr group)) "None")))
      )
    )
    ;; No selection was made
    (princ "\nNo polylines selected.")
  )

  ;; End function
  (princ)
)

(defun get-polyline-length(ent)
  (setq entity-length (vlax-curve-getDistAtParam entity (vlax-curve-getEndParam entity)))
)


