#!/usr/bin/env pwsh
Param(
    [string]
    $SettingsFile = (Join-Path $PSScriptRoot 'settings.json'),

    [switch]
    $Force
)

Import-Module (Join-Path $PSScriptRoot '..' Utils)
$Settings = Get-JSONFile $SettingsFile

Write-Header 'Install Dart lang'

if ($IsMacOS) {
    brew tap dart-lang/dart
    Install-SystemPackages dart
    return
}

$DartVersion = $Settings.dart.version
$SDKUrl = "https://storage.googleapis.com/dart-archive/channels/stable/release/$DartVersion/sdk/dartsdk-linux-x64-release.zip"
$zipfile = 'dartsdk-linux-x64-release.zip'
$DartRoot = $Settings.dart.dartroot
$DartInstalled = (Invoke-Command "$DartRoot/bin/dart" "--version").StdErr.Split(' ')[3]

if ((!$Force) -and ($DartVersion -eq $DartInstalled)) {
    Write-ColoredLine "Dart is at requested version $DartInstalled" DarkGreen
    return
}

if (!(Test-FileExists $zipfile)) {
    Get-RemoteFile $SDKUrl $zipfile
}

if (Test-DirExists $DartRoot) {
    sudo rm -rf $DartRoot
}

sudo unzip -q $zipfile -d /usr/lib
sudo mv /usr/lib/dart-sdk $DartRoot

# Fix permissions
sudo find $DartRoot -type f -exec chmod 0644 '{}' +
sudo find $DartRoot/bin -maxdepth 1 -type f -exec chmod 0755 '{}' +
sudo find $DartRoot -type d -exec chmod 0755 '{}' +

Remove-Item $zipfile
Add-ToPath dart "$DartRoot/bin"
