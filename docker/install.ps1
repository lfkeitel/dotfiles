#!/usr/bin/env pwsh
Param(
    [switch]
    $Force
)
Import-Module (Join-Path $PSScriptRoot '..' Utils)

if (!$IsLinux) { return }

Write-Header 'Setting up Docker'

if (!(Test-CommandExists docker) -or $Force) {
    if (Test-IsArch) {
        Install-SystemPackage 'docker-bin'
    } else {
        Import-RepoKey 'https://download.docker.com/linux/ubuntu/gpg'
        Install-RepoList "$PSScriptRoot/docker"
        Update-PackageLists
        Install-SystemPackage 'docker-ce'
    }
}

if (!(Test-IsArch)) { return }

Write-Header 'Setting up Docker Credential Store'

$DockerConfig = "$HOME/.docker/config.json"
$Config = Get-JSONFile $DockerConfig

if (!(Get-Member -InputObject $Config 'credsStore')) {
    Install-SystemPackage 'docker-credential-secretservice' 'gnome-keyring'

    if (Get-Member -InputObject $Config 'auths') {
        $Config.auths = @{}
    }

    $Config | Add-Member -Name 'credsStore' -Value 'secretservice' -Type NoteProperty
    Set-Content -Path $DockerConfig -Value (ConvertTo-Json $Config)

    sudo systemctl restart docker
}

Write-Header 'Setting up Overlayfs Kernel Workaround'

Copy-Config -Sudo "$PSScriptRoot/overlay_metacopy_fix.service" "/etc/systemd/system/overlay_metacopy_fix.service"
Copy-Config -Sudo "$PSScriptRoot/overlay_metacopy_fix.sh" "/opt/overlay_metacopy_fix.sh"
sudo chmod +x "/opt/overlay_metacopy_fix.sh"

sudo systemctl daemon-reload
sudo systemctl enable overlay_metacopy_fix.service
