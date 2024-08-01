(defun c:SelectPolylinesByColor () 
  (setq colorCode 1) ; Replace with your desired color code (e.g., 1 for red)
  (setq ss (ssget "X" (list (cons 0 "LWPOLYLINE") (cons 62 colorCode)))) ; Select polylines with the specified color
  (if ss 
    (progn 
      (princ (strcat "\nNumber of polylines selected: " (itoa (sslength ss))))
    )
    (princ "\nNo polylines found with the specified color.")
  )
  (princ)
)