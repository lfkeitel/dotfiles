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
$MinimumLength = 20

function Write-Header ([string] $message) {
    Write-Banner $message DarkGreen
}

function Write-Banner ([string] $message, [ConsoleColor] $color = 'White') {
    $Length = Get-Max $message.Length $MinimumLength
    $BannerFril = "*" * ($Length + 4 + ($BannerPadding*2))
    $ExtraPadding = Get-ExtraPadding $message

    Write-Host $BannerFril -ForegroundColor $color
    Write-Host "** $message$ExtraPadding **" -ForegroundColor $color
    Write-Host $BannerFril -ForegroundColor $color
}

function Write-MainBanner ([string] $message, [ConsoleColor] $color = 'White') {
    $Length = Get-Max $message.Length $MinimumLength
    $BannerFril = "*" * ($Length + 4 + ($BannerPadding*2))
    $BannerFrilSp = " " * $Length
    $ExtraPadding = Get-ExtraPadding $message

    Write-Host $BannerFril -ForegroundColor $color
    Write-Host "** $BannerFrilSp **" -ForegroundColor $color
    Write-Host "** $message$ExtraPadding **" -ForegroundColor $color
    Write-Host "** $BannerFrilSp **" -ForegroundColor $color
    Write-Host $BannerFril -ForegroundColor $color
}

function Get-ExtraPadding ([string] $Message) {
    $ExtraPadding = ''
    if ($Message.Length -lt $MinimumLength) {
        $ExtraPadding = " " * ($MinimumLength - $Message.Length)
    }
    return $ExtraPadding
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
