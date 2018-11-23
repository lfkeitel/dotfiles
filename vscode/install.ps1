#!/usr/bin/env pwsh
Param(
    [string]
    $SettingsFile = (Join-Path $PSScriptRoot 'settings.json'),

    [alias("Install")]
    [switch]
    $RunInstall,

    [alias("Force")]
    [switch]
    $ForceInstall,

    [alias("Link")]
    [switch]
    $RunLinks,

    [alias("Ext")]
    [switch]
    $RunExtInstall
)

Import-Module (Join-Path $PSScriptRoot '..' Utils)

Write-Header 'Setting up VS Code'
$Settings = Get-JSONFile $SettingsFile

if (!$RunInstall -and !$RunLinks -and !$RunExtInstall) {
    $RunInstall = $true
    $RunLinks = $true
    $RunExtInstall = $true
}

if ($IsMacOS) {
    Add-ToPath vscode '/Applications/Visual Studio Code.app/Contents/Resources/app/bin'
}

if ($RunInstall) {
    if (!$ForceInstall && (Test-CommandExists code)) {
        Write-ColoredLine 'VSCode already installed, update through the package manager' Magenta
    } else {
        if ($IsMacOS) {
            Write-Output 'Please install VS Code first'
            ExitWithCode 1
        } elseif (Test-IsArch) {
            Install-SystemPackage visual-studio-code-bin
        } elseif ($IsLinux) {
            Import-RepoKey 'https://packages.microsoft.com/keys/microsoft.asc'
            Install-RepoList "$PSScriptRoot/vscode"
            Install-SystemPackage -Update code
        } else {
            Write-Output 'Unsupported distribution'
            return
        }
    }
}

if ($RunLinks) {
    Write-ColoredLine 'Linking VSCode Settings' Magenta
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
    Write-ColoredLine 'Installing VSCode Extensions' Magenta

    $InstalledExts = $(code --list-extensions) | ForEach-Object { $_.toLower() }

    $NeededExts = $Settings.vscode.extensions | ForEach-Object { $_.toLower() } | Where-Object {
        !($InstalledExts.Contains($_))
    }

    $NeededExts | ForEach-Object {
        code --force --install-extension $_
    }
}
