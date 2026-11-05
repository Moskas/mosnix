;;; custom/binds.el -*- lexical-binding: t; -*-

(map! :leader
      :desc "Open nano agenda" "o a n" #'nano-agenda)
(map! :leader
      :desc "Olliveti mode" "t o" #'olivetti-mode)
(map! :leader
      :desc "Spacious padding mode" "t p" #'spacious-padding-mode)
