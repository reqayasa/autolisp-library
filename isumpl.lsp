(defun c:iSumPL () 
  (setq selection-set (ssget '((0 . "LWPOLYLINE")))) ; Select all polylines
  (setq total-length 0.0)
  (if selection-set 
    (progn 
      (setq i 0)
      (while (< i (sslength selection-set)) 
        (setq entity (ssname selection-set i))
        (setq entity-length (vlax-curve-getDistAtParam entity (vlax-curve-getEndParam entity)))
        (setq entity-length-rounded (ceiling entity-length))
        (setq total-length (+ total-length entity-length-rounded))
        (setq i (1+ i))
      )
      ; (setq rounded-length (ceiling total-length)) ; Round up the total length
      ; (setq ins-point (getpoint "\n Specify point"))
      (princ (strcat "\nTotal Length: "(rtos total-length 2 0) " mm \nTotal Length: " (rtos (ceiling (/ total-length 1000)) 2 0) " m"))
      ; (command ".TEXT" ins-point pause "0" (rtos rounded-length 2 0)) ; Display the rounded length as text
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