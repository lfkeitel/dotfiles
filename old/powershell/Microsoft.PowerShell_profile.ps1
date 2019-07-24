Import-Module posh-git
Import-Module oh-my-posh
Set-Theme tehrob
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

function Git-Status { git status @args }
Set-Alias gs Git-Status

function Git-Diff { git diff @args }
Set-Alias gd Git-Diff

function Git-Commit { git commit @args }
Remove-Alias -Force gc
Set-Alias gc Git-Commit

function Git-CommitAll { git commit -a @args }
Set-Alias gca Git-CommitAll

function Git-CommitAllAmend { git commit -a --amend @args }
Set-Alias gcaa Git-CommitAllAmend

function Git-Push { git push @args }
Remove-Alias -Force gp
Set-Alias gp Git-Push

function Git-Pull { git pull @args }
Remove-Alias -Force gl
Set-Alias gl Git-Pull
