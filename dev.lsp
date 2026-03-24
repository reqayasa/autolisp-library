(defun c:iSumPL () 
  (princ "version 0.1.11 /n")
  (setq selection-set nil)
  (setq total-length 0.0)
  (setq num-corners 0)

  (initget "Normal Style Layer")
  (setq option (getkword 
                 "Select the selection mode \n[Normal/Style/Layer]: <Normal>"
               )
  )

  (cond 
    ((or (not option) (= option "Normal")) (NormalMode))
    ((= option "Style") (StyleMode))
    ((= option "Layer") (LayerMode))
    (t (NormalMode))
  )
  (princ)
)

(defun NormalMode () 
  (princ "Enter Normal Mode")
  (setq selection-set (ssget '((0 . "LWPOLYLINE"))))
  (CalculateLengthAndCorner)
)

(defun StyleMode () 
  (princ "Enter Style Mode")
)

(defun LayerMode () 
  (princ "Enter Layer Mode")
)

(defun CalculateLengthAndCorner () 
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
        
        (setq param 0)
        (setq end-param (vlax-curve-getEndParam entity))      
        (while (<= param end-param) 
          (setq point (vlax-curve-getPointAtParam entity param))
          (setq num-corners (1+ num-corners))
          (setq param (1+ param))
        )
        
        (setq i (1+ i))
      )
      (princ 
        (strcat "\nTotal Length: " 
                (rtos total-length 2 0)
                " mm, "
                "Total Length: "
                (rtos (ceiling (/ total-length 1000)) 2 0)
                " m, "
                "Corner: "
                (itoa num-corners)
        )
      )
    )
  )
)

(defun ceiling (x) 
  (if (= x (fix x)) 
    x
    (1+ (fix x))
  )
)

(defun c:CountPolylineCorners () 
  (princ "\nSelect a polyline:")
  (setq selection-set (ssget '((0 . "LWPOLYLINE"))))
  (if (and selection-set (= (sslength selection-set) 1)) 
    (progn 
      (setq polyline (ssname selection-set 0))
      (setq end-param (vlax-curve-getEndParam polyline))
      (setq num-corners 0)
      (setq param 0)
      (while (<= param end-param) 
        (setq point (vlax-curve-getPointAtParam polyline param))
        (setq num-corners (1+ num-corners))
        (setq param (1+ param))
      )
      (princ (strcat "\nNumber of corners: " (itoa num-corners)))
    )
    (princ "\nPlease select exactly one polyline.")
  )
  (princ)
)