#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' Utils)

Write-Header 'Setting up Emacs'
New-Item "$HOME/.emacs.d" -ItemType Directory -Force | Out-Null

Add-FileLink "$PSScriptRoot/.emacs.d/config" "$HOME/.emacs.d/config"
Add-FileLink "$PSScriptRoot/.emacs.d/lisp" "$HOME/.emacs.d/lisp"
Add-FileLink "$PSScriptRoot/.emacs.d/org-templates" "$HOME/.emacs.d/org-templates"
Add-FileLink "$PSScriptRoot/.emacs.d/init.el" "$HOME/.emacs.d/init.el"

New-Item "$HOME/org" -ItemType Directory -Force | Out-Null
New-Item -ItemType File "$HOME/org/index.org" -ErrorAction Ignore
