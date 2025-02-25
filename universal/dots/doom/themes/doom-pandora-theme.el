;;; doom-pandora-theme.el --- Pandora Base16 theme for Doom Emacs -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Based on Base16 Pandora scheme by Cassandra Fox.
;; Adapted from doom-dracula-theme.el
;;
;;; Commentary:
;; This theme is a modification of the Doom Dracula theme,
;; replacing the Dracula palette with the Base16 Pandora colors.
;;
;;; Code:

(require 'doom-themes)

(defgroup doom-pandora-theme nil
  "Options for the `doom-pandora' theme."
  :group 'doom-themes)

(defcustom doom-pandora-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'doom-pandora-theme
  :type 'boolean)

(defcustom doom-pandora-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-pandora-theme
  :type 'boolean)

(defcustom doom-pandora-colorful-headers nil
  "If non-nil, headers in org-mode will be more colorful."
  :group 'doom-pandora-theme
  :type 'boolean)

(defcustom doom-pandora-comment-bg doom-pandora-brighter-comments
  "If non-nil, comments will have a subtle, darker background to enhance legibility."
  :group 'doom-pandora-theme
  :type 'boolean)

(defcustom doom-pandora-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a padding to the mode-line. It can be an integer to specify exact padding."
  :group 'doom-pandora-theme
  :type '(choice integer boolean))


(def-doom-theme doom-pandora
                "A dark theme based on the Base16 Pandora color scheme by Cassandra Fox."

                ;; Palette:
                ;;   Base16 Pandora (keys from base00 to base0F)
                ((bg         '("#131213" nil       nil)) ; base00
                 (bg-alt     '("#2f1823" nil       nil)) ; base01
                 (base02     '("#472234" nil       nil)) ; base02
                 (base03     '("#ffbee3" nil       nil)) ; base03
                 (base04     '("#9b2a46" nil       nil)) ; base04
                 (fg         '("#f15c99" "#f15c99" "brightwhite")) ; base05
                 (fg-alt     '("#9ddf69" "#9ddf69" "white"))       ; base0B
                 (accent     '("#008080" nil       nil)) ; base0D

                 (base06     '("#81506a" nil       nil)) ; base06
                 (base07     '("#632227" nil       nil)) ; base07
                 (base08     '("#b00b69" nil       nil)) ; base08 (red)
                 (base09     '("#ff9153" nil       nil)) ; base09 (orange)
                 (base0A     '("#ffcc00" nil       nil)) ; base0A (yellow)
                 (base0C     '("#714ca6" nil       nil)) ; base0C (blue)
                 (base0D     '("#008080" nil       nil)) ; base0D (teal; reused as accent)
                 (base0E     '("#a24030" nil       nil)) ; base0E (magenta)
                 (base0F     '("#a24030" nil       nil)) ; base0F (duplicate of base0E)

                 ;; You may optionally define a "grey" for extra use:
                 (grey       base04))

                ;; Face categories:
                ;; Here we map our palette to Doom's standard face categories.
                ((red        base08)
                 (orange     base09)
                 (green      base0B)
                 (teal       base0D)
                 (yellow     base0A)
                 (blue       base0C)
                 (dark-blue  (doom-darken base0C 0.2))
                 (magenta    base0E)
                 (violet     (doom-blend base0E base0C 0.5))
                 (cyan       base0D))  ; Using base0D for cyan (teal)

                ;; Base theme face overrides
                (((line-number &override) :foreground base04)
                 ((line-number-current-line &override) :foreground fg)
                 ((font-lock-comment-face &override)
                  :background (if doom-pandora-comment-bg (doom-lighten bg 0.05) 'unspecified))
                 (mode-line
                  :background accent :foreground fg
                  :box (when doom-pandora-padded-modeline
                         `(:line-width ,(if (integerp doom-pandora-padded-modeline)
                                            doom-pandora-padded-modeline 4)
                           :color ,accent)))
                 (mode-line-inactive
                  :background (doom-darken bg 0.075) :foreground base04
                  :box (when doom-pandora-padded-modeline
                         `(:line-width ,(if (integerp doom-pandora-padded-modeline)
                                            doom-pandora-padded-modeline 4)
                           :color ,(doom-darken bg 0.075))))
                 (mode-line-emphasis :foreground (if doom-pandora-brighter-modeline fg accent))
                 ;; Example for org-mode customizations:
                 ((org-tag &override) :foreground (doom-lighten orange 0.3)))
                ;; No additional variable overrides
                ())

;;; doom-pandora-theme.el ends here
