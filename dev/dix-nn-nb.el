;;; Some extra emacs-lisp functions for apertium-nn-nb and ordbanken 
;;; (see http://savannah.nongnu.org/projects/ordbanken/ )

;;; Author: Kevin Brubeck Unhammer <unhammer hos gmail punktum com>

(require 'dix)

(defun dix-compound-guess-pardef (&optional partype)
  "How to use: write a compound word, eg. \"øygruppe\", in the
dix file below all the nouns, put point between \"øy\" and
\"gruppe\", and if \"gruppe\" is defined somewhere above, this
function will turn the word into eg.

<e lm=\"øygruppe\">    <i>øygruppe</i><par n=\"lø/e__n\"/></e>

TODO: ideally, instead of having to place the cursor at the
compound border, it should try to get the longest possible match,
the same as trying this function from first char, then from
second, etc., but preferably using a more efficient method..."
  (interactive)
  (let* ((rhs (buffer-substring-no-properties (point) (line-end-position)))
	 (pos (save-excursion
		(re-search-backward
		 (concat "<e.* lm=\"[^\"]*" rhs "\".*" partype "\"") nil 'noerror 1))))
    (if pos
	(let ((e (buffer-substring-no-properties pos (nxml-scan-element-forward pos)))
	      (word (buffer-substring-no-properties (line-beginning-position)
						    (line-end-position))))
	  (kill-region (line-beginning-position) (line-end-position))
	  (insert e)
	  (beginning-of-line)
	  (dix-next)
	  (let* ((lmbound (progn (nxml-token-after)
				 (nxml-attribute-value-boundary (point))))
		 (oldlm (buffer-substring-no-properties (car lmbound) (cdr lmbound))))      
	    (dix-with-sexp (kill-sexp))
	    (insert word)
	    (dix-next)
	    (let* ((suffix (cdr (dix-split-root-suffix)))
		   (root (if suffix
			     (if (string= (substring word (- (length suffix))) suffix)
				 (substring word 0 (- (length suffix)))
			       (error "Pardef suffix didn't match!"))
			   word)))
	      (dix-with-sexp (kill-sexp))
	      (insert root)
	      (beginning-of-line) (insert (concat "<!-- " oldlm " -->")) (end-of-line)
	      ;; (message oldlm)
	      )))
      (message "No fitting word found :-/"))))

(defun dix-compound-guess-pardef__n ()
  (interactive)
  (dix-compound-guess-pardef "__n"))

(defun dix-ordbanken-lookup-lm ()
  "Used with the cursor at an entry like 

<e lm=\"spirakel\"><i>spirak</i><par n=\"/el__n\"/></e>

this mess of a function will open a buffer in another window,
look up \"spirakel\" in ordbanken (keeping only noun lines) and
turn it into an lttoolbox pardef. 

Additionally, it'll copy over the `dix-suffix-maps' and print
`dix-find-duplicate-pardefs', so if you previously did C-u C-c D
on a noun pardef, this might tell you that it matches the
\"es/el__n\" pardef.

TODO: an option to force-update `dix-suffix-maps', and another
one to remove the invariant prefix before calling
`dix-find-duplicate-pardefs'."
  (interactive)
  (save-selected-window
    (let* ((suffix-maps (copy-list dix-suffix-maps))
	   (split (dix-split-root-suffix))
	   (word (concat (car split)
			 (cdr split)))
	   (class (dix-pardef-type-of-e))
	   (lang (if (or (string-match "nb" (buffer-name))
			 (string-match "nob" (buffer-name))) " nb " " nn "))
	   (buf (pop-to-buffer "*Ordbanken*"))
	   (fcmd (cond
		  ((string= class "adj") "|grep '\"adj\".*\"\\(comp\\|sup\\|posi\\)\"'")
		  ((string= class "vblex_adj") "|grep '\\(\"vblex\"\\|\"adj\".*\"pp\\)'")
		  (t (concat "|grep '\"" class "\"'"))))
	   (scmd (concat "|sed 's/" "\\(<[lr]>\\)" (car split) "/\\1/g'")))
      (with-output-to-temp-buffer "*Ordbanken*"
	(nxml-mode)
	(shell-command
	 (concat "/l/n/dev/ordbanken2XML.sh " lang word fcmd scmd) (current-buffer))
	(sit-for 0.1)
 	(setq dix-suffix-maps suffix-maps)
	(flush-lines "pardef")
	(flush-lines "\"adj\".*\"m\"")	; since we don't use these
	(goto-char (point-max))	(insert "</pardef>")
	(goto-char (point-min))	(insert (concat "<pardef n=\""
						(car split)
						(if (cdr split) (concat "/" (cdr split)))
						(concat "__" class "\">\n")))
	(dix-sort-pardef nil)
	(align (point-min) (point-max))
	(replace-regexp "  *<e r=\"LR\">\\(.*\\)\n  *<e>  *\\1"
			"  <e>       \\1" nil
			(point-min) (point-max))
	(kill-ring-save (point-min) (point-max))
	(insert (concat (prin1-to-string (dix-find-duplicate-pardefs nil)) "\n"))))))

(provide 'dix-nn-nb)
