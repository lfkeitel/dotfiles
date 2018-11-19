# Utils Powershell Module Documentation

## Packages Module

This module includes functions to handle install/managing system packages and
repositories.

### Import-RepoKey

`Import-RepoKey ([string] $url)`

Install a repository GPG key from a URL. Used on Ubuntu and Fedora.

### Install-RepoList

`Install-RepoList ([string] $RepoFileBase)`

Installs an APT or YUM repository file. APT files have access to a variable named
`$CODE_RELEASE` which is replaced with the Ubuntu code release name (Bionic, Trusty).
The file is then copied to the appropriate /etc directory. The package manager
is not called to update the local database.

### Install-RemoteRepoList

`Install-RemoteRepoList ([string] $url)`

Same as `Install-RepoList` except uses a URL instead of a file path.


### Install-UbuntuPPA

`Install-UbuntuPPA ([string] $Repo, [switch] $Update)`

Runs `add-apt-repository ppa:$Repo`. If $Update flag is true, Apt is updated.


### Update-PackageLists

`Update-PackageLists ()`

On Ubuntu, Fedora, or macOS, update the local package database.

### Install-SystemPackage

`Install-SystemPackage ([switch] $Update, @Args...)`

Install a system package (on Arch this includes the AUR). If $Update is true,
update local package database before installing packages (not needed on Fedora
or Arch).

### Test-CommandExists

`Test-CommandExists ([string] $command) -> bool`

Checks if a command is executable.

### Test-PipPackInstalled

`Test-PipPackInstalled ([string] $Package) -> bool`

Checks if a pip packages is installed. This is done by starting python3 and attempting
to import the package.

### Test-IsPackageInstalled

`Test-IsPackageInstalled ([string] $pkg) -> bool`

Checks if a package in installed by consulting the system package manager.

## Display Module

This module isfor printing pretty banners or colored lines of text.

ConsoleColor can be any one of:

- Black
- DarkBlue
- DarkGreen
- DarkCyan
- DarkRed
- DarkMagenta
- DarkYellow
- Gray
- DarkGray
- Blue
- Green
- Cyan
- Red
- Magenta
- Yellow
- White

### Write-Header

`Write-Header ([string] $message)`

Equivalent to `Write-Banner $message DarkGreen`.

### Write-Banner

`Write-Banner ([string] $message, [ConsoleColor] $color = 'White')`

Display a simple banner with a message. Banners are a minimum of 20 characters wide.

```
************************
** Setting up configs **
************************
```

### Write-MainBanner

`Write-MainBanner ([string] $message, [ConsoleColor] $color = 'White')`

Similar to `Write-Banner` but with a bit more spacing and flair. Banners are a
minimum of 20 characters wide.

```
************************
**                    **
** Setting up configs **
**                    **
************************
```

### Get-ExtraPadding

`Get-ExtraPadding ([string] $Message) -> int`

Used internally. Calculates the padding needed for a message less than the minimum
banner width.

### Write-ColoredLineNN

`Write-ColoredLineNN ([string] $message, [ConsoleColor] $color = 'White')`

Equivalent to `Write-Host $message -ForegroundColor $color -NoNewline`.

### Write-ColoredLine

`Write-ColoredLine ([string] $message, [ConsoleColor] $color = 'White')`

Equivalent to `Write-Host $message -ForegroundColor $color`.

### Write-WarningMsg

`Write-WarningMsg ([string] $message)`

Equivalent to `Write-ColoredLine $message Yellow`.

## Generic Utils

### Test-IsFedora

`Test-IsFedora () -> bool`

Returns if the system is Fedora.

### Test-IsUbuntu

`Test-IsUbuntu () -> bool`

Returns if the system is Ubuntu.

### Test-IsArch

`Test-IsArch () -> bool`

Returns if the system is Arch.

### Restore-EncryptedFile

`Restore-EncryptedFile ([string] $Source, [string] $Dest)`

Decrypts $Source file with gpg2 and writes it to $Dest. No linking.

### Add-FileLink

`Add-FileLink ([string] $Source, [string] $Dest, [switch] $Sudo)`

Create a symbolic link at $Dest pointing to $Source. If $Sudo is true, uses sudo
to make the link. If $Dest exists, it will be deleted.

### Test-FileExists

`Test-FileExists ([string] $path) -> bool`

Returns if $path exists and is a file.

### Test-DirExists

`Test-DirExists ([string] $path) -> bool`

Returns if $path exists and is a directory.

### Copy-Config

`Copy-Config ([string] $src, [string] $dest, [switch] $sudo)`

Copies $src to $dest using sudo if $sudo is true.

### Invoke-Command

`Invoke-Command ([String] $Path, [String[]] $CmdArgs) -> CustomObject`

Executes a command without a shell and returns a custom object with the properties:

```powershell
@{
    StdOut = ""
    StdErr = ""
    ExitCode = 0
}
```


### ExitWithCode

`ExitWithCode ($exitcode)`

Exit the running script and set the exit code.


### New-Directory

`New-Directory ([string] $Dir)`

Create the directory $Dir.

### Get-Max

`Get-Max ([int] $A, [int] $B) -> int`

Returns the greater of two numbers.

### Get-RemoteFile

`Get-RemoteFile ([string] $url, [string] $path, [switch] $silent)`

Download a remote file from $url and save to $path. If $silent is true, don't
print status messages.

### Get-JSONFile

`Get-JSONFile ([string] $File) -> CustomObject`

Read $File and decode its contents as JSON.

## ZSH Utils

This module adds functions to manipulate the main shell environment. It adds and
easy to use file-based hooks system as well as a path manipulation system.

Path files are stored in `$HOME/.local.zsh.d/paths`.

Hook scripts are stored in `$HOME/.local.zsh.d/$hook`.

Available custom hooks:

- `pre` - Executed after $PATH has been finalized but before anything else.
- `pre-oh-my-zsh` - Executed directly before sourcing oh-my-zsh.
- `post-oh-my-zsh` - Executed directly after sourcing oh-my-zsh.
- `post` - Executed at the end of .zshrc.

### Add-ToPath

`Add-ToPath ([string] $module, [string] $path)`

Adds a path directory to the module's path file. Path files are read when the
shell starts and are prepended to the $PATH variable.

### Remove-PathModule

`Remove-PathModule ([string] $module)`

Remove a module's path file. Note, this does not remove any paths already added
with `Add-ToPath`. If `Add-ToPath` has been called, a new file will be written.

### Add-ZshHook

`Add-ZshHook ([string] $hook, [string] $hookname, [string] $hookfile, [switch] $nolink)`

Install a new hook script. $hook can by anything but only the names mentioned
above will be used. $hookname will be the name of the script. Hooks are executed
in lexicographical order so numbered scripts work really well, e.g. `10-my-script`.
$hookfile is the file that will be linked to. If $nolink is true, the script will
be copied instead of linked.

### Remove-ZshHook

`Remove-ZshHook ([string] $hook, [string] $hookname)`

Delete a hook script from a specific hook.

### Test-ZshHookExists

`Test-ZshHookExists ([string] $hook, [string] $hookname)`

Check if a hook script exists for a given hook.

### Write-PathData

`Write-PathData ()`

Used internally. Called when the script exits to write module path files.
