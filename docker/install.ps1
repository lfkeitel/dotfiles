#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' Utils)

if (!$IsLinux) { return }

Write-Header 'Setting up Docker'

$Force = ($Args.Count -gt 0 -and $Args[0] -eq 'force')

if (Test-CommandExists docker -and !$Force) {
    Write-Output "Docker already installed, skipping"
    return
}

if (Test-IsArch) {
    Install-SystemPackage 'docker-bin'
    return
}

Import-RepoKey 'https://download.docker.com/linux/ubuntu/gpg'
Install-RepoList "$PSScriptRoot/docker"
Update-PackageLists
Install-SystemPackage docker-ce
