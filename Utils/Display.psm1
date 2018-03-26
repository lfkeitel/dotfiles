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

$BannerPadding = 1

function Write-Header ([string] $message) {
    Write-Banner $message DarkGreen
}

function Write-Banner ([string] $message, [ConsoleColor] $color = 'White') {
    $BannerFril = "*" * ($message.Length + 4 + ($BannerPadding*2))

    Write-Host $BannerFril -ForegroundColor $color
    Write-Host "** $message **" -ForegroundColor $color
    Write-Host $BannerFril -ForegroundColor $color
}

function Write-MainBanner ([string] $message, [ConsoleColor] $color = 'White') {
    $BannerFril = "*" * ($message.Length + 4 + ($BannerPadding*2))
    $BannerFrilSp = " " * $message.Length

    Write-Host $BannerFril -ForegroundColor $color
    Write-Host "** $BannerFrilSp **" -ForegroundColor $color
    Write-Host "** $message **" -ForegroundColor $color
    Write-Host "** $BannerFrilSp **" -ForegroundColor $color
    Write-Host $BannerFril -ForegroundColor $color
}

function Write-ColoredLineNN ([string] $message, [ConsoleColor] $color = 'White') {
    Write-Host $message -ForegroundColor $color -NoNewline
}

function Write-ColoredLine ([string] $message, [ConsoleColor] $color = 'White') {
    Write-Host $message -ForegroundColor $color
}

function Write-WarningMsg ([string] $message) {
    Write-ColoredLine $message Yellow
}
