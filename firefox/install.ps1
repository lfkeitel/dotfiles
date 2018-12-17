#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' Utils)

Write-Header 'Setting up Firefox profile'

$MozillaDir = "$HOME/.mozilla/firefox"

$Profiles = Get-IniContent "$MozillaDir/profiles.ini"

$DefaultProfileName = $Profiles.Keys | Where-Object{$Profiles[$_].Default -eq "1"}
$DefaultProfile = $Profiles[$DefaultProfileName]
$ProfileDir = "$MozillaDir/$($DefaultProfile.Path)"

Add-FileLink $PSScriptRoot/user.js $ProfileDir/user.js
