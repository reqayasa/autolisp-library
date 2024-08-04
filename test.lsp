(defun c:testbeam ()
	;define the function
;********************************************************
	;Save System Variables
 
	(setq oldsnap (getvar "osmode"))
	;save snap settings
 
	(setq oldblipmode (getvar "blipmode"))
	;save blipmode setting
 
;********************************************************
	;Switch OFF System Variables
 
	(setvar "osmode" 0)
	;Switch OFF snap
 
	(setvar "blipmode" 0)
	;Switch OFF Blipmode
 
;********************************************************
	;Get User Inputs	
	
	(initget (+ 1 2 4))
	;check user input
	(setq lb (getdist "\nLength of Beam : "))
	;get the length of the beam
 
	(initget (+ 1 2 4))
	;check user input
	(setq hb (getdist "\nHeight of Beam : "))
	;get the height of the beam
 
	(initget (+ 1 2 4))
	;check user input
	(setq wt (getdist "\nFlange Thickness : "))
	;get the thickness of the flange
 
	(initget (+ 1 2 4))
	;check user input
	(setq ep (getdist "\nEnd Plate Thickness : "))
	;get the thickness of the end plate
 
	(initget (+ 1 2 4))
	;check user input
	(setq nl (getdist "\nLength of Notch : "))
	;get the length of notch
 
	(initget (+ 1 2 4))
	;check user input
	(setq nd (getdist "\nDepth of Notch : "))
	;get the depth of the notch
 
	;End of User Inputs
;*********************************************************
	;Get Insertion Point
 
	(setvar "osmode" 32)
	;switch ON snap
	
	(while
	;start of while loop	
	
	(setq ip (getpoint "\nInsertion Point : "))
	;get the insertion point
 
	(setvar "osmode" 0)
	;switch OFF snap
 
;********************************************************
	;Start of Polar Calculations
 
	(setq p2  (polar ip (dtr 180.0) (- (/ lb 2) nl)))
	(setq p3  (polar p2 (dtr 270.0) wt))
	(setq p4  (polar p2 (dtr 270.0) nd))
	(setq p5  (polar p4 (dtr 180.0) nl))
	(setq p6  (polar p5 (dtr 180.0) ep))
	(setq p7  (polar p6 (dtr 270.0) (- hb nd)))
	(setq p8  (polar p7 (dtr 0.0) ep))
	(setq p9  (polar p8 (dtr 90.0) wt))
	(setq p10 (polar p9 (dtr 0.0) lb))
	(setq p11 (polar p8 (dtr 0.0) lb))
	(setq p12 (polar p11 (dtr 0.0) ep))
	(setq p13 (polar p12 (dtr 90.0) (- hb nd)))
	(setq p14 (polar p13 (dtr 180.0) ep))
	(setq p15 (polar p14 (dtr 180.0) nl))
	(setq p16 (polar p15 (dtr 90.0) (- nd wt)))
	(setq p17 (polar p16 (dtr 90.0) wt))
	;End of Polar Calculations
;**********************************************************
	;Start of Command Function
 
	(command "Line" ip p2 p4 p6 p7 p12 p13 p15 p17 "c"
		 "Line" p3 p16 ""
		 "Line" p9 p10 ""
		 "Line" p5 p8 ""
		 "Line" p11 p14 ""
	)        ;End Command
	;End of Command Function
;**********************************************************
	
	(setvar "osmode" 32)
	;Switch ON snap
 
	);end of while loop
	
;**********************************************************
	;Reset System Variable
 
	(setvar "osmode" oldsnap)
	;Reset snap
 
	(setvar "blipmode" oldblipmode)
	;Reset blipmode
 
;*********************************************************
	(princ)
	;finish cleanly
 
)	;end of defun
 
;**********************************************************
;This function converts Degrees to Radians.
 
(defun dtr (x)
	;define degrees to radians function
 
	(* pi (/ x 180.0))
	;divide the angle by 180 then
	;multiply the result by the constant PI
 
)	;end of function
 
;**********************************************************
(princ)	;load cleanly
;**********************************************************