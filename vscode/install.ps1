#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' Utils)

Write-Header 'Setting up VS Code'
$RunInstall = $false
$RunLinks = $false
$RunExtInstall = $false

if ($Args.Count -eq 0 -or $Args[0] -eq 'all') {
    $RunInstall = $true
    $RunLinks = $true
    $RunExtInstall = $true
}
switch ($Args[0]) {
    'install' { $RunInstall = $true }
    'link' { $RunLinks = $true }
    'ext' { $RunLinks = $true }
}

if ($IsMacOS) {
    Add-ToPath vscode '/Applications/Visual Studio Code.app/Contents/Resources/app/bin'
}

if ($RunInstall -and -not (Get-CommandExists code)) {
    if ($IsMacOS) {
        Write-Output 'Please install VS Code first'
        ExitWithCode 1
    } elseif ($IsLinux) {
        Import-RepoKey 'https://packages.microsoft.com/keys/microsoft.asc'
        Install-RepoList $DIR/vscode
        Update-PackageLists
        Install-SystemPackages code
    } else {
        Write-Output 'Unsupported distribution'
        return
    }
}

if ($RunLinks) {
    $SettingsPath = "$HOME/.config/Code/User"
    if ($IsMacOS) {
        $SettingsPath = "$HOME/Library/Application Support/Code/User"
    }

    New-Item $SettingsPath -ItemType Directory -Force | Out-Null
    Add-FileLink "$PSScriptRoot/settings.json" "$SettingsPath/settings.json"
    Add-FileLink "$PSScriptRoot/keybindings.json" "$SettingsPath/keybindings.json"

    if (Test-DirExists "$SettingsPath/snippets") {
        Remove-Item "$SettingsPath/snippets" -Recurse -Force | Out-Null
    }
    Add-FileLink "$PSScriptRoot/snippets" "$SettingsPath/snippets"
}

if ($RunExtInstall) {
    Write-Banner 'Installing VSCode extensions' Magenta

    Get-Content "$PSScriptRoot/extensions" | ForEach-Object {
        code --install-extension $_
    }
}
