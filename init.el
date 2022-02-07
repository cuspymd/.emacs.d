(require 'package)

(add-to-list 'package-archives
       '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(setq inhibit-startup-message t) ;; hide the startup message
(use-package better-defaults)
(load custom-file)
(package-install-selected-packages)
(setq ido-everywhere t)

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

(elpy-enable)
(add-hook 'clojure-mode-hook #'paredit-mode)
(add-hook 'clojure-mode-hook #'rainbow-delimiters-mode)

(require 'projectile)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(setq projectile-project-search-path '("~/work/"))
(projectile-mode +1)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (
         (typescript-mode . lsp)
         (js-mode . lsp)
         (svelte-mode . lsp)
         (nix-mode . lsp)
         (html-mode . lsp)
         (css-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :config
  (add-to-list 'lsp-language-id-configuration '(nix-mode . "nix"))
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("rnix-lsp"))
                    :major-modes '(nix-mode)
                    :server-id 'nix)))

(use-package lsp-ui :commands lsp-ui-mode)
(use-package which-key
    :config
    (which-key-mode))

(use-package all-the-icons
  :if (display-graphic-p))

(use-package doom-modeline
  :init (doom-modeline-mode 1))

(use-package doom-themes
  :init (load-theme 'doom-palenight t))

(use-package emojify
  :hook (after-init . global-emojify-mode))

(use-package emmet-mode
  :hook (
         (html-mode . emmet-mode)
         (css-mode . emmet-mode)
         ))
  

(setq org-publish-project-alist
      '(
        ("blog-posts"
         :base-directory "~/work/cuspymd.github.io/org/"
         :base-extension "org"
         :publishing-directory "~/work/cuspymd.github.io/docs/_posts"
         :recursive t
         :publishing-function org-html-publish-to-html
         :headline-levels 4
         :html-extension "html"
         :body-only t ;; Only export section between <body> </body>
         )
        ("blog-assets"
         :base-directory "~/work/cuspymd.github.io/org/"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|php"
         :publishing-directory "~/work/cuspymd.github.io/docs/assets"
         :recursive t
         :publishing-function org-publish-attachment)

        ("blog" :components ("blog-posts" "blog-assets"))
        ))
