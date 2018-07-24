#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' '..' Utils)

Write-Header 'Setting up Calcurse'
Add-FileLink "$PSScriptRoot/conf" "$HOME/.calcurse/conf"
Add-FileLink "$PSScriptRoot/keys" "$HOME/.calcurse/keys"
