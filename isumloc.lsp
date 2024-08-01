(defun c:isumloc () 
  (setq LST (ssget '((0 . "DIMENSION")))) 
  (setq COUNT 0)
  (if LST 
    (progn 
      (setq i 0)
      (while (< i (sslength LST)) 
        (setq entName (ssname LST i))
        (setq ent (entget entName))
        (setq textOverride (cdr (assoc 1 ent))) ; Get the text override value
        (setq n (extract-number textOverride))
        (setq COUNT (+ COUNT n))
        (setq i (1+ i))
      )
    )
  )
  (princ (strcat "\ntotal count: " (itoa COUNT)))
  (princ)
)

(defun extract-number (str) 
  (atoi (vl-string-trim "LOC" str))
)