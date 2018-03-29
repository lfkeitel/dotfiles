#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' Utils)

if ($IsMacOS) {
    brew tap dart-lang/dart
    Install-SystemPackages dart
    return
}

Write-Header 'Install Dart lang'

$DartVersion = '1.24.3'
$SDKUrl = "https://storage.googleapis.com/dart-archive/channels/stable/release/$DartVersion/sdk/dartsdk-linux-x64-release.zip"
$tarfile = 'dartsdk-linux-x64-release.zip'
$DartRoot = '/usr/lib/dart'
$DartInstalled = (Invoke-Command "$DartRoot/bin/dart" "--version").StdErr.Split(' ')[3]

if ($DartVersion -eq $DartInstalled) {
    Write-ColoredLine "Dart is at requested version $DartInstalled" DarkGreen
    return
}

if (!(Test-FileExists $tarfile)) {
    (New-Object System.Net.WebClient).DownloadFile($SDKUrl, $tarfile)
}

if (Test-DirExists $DartRoot) {
    sudo rm -rf $DartRoot
}

sudo unzip -q $tarfile -d /usr/lib
sudo mv /usr/lib/dart-sdk $DartRoot

# Fix permissions
sudo find $DartRoot -type f -exec chmod 0644 '{}' +
sudo find $DartRoot/bin -maxdepth 1 -type f -exec chmod 0755 '{}' +
sudo find $DartRoot -type d -exec chmod 0755 '{}' +

Remove-Item $tarfile
Add-ToPath dart "$DartRoot/bin"
