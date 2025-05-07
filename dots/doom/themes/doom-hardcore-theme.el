;;; doom-hardcore-theme.el --- inspired by the Hardcore theme -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Added: February 23, 2025
;; Author: Your Name <https://github.com/yourusername>
;; Maintainer: Your Name <https://github.com/yourusername>
;; Source: Hardcore Theme
;;
;;; Commentary:
;;; Code:

(require 'doom-themes)

;;
;;; Variables

(defgroup doom-hardcore-theme nil
  "Options for the `doom-hardcore' theme."
  :group 'doom-themes)

(defcustom doom-hardcore-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'doom-hardcore-theme
  :type 'boolean)

(defcustom doom-hardcore-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-hardcore-theme
  :type 'boolean)

(defcustom doom-hardcore-colorful-headers nil
  "If non-nil, headers in org-mode will be more colorful."
  :group 'doom-hardcore-theme
  :type 'boolean)

(defcustom doom-hardcore-comment-bg doom-hardcore-brighter-comments
  "If non-nil, comments will have a subtle, darker background."
  :group 'doom-hardcore-theme
  :type 'boolean)

(defcustom doom-hardcore-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line. Can be an integer."
  :group 'doom-hardcore-theme
  :type '(choice integer boolean))

;;
;;; Theme definition

(def-doom-theme doom-hardcore
                "A dark theme based on the Hardcore theme."

                ;; name        default   256       16
                ((bg         '("#141414" "#121212" "black"        ))
                 (bg-alt     '("#141414" "#0d0d0d" "black"        ))
                 (base0      '("#0f0f0f" "#0a0a0a" "black"        ))
                 (base1      '("#191919" "#161616" "brightblack"  ))
                 (base2      '("#242424" "#202020" "brightblack"  ))
                 (base3      '("#303030" "#282828" "brightblack"  ))
                 (base4      '("#3c3c3c" "#363636" "brightblack"  ))
                 (base5      '("#4e4e4e" "#484848" "brightblack"  ))
                 (base6      '("#8c8c8c" "#888888" "brightblack"  ))
                 (base7      '("#b2b2b2" "#b0b0b0" "brightblack"  ))
                 (base8      '("#ffffff" "#eeeeee" "white"        ))
                 (fg         '("#e0e0e0" "#ffffff" "white"        ))
                 (fg-alt     '("#c6c6c6" "#b0b0b0" "brightwhite"  ))

                 (grey       base4)
                 (red        '("#ff5f5f" "#ff6b6b" "red"          ))
                 (orange     '("#ffaf5f" "#ffae5f" "brightred"    ))
                 (green      '("#5fff5f" "#6bff6b" "green"        ))
                 (teal       '("#5fafd7" "#5faed7" "brightgreen"  ))
                 (yellow     '("#ffff5f" "#ffff6b" "yellow"       ))
                 (blue       '("#5fafff" "#5faeff" "brightblue"   ))
                 (dark-blue  '("#005f87" "#004f77" "blue"         ))
                 (magenta    '("#af5fff" "#ae5fff" "magenta"      ))
                 (violet     '("#875fff" "#865fff" "brightmagenta"))
                 (cyan       '("#5fdfff" "#5fceff" "brightcyan"   ))
                 (dark-cyan  '("#0087af" "#00779f" "cyan"         ))

                 ;; face categories -- required for all themes
                 (highlight      magenta)
                 (vertical-bar   (doom-darken base1 0.1))
                 (selection      dark-blue)
                 (builtin        orange)
                 (comments       (if doom-hardcore-brighter-comments dark-cyan base5))
                 (doc-comments   (doom-lighten (if doom-hardcore-brighter-comments dark-cyan base5) 0.25))
                 (constants      cyan)
                 (functions      green)
                 (keywords       magenta)
                 (methods        teal)
                 (operators      violet)
                 (type           violet)
                 (strings        yellow)
                 (variables      (doom-lighten magenta 0.6))
                 (numbers        violet)
                 (region         `(,(car base3) ,@(cdr base1)))
                 (error          red)
                 (warning        yellow)
                 (success        green)
                 (vc-modified    orange)
                 (vc-added       green)
                 (vc-deleted     red)

                 ;; modeline
                 (-modeline-bright doom-hardcore-brighter-modeline)
                 (-modeline-pad (when doom-hardcore-padded-modeline (if (integerp doom-hardcore-padded-modeline) doom-hardcore-padded-modeline 4)))
                 (modeline-bg `(,(doom-darken (car bg) 0.15) ,@(cdr base0)))
                 (modeline-bg-l `(,(car bg) ,@(cdr base0)))
                 (modeline-bg-inactive `(,(doom-darken (car bg) 0.075) ,@(cdr base1)))
                 (modeline-bg-inactive-l (doom-darken bg 0.1)))

                ;; Base theme face overrides
                (((line-number &override) :foreground base5)
                 ((line-number-current-line &override) :foreground fg)
                 (mode-line :background modeline-bg :foreground base8
                            :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
                 (mode-line-inactive :background modeline-bg-inactive :foreground base5
                                     :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive))))
                )

;;; doom-hardcore-theme.el ends here
