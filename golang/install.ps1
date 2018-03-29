#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' Utils)
$GoRoot = "/usr/local/go"
$GoPath = "$HOME/go"

function Install-Golang {
    Write-Header "Installing Go"
    $GoVersion = "go1.10.1"
    $GoInstalled = (Invoke-Command "$GoRoot/bin/go" "version").StdOut.Split(' ')[2]
    $tarfile = "$GoVersion.linux-amd64.tar.gz"
    $url = "https://storage.googleapis.com/golang/$GoVersion.linux-amd64.tar.gz"

    if ($GoVersion -eq $GoInstalled) {
        Write-ColoredLine "Go is at requested version $GoInstalled" DarkGreen
        Finish-Install
        return
    }

    Write-WarningMsg "Installed: $GoInstalled"
    Write-WarningMsg "Wanted:    $GoVersion"

    if ($IsMacOS) {
        Write-WarningMsg "macOS detected, please install/upgrade Go"
        exit
    }

    if (!(Test-FileExists $tarfile)) {
        Get-RemoteFile $url $tarfile
    }

    if (Test-DirExists $GoRoot) {
        sudo rm -rf $GoRoot
    }

    sudo tar -C /usr/local -xzf $tarfile
    Remove-Item $tarfile

    if (Test-DirExists "$GoPath/pkg") {
        # Remove any archive packages from older version of Go
        Remove-Item "$GoPath/pkg" -Recurse -Force | Out-Null
    }

    New-Item "$GoPath/src" -ItemType Directory -Force | Out-Null
    New-Item "$GoPath/pkg" -ItemType Directory -Force | Out-Null
    New-Item "$GoPath/bin" -ItemType Directory -Force | Out-Null

    Finish-Install
}

function Install-GoPackages {
    Get-GoPackage 'github.com/golang/dep/cmd/dep'
    Get-GoPackage 'github.com/kardianos/govendor'
    Get-GoPackage 'github.com/nsf/gocode'
    Get-GoPackage 'golang.org/x/tools/cmd/goimports'
    Get-GoPackage 'golang.org/x/tools/cmd/guru'
    Get-GoPackage 'github.com/erning/gorun'
    Get-GoPackage 'golang.org/x/vgo'
    Get-GoPackage 'github.com/go-bindata/go-bindata/...'
}

function Get-GoPackage ([string] $Package) {
    $Result = (Invoke-Command "$GoRoot/bin/go" 'get' '-u' $Package)
    if ($Result.ExitCode -eq 0) {
        Write-Output "Successfully downloaded $Package"
    }
}

function Finish-Install() {
    Add-ToPath go "$GoRoot/bin" # Go binary and tools
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
