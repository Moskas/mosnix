;;; logo.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2023 Moskas
;;
;; Author: Moskas <minemoskas@gmail.com>
;; Maintainer: Moskas <minemoskas@gmail.com>
;; Created: April 05, 2023
;; Modified: April 05, 2023
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/moskas/logo
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(defvar logo-path "") ;; absolute path to images
(defvar logo-images (list)) ;; list of images in logo directory

(defun logo-get-list ()
  "Get the list of logos."
  (interactive)
  (message "%s" logo-images))

(defun logo-random ()
  "Get random logo."
  (interactive)
  (message "%s" (concat logo-path (nth (random (length logo-images)) logo-images))))

(provide 'logo)
;;; logo.el ends here
