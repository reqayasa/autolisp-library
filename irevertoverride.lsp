(defun c:iRevertOverride () 
  (princ "\nSelect Dimension")
  (setq selection-set (ssget '((0 . "DIMENSION"))))
  (if selection-set 
    (progn 
      (setq i 0)
      (while (< i (sslength selection-set)) 
        (setq entity-name (ssname selection-set i))
        (setq entity (entget entity-name))
        ; (princ (strcat "\nOriginal entity: " (vl-princ-to-string entity))) ; Debug print
        (setq entity (subst (cons 1 "") (assoc 1 entity) entity)) ; Remove the text override
        ; (princ (strcat "\nModified entity: " (vl-princ-to-string entity))) ; Debug print
        (entmod entity) ; Modify the entity
        (entupd entity-name) ; Update the entity in the drawing database
        (setq i (1+ i))
      )
      (princ "\nText overrides removed from selected dimensions.")
    )
    (princ "\nNo dimensions selected.")
  )
  (princ)
)