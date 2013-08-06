;; Rudimentary, but operational major mode for editing OWL files in Manchester syntax

;; Author: Marc Wilhelm Küster


(defvar manchester-keywords)

(defvar manchester-top-level-keywords
  "Individual:\\|Class:\\|Ontology:\\|Namespace:\\|Import:\\|ObjectProperty:\\|DataProperty:\\|DifferentIndividuals:\\|DisjointClasses:")

(defvar manchester-second-level-keywords
  "Facts:\\|Types:\\|Annotations:\\|SubClassOf:\\|DisjointWith:\\|InverseOf:\\|Characteristics:\\|Domain:\\|Range:\\|EquivalentTo:\\|SubPropertyOf:\\|SubPropertyChain:")

(defvar manchester-third-level-keywords
  '("has" "that" "and" "or" "value" "some"))

(setf manchester-keywords
 (list 
  (cons
   manchester-top-level-keywords
    'font-lock-keyword-face)
  (cons
   manchester-second-level-keywords
   'font-lock-builtin-face)
  (cons
    (regexp-opt manchester-third-level-keywords 'words)
   'font-lock-constant-face)))

(defun manchester-comment-dwim (arg)
"Comment or uncomment current line or region in a smart way.
For detail, see `comment-dwim'. Cf. http://xahlee.org/emacs/elisp_comment_handling.html"
   (interactive "*P")
   (require 'newcomment)
   (let 
       ((deactivate-mark nil) 
	(comment-start "rdfs:comment") 
	(comment-end ""))
     (comment-dwim arg)))

(defun manchester-indent-line ()
   "Indent current line of manchester OWL code."
   (interactive)
   (let ((savep (> (current-column) (current-indentation)))
	 (indent (condition-case nil (max (manchester-calculate-indentation) 0)
		   (error 0))))
     (if savep
	 (save-excursion (indent-line-to indent))
       (indent-line-to indent))))

 (defun manchester-calculate-indentation ()
   "Return the column to which the current line should be
indented. The chosen algorithm is quite simple and not robust,
but works for my needs: top level keywords are always left
aligned, second level keywords at one tab. Properties and types
are two tabs intended"
   (save-excursion
     (let
	 ((current-line
	   (buffer-substring-no-properties (line-beginning-position) (line-end-position))))
       (cond
	((string-match manchester-top-level-keywords current-line)
	 0)
	((string-match "^[ ]*$" current-line)
	 0)
	((string-match manchester-second-level-keywords current-line)
	 tab-width)
	(t
	 (* 2 tab-width))))))
   
(defun manchester-indent-and-newline ()
  (interactive)
  (manchester-indent-line)
  (newline))

(define-derived-mode manchester-mode fundamental-mode "Manchester OWL"
   "A major mode for editing OWL files in Manchester syntax"
  (define-key manchester-mode-map 
    [remap comment-dwim] 'manchester-comment-dwim)
  (set (make-local-variable 'indent-line-function) 'manchester-indent-line)
  (local-set-key "\C-m" 'manchester-indent-and-newline)
  (setf font-lock-defaults '(manchester-keywords)))
