function Import-RepoKey ([string] $url) {
    if (Test-IsUbuntu) {
        curl -fsSL $url | sudo apt-key add -
    } elseif (Test-IsFedora) {
        sudo rpm --import $url
    }
}

function Install-RepoList ([string] $RepoFileBase) {
    if (!$IsLinux -or (Test-IsArch)) { return }

    $CodeRelease = ''
    if (Test-IsUbuntu) {
        $CodeRelease = $SystemInfo.Version_Codename
    }

    $RepoFile = "$RepoFileBase.list"
    if (Test-IsFedora) {
        $RepoFile = "$RepoFileBase.repo"
    }
    $RepoFileBaseName = (Get-ChildItem -Path $RepoFile | Select-Object BaseName,Extension)
    $RepoFileBaseName = "$($RepoFileBaseName.BaseName)$($RepoFileBaseName.Extension)"

    $RepoDir = '/etc/apt/sources.list.d'
    if (Test-IsFedora) {
        $RepoDir = '/etc/yum.repos.d'
    }

    $TempFile = ([System.IO.Path]::GetTempFileName())
    Get-Content $RepoFile | ForEach-Object{$_ -replace '\$CODE_RELEASE',"$CodeRelease"} | Out-File $TempFile
    sudo mv $TempFile $RepoDir/$RepoFileBaseName
    sudo chown root:root $RepoDir/$RepoFileBaseName
    sudo chmod 0644 $RepoDir/$RepoFileBaseName
}

function Install-RemoteRepoList ([string] $url) {
    if (!$IsLinux -or (Test-IsArch)) { return }

    $RepoFile = (Split-Path -Path $url -Leaf)

    $RepoDir = '/etc/apt/sources.list.d'
    if (Test-IsFedora) {
        $RepoDir = '/etc/yum.repos.d'
    }

    $TempFile = ([System.IO.Path]::GetTempFileName())
    (New-Object System.Net.WebClient).DownloadFile($url, $TempFile)
    sudo mv $TempFile $RepoDir/$RepoFile
    sudo chown root:root $RepoDir/$RepoFile
    sudo chmod 0644 $RepoDir/$RepoFile
}

function Install-UbuntuPPA ([string] $Repo, [switch] $Update) {
    if (!(Test-IsUbuntu)) { return }
    sudo add-apt-repository ppa:$Repo
    if ($Update) { Update-PackageLists }
}

function Update-PackageLists {
    if (Test-IsUbuntu) { sudo apt update }
    elseif ($IsMacOS) { brew update }
}

function Install-SystemPackage ([switch] $Update) {
    if ($Update) { Update-PackageLists }

    if (Test-IsUbuntu) { sudo apt install -y @Args }
    elseif (Test-IsFedora) { sudo dnf install -y @Args }
    elseif (Test-IsArch) { yay -S --noconfirm --needed @Args }
    elseif ($IsMacOS) { brew install -y @Args }
}

function Test-CommandExists ([string] $command) {
    which $command 2>&1 | Out-Null
    return ($LASTEXITCODE -eq 0)
}

function Test-PipPackInstalled ([string] $Package) {
    python3 -c "import $Package" 2>&1 | Out-Null
    return ($LASTEXITCODE -eq 0)
}

function Test-IsPackageInstalled ([string] $pkg) {
    if (Test-IsUbuntu) {
        $AptList = (apt list $pkg 2>$null | Where-Object { $_ -match 'installed' })
        return ($AptList.Count -gt 0)
    } elseif (Test-IsFedora) {
        dnf list $pkg | Out-Null
        return ($LASTEXITCODE -eq 0)
    } elseif (Test-IsArch) {
        pacman -Q $pkg 2>&1 | Out-Null
        return ($LASTEXITCODE -eq 0)
    } elseif ($IsMacOS) {
        $BrewList = (brew list $pkg)
        return ($BrewList.Count -gt 0)
    }
}
