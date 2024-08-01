(defun c:icount () 
  ; Check to see if the Text Style has a height defined - This will return 0.0 if NOT defined
  (setq STYLEHEIGHT (cdr (assoc 40 (tblsearch "style" (getvar "textstyle")))))

  ; Set and remember initial stat
  (if (= STARTNUM nil) (setq STARTNUM 1))
  (setq TMP_STARTNUM (getint (strcat "\Counting from <" (rtos STARTNUM 2 0) ">: ")))
  (if TMP_STARTNUM (setq STARTNUM TMP_STARTNUM))

  ; Display Current Settings
  (princ 
    (strcat 
      ", Start at = "
      (rtos STARTNUM 2 0)
      ", Height = "
      (rtos STYLEHEIGHT 2 3)
    )
  )


  (while (setq INSPOINT (getpoint "\n Specify point")) 
    (command ".TEXT" "J" "MC" INSPOINT 300 0 STARTNUM)
    (setq STARTNUM (+ STARTNUM 1))
  )

  (princ)
)