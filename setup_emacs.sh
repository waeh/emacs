#!/bin/bash

# Update dnf repo
sudo dnf -y update

# Upgrade the OS
sudo dnf -y upgrade

# Install emacs
sudo dnf -y install emacs-nox

# Install prerequisites for vterm
sudo dnf -y install libtool cmake

# Install git
sudo dnf -y install git

# Building silversearcher
sudo yum -y groupinstall "Development Tools"
sudo yum -y install pcre-devel xz-devel zlib-devel
pushd /usr/local/src
sudo git clone https://github.com/ggreer/the_silver_searcher.git
pushd the_silver_searcher
sudo ./build.sh
sudo make install
popd
popd

# Install golang
## Download and install golang
sudo wget -qO- https://go.dev/dl/go1.20.4.linux-amd64.tar.gz | sudo tar -xvz -C /usr/local/

## Adding golib and gopath to path and load it
mkdir ~/go ~/go/bin
cat <<EOF >> .bash_profile
export GOPATH=~/go
export PATH=\$PATH:/usr/local/go/bin:\$GOPATH/bin
EOF
source .bash_profile

## Install gopls (goland language server)
go install golang.org/x/tools/gopls@latest

# Adding emacs configuration
cat <<EOF> ~/.emacs
;; Adding TLS settings
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; Add Melpa repository and refresh
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Configure use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
	        use-package-expand-minimally t))

;; y-or-n instead of yes-or-no
(defalias 'yes-or-no-p 'y-or-n-p)

;; Disable menu bar
(menu-bar-mode -1)

;; Disable blinking cursor
(setq visible-cursor nil)

;; Show column
(setq column-number-mode t)

;; Show line number
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Put all emacs backup files in .Trash dir
(setq backup-directory-alist '((".*" . "~/.Trash")))

;; Bury scratch buffer
(add-hook 'emacs-startup-hook (lambda ()
                                (when (get-buffer "*scratch*")
                                  (kill-buffer "*scratch*"))))

;; Kill message buffer
(setq-default message-log-max nil)
(kill-buffer "*Messages*")

;; Install solarized-theme
(use-package solarized-theme
  :ensure t)

;; Install Kubernetes package
(use-package kubernetes
	     :ensure t
	     :commands (kubernetes-overview)
	     :config
	     (setq kubernetes-poll-frequency 3600
		           kubernetes-redraw-frequency 3600))

;; Install yaml-mode
(use-package yaml-mode
  :ensure t)

;; Install go-mode
(use-package go-mode
  :ensure t
  :bind (
         ("C-c C-j" . lsp-find-definition)
         ("C-c C-d" . lsp-describe-thing-at-point)
         )
  :hook ((go-mode . lsp-deferred)
         (before-save . lsp-format-buffer)
         (before-save . lsp-organize-imports)))

;; Install go lsp
(use-package lsp-mode
    :hook (go-mode . lsp-deferred)
    :commands (lsp lsp-deferred))

;; Install company mode
(use-package company
  :ensure t
  :hook (after-init-hook global-company-mode))

;; Install counsel/Ivy
(use-package counsel
  :ensure t)

;; Install projectile
(use-package projectile
  :ensure t)

;; Install lsp-ui
(use-package lsp-ui
  :ensure t)

;; Install Ivy-mode
(use-package ivy
  :ensure t)
(ivy-mode 1)

;; Installing vterm
(use-package vterm
    :ensure t)

;; Install flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; Install multi-vterm
(use-package multi-vterm
  :ensure t)

;; Setting up org-mode
(require 'org)
(setq org-capture-templates
      '(("t" "todo" entry (file+headline "~/org/todo.org" "Tasks")
         "* TODO %?\n  %i\n  %a")
        ("T" "todo today" entry (file+headline "~/org/todo.org")
         "* TODO %?\nDEADLINE: %t")
	("i" "inbox" entry (file "~/org/inbox.org")
         "* %?")
	("v" "clip to inbox" entry (file "~/org/inbox.org")
         "* %x%?"))
      )

;; RETURN will follow links in org-mode files
(setq org-return-follows-link  t)

;; Configure company
(setq company-minimum-prefix-length 1
      company-idle-delay 0.0) ;; default is 0.2
(put 'dired-find-alternate-file 'disabled nil)

;; Customize themes
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(solarized-selenized-black))
 '(custom-safe-themes
   '("d89e15a34261019eec9072575d8a924185c27d3da64899905f8548cbd9491a36" "830877f4aab227556548dc0a28bf395d0abe0e3a0ab95455731c9ea5ab5fe4e1" "fee7287586b17efbfda432f05539b58e86e059e78006ce9237b8732fde991b4c" default))
 '(package-selected-packages
   '(multi-vterm flycheck vterm lsp-ui projectile counsel company lsp-mode go-mode yaml-mode kubernetes use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
EOF

# Start emacs
emacs
