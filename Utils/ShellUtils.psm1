$NewPaths = @{}

function Add-ToPath ([string] $module, [string] $path) {
    $module = "40-$module"
    if (!$NewPaths.Contains($module)) {
        $NewPaths.Add($module, (New-Object System.Collections.ArrayList($null)))
    }
    ($NewPaths[$module]).Add($path) | Out-Null # Add returns the inserted index, ignore it
}

function Remove-PathModule ([string] $module) {
    Remove-Item "$HOME/.local.zsh.d/paths/40-$module" -ErrorAction Ignore
}

function Add-ZshHook ([string] $hook, [string] $hookname, [string] $hookfile, [switch] $nolink) {
    Write-Output "Adding $hookname to ZSH $hook hooks"
    New-Item -ItemType Directory "$HOME/.local.zsh.d/$hook" -ErrorAction Ignore | Out-Null

    if ($nolink) {
        Copy-Config $hookfile "$HOME/.local.zsh.d/$hook/$hookname.zsh"
    } else {
        Add-FileLink $hookfile "$HOME/.local.zsh.d/$hook/$hookname.zsh"
    }
}

function Remove-ZshHook ([string] $hook, [string] $hookname) {
    Write-Output "Removing $hookname from ZSH $hook hooks"
    Remove-Item "$HOME/.local.zsh.d/$hook/$hookname.zsh"
}

function Test-ZshHookExists ([string] $hook, [string] $hookname) {
    return (Test-Path "$HOME/.local.zsh.d/$hook/$hookname.zsh" -PathType Leaf)
}

$FishCfgDir = "$HOME/.config/fish"
$FishFuncsDir = "$HOME/.config/fish/functions"
$FishHooksDir = "$HOME/.config/fish/hooks"

function Add-FishFunction ([string] $funcname, [string] $hookfile, [switch] $nolink) {
    Write-Output "Adding $funcname to Fish functions"
    New-Item -ItemType Directory "$FishFuncsDir" -ErrorAction Ignore | Out-Null

    if ($nolink) {
        Copy-Config $hookfile "$FishFuncsDir/$funcname.fish"
    } else {
        Add-FileLink $hookfile "$FishFuncsDir/$funcname.fish"
    }
}

function Remove-FishFunction ([string] $funcname) {
    Write-Output "Removing $funcname from Fish functions"
    Remove-Item "$FishFuncsDir/$funcname.fish"
}

function Add-FishHook ([string] $hook, [string] $hookname, [string] $hookfile, [switch] $nolink) {
    Write-Output "Adding $hookname to Fish $hook hooks"
    New-Item -ItemType Directory "$FishHooksDir/$hook" -ErrorAction Ignore | Out-Null

    if ($nolink) {
        Copy-Config $hookfile "$FishHooksDir/$hook/$hookname.fish"
    } else {
        Add-FileLink $hookfile "$FishHooksDir/$hook/$hookname.fish"
    }
}

function Remove-FishHook ([string] $hook, [string] $hookname) {
    Write-Output "Removing $hookname from Fish $hook hooks"
    Remove-Item "$FishHooksDir/$hook/$hookname.fish"
}

function Test-FishHookExists ([string] $hook, [string] $hookname) {
    return (Test-Path "$FishHooksDir/$hook/$hookname.fish" -PathType Leaf)
}

function Write-PathData {
    if (Test-DirExists "$HOME/.local.zsh.d/paths") {
        $NewPaths.Keys | ForEach-Object {
            Write-Output $NewPaths.Item($_) | Out-File "$HOME/.local.zsh.d/paths/$_"
        }
    }

    if (Test-DirExists "$HOME/.config/fish/hooks/paths") {
        $NewPaths.Keys | ForEach-Object {
            Write-Output $NewPaths.Item($_) | Out-File "$HOME/.config/fish/hooks/paths/$_"
        }
    }
}

Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action {
    Write-PathData
}
