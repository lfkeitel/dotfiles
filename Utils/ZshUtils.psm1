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
    New-Item -ItemType Directory "$HOME/.local.zsh.d/$hook" -ErrorAction Ignore

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

function Write-PathData {
    if (Test-DirExists "$HOME/.local.zsh.d/paths") {
        $NewPaths.Keys | ForEach-Object {
            Write-Output $NewPaths.Item($_) | Out-File "$HOME/.local.zsh.d/paths/$_"
        }
    }
}

Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action {
    Write-PathData
}
