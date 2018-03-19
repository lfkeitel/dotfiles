$NewPaths = @{}

function Add-ToPath ([string] $module, [string] $path) {
    $module = "40-$module"
    if (!$NewPaths.Contains($module)) {
        $newPaths.Add($module, @())
    }

    $NewPaths.$module += $path
}

function Add-ZshHook ([string] $hook, [string] $hookname, [string] $hookfile) {
    Write-Output "Adding $hookname to ZSH $hook hooks"
    New-Item -ItemType Directory "$HOME/.local.zsh.d/$hook"
    Add-FileLink $hookfile "$HOME/.local.zsh.d/$hook/$hookname.zsh"
}

function Remove-ZshHook ([string] $hook, [string] $hookname) {
    Write-Output "Removing $hookname from ZSH $hook hooks"
    Remove-Item "$HOME/.local.zsh.d/$hook/$hookname.zsh"
}

function Get-ZshHookExists ([string] $hook, [string] $hookname) {
    return (Test-Path "$HOME/.local.zsh.d/$hook/$hookname.zsh" -PathType Leaf)
}

Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action {
    if (Test-DirExists "$HOME/.local.zsh.d/paths") {
        $NewPaths.Keys | ForEach-Object {
            Write-Output $NewPaths.Item($_) | Out-File "$HOME/.local.zsh.d/paths/$_"
        }
    }
}
