#!/usr/bin/env pwsh
Param(
    [string]
    $SettingsFile = (Join-Path $PSScriptRoot 'settings.json'),

    [switch]
    $Force
)

Import-Module (Join-Path $PSScriptRoot '..' Utils)
$Settings = Get-JSONFile $SettingsFile
$GoRoot = $Settings.go.goroot
$GoPath = "$HOME/go"
$GoVersion = "go$($Settings.go.version)"

function Install-GolangFromRemote {
    $tarfile = "$GoVersion.linux-amd64.tar.gz"
    $url = "https://storage.googleapis.com/golang/$GoVersion.linux-amd64.tar.gz"

    if (!(Test-FileExists $tarfile)) {
        Get-RemoteFile $url $tarfile
    }

    if (Test-DirExists $GoRoot) {
        sudo rm -rf $GoRoot
    }

    sudo tar -C /usr/local -xzf $tarfile
    Remove-Item $tarfile
}

function Install-Golang {
    Write-Header "Installing Go"
    $GoInstalled = (Invoke-Command "go" "version").StdOut.Split(' ')[2]

    if ((!$Force) -and ($GoVersion -eq $GoInstalled)) {
        Write-ColoredLine "Go is at requested version $GoInstalled" DarkGreen
        Finish-Install
        return
    }

    Write-WarningMsg "Installed: $GoInstalled"
    Write-WarningMsg "Wanted:    $GoVersion"

    if ($IsMacOS) {
        Write-WarningMsg "macOS detected, please install/upgrade Go"
        return
    } elseif (Get-IsArch) {
        Write-ColoredLine "Go is managed by Arch, please run yay to update" DarkGreen
        return
    } else {
        Install-GolangFromRemote

        if (Test-DirExists "$GoPath/pkg") {
            # Remove any archive packages from older version of Go
            Remove-Item "$GoPath/pkg" -Recurse -Force | Out-Null
        }
    }

    New-Item "$GoPath/src" -ItemType Directory -Force | Out-Null
    New-Item "$GoPath/pkg" -ItemType Directory -Force | Out-Null
    New-Item "$GoPath/bin" -ItemType Directory -Force | Out-Null

    Finish-Install
}

function Install-GoPackages {
    $Settings.go.packages | ForEach-Object { Get-GoPackage $_ }
}

function Get-GoPackage ([string] $Package) {
    $Result = (Invoke-Command 'go' 'get' '-u' $Package)
    if ($Result.ExitCode -eq 0) {
        Write-Output "Successfully downloaded $Package"
    }
}

function Finish-Install() {
    if (!(Get-IsArch)) {
        Add-ToPath go "$GoRoot/bin" # Go binary and tools
    }
    Add-ToPath go "$GoPath/bin" # Installed Go programs

    Write-ColoredLine 'Installing/updating Go packages' Magenta

    Install-GoPackages

    if ($IsLinux) {
        Write-ColoredLine 'Setting up gorun binfmt_misc' Magent
        sudo mv "$GoPath/bin/gorun" '/usr/local/bin/'

        if (!(Test-fileExists '/proc/sys/fs/binfmt_misc/golang')) {
            sudo sh -c "echo ':golang:E::go::/usr/local/bin/gorun:OC' > /proc/sys/fs/binfmt_misc/register"
        }
    }

    Add-ZshHook post '10-golang'  "$PSScriptRoot/setuphook.zsh"
}

Install-Golang
