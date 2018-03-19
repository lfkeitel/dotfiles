# Available Colors:
#  Black
#  DarkBlue
#  DarkGreen
#  DarkCyan
#  DarkRed
#  DarkMagenta
#  DarkYellow
#  Gray
#  DarkGray
#  Blue
#  Green
#  Cyan
#  Red
#  Magenta
#  Yellow
#  White

function Write-Header ([string] $message) {
    Write-Banner $message DarkGreen
}

function Write-Banner ([string] $message, [ConsoleColor] $color = 'White') {
    Write-Host '**********************************' -ForegroundColor $color
    Write-Host "** $message" -ForegroundColor $color
    Write-Host '**********************************' -ForegroundColor $color
}

function Write-MainBanner ([string] $message, [ConsoleColor] $color = 'White') {
    Write-Host '**********************************' -ForegroundColor $color
    Write-Host '**                              **' -ForegroundColor $color
    Write-Host "** $message" -ForegroundColor $color
    Write-Host '**                              **' -ForegroundColor $color
    Write-Host '**********************************' -ForegroundColor $color
}

function Write-ColoredLine ([string] $message, [ConsoleColor] $color = 'White') {
    Write-Host $message -ForegroundColor $color -NoNewline
}

function Write-ColoredLineNl ([string] $message, [ConsoleColor] $color = 'White') {
    Write-Host $message -ForegroundColor $color
}

function Write-WarningMsg ([string] $message) {
    Write-ColoredLineNl $message Yellow
}
