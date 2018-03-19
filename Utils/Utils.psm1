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

function Invoke-Command {
    param
    (
        [parameter(Mandatory=$true)]
        [String]
        $Path,

        [parameter(Mandatory=$true,
        ValueFromRemainingArguments=$true)]
        [String[]]
        $CmdArgs
    )

    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $Path
    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = $CmdArgs
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null
    $p.WaitForExit()
    [pscustomobject]@{
        StdOut = $p.StandardOutput.ReadToEnd()
        StdErr = $p.StandardError.ReadToEnd()
        ExitCode = $p.ExitCode
    }
}
