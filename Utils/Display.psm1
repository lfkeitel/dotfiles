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
