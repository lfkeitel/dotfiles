#!/usr/bin/env pwsh
dconf dump / > (Join-Path $PSScriptRoot dconf-export.txt)
