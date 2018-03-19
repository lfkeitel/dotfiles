#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' Utils)

if (!$IsLinux) { return }

Write-Header 'Setting up Docker'

$Force = ($Args.Count -gt 0 -and $Args[0] -eq 'force')

if (Get-CommandExists docker -and !$Force) {
    Write-Output "Docker already installed, skipping"
    return
}

Import-RepoKey 'https://download.docker.com/linux/ubuntu/gpg'
Install-RepoList "$PSScriptRoot/docker"
Update-PackageLists
Install-SystemPackages docker-ce
