manchester-mode
===============

Emacs major mode for editing OWL files in Manchester syntax

## Installation

- Create a local clone of the repository
- Add to your .emacs:

  (add-to-list 'load-path "PATH TO DIRECTORY CONTAINING manchester-mode.el")
  (autoload 'sparql-mode "manchester-mode.el"
     "Major mode for editing OWL files in Manchester syntax" t)
  (add-to-list 'auto-mode-alist '("\\.omn$" . manchester-mode))



