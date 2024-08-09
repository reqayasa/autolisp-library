(defun RoundWithThreshold (number threshold) 
  (if (<= (- number (fix number)) threshold) 
    (fix number)
    (1+ (fix number))
  )
)


(defun truncate (number) 
  (if (>= number 0) 
    (floor number)
    (ceiling number)
  )
)


(defun ceiling (x) 
  (if (= x (fix x)) 
    x
    (1+ (fix x))
  )
)

(defun floor (x) 
  (fix x)
)