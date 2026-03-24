;; Filename: iBlkBL.lsp
;; Purpose: Automatically change lineweight to ByLayer selected blocks and recursively explode nested blocks.
;; Parameters:
;; - Select: Select blocks to explode.
;; - ExplodeNested: Recursively explode nested blocks within the selected blocks.
;; Date: August 9, 2024
;; Version: 0.0.0

(defun c:eBlkBL ()
  ;; Command to set line weight of all entities in selected blocks and nested blocks to "ByLayer"
  (princ "\nVersion 0.0.7 - Starting process...")
  (setq selection-set (ssget '((0 . "INSERT")))) ; Prompt user to select blocks
  (if selection-set
    (progn
      (setq i 0)
      (while (< i (sslength selection-set))
        (setq blk (ssname selection-set i)) ; Get the ith selected block
        (ChangeLineWeightInNestedBlocks blk)
        (setq i (1+ i)) ; Increment i
      )
      (princ "\nProcessing completed.")
    )
    (princ "\nNo blocks selected.")
  )
  (princ)
)

(defun ChangeLineWeightInNestedBlocks (ent)
  ;; Recursive function to handle line weight changes in blocks and nested blocks
  (if (and ent (eq (cdr (assoc 0 (entget ent))) "INSERT"))
    (progn
      (princ (strcat "\nProcessing block: " (cdr (assoc 2 (entget ent))))) ; Debug output
      (ChangeLineWeightInBlock (cdr (assoc 2 (entget ent)))) ; Process the block itself
      (let ((blkDef (tblobjname "BLOCK" (cdr (assoc 2 (entget ent))))))
        (when blkDef
          (setq blkEnt (entnext blkDef))
          (while (and blkEnt (/= blkEnt blkDef))
            (if (and blkEnt (eq (cdr (assoc 0 (entget blkEnt))) "INSERT"))
              (ChangeLineWeightInNestedBlocks blkEnt)) ; Recursive call for nested blocks
            (setq blkEnt (entnext blkEnt))
          )
        )
      )
    )
    (princ "\nInvalid entity or non-block reference encountered.")
  )
)

(defun ChangeLineWeightInBlock (blkName)
  ;; Function to change the line weight of all entities within a block to "ByLayer"
  (let ((blkDef (tblobjname "BLOCK" blkName)))
    (if blkDef
      (progn
        (setq blkEnt (entnext blkDef))
        (while (and blkEnt (/= blkEnt blkDef))
          (if (and blkEnt (entget blkEnt)) ; Check entity validity
            (if (not (wcmatch (cdr (assoc 0 (entget blkEnt))) "*SEQEND"))
              (progn
                (entmod (subst (cons 370 -1) (assoc 370 (entget blkEnt)) (entget blkEnt))) ; Set line weight to "ByLayer"
                (princ (strcat "\nModified entity: " (cdr (assoc 0 (entget blkEnt))))) ; Debug output
              )
            )
            (princ "\nSkipping invalid or missing entity.")
          )
          (setq blkEnt (entnext blkEnt)) ; Move to the next entity
        )
      )
      (princ (strcat "\nError: Block definition not found for " blkName))
    )
  )
)

