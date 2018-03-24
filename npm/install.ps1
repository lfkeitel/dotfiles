#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' Utils)

Write-Header 'Setting up NPM'

Add-FileLink "$PSScriptRoot/.npmrc" "$HOME/.npmrc"
Add-ToPath npm "$HOME/.npm-packages/bin"
