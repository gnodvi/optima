;;; -*- Mode:LISP; Base:10; Syntax:Common-Lisp; -*-

;;;=============================================================================

;(in-package :ltk)

;-------------------------------------------------------------------------------

(defvar *ti* 0)

;===============================================================================
;-------------------------------------------------------------------------------
(defun create_circle (canvas x0 y0 r color)

(let (
  (o (create-oval canvas
               (- x0 r) (- y0 r)
               (+ x0 r) (+ y0 r))
     )
  )

  ;(itemconfigure canvas o "fill" "blue")
  (itemconfigure canvas o "fill" color)
))
;-------------------------------------------------------------------------------
(defun create_line (canvas coords color width)

(let (
  (o (create-line canvas coords))
  )

  (itemconfigure canvas o "fill" color)
  (itemconfigure canvas o "width" width)
))
;===============================================================================
;===============================================================================

