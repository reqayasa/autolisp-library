;; Filename: iExplode.lsp
;; Purpose: Automatically explode selected blocks and recursively explode nested blocks.
;; Parameters:
;; - Select: Select blocks to explode.
;; - ExplodeNested: Recursively explode nested blocks within the selected blocks.
;; Date: August 9, 2024
;; Version: 0.1.0

(defun c:iExplode () 
  (princ "version 0.1.0")
  (setq selection-set (ssget '((0 . "INSERT")))) ; Prompt user to select blocks
  (if selection-set 
    (progn 
      (setq i 0)
      (while (< i (sslength selection-set)) 
        (setq blk (ssname selection-set i)) ; Get the ith selected block
        (ExplodeNestedBlocks blk)
        (setq i (1+ i)) ; Increment i
      )
    )
    (princ "\nNo block selected.")
  )
  (princ)
)

(defun ExplodeNestedBlocks (ent) 
  (if (and ent (eq (cdr (assoc 0 (entget ent))) "INSERT")) 
    (progn 
      (princ (strcat "\nExploding block: " (cdr (assoc 2 (entget ent))))) ; Debug output
      (command "_.explode" ent) ; Explode the block
      (setq exploded-ents (ssget "P")) ; Get the exploded entities
      (if exploded-ents 
        (foreach e 
          (vl-remove-if-not '(lambda (x) (eq (cdr (assoc 0 (entget x))) "INSERT")) 
                            (mapcar 'cadr (ssnamex exploded-ents))
          )
          (ExplodeNestedBlocks e) ; Recursively explode nested blocks
        )
      )
    )
  )
)