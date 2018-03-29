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

function ExitWithCode ($exitcode) {
    $host.SetShouldExit($exitcode)
    exit
}

function New-Directory ([string] $Dir) {
    New-Item $Dir -ItemType Directory -Force | Out-Null
}

function Get-Max ([int] $A, [int] $B) {
    if ($A -gt $B) { return $A }
    return $B
}

function Get-RemoteFile ([string] $url, [string] $path, [switch] $silent) {
    if (!$silent) {
        Write-Output "Downloading $url"
    }

    $start_time = Get-Date
    (New-Object System.Net.WebClient).DownloadFile($url, $path)

    if (!$silent) {
        Write-Output "Download took: $((Get-Date).Subtract($start_time).Seconds)s"
    }
}
