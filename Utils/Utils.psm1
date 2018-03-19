function Restore-EncryptedFile ([string] $Source, [string] $Dest) {
    $gpgOut = (gpg2 --yes --output $Dest -d $Source 2>&1)
    if ($LASTEXITCODE -gt 0) {
        Write-Output $gpgOut
    }
}

function Add-FileLink ([string] $Source, [string] $Dest) {
    New-Item -ItemType SymbolicLink -Target $Source -Path $Dest -Force | Out-Null
}

function Test-FileExists ([string] $path) {
    return (Test-Path $path -PathType Leaf)
}

function Test-DirExists ([string] $path) {
    return (Test-Path $path -PathType Container)
}
