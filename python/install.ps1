#!/usr/bin/env pwsh
Param(
    [string]
    $SettingsFile = (Join-Path $PSScriptRoot 'settings.json')
)

Import-Module (Join-Path $PSScriptRoot '..' Utils)
$Settings = Get-JSONFile $SettingsFile

Write-Header 'Setting up Python'

if (!(Test-CommandExists('python3'))) {
    # Ubuntu and Fedora already have Python 3 installed
    if ($IsMacOS) {
        Install-SystemPackage 'python3'
    } else {
        Write-ColoredLine 'Python 3 could not be installed.' Red
        return
    }
}

if (!(Test-CommandExists('pip3'))) {
    # pip3 is installed on macOS with brew
    if ($IsLinux) {
        Install-SystemPackage 'python3-pip'
    } else {
        Write-ColoredLine 'Python 3 could not be installed.' Red
        return
    }
}

Write-ColoredLine 'Installing Pip Packages' Magenta

function Install-PipPackage ([string] $Package) {
    if (Test-CommandExists($Package)) { return }
    sudo pip3 install $Package
}

$Settings.python.pip.packages | Foreach-Object {
    Install-PipPackage $_
}

$venvHome = "$HOME/code/venv"
New-Directory $venvHome

if (!(Test-DirExists("$venvHome/py3"))) {
    Write-ColoredLine 'Setting up virtual environment' Magenta
    virtualenv --python python3 "$venvHome/py3"
}
