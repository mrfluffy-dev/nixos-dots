;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Zastian Pretorius"
    user-mail-address "Zastian00@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(add-to-list 'load-path "~/.config/doom/themes")
(setq doom-theme 'doom-dracula)



;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


(add-to-list 'load-path "~/.config/doom/lisp")


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type `relative)

;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(setq auto-window-vscroll nil)

(set-fontset-font "fontset-default" nil (font-spec :size 17 :name "ZedMono Nerd Font"))

(setq doom-font (font-spec :family "Illusion Z" :size 17)
    doom-variable-pitch-font (font-spec :family "Illusion Z" :size 17)
    doom-big-font (font-spec :family "Illusion Z" :size 24))

(require 'whitespace)
(setq whitespace-line-column 99)
(setq whitespace-style '(face lines-tail))
(add-hook 'prog-mode-hook 'whitespace-mode)

(require 'fill-column-indicator)
(setq fci-rule-column 99)
(setq fci-rule-width 1)
(setq fci-rule-color "#a280d5")
(add-hook 'prog-mode-hook 'fci-mode)

;; tab width
(setq-default tab-width 4) ;; Set tab width to 2 spaces
(setq-default indent-tabs-mode nil) ;; Use spaces instead of tabs
(add-hook 'prog-mode-hook
    (lambda ()
        (setq-local tab-width 4)
        (setq-local indent-tabs-mode nil)))
(setq lisp-indent-offset 4)
(use-package nix-mode
    :mode "\\.nix\\'"
    :config
    (setq nix-indent-function (lambda (_) 4)))

(setq rust-indent-offset 4)





(custom-set-faces
    '(org-level-1 ((t (:inherit outline-1 :height 1.4))))
    '(org-level-2 ((t (:inherit outline-2 :height 1.3))))
    '(org-level-3 ((t (:inherit outline-3 :height 1.2))))
    '(org-level-4 ((t (:inherit outline-4 :height 1.1))))
    '(org-level-5 ((t (:inherit outline-5 :height 1.0)))))


;; company mode delay 0
(setq company-idle-delay 0)




;;japanese stuff
(setq default-input-method "japanese")



(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-footer)
(add-hook! '+doom-dashboard-functions :append
    (insert "\n" (+doom-dashboard--center +doom-dashboard--width "The UwU Editor")))

;;
;;
;;
(setq org-image-actual-width 300)

(setq fancy-splash-image (concat doom-user-dir "xenia.png"))

(setq ess-r--no-company-meta t)

(set-frame-parameter nil 'alpha-background 90) ; For current frame
(add-to-list 'default-frame-alist '(alpha-background . 90)) ; For all new frames henceforth
(add-to-list 'default-frame-alist '(undecorated . t))



                                        ;undo fix
(setq undo-tree-enable-undo-in-region nil)
(setq undo-limit 8000000000)


(org-babel-do-load-languages
    'org-babel-load-languages
    '((emacs-lisp . t)
         (julia . t)
         (python . t)
         (jupyter . t)))

;; accept completion from copilot and fallback to company
(defun my-tab ()
    (interactive)
    (or (copilot-accept-completion)
        (company-indent-or-complete-common nil)))


(use-package! copilot
    :hook (prog-mode . copilot-mode)
    :bind (("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)
              :map company-active-map
              ("<tab>" . 'my-tab)
              ("TAB" . 'my-tab)
              :map company-mode-map
              ("<tab>" . 'my-tab)
              ("TAB" . 'my-tab)))
(setq copilot-log-max 1000)

;; asm stuff
(use-package! nasm-mode
    :mode "\\.[n]*\\(asm\\|s\\)\\'")

;; Get Haxor VM from https://github.com/krzysztof-magosa/haxor
(use-package! haxor-mode
    :mode "\\.hax\\'")

(use-package! mips-mode
    :mode "\\.mips\\'")

(use-package! riscv-mode
    :mode "\\.riscv\\'")

(use-package x86-lookup
    :ensure t
    :config
    (setq  x86-lookup-pdf "~/.config/doom/asm-ref.pdf"))

(setq openai-key (getenv "OPENAIKEY"))
(setq chatgpt-input-method 'minibuffer)



;;discord rich presence
;;(require 'elcord)
;;(add-hook 'doom-switch-buffer-hook
;;          (lambda ()
;;            (if (string= (buffer-name) "*doom*")
;;                (elcord-mode -1)
;;              (elcord-mode 1))))
;;
;;(defun elcord--disable-elcord-if-no-frames (f)
;;  (declare (ignore f))
;;  (when (let ((frames (delete f (visible-frame-list))))
;;          (or (null frames)
;;              (and (null (cdr frames))
;;                   (eq (car frames) terminal-frame))))
;;    (elcord-mode -1)
;;    (add-hook 'after-make-frame-functions 'elcord--enable-on-frame-created)))
;;
;;(defun elcord--enable-on-frame-created (f)
;;  (declare (ignore f))
;;  (elcord-mode +1))
;;
;;(defun my/elcord-mode-hook ()
;;  (if elcord-mode
;;      (add-hook 'delete-frame-functions 'elcord--disable-elcord-if-no-frames)
;;    (remove-hook 'delete-frame-functions 'elcord--disable-elcord-if-no-frames)))
;;
;;(add-hook 'elcord-mode-hook 'my/elcord-mode-hook)
;;
;;(setq elcord-idle-message "Out doing your mom")


;; add my_stuff.el here and load it
(load! "my_stuff.el")


;;ollama stuff
;;
(use-package ellama
    :init
    ;; setup key bindings
    (setopt ellama-keymap-prefix "C-c e")
    ;; language you want ellama to translate to
    (setopt ellama-language "English")
    ;; could be llm-openai for example
    (require 'llm-ollama)
    (setopt ellama-provider
	(make-llm-ollama
	    ;; this model should be pulled to use it
	    ;; value should be the same as you print in terminal during pull
	    :chat-model "codellama:13b"
	    :embedding-model "codellama:13b"))
    )
(use-package qml-ts-mode
    :after lsp-mode
    :config
    (add-to-list 'lsp-language-id-configuration '(qml-ts-mode . "qml-ts"))
    (lsp-register-client
        (make-lsp-client :new-connection (lsp-stdio-connection '("qmlls", "-E"))
            :activation-fn (lsp-activate-on "qml-ts")
            :server-id 'qmlls))
    (add-hook 'qml-ts-mode-hook (lambda ()
                                    (setq-local electric-indent-chars '(?\n ?\( ?\) ?{ ?} ?\[ ?\] ?\; ?,))
                                    (lsp-deferred))))


;; custom functions



;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
