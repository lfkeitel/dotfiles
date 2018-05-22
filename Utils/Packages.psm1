function Import-RepoKey ([string] $url) {
    if (Get-IsUbuntu) {
        curl -fsSL $url | sudo apt-key add -
    } elseif (Get-IsFedora) {
        sudo rpm --import $url
    }
}

function Install-RepoList ([string] $RepoFileBase) {
    $CodeRelease = ''
    if (Get-IsUbuntu) {
        $CodeRelease = $SystemInfo.Version_Codename
    }

    $RepoFile = "$RepoFileBase.list"
    if (Get-IsFedora) {
        $RepoFile = "$RepoFileBase.repo"
    }
    $RepoFileBaseName = (Get-ChildItem -Path $RepoFile | Select-Object BaseName,Extension)
    $RepoFileBaseName = "$($RepoFileBaseName.BaseName)$($RepoFileBaseName.Extension)"

    $RepoDir = '/etc/apt/sources.list.d'
    if (Get-IsFedora) {
        $RepoDir = '/etc/yum.repos.d'
    }

    $TempFile = ([System.IO.Path]::GetTempFileName())
    Get-Content $RepoFile | ForEach-Object{$_ -replace '\$CODE_RELEASE',"$CodeRelease"} | Out-File $TempFile
    sudo mv $TempFile $RepoDir/$RepoFileBaseName
    sudo chown root:root $RepoDir/$RepoFileBaseName
    sudo chmod 0644 $RepoDir/$RepoFileBaseName
}

function Install-RemoteRepoList ([string] $url) {
    $RepoFile = (Split-Path -Path $url -Leaf)

    $RepoDir = '/etc/apt/sources.list.d'
    if (Get-IsFedora) {
        $RepoDir = '/etc/yum.repos.d'
    }

    $TempFile = ([System.IO.Path]::GetTempFileName())
    (New-Object System.Net.WebClient).DownloadFile($url, $TempFile)
    sudo mv $TempFile $RepoDir/$RepoFile
    sudo chown root:root $RepoDir/$RepoFile
    sudo chmod 0644 $RepoDir/$RepoFile
}

function Install-UbuntuPPA ([string] $Repo, [switch] $Update) {
    if (!(Get-IsUbuntu)) { return }
    sudo add-apt-repository ppa:$Repo
    if ($Update) { Update-PackageLists }
}

function Update-PackageLists {
    if (Get-IsUbuntu) { sudo apt update }
    elseif ($IsMacOS) { brew update }
}

function Install-SystemPackages ([switch] $Update) {
    if ($Update) { Update-PackageLists }
    if (Get-IsUbuntu) { sudo apt install -y @Args }
    elseif (Get-IsFedora) { sudo dnf install -y @Args }
    elseif ($IsMacOS) { brew install -y @Args }
}

function Get-CommandExists ([string] $command) {
    which $command 2>/dev/null >/dev/null
    return ($LASTEXITCODE -eq 0)
}

function Get-PipPackInstalled ([string] $Package) {
    python3 -c "import $Package" 2>/dev/null >/dev/null
    return ($LASTEXITCODE -eq 0)
}

function Get-IsPackageInstalled ([string] $pkg) {
    if (Get-IsUbuntu) {
        $AptList = (apt list $pkg 2>/dev/null | Where-Object { $_ -match 'installed' })
        return ($AptList.Count -gt 0)
    } elseif (Get-IsFedora) {
        dnf list $pkg >/dev/null
        return ($LASTEXITCODE -eq 0)
    } elseif ($IsMacOS) {
        $BrewList = (brew list $pkg 2>/dev/null)
        return ($BrewList.Count -gt 0)
    }
}
