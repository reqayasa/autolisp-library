; (defun c:plLength(/ i ss-get)
;   (princ "\nVersion 0.0.5")
;   (princ "\nSelect polyline as Reference:")
;   (setq ss-get (ssget '((0 . "LWPOLYLINE"))))

;   (setq ref-linetype (cdr (assoc 6 (entget (ssname ss 0)))))
;   (setq ref-color (cdr (assoc 62 (entget (ssname ss 0)))))

; )


(defun testloop()
  (setq the-list (list 'a 'b 'c 'd))
  (e-loop 0 the-list)
  (print)
)

(defun e-loop(index my-list)
  (if (< index (length my-list))
    (progn
      (print (nth index my-list))
      (e-loop (1+ index) my-list)
    )
  )
)